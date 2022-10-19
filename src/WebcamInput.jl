### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 1791669b-d1ee-4c62-9485-52d8493888a7
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(temp=true)
	Pkg.add(["ImageShow", "ImageIO", "PNGFiles"])
	using ImageShow, ImageIO, PNGFiles # these packages are only loaded in this notebook (to see the images), not in the PlutoUI package
	
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
end
  ╠═╡ =#

# ╔═╡ 25fc026c-c593-11ec-05c8-93e16f9dc527
using HypertextLiteral

# ╔═╡ cfb76adb-96da-493c-859c-ad24aa18437e
using UUIDs: UUID, uuid4

# ╔═╡ b3b59805-7062-463f-b6c5-1679133a589f
using ColorTypes

# ╔═╡ 39f594bb-6326-4431-9fad-8974fef608a1
using FixedPointNumbers

# ╔═╡ 31dff3d3-b3ee-426d-aec8-ee811820d842
import AbstractPlutoDingetjes

# ╔═╡ 5104aabe-43f7-451e-b4c1-68c0b345669e
"""
Converts [ImageData](https://developer.mozilla.org/en-US/docs/Web/API/ImageData) vector to an RGBA Matrix.

Accepts a `Dict{Any, Any}` similar to the ImageData type, i.e. with keys
 - `width`: width of the image
 - `height`: height of the image
 - `data`: image data - 4 elements per pixel, ``4*width*height`` total length

"""
function ImageDataToRGBA(d::Dict)
	width = d["width"]
	height = d["height"]

	PermutedDimsArray( # lazy transpose
		reshape( # lazy unflatten
			reinterpret( # lazy UInt8 to RGBA{N0f8}
				RGBA{N0f8}, d["data"]::Vector{UInt8}),
				width, height
			), 
		(2,1)
	)
end

# ╔═╡ 43332d10-a10b-4acc-a3ac-8c4b4eb58c46
"""
Converts an `Image` (`Matrix{<:Colorant}`) to the equivalent [ImageData](https://developer.mozilla.org/en-US/docs/Web/API/ImageData)

"""
function RGBAToImageData(img)
	f = reshape(img, :)
	arr = zeros(4 * length(f))
	for (i, color) in enumerate(f)
		arr[4*(i - 1) + 1] = 255 * red(color)
		arr[4*(i - 1) + 2] = 255 * green(color)
		arr[4*(i - 1) + 3] = 255 * blue(color)
		arr[4*(i - 1) + 4] = 255 * alpha(color)
	end
	arr
end

# ╔═╡ 6dd82485-a392-4110-9148-f70f0e7c0985
const standard_default_avoid_allocs = ImageDataToRGBA(Dict{Any,Any}(
	"width" => 1, "height" => 1, 
	"data" => UInt8[0,0,0,0],
))

# ╔═╡ c917c90c-6999-4553-9187-a84e1f3b9315
# ╠═╡ skip_as_script = true
#=╠═╡
standard_default_avoid_allocs |> typeof
  ╠═╡ =#

# ╔═╡ 9a07c7f4-e2c1-4322-bcbc-c7db90af0059
const standard_default = collect(standard_default_avoid_allocs)

# ╔═╡ 43f46ca7-08e0-4687-87eb-218df976a8a5
# ╠═╡ skip_as_script = true
#=╠═╡
standard_default |> typeof
  ╠═╡ =#

# ╔═╡ 97e2467e-ca58-4b5f-949d-ad95253b1ac0
const css = @htl("""<style>
	plutoui-webcam {
		width: 300px;
		height: 200px;
		display: flex;
        border: 3px dashed lightgrey; 
		border-radius: 2px;
		position: relative;
	}

	plutoui-webcam.enabled::after{
		color: red;
	}

	plutoui-webcam .permissions-help,
	plutoui-webcam video {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
	}

	plutoui-webcam .permissions-help {
		display: grid;
		place-items: center;
		padding: 1em;
		z-index: 6;
		pointer-events: none;
    	touch-action: none;
	}
	plutoui-webcam .permissions-help span {
	    background: #f6d5cc;
    	color: black;
		padding: .5em;
	}
		
	plutoui-webcam .grid {
		display: grid;
		width: 100%;
		height: 100%;
		grid-template-columns: 1fr 1fr 1fr;
		grid-template-rows: 1fr 1fr 50px;
	}
	plutoui-webcam .select-device {
		grid-column-start: 2;
		grid-row-start: 1;
		display: flex;
		align-items: start;
		justify-content: center;
		margin:0.2em;
		z-index: 2;
	}
	plutoui-webcam .start-large {
		grid-column-start: 2;
		grid-row-start: 2;
		z-index: 2;
		display: grid;
		place-items: center;
	}
	plutoui-webcam .start-large .ionic {
		--size: 3em;
	}
	plutoui-webcam .controls {
		grid-column-start: 2;
		grid-row-start: 3;
		display: flex;
		align-items: center;
		justify-content: center;
		margin:0.2em;
		z-index: 2;
	}
	plutoui-webcam .controls > button {
		margin-left: 0.2em;
	}
	plutoui-webcam .ionic {
		--size: 1em;
		display: inline-block;
		width: var(--size);
		height: var(--size);
		line-height: var(--size);
		background-size: var(--size);
		margin-bottom: -2px;
	}
	plutoui-webcam .ionic-cam {
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.2/src/svg/camera-outline.svg");
		/* generated using https://dopiaza.org/tools/datauri/index.php */
		background-image: url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiI+PHRpdGxlPmlvbmljb25zLXY1LWU8L3RpdGxlPjxwYXRoIGQ9Ik0zNTAuNTQsMTQ4LjY4bC0yNi42Mi00Mi4wNkMzMTguMzEsMTAwLjA4LDMxMC42Miw5NiwzMDIsOTZIMjEwYy04LjYyLDAtMTYuMzEsNC4wOC0yMS45MiwxMC42MmwtMjYuNjIsNDIuMDZDMTU1Ljg1LDE1NS4yMywxNDguNjIsMTYwLDE0MCwxNjBIODBhMzIsMzIsMCwwLDAtMzIsMzJWMzg0YTMyLDMyLDAsMCwwLDMyLDMySDQzMmEzMiwzMiwwLDAsMCwzMi0zMlYxOTJhMzIsMzIsMCwwLDAtMzItMzJIMzczQzM2NC4zNSwxNjAsMzU2LjE1LDE1NS4yMywzNTAuNTQsMTQ4LjY4WiIgc3R5bGU9ImZpbGw6bm9uZTtzdHJva2U6IzAwMDtzdHJva2UtbGluZWNhcDpyb3VuZDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLXdpZHRoOjMycHgiLz48Y2lyY2xlIGN4PSIyNTYiIGN5PSIyNzIiIHI9IjgwIiBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojMDAwO3N0cm9rZS1taXRlcmxpbWl0OjEwO3N0cm9rZS13aWR0aDozMnB4Ii8+PHBvbHlsaW5lIHBvaW50cz0iMTI0IDE1OCAxMjQgMTM2IDEwMCAxMzYgMTAwIDE1OCIgc3R5bGU9ImZpbGw6bm9uZTtzdHJva2U6IzAwMDtzdHJva2UtbGluZWNhcDpyb3VuZDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLXdpZHRoOjMycHgiLz48L3N2Zz4=");
	}
    plutoui-webcam .ionic-start{
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.2/src/svg/play-outline.svg");
		background-image: url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiI+PHRpdGxlPmlvbmljb25zLXY1LWM8L3RpdGxlPjxwYXRoIGQ9Ik0xMTIsMTExVjQwMWMwLDE3LjQ0LDE3LDI4LjUyLDMxLDIwLjE2bDI0Ny45LTE0OC4zN2MxMi4xMi03LjI1LDEyLjEyLTI2LjMzLDAtMzMuNThMMTQzLDkwLjg0QzEyOSw4Mi40OCwxMTIsOTMuNTYsMTEyLDExMVoiIHN0eWxlPSJmaWxsOm5vbmU7c3Ryb2tlOiMwMDA7c3Ryb2tlLW1pdGVybGltaXQ6MTA7c3Ryb2tlLXdpZHRoOjMycHgiLz48L3N2Zz4=");
	}
    plutoui-webcam .ionic-stop{
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.2/src/svg/stop-outline.svg");
		background-image: url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiI+PHRpdGxlPmlvbmljb25zLXY1LWM8L3RpdGxlPjxyZWN0IHg9Ijk2IiB5PSI5NiIgd2lkdGg9IjMyMCIgaGVpZ2h0PSIzMjAiIHJ4PSIyNCIgcnk9IjI0IiBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojMDAwO3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2Utd2lkdGg6MzJweCIvPjwvc3ZnPg==");
	}
</style>""");

# ╔═╡ 3d2ed3d4-60a7-416c-aaae-4dc662127f5b
const help = @htl("""
<div class="camera-help">

<h3>Welcome to the PlutoUI Webcam!</h3>

<p>👉🏾 To <strong>disable this help message</strong>, you can use <code>WebcamInput(;help=false)</code></p>

<p>👉🏾 The bound value will be a <code style="font-weight: bold;">Matrix{RGBA}</code>. By default, this will be displayed using text, but if you add <code style="font-weight: bold;">import ImageShow, ImageIO</code> somewhere in your notebook, it will be displayed as an image.</p>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1em; border: 3px solid pink; margin: 1em 3em; text-align: center;">
	<img src="https://user-images.githubusercontent.com/6933510/196425942-2ead75dd-07cc-4a88-b30c-50a0c7835862.png" style="aspect-ratio: 1; object-fit: cover; width: 100%;">
	<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Macaca_nigra_self-portrait_large.jpg/347px-Macaca_nigra_self-portrait_large.jpg" style="aspect-ratio: 1; object-fit: cover; width: 100%;">
	<div>default</div>
	<div>with <code style="font-weight: bold;">import ImageShow, ImageIO</code></div>

</div>

<p>👉🏾 Check out the <em>Live docs</em> for <code>WebcamInput</code> to learn more!</p>

</div>""")

# ╔═╡ 06062a16-d9e1-46ef-95bd-cdae8b03bafd
function html(webcam)


	@htl("""
	<plutoui-webcam>
		$(css)
		<div class="grid">
			<div class="select-device">
				<select title="Select Input Device" disabled=""><option value=""></option></select>
			</div>
			<div class="start-large">
				<button class="start-cam" title="Open camera">
				<span class="ionic ionic-start">
				</span></button>
			</div>
			<div class="controls">
				<button class="start-cam" title="Open camera">
					<span class="ionic ionic-start"></span>
				</button>
				<button class="stop-cam" title="Stop camera" disabled="">
					<span class="ionic ionic-stop"></span>
				</button>
			    <span style="width: 1em"></span>
				<button class="capture-img" title="Capture image" disabled="">
					capture <span class="ionic ionic-cam"></span>
				</button>
			</div>
		</div>
		<video autoplay=""></video>
		<div class="permissions-help" style="visibility: hidden;">
			<span>It looks like this page does not have permission to use the camera. <strong>Enable camera access</strong> and try again.</span>
		</div>
			
		<canvas style="display: none"></canvas>
		<script>
		const parent = currentScript.parentElement
	const video = parent.querySelector("video")
	const canvas = parent.querySelector("canvas")
	const start_video_ctl = parent.querySelector(".controls .start-cam")
	const start_video_large_ctl = parent.querySelector(".start-large .start-cam")
	const stop_video_ctl = parent.querySelector(".controls .stop-cam")
	const capture_ctl = parent.querySelector(".controls .capture-img")
	const select_device = parent.querySelector("select")
	const permissionsHelp = parent.querySelector(".permissions-help")
			
	const state = {
		initialized: false,
		streaming: false,
		error: false,
		stream: null,
		width: 0,
		height: 0,
		devices: [],
		preferredId: null
	};

		
	const add_listener_clean = (element, type, f) => {
		element.addEventListener(type, f)
		invalidation.then(() => 
			element.removeEventListener(type, f)
		 )
	}

			
	const checkIfHasMedia = () => {
		return !!(
			navigator.mediaDevices &&
			navigator.mediaDevices.getUserMedia
		)
	};
	const hasMedia = checkIfHasMedia()

	const getDevices = () =>{
		const constraints = {
			video: true
		}
		navigator
			.mediaDevices
			.enumerateDevices()
			.then(devices => {
				console.log("Found devices", devices)
				state.devices = devices.filter(({kind}) => kind === "videoinput")
				state.preferredId = state.devices?.[0]?.deviceId
				select_device.innerHTML = state
					.devices
					.map(({deviceId, label}) => `<option value="\${deviceId}">\${label}</option>`)
				select_device.disabled = state.devices.length <= 1
			})
	}

	const output_size = (width, height) => {
		const max = $(webcam.max_size)
		const major = Math.max(width, height)
		if(max == null || major <= max) {
			return [width, height]
		} else {
			let ratio = max / major
			return [Math.round(width * ratio), Math.round(height * ratio)]
		}
	}
	
	const tryInitVideo = () => {
		const constraints = {
  			video: {
				deviceId: state.preferredId
			}
		};
		navigator.mediaDevices
			.getUserMedia(constraints)
			.then((stream) => {
				permissionsHelp.style.visibility = "hidden";
					
				state.stream = stream;
				let {width, height} = stream.getTracks()[0].getSettings();

				const [output_width, output_height] = output_size(width, height)

				canvas.width = output_width;
				canvas.height = output_height;
	
				state.width = width
				state.height = height;
	
				video.srcObject = stream;
	
				start_video_ctl.disabled = true;
				start_video_large_ctl.disabled = true;
				start_video_large_ctl.style.visibility = "hidden";
				stop_video_ctl.disabled = false;
				capture_ctl.disabled = false;
	
			}).catch(err => {
				console.log(err)
				permissionsHelp.style.visibility = null;
				
				state.stream = null;
				state.width = 0;
	
				state.height = 0;
				state.error = err;
	
				start_video_ctl.disabled = false;
				stop_video_ctl.disabled = true;
				capture_ctl.disabled = true;
			});
	}

	const closeCamera = () => {
		video.srcObject = null;
		start_video_ctl.disabled = false;
		start_video_large_ctl.disabled = false;
		start_video_large_ctl.style.visibility = null;
		stop_video_ctl.disabled = true;
		capture_ctl.disabled = true;
		if(state.stream)
			state.stream.getTracks().forEach(track => {
				track.readyState == "live" && track.stop()
			})

		state.stream = null;
		state.width = 0;
		state.height = 0;
	}

	const capture = () => {
		const context = canvas.getContext('2d');
		context.drawImage(video, 0, 0, canvas.width, canvas.height)
		const img = context.getImageData(0, 0, canvas.width, canvas.height)
		parent.value = {width: canvas.width, height: canvas.height, data: img.data}
		parent.dispatchEvent(new CustomEvent('input'))
	}
			
	start_video_ctl.onclick = tryInitVideo
	start_video_large_ctl.onclick = tryInitVideo
	stop_video_ctl.onclick = closeCamera
	capture_ctl.onclick = capture

	add_listener_clean(select_device, 'change', (event) => {
  		state.preferredId = event.target.value
		closeCamera()
		tryInitVideo()
	});

	invalidation.then(closeCamera)

	add_listener_clean(document, "visibilitychange", () => {
		console.log(document.visibilityState)
		if (document.visibilityState != "visible") {
			closeCamera()
		}
	})
	
	getDevices()

	add_listener_clean(navigator.mediaDevices, "devicechange", getDevices)
		</script>
	</plutoui-webcam>""")
end

# ╔═╡ d9b806a2-de81-4b50-88cd-acf7db35da9a
begin
	local result = begin
	Base.@kwdef struct WebcamInput
		help::Bool = true
		avoid_allocs::Bool = false
		max_size::Union{Nothing,Int64}=nothing
		default::Union{Nothing,AbstractMatrix{RGBA{N0f8}}}=nothing
	end

	@doc """
	```julia
	@bind image WebcamInput(; kwargs...)
	```

	A webcam input. Provides the user with a small interface to select a camera and take a picture, the captured image is returned as a `Matrix{RGBA}` via `@bind`. 

	# How to use a `Matrix{RGBA}`

	The output type is of the type `Matrix{RGBA{N0f8}}`, let's break that down:
	- `Matrix`: This is a 2D **Array**, which you can index like `img[10,20]` to get an entry, of type `RGBA{N0f8}`.
	- `RGBA` (from [ColorTypes.jl](https://github.com/JuliaGraphics/ColorTypes.jl)): a `struct` with fields `r` (Red), `g` (Green), `b` (Blue) and `a` (Alpha), each of type `N0f8`. These are the digital 'channel' value that make up a color.
	- `N0f8` (from [FixedPointNumbers.jl](https://github.com/JuliaMath/FixedPointNumbers.jl)): a special type of floating point number that uses only 8 bits. Think of it as a `Float8`, rather than the usual `Float64`. You can use `Float64(x)` to convert to a normal `Float64`.

	By default, a `Matrix{RGBA}` will be displayed using text, but if you add 
	```julia
	import ImageShow, ImageIO
	```
	somewhere in your notebook, then Pluto will be able to display the matrix as a color image.

	For more image manipulation capabilities, check out [`Images.jl`](https://github.com/JuliaImages/Images.jl).

	# Keyword arguments

	- `help::Bool=true` by default, we display a little help message when you use `WebcamInput`. You can disable that here.
	- `default::Matrix{RGBA{N0f8}}` set a default image, which is used until the user captures an image. Defaults to a **1x1 transparent image**.
	- `max_size::Int64` when given, this constraints the largest dimension of the image, while maintaining aspect ratio. A lower value has better performance.
	- `avoid_allocs::Bool=false` when set to `true`, we lazily convert the raw `Vector{UInt8}` camera data to a `AbstractMatrix{RGBA{N0f8}}`, with zero allocations. This will lead to better performance, but the bound value will be an `AbstractMatrix`, not a `Matrix`.
	
	# Examples

	```julia
	@bind image WebcamInput()
	```

	Let's see what we captured:

	```julia
	import ImageShow, ImageIO
	```
	```julia
	image
	```

	Let's look at the **size** of the matrix:

	```julia
	size(image)
	```

	To get the **green** channel value of the **top right** pixel of the image:
	
	```julia
	image[1, end].g
	```

	""" WebcamInput
	end

	function AbstractPlutoDingetjes.Bonds.initial_value(w::WebcamInput)
		return w.default !== nothing ? 
			w.default :
			w.avoid_allocs ? standard_default_avoid_allocs : standard_default
	end
	Base.get(w::WebcamInput) = AbstractPlutoDingetjes.Bonds.initial_value(w)

	function AbstractPlutoDingetjes.Bonds.transform_value(w::WebcamInput, d)
		if d isa Dict
			img_lazy = ImageDataToRGBA(d)
			w.avoid_allocs ? img_lazy : collect(img_lazy)
		else
			AbstractPlutoDingetjes.Bonds.initial_value(w)
		end
	end

	function Base.show(io::IO, m::MIME"text/html", webcam::WebcamInput)
		webcam.help && @info help
		Base.show(io, m, html(webcam))
	end
	result
end

# ╔═╡ 5d9f2eeb-4cf6-4ab7-8475-301547570a32
export WebcamInput

# ╔═╡ ba3b6ecb-062e-4dd3-bfbe-a757fd63c4a7
# ╠═╡ skip_as_script = true
#=╠═╡
@bind img1 WebcamInput(; max_size=200)
  ╠═╡ =#

# ╔═╡ d0b8b2ac-60be-481d-8085-3e57525e4a74
#=╠═╡
size(img1)
  ╠═╡ =#

# ╔═╡ 55ca59b0-c292-4711-9aa6-81499184423c
#=╠═╡
typeof(img1)
  ╠═╡ =#

# ╔═╡ 62334cca-b9db-4eb0-91e2-25af04c58d0e
#=╠═╡
img1
  ╠═╡ =#

# ╔═╡ cad85f17-ff15-4a1d-8897-6a0a7ca59023
#=╠═╡
[img1 img1[end:-1:1, :]
img1[:, end:-1:1] img1[end:-1:1, end:-1:1]]
  ╠═╡ =#

# ╔═╡ 30267bdc-fe1d-4c73-b322-e19f3e934749
# ╠═╡ skip_as_script = true
#=╠═╡
@bind img2 WebcamInput(; avoid_allocs=true, max_size=40)
  ╠═╡ =#

# ╔═╡ 28d5de0c-f619-4ffd-9be0-623999b437e0
#=╠═╡
size(img2)
  ╠═╡ =#

# ╔═╡ be1b7fd5-6a06-4dee-a479-c84b56edbaba
#=╠═╡
typeof(img2)
  ╠═╡ =#

# ╔═╡ 033fea3f-f0e2-4362-96ce-041b7e0c27c6
#=╠═╡
img2
  ╠═╡ =#

# ╔═╡ 04bbfc5b-2eb2-4024-a035-ddc8fe60a932
# ╠═╡ skip_as_script = true
#=╠═╡
test_img = rand(RGBA{N0f8}, 8, 8)
  ╠═╡ =#

# ╔═╡ 3ed223be-2808-4e8f-b3c0-f2caaa11a6d2
#=╠═╡
@bind img3 WebcamInput(; default=test_img)
  ╠═╡ =#

# ╔═╡ e72950c1-2130-4a49-8d9c-0216c365683f
#=╠═╡
size(img3)
  ╠═╡ =#

# ╔═╡ a5308e5b-77d2-4bc3-b368-15320d6a4049
#=╠═╡
typeof(img3)
  ╠═╡ =#

# ╔═╡ af7b1cec-2a47-4d90-8e66-90940ae3a087
#=╠═╡
img3
  ╠═╡ =#

# ╔═╡ Cell order:
# ╠═1791669b-d1ee-4c62-9485-52d8493888a7
# ╠═5d9f2eeb-4cf6-4ab7-8475-301547570a32
# ╠═25fc026c-c593-11ec-05c8-93e16f9dc527
# ╠═cfb76adb-96da-493c-859c-ad24aa18437e
# ╠═b3b59805-7062-463f-b6c5-1679133a589f
# ╠═39f594bb-6326-4431-9fad-8974fef608a1
# ╠═31dff3d3-b3ee-426d-aec8-ee811820d842
# ╠═5104aabe-43f7-451e-b4c1-68c0b345669e
# ╟─43332d10-a10b-4acc-a3ac-8c4b4eb58c46
# ╠═6dd82485-a392-4110-9148-f70f0e7c0985
# ╠═c917c90c-6999-4553-9187-a84e1f3b9315
# ╠═9a07c7f4-e2c1-4322-bcbc-c7db90af0059
# ╠═43f46ca7-08e0-4687-87eb-218df976a8a5
# ╟─d9b806a2-de81-4b50-88cd-acf7db35da9a
# ╟─97e2467e-ca58-4b5f-949d-ad95253b1ac0
# ╟─3d2ed3d4-60a7-416c-aaae-4dc662127f5b
# ╠═06062a16-d9e1-46ef-95bd-cdae8b03bafd
# ╠═ba3b6ecb-062e-4dd3-bfbe-a757fd63c4a7
# ╠═d0b8b2ac-60be-481d-8085-3e57525e4a74
# ╠═55ca59b0-c292-4711-9aa6-81499184423c
# ╠═62334cca-b9db-4eb0-91e2-25af04c58d0e
# ╠═cad85f17-ff15-4a1d-8897-6a0a7ca59023
# ╠═30267bdc-fe1d-4c73-b322-e19f3e934749
# ╠═28d5de0c-f619-4ffd-9be0-623999b437e0
# ╠═be1b7fd5-6a06-4dee-a479-c84b56edbaba
# ╠═033fea3f-f0e2-4362-96ce-041b7e0c27c6
# ╠═04bbfc5b-2eb2-4024-a035-ddc8fe60a932
# ╠═3ed223be-2808-4e8f-b3c0-f2caaa11a6d2
# ╠═e72950c1-2130-4a49-8d9c-0216c365683f
# ╠═a5308e5b-77d2-4bc3-b368-15320d6a4049
# ╠═af7b1cec-2a47-4d90-8e66-90940ae3a087
