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

	plutoui-webcam video {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
	}
	plutoui-webcam .grid {
		display: grid;
		width: 300px;
		height: 200px;
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
	}
    plutoui-webcam .ionic-start{
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.2/src/svg/play-outline.svg");
	}
    plutoui-webcam .ionic-stop{
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.2/src/svg/stop-outline.svg");
	}
</style>""");

# ╔═╡ 3d2ed3d4-60a7-416c-aaae-4dc662127f5b
const help = @htl("""
<div class="camera-help">

<h3>Welcome to the PlutoUI Webcam!</h3>

<p>👉🏾 To <strong>disable this help message</strong>, you can use <code>WebcamInput(;help=false)</code></p>

<p>👉🏾 The bound value will be a <code style="font-weight: bold;">Matrix{RGBA}</code>. By default, this will be displayed using text, but if you add <code style="font-weight: bold;">import ImageShow</code> somewhere in your notebook, it will be displayed as an image.</p>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1em; border: 3px solid pink; margin: 1em 3em; text-align: center;">
	<img src="https://user-images.githubusercontent.com/6933510/196425942-2ead75dd-07cc-4a88-b30c-50a0c7835862.png" style="aspect-ratio: 1; object-fit: cover; width: 100%;">
	<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Macaca_nigra_self-portrait_large.jpg/347px-Macaca_nigra_self-portrait_large.jpg" style="aspect-ratio: 1; object-fit: cover; width: 100%;">
	<div>default</div>
	<div>with <code style="font-weight: bold;">import ImageShow</code></div>

</div>

<p>👉🏾 The Webcam only works in <a href="https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts">secure contexts</a> (<code>http://localhost</code> or <code>https://</code>)!</p>

</div>""")

# ╔═╡ 06062a16-d9e1-46ef-95bd-cdae8b03bafd
function html(webcam)


	@htl("""
	<plutoui-webcam>
		$(css)
		<script>
		const parent = currentScript.parentElement

	const checkIfHasMedia = () => {
		return !!(
			navigator.mediaDevices &&
			navigator.mediaDevices.getUserMedia
		)
	};
	const hasMedia = checkIfHasMedia()
	
	const video = html`<video autoplay></video>`
	const canvas = html`<canvas style="display: none"></canvas>`
	const start_video_ctl = html`<button title="Open camera">
		<span class="ionic ionic-start" />
		</button>`;
	const start_video_large_ctl = html`<button title="Open camera">
		<span class="ionic ionic-start" />
		</button>`;

	const capture_ctl = html`<button title="Capture image" disabled>
		capture <span class="ionic ionic-cam" />
		</button>`;

	const stop_video_ctl = html`<button title="Stop camera" disabled>
		<span class="ionic ionic-stop" />
		</button>`;
	const select_device = html`<select title="Select Input Device" disabled>
		<option value="">Loading...</option>
		</select>`;

	const state = {
		initialized: false,
		streaming: false,
		error: false,
		stream: null,
		height: 0,
		width: 0,
		devices: [],
		preferredId: null
	};

	const getDevices = () =>{
		const constraints = {
			video: true
		}
		navigator
			.mediaDevices
			.enumerateDevices()
			.then(devices => {
				state.devices = devices.filter(({kind}) => kind === "videoinput")
				state.preferredId = state.devices?.[0]?.deviceId
				select_device.innerHTML = state
					.devices
					.map(({deviceId, label}) => `<option value="\${deviceId}">\${label}</option>`)
				select_device.disabled = state.devices.length <= 1
			})
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
				state.stream = stream;
				let {width, height} = stream.getTracks()[0].getSettings();

				canvas.width = width;
				canvas.height = height;
	
				state.width = width
				state.height = height;
	
				video.srcObject = stream;
	
				start_video_ctl.disabled = true;
				start_video_large_ctl.disabled = true;
				start_video_large_ctl.style.visibility = "hidden";
				stop_video_ctl.disabled = false;
				capture_ctl.disabled = false;
	
			}).catch(err => {
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
		context.drawImage(video, 0, 0, state.width, state.height)
		const img = context.getImageData(0, 0, state.width, state.height)
		console.log(state)
		parent.value = {width: img.width, height: img.height, data: img.data}
		parent.dispatchEvent(new CustomEvent('input'))
	}
			
	start_video_ctl.onclick = tryInitVideo
	start_video_large_ctl.onclick = tryInitVideo
	stop_video_ctl.onclick = closeCamera
	capture_ctl.onclick = capture
	select_device.addEventListener('change', (event) => {
  		state.preferredId = event.target.value
		closeCamera()
		tryInitVideo()
	});

	invalidation.then(closeCamera)
	const on_vis_change = () => {
		console.log(document.visibilityState)
		if (document.visibilityState != "visible") {
			closeCamera()
		}
	}
	document.addEventListener("visibilitychange", on_vis_change)
	invalidation.then(() => 
		document.removeEventListener("visibilitychange", on_vis_change)
	 )
	
	getDevices()
	return html`
<div class="grid">
	<div class="select-device">
		\${select_device}
	</div>
	<div class="start-large">
		\${start_video_large_ctl}
	</div>
	<div class="controls">
		\${start_video_ctl}
		\${stop_video_ctl}
	    <span style="width: 1em"></span>
		\${capture_ctl}
	</div>
</div>
\${video}
\${canvas}
`
		</script>
	</plutoui-webcam>""")
end

# ╔═╡ d9b806a2-de81-4b50-88cd-acf7db35da9a
begin
	Base.@kwdef struct WebcamInput
		help::Bool = true
		avoid_allocs::Bool = false
		default::Union{Nothing,AbstractMatrix{RGBA{N0f8}}}=nothing
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
end

# ╔═╡ ba3b6ecb-062e-4dd3-bfbe-a757fd63c4a7
# ╠═╡ skip_as_script = true
#=╠═╡
@bind img1 WebcamInput()
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
# @bind img2 WebcamInput(; avoid_allocs=true)
  ╠═╡ =#

# ╔═╡ 28d5de0c-f619-4ffd-9be0-623999b437e0
size(img2)

# ╔═╡ be1b7fd5-6a06-4dee-a479-c84b56edbaba
typeof(img2)

# ╔═╡ 033fea3f-f0e2-4362-96ce-041b7e0c27c6
img2

# ╔═╡ 04bbfc5b-2eb2-4024-a035-ddc8fe60a932
# ╠═╡ skip_as_script = true
#=╠═╡
test_img = rand(RGBA{N0f8}, 8, 8)
  ╠═╡ =#

# ╔═╡ 3ed223be-2808-4e8f-b3c0-f2caaa11a6d2
# @bind img3 WebcamInput(; default=test_img)

# ╔═╡ e72950c1-2130-4a49-8d9c-0216c365683f
size(img3)

# ╔═╡ a5308e5b-77d2-4bc3-b368-15320d6a4049
typeof(img3)

# ╔═╡ af7b1cec-2a47-4d90-8e66-90940ae3a087
img3

# ╔═╡ Cell order:
# ╠═1791669b-d1ee-4c62-9485-52d8493888a7
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
# ╠═d9b806a2-de81-4b50-88cd-acf7db35da9a
# ╠═97e2467e-ca58-4b5f-949d-ad95253b1ac0
# ╠═3d2ed3d4-60a7-416c-aaae-4dc662127f5b
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
