### A Pluto.jl notebook ###
# v0.19.4

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

# ╔═╡ 25fc026c-c593-11ec-05c8-93e16f9dc527
using HypertextLiteral

# ╔═╡ cfb76adb-96da-493c-859c-ad24aa18437e
using UUIDs: UUID, uuid4

# ╔═╡ b3b59805-7062-463f-b6c5-1679133a589f
using ColorTypes

# ╔═╡ 440da770-f7ec-45a4-ab60-b09380520ecb


# ╔═╡ 31dff3d3-b3ee-426d-aec8-ee811820d842
import AbstractPlutoDingetjes

# ╔═╡ 62ce4916-559e-4644-9d91-b0eedf45638a


# ╔═╡ d7210b82-83b7-48e5-ba3e-12d4556c306d
aa = [RGBA(0.5, 0.2, x/100, x * y / 10000) for x in 1:100, y in 1:100]

# ╔═╡ e9244106-6876-4238-9dec-2c32af5e0bb8
typeof(aa)

# ╔═╡ 250aad21-fd58-4c69-a002-7780834e2505
reshape(reshape(Vector(1:16), 2, 2, 4), :)

# ╔═╡ 35f04ea4-d1fc-4a57-82eb-b93d56e72498
c = RGBA(0.5, 0.5, 0.2, 1)

# ╔═╡ 5104aabe-43f7-451e-b4c1-68c0b345669e
"""
Converts ImageData vector to an RGBA Matrix.

Assumes the first two positions of the input vector contain width & height of the image (just to make communication easier)

"""
function ImageDataToRGBA(j::Vector{Int})
	width = j[1]
	height = j[2]
	r = reshape(j[3:end], 4, width, height) ./ 255
	return [
		RGBA(
			r[1, w, h],
			r[2, w, h],
			r[3, w, h],
			r[4, w, h]
		) for
			w in 1:width,
			h in 1:height
		]
end

# ╔═╡ 43332d10-a10b-4acc-a3ac-8c4b4eb58c46
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

# ╔═╡ 0d0e666c-c0ef-46ca-ad4b-206e9e643e6a
begin 
	function imageshow(io, image)
		width = size(image, 1)
		height = size(image, 2)
		pixel = image[1,1]
		clammedArray = RGBAToImageData(image)
		
		show(io, MIME("text/html"), @htl("""
			<canvas width="$width" height="$height"></canvas>
			<script>
				const canvas = currentScript.parentElement.firstElementChild
				const ctx = canvas.getContext("2d")
				const imgdata = new ImageData(new Uint8ClampedArray($(clammedArray)), $width, $height)
				ctx.putImageData(imgdata, 0, 0)
				console.log(imgdata, canvas)
				return canvas
			</script>
		"""))
	end

	function Base.show(io::IO, ::MIME"text/html", image::Array{C, 2} where C <:Colorant )
		imageshow(io, image)
	end

	function Base.show(io::IO, ::MIME"text/html", image::Array{C, 2} where C<:Colorant)
		imageshow(io, image)
	end
	
	function Base.show(io::IO, ::MIME"text/html", pixel::C where C <:Colorant)
		show(io, MIME("text/html"), @htl("""
			<div style="margin: .5em 0;width: 60px; border: 1px solid lightgrey; height: 60px; background-color: rgba($(255*red(pixel)), $(255*green(pixel)), $(255*blue(pixel)), $(alpha(pixel));"></div>
		"""))
	end
end

# ╔═╡ d1f8392f-e94d-4c4b-af0e-b18b95dc0819


# ╔═╡ d9b806a2-de81-4b50-88cd-acf7db35da9a
begin 
	Base.@kwdef struct WebcamInput
		uuid::UUID
		height::Integer = 640
		width::Integer = 320
	end
	WebcamInput() = WebcamInput(; uuid = uuid4())
	WebcamInput
end

# ╔═╡ dfb2480d-401a-408b-bbe8-61f9551b1d65
AbstractPlutoDingetjes.Bonds.initial_value(w::WebcamInput) = begin
	[RGBA(0, 0, 0, 1) for i in 1:w.height, j in 1:w.width]
end

# ╔═╡ c830df17-dd4f-4636-aaf5-a13ca1cc6b15
function AbstractPlutoDingetjes.Bonds.transform_value(w::WebcamInput, v::Vector{Int})
	ImageDataToRGBA(v)
end

# ╔═╡ 97e2467e-ca58-4b5f-949d-ad95253b1ac0
css = @htl("""<style>
	.webcam {
		width: 300px;
		height: 300px;
		display: flex;
		flex-flow: row nowrap;
		align-items: center;
		justify-content: center;
		background-color: lightgrey;
		border-radius: 8px;
		position: relative;
	}
	.webcam::after{
		content: '•';
		position: absolute; 
		color: black;
		top: 24px;
		right: 24px;
		font-size: 120px;
		line-height: 0;
	}
	.webcam.enabled::after{
		color: red;
	}
	.webcam video {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%
		height: 100%;
	}
	.grid {
		display: grid;
		height: 300px;
		width: 300px;
		grid-template-columns: 1fr 200px 1fr;
		grid-template-rows: 1fr 1fr 50px;
	}
	.controls {
		grid-column-start: 2;
		grid-row-start: 3;
		display: flex;
		align-items: center;
		justify-content: center;
		margin:0.2em;
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
</style>""")

# ╔═╡ 063bba88-ef00-4b5b-b91c-14b497da85c1
begin 
	a = 4
	function Base.show(io::IO, ::MIME"text/html", webcam::WebcamInput)
	id = string("id-", webcam.uuid)
	@info "Note that the Webcam only works in localhost or https:// contexts!"
	show(io, MIME("text/html"), @htl("""
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
	const canvas = html`<canvas style="display: none" height></canvas>`
	const start_video_ctl = html`<button>
		start <span class="ionic ionic-cam" />
		</button>`;

	const capture_ctl = html`<button>
		capture <span class="ionic ionic-cam" />
		</button>`;

	const stop_video_ctl = html`<button>
		stop <span class="ionic ionic-cam" />
		</button>`;

	const state = {
		initialized: false,
		streaming: false,
		error: false,
		stream: null,
	};

	const tryInitVideo = () => {
		const constraints = {
  			video: true,
		};
		navigator.mediaDevices
			.getUserMedia(constraints)
			.then((stream) => {
				state.stream = stream;
				video.srcObject = stream;
			}).catch(err => {
				state.stream = null;
				state.error = err;
			});
	}
	const closeCamera = () => {
		video.srcObject = null;
		if(state.stream)
			state.stream.getTracks().forEach(track => {
				track.readyState == "live" && track.stop()
			})
	}

	const capture = () => {
		const context = canvas.getContext('2d');
		context.drawImage(video, 0, 0, canvas.width, canvas.height)
		const img = context.getImageData(0, 0, canvas.width, canvas.height)

		const parent = currentScript.parentElement
		parent.value = [img.width, img.height, ...img.data]
		console.log(parent, parent.value)
		parent.dispatchEvent(new CustomEvent('input'))
	}
			
	start_video_ctl.onclick = tryInitVideo
	stop_video_ctl.onclick = closeCamera
	capture_ctl.onclick = capture

	const cleanup = () => {
		closeCamera()
	}
	invalidation.then(cleanup)

	return html`
<div class="grid">
	<div class="controls">
		\${start_video_ctl}
		\${capture_ctl}
		\${stop_video_ctl}
	</div>
</div>
\${video}
\${canvas}
`	
		</script>
	</div>"""))
end
end

# ╔═╡ ba3b6ecb-062e-4dd3-bfbe-a757fd63c4a7
begin
a
@bind img WebcamInput()
end

# ╔═╡ cad85f17-ff15-4a1d-8897-6a0a7ca59023
img

# ╔═╡ 55ca59b0-c292-4711-9aa6-81499184423c
typeof(img)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
ColorTypes = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
ColorTypes = "~0.11.2"
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "a985dc37e357a3b22b260a5def99f3530fb415d3"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.2"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═25fc026c-c593-11ec-05c8-93e16f9dc527
# ╠═cfb76adb-96da-493c-859c-ad24aa18437e
# ╠═b3b59805-7062-463f-b6c5-1679133a589f
# ╠═440da770-f7ec-45a4-ab60-b09380520ecb
# ╠═31dff3d3-b3ee-426d-aec8-ee811820d842
# ╠═62ce4916-559e-4644-9d91-b0eedf45638a
# ╠═0d0e666c-c0ef-46ca-ad4b-206e9e643e6a
# ╠═d7210b82-83b7-48e5-ba3e-12d4556c306d
# ╠═e9244106-6876-4238-9dec-2c32af5e0bb8
# ╠═250aad21-fd58-4c69-a002-7780834e2505
# ╠═35f04ea4-d1fc-4a57-82eb-b93d56e72498
# ╠═5104aabe-43f7-451e-b4c1-68c0b345669e
# ╠═43332d10-a10b-4acc-a3ac-8c4b4eb58c46
# ╠═d1f8392f-e94d-4c4b-af0e-b18b95dc0819
# ╠═d9b806a2-de81-4b50-88cd-acf7db35da9a
# ╠═dfb2480d-401a-408b-bbe8-61f9551b1d65
# ╠═c830df17-dd4f-4636-aaf5-a13ca1cc6b15
# ╟─97e2467e-ca58-4b5f-949d-ad95253b1ac0
# ╠═063bba88-ef00-4b5b-b91c-14b497da85c1
# ╠═ba3b6ecb-062e-4dd3-bfbe-a757fd63c4a7
# ╠═cad85f17-ff15-4a1d-8897-6a0a7ca59023
# ╠═55ca59b0-c292-4711-9aa6-81499184423c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
