import Base64
import Markdown
import MIMEs
import URIs
using HypertextLiteral

export Resource, RemoteResource, LocalResource, DownloadButton

"""
    Resource(src::String, mime=mime_from_filename(src)[, html_attributes::Pair...])

A container for a URL-addressed resource that displays correctly in rich IDEs.

# Examples
```
Resource("https://julialang.org/assets/infra/logo.svg")
```

```
Resource("https://interactive-examples.mdn.mozilla.net/media/examples/flower.webm", :width => 100)
```

```
md\"\"\"
This is what a duck sounds like: \$(Resource("https://interactive-examples.mdn.mozilla.net/media/examples/t-rex-roar.mp3"))
md\"\"\"
```

"""
struct Resource
    src::AbstractString
    mime::Union{Nothing,MIME}
    html_attributes::NTuple{N,Pair} where N
end
Resource(src::AbstractString, html_attributes::Pair...) = Resource(src, mime_fromfilename(src), html_attributes)

function Base.show(io::IO, m::MIME"text/html", r::Resource)
    mime_str = string(r.mime)
    
    tag = if startswith(mime_str, "image/")
        :img
    elseif r.mime isa MIME"text/javascript"
        :script
    elseif startswith(mime_str, "audio/")
        :audio
    elseif startswith(mime_str, "video/")
        :video
    else
        :data
    end

    Base.show(io, m, 
        @htl("""<$(tag) controls='' src=$(r.src) type=$(r.mime) $(Dict{String,Any}(
                string(k) => v 
                for (k, v) in r.html_attributes
            ))></$(tag)>""")
    )
end


const RemoteResource = Resource

"""
Create a `Resource` for a local file (a base64 encoded data URL is generated).

# WARNING
`LocalResource` **will not work** when you share the script/notebook with someone else, _unless they have those resources at exactly the same location on their file system_. 

## Recommended alternatives (images)
1. Go to [imgur.com](https://imgur.com) and drag&drop the image to the page. Right click on the image, and select "Copy image location". You can now use the image like so: `PlutoUI.Resource("https://i.imgur.com/SAzsMMA.jpg")`.
2. If your notebook is part of a git repository, place the image in the repository and use a relative path: `PlutoUI.LocalResource("../images/cat.jpg")`.

# Examples
```
LocalResource("./cat.jpg")
```

```
LocalResource("/home/fons/Videos/nijmegen.mp4", :width => 200)
```

```
md\"\"\"
This is what a duck sounds like: \$(LocalResource("../data/hannes.mp3"))
md\"\"\"
```
"""
function LocalResource(path::AbstractString, html_attributes::Pair...)
    # @warn """`LocalResource` **will not work** when you share the script/notebook with someone else, _unless they have those resources at exactly the same location on their file system_. 

    # ## Recommended alternatives (images)
    # 1. Go to [imgur.com](https://imgur.com) and drag&drop the image to the page. Right click on the image, and select "Copy image location". You can now use the image like so: `PlutoUI.Resource("https://i.imgur.com/SAzsMMA.jpg")`.
    # 2. If your notebook is part of a git repository, place the image in the repository and use a relative path: `PlutoUI.LocalResource("../images/cat.jpg")`."""
    mime = mime_fromfilename(path)
    src = "data:$( 
		    string(something(mime,""))
		);base64,$(
		    Base64.base64encode(read(path))
	    )"
    return Resource(src, mime, html_attributes)
	Resource(src, mime, html_attributes)
end

###
# DOWNLOAD BUTTON
###

"""
Button to download a Julia object as a file from the browser.

See [`FilePicker`](@ref) to do the opposite.

# Examples

```julia
DownloadButton("Roses are red,", "novel.txt")
```
```julia
DownloadButton(UInt8[0xff, 0xd8, 0xff, 0xe1, 0x00, 0x69], "raw.dat")
```
```julia
import JSON
DownloadButton(JSON.json(Dict("name" => "merlijn", "can_cook" => true)), "staff.json")
```

If you want to make a **local file** available for download, you need to `read` the file's data:
```julia
let
    filename = "/Users/fonsi/Documents/mydata.csv"
    DownloadButton(read(filename), basename(filename))
end
```

"""
struct DownloadButton
    data
    filename::AbstractString
end
DownloadButton(data) = DownloadButton(data, "result")

function Base.show(io::IO, m::MIME"text/html", db::DownloadButton)
    mime = mime_fromfilename(db.filename)
    data = if db.data isa Union{AbstractString,AbstractVector{UInt8}} || isnothing(mime)
        db.data
    else
        repr(mime, db.data)
    end

    write(io, "<a href=\"data:")
	write(io, string(!isnothing(mime) ? mime : ""))
	write(io, ";base64,")
	write(io, Base64.base64encode(data))
	write(io, "\" download=\"")
	write(io, Markdown.htmlesc(db.filename))
	write(io, "\" style=\"text-decoration: none; font-weight: normal; font-size: .75em; font-family: sans-serif;\"><button>Download...</button> ")
	write(io, db.filename)
	write(io, "</a>")
end

function downloadbutton_data(object::Any, mime::Union{MIME, Nothing})::String
    data = if object isa String || object isa AbstractVector{UInt8} || isnothing(mime)
        object
    else
        repr(mime, object)
    end
    Base64.base64encode(data)
end


###
# MIMES
###

"Attempt to find the MIME pair corresponding to the extension of a filename. Defaults to `text/plain`."
function mime_fromfilename(filename; default::T=nothing, filename_maxlength=2000)::Union{MIME, T} where T
	if length(filename) > filename_maxlength
		default
    else
        MIMEs.mime_from_path(
            URIs.URI(filename).path,
            default
        )
	end
end

