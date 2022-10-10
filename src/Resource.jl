import Base64
import Markdown

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

function Base.show(io::IO, ::MIME"text/html", r::Resource)
    tag = if r.mime ∈ imagemimes
        :img
    elseif r.mime isa MIME"text/javascript"
        :script
    elseif r.mime ∈ audiomimes
        :audio
    elseif r.mime ∈ videomimes
        :video
    else
        :data
    end
    type_attr = r.mime isa MIME ? [:type => string(r.mime)] : []
    
    Markdown.withtag(() -> (), io, tag, :src => r.src, :controls => "", type_attr..., (k => string(v) for (k, v) in r.html_attributes)...)
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
    src = join([
		"data:", 
		string(something(mime,"")),
		";base64,", 
		Base64.base64encode(read(path))
	])
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
	write(io, "<a href=\"data:")
	write(io, string(mime_fromfilename(db.filename, default="")))
	write(io, ";base64,")
	write(io, Base64.base64encode(db.data))
	write(io, "\" download=\"")
	write(io, Markdown.htmlesc(db.filename))
	write(io, "\" style=\"text-decoration: none; font-weight: normal; font-size: .75em; font-family: sans-serif;\"><button>Download...</button> ")
	write(io, db.filename)
	write(io, "</a>")
end

###
# MIMES
###

"Attempt to find the MIME pair corresponding to the extension of a filename. Defaults to `text/plain`."
function mime_fromfilename(filename; default=nothing, filename_maxlength=2000)
	if length(filename) > filename_maxlength
		default
    else
		get(mimepairs, lowercase('.' * split(split(split(filename, '?')[1], '#')[1], '.')[end]), default)
	end
end

# This bad boy is from: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
const mimepairs = Dict{String,MIME}(".aac" => MIME"audio/aac"(), ".bin" => MIME"application/octet-stream"(), ".bmp" => MIME"image/bmp"(), ".css" => MIME"text/css"(), ".csv" => MIME"text/csv"(), ".eot" => MIME"application/vnd.ms-fontobject"(), ".gz" => MIME"application/gzip"(), ".gif" => MIME"image/gif"(), ".htm" => MIME"text/html"(), ".html" => MIME"text/html"(), ".ico" => MIME"image/vnd.microsoft.icon"(), ".jpeg" => MIME"image/jpeg"(), ".jpg" => MIME"image/jpeg"(), ".js" => MIME"text/javascript"(), ".json" => MIME"application/json"(), ".jsonld" => MIME"application/ld+json"(), ".mjs" => MIME"text/javascript"(), ".mp3" => MIME"audio/mpeg"(), ".mpeg" => MIME"video/mpeg"(), ".mp4" => MIME"video/mp4"(), ".oga" => MIME"audio/ogg"(), ".ogg" => MIME"audio/ogg"(), ".ogv" => MIME"video/ogg"(), ".ogx" => MIME"application/ogg"(), ".opus" => MIME"audio/opus"(), ".otf" => MIME"font/otf"(), ".png" => MIME"image/png"(), ".pdf" => MIME"application/pdf"(), ".rtf" => MIME"application/rtf"(), ".sh" => MIME"application/x-sh"(), ".svg" => MIME"image/svg+xml"(), ".tar" => MIME"application/x-tar"(), ".tif" => MIME"image/tiff"(), ".tiff" => MIME"image/tiff"(), ".ttf" => MIME"font/ttf"(), ".txt" => MIME"text/plain"(), ".wav" => MIME"audio/wav"(), ".weba" => MIME"audio/webm"(), ".webm" => MIME"video/webm"(), ".webp" => MIME"image/webp"(), ".woff" => MIME"font/woff"(), ".woff2" => MIME"font/woff2"(), ".xhtml" => MIME"application/xhtml+xml"(), ".xml" => MIME"application/xml"(), ".xul" => MIME"application/vnd.mozilla.xul+xml"(), ".zip" => MIME"application/zip"())

const imagemimes = (MIME"image/svg+xml"(), MIME"image/png"(), MIME"image/webp"(), MIME"image/tiff"(), MIME"image/jpg"(), MIME"image/jpeg"(), MIME"image/bmp"(), MIME"image/gif"())
const audiomimes = (MIME"audio/mpeg"(), MIME"audio/wav"(), MIME"audio/aac"(), MIME"audio/ogg"(), MIME"audio/opus"(), MIME"audio/webm"())
const videomimes = (MIME"video/mpeg"(), MIME"video/ogg"(), MIME"video/webm"(), MIME"video/mp4"())

