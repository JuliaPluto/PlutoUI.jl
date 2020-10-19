import Base64
import Markdown

export Resource, RemoteResource, LocalResource, DownloadButton

@widget """Resouce <{{tag}} src={{src}} controls="" type={{mime}}></{{tag}}>""" default=""
function Resource(src::AbstractString, mime = mime_fromfilename(src))
    tag = if mime ∈ imagemimes
        :img
    elseif mime isa MIME"text/javascript"
        :script
    elseif mime ∈ audiomimes
        :audio
    elseif mime ∈ videomimes
        :video
    else
        :data
    end
    Resource(; src=src, tag=tag, mime=(mime isa MIME ? string(mime) : ""))
end

const RemoteResource=LocalResource

function LocalResource(path::AbstractString)
    @warn """`LocalResource` **will not work** when you share the script/notebook with someone else, _unless they have those resources at exactly the same location on their file system_. 

    ## Recommended alternatives (images)
    1. Go to [imgur.com](https://imgur.com) and drag&drop the image to the page. Right click on the image, and select "Copy image location". You can now use the image like so: `PlutoUI.Resource("https://i.imgur.com/SAzsMMA.jpg")`.
    2. If your notebook is part of a git repository, place the image in the repository and use a relative path: `PlutoUI.LocalResource("../images/cat.jpg")`."""
    mime = mime_fromfilename(path; default="")
    src = join([
		"data:", 
		string(mime),
		";base64,", 
		Base64.base64encode(read(path))
	])
	Resource(src, mime)
end

###
# DOWNLOAD BUTTON
###

@widget DownloadButton """<a href="data:{{mime}};base64,{{encoded_data}}" download="{{filename}}"
style=\"text-decoration: none; font-weight: normal; font-size: .75em; font-family: sans-serif;\"><button>Download...</button> 
{{filename}}</a>"""
function DownloadButton(; filename, data, mime=mime_fromfilename(filename, default=""))
    DownloadButton(; filename=filename, encoded_data=Base64.base64encode(data), mime=mime)
end

###
# MIMES
###

"Attempt to find the MIME pair corresponding to the extension of a filename. Defaults to `text/plain`."
function mime_fromfilename(filename; default=nothing, filename_maxlength=2000)
	if length(filename) > filename_maxlength
		default
    else
		get(mimepairs, '.' * split(split(split(filename, '?')[1], '#')[1], '.')[end], default)
	end
end

const mimepairs = let
	# This bad boy is from: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
	originals = Dict(".aac" => "audio/aac", ".bin" => "application/octet-stream", ".bmp" => "image/bmp", ".css" => "text/css", ".csv" => "text/csv", ".eot" => "application/vnd.ms-fontobject", ".gz" => "application/gzip", ".gif" => "image/gif", ".htm" => "text/html", ".html" => "text/html", ".ico" => "image/vnd.microsoft.icon", ".jpeg" => "image/jpeg", ".jpg" => "image/jpeg", ".js" => "text/javascript", ".json" => "application/json", ".jsonld" => "application/ld+json", ".mjs" => "text/javascript", ".mp3" => "audio/mpeg", ".mpeg" => "video/mpeg", ".mp4" => "video/mp4", ".oga" => "audio/ogg", ".ogg" => "audio/ogg", ".ogv" => "video/ogg", ".ogx" => "application/ogg", ".opus" => "audio/opus", ".otf" => "font/otf", ".png" => "image/png", ".pdf" => "application/pdf", ".rtf" => "application/rtf", ".sh" => "application/x-sh", ".svg" => "image/svg+xml", ".tar" => "application/x-tar", ".tif" => "image/tiff", ".tiff" => "image/tiff", ".ttf" => "font/ttf", ".txt" => "text/plain", ".wav" => "audio/wav", ".weba" => "audio/webm", ".webm" => "video/webm", ".webp" => "image/webp", ".woff" => "font/woff", ".woff2" => "font/woff2", ".xhtml" => "application/xhtml+xml", ".xml" => "application/xml", ".xul" => "application/vnd.mozilla.xul+xml", ".zip" => "application/zip")
	Dict((k => MIME(v)) for (k, v) in originals)
end

const imagemimes = [MIME"image/svg+xml"(), MIME"image/png"(), MIME"image/webp"(), MIME"image/tiff"(), MIME"image/jpg"(), MIME"image/jpeg"(), MIME"image/bmp"(), MIME"image/gif"()]
const audiomimes = [MIME"audio/mpeg"(), MIME"audio/wav"(), MIME"audio/aac"(), MIME"audio/ogg"(), MIME"audio/opus"(), MIME"audio/webm"()]
const videomimes = [MIME"video/mpeg"(), MIME"video/ogg"(), MIME"video/webm"(), MIME"video/mp4"()]

