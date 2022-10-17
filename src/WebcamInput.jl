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
	using ImageShow, ImageIO, PNGFiles
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

# ╔═╡ 31dff3d3-b3ee-426d-aec8-ee811820d842
import AbstractPlutoDingetjes

# ╔═╡ 0d0e666c-c0ef-46ca-ad4b-206e9e643e6a
# ╠═╡ disabled = true
#=╠═╡
begin 
	# Note: This is a reference implementation of show for images, mainly for educational purposes.
	# ImageShow is better
	function Base.show(io::IO, ::MIME"text/html",
						image::Array{C, 2} where C<:Colorant)
		width = size(image, 1)
		height = size(image, 2)
		clammedArray = RGBAToImageData(image)
		
		show(io, MIME("text/html"), @htl("""
			<script>
				const canvas = currentScript.parentElement.firstElementChild
				const ctx = canvas.getContext("2d")
				const imgdata = new ImageData(
					new Uint8ClampedArray(
						$(PlutoRunner.publish_to_js(clammedArray))
					),
					$(PlutoRunner.publish_to_js(width)),
					$(PlutoRunner.publish_to_js(height))
				)
				ctx.putImageData(imgdata, 0, 0)
				return canvas
			</script>
		"""))
	end
	
	function Base.show(io::IO, ::MIME"text/html", pixel::C where C <:Colorant)
		show(io, MIME("text/html"), @htl("""
			<div style="margin: .5em 0;width: 60px; border: 1px solid lightgrey; height: 60px; background-color: rgba($(255*red(pixel)), $(255*green(pixel)), $(255*blue(pixel)), $(alpha(pixel));"></div>
		"""))
	end
end
  ╠═╡ =#

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
	r = reshape(d["data"], 4, width, height) ./ 255
	return [
		RGBA(
			r[1, w, h],
			r[2, w, h],
			r[3, w, h],
			r[4, w, h]
		) for
			h in 1:height,
			w in 1:width
		]
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

# ╔═╡ 97e2467e-ca58-4b5f-949d-ad95253b1ac0
css = @htl("""<style>
    .camera-help {
		font-size: 0.8rem;
        font-family: JuliaMono, monospace;
	}

	.webcam {
		width: 300px;
		height: 200px;
		display: flex;
		flex-flow: row nowrap;
		align-items: center;
		justify-content: center;
        border: 3px dashed lightgrey; 
		border-radius: 2px;
		position: relative;
	}

	.webcam.enabled::after{
		color: red;
	}

	.webcam video {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
	}
	.grid {
		display: grid;
		width: 300px;
		height: 200px;
		grid-template-columns: 1fr 200px 1fr;
		grid-template-rows: 1fr 1fr 50px;
	}
	.select-device {
		grid-column-start: 2;
		grid-row-start: 1;
		display: flex;
		align-items: start;
		justify-content: center;
		margin:0.2em;
		z-index: 2;
	}
	.controls {
		grid-column-start: 2;
		grid-row-start: 3;
		display: flex;
		align-items: center;
		justify-content: center;
		margin:0.2em;
		z-index: 2;
	}
	.controls > button {
		margin-left: 0.2em;
	}
	.ionic {
		display: inline-block;
		width: 1em;
		height: 1em;
		line-height: 1em;
		margin-bottom: -2px;
	}
	.ionic-cam {
		background-image: url("https://unpkg.com/ionicons@5.5.2/dist/svg/camera-outline.svg");
	}
    .ionic-start{
		background-image: url("https://unpkg.com/ionicons@5.5.2/dist/svg/play-outline.svg");
	}
    .ionic-stop{
		background-image: url("https://unpkg.com/ionicons@5.5.2/dist/svg/stop-outline.svg");
	}
</style>""")

# ╔═╡ 3d2ed3d4-60a7-416c-aaae-4dc662127f5b
help = @htl("""
<div class="camera-help">

<h3>Welcome to the Pluto UI Webcam Utility, that lets you capture images from your webcam!</h3>

<p>👉🏾 To <strong>disable this help message</strong>, please invoke the constructor with the argument <code>help = false</code> - e.g. <code>WebcamInput(;help=false)</code>.</p>

<p>👉🏾 The Webcam only works in <a href="https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts">secure contexts</a> (<code>http://localhost</code> or <code>https://</code>)!</p>

<p>👉🏾 The webcam component allows you to pick a device from your system's available ones. Pick the camera you want from the dropdown.</p>

<p>👉🏾 Note that you will have to allow the browser to access the camera.</p>
</div>""")

# ╔═╡ 06062a16-d9e1-46ef-95bd-cdae8b03bafd
function html(webcam)

	id = string("id-", webcam.uuid)

	@htl("""
	<div class="webcam">
		$(css)
		<script id="$(id)">
	if (this) return this;

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
		const parent = currentScript.parentElement
		parent.value = {width: img.width, height: img.height, data: img.data}
		parent.dispatchEvent(new CustomEvent('input'))
	}
			
	start_video_ctl.onclick = tryInitVideo
	stop_video_ctl.onclick = closeCamera
	capture_ctl.onclick = capture
	select_device.addEventListener('change', (event) => {
  		state.preferredId = event.target.value
		closeCamera()
		tryInitVideo()
	});

	const cleanup = () => {
		closeCamera();
	}
	invalidation.then(cleanup)
	getDevices()
	return html`
<div class="grid">
	<div class="select-device">
		\${select_device}
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
	</div>""")
end

# ╔═╡ d9b806a2-de81-4b50-88cd-acf7db35da9a
begin
	Base.@kwdef struct WebcamInput
		uuid::UUID
		help::Bool = true
	end
	WebcamInput() = WebcamInput(; uuid = uuid4())
	WebcamInput

	function AbstractPlutoDingetjes.Bonds.initial_value(w::WebcamInput)
		return [RGBA(rand(), rand(), rand(), .97) for i in 1:100, j in 1:100]
	end
	Base.get(w::WebcamInput) = AbstractPlutoDingetjes.Bonds.initial_value(w)

	function AbstractPlutoDingetjes.Bonds.transform_value(w::WebcamInput, d)
		if d isa Dict{Any, Any}
			return ImageDataToRGBA(d)
		else
			return AbstractPlutoDingetjes.Bonds.initial_value(w)
		end
	end

	function Base.show(io::IO, m::MIME"text/html", webcam::WebcamInput)
			
		webcam.help && @info help
	
		show(io, m, html(webcam))
	end
end

# ╔═╡ ba3b6ecb-062e-4dd3-bfbe-a757fd63c4a7
@bind img WebcamInput()

# ╔═╡ d0b8b2ac-60be-481d-8085-3e57525e4a74
size(img)

# ╔═╡ 62334cca-b9db-4eb0-91e2-25af04c58d0e
img

# ╔═╡ cad85f17-ff15-4a1d-8897-6a0a7ca59023
[img img[end:-1:1, :]
img[:, end:-1:1] img[end:-1:1, end:-1:1]]

# ╔═╡ 55ca59b0-c292-4711-9aa6-81499184423c
typeof(img)

# ╔═╡ Cell order:
# ╠═1791669b-d1ee-4c62-9485-52d8493888a7
# ╠═25fc026c-c593-11ec-05c8-93e16f9dc527
# ╠═cfb76adb-96da-493c-859c-ad24aa18437e
# ╠═b3b59805-7062-463f-b6c5-1679133a589f
# ╠═31dff3d3-b3ee-426d-aec8-ee811820d842
# ╠═0d0e666c-c0ef-46ca-ad4b-206e9e643e6a
# ╟─5104aabe-43f7-451e-b4c1-68c0b345669e
# ╟─43332d10-a10b-4acc-a3ac-8c4b4eb58c46
# ╠═d9b806a2-de81-4b50-88cd-acf7db35da9a
# ╟─97e2467e-ca58-4b5f-949d-ad95253b1ac0
# ╟─3d2ed3d4-60a7-416c-aaae-4dc662127f5b
# ╠═06062a16-d9e1-46ef-95bd-cdae8b03bafd
# ╠═ba3b6ecb-062e-4dd3-bfbe-a757fd63c4a7
# ╠═d0b8b2ac-60be-481d-8085-3e57525e4a74
# ╠═55ca59b0-c292-4711-9aa6-81499184423c
# ╠═62334cca-b9db-4eb0-91e2-25af04c58d0e
# ╠═cad85f17-ff15-4a1d-8897-6a0a7ca59023
