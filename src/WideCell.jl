### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ 600b676e-19aa-11ef-0a02-cd61e0a3dff3
using HypertextLiteral

# ╔═╡ 48d03cad-0d61-4996-8458-ba39aa42efee
# ╠═╡ skip_as_script = true
#=╠═╡
using PlutoUI
  ╠═╡ =#

# ╔═╡ b44737dc-f36e-4c56-bf3d-e87d90da2d8d
#=╠═╡
PlutoUI.TableOfContents()
  ╠═╡ =#

# ╔═╡ 376bc398-a982-4b01-bc2a-e894d15893ae


# ╔═╡ f5882dbd-a603-4df8-8a20-3b2b34f0cf84
const DEFAULT_WIDTH = 1000

# ╔═╡ 4edba64f-4e71-4780-964a-d8635470a595
WideCell(; kwargs...) = x -> WideCell(x; kwargs...)

# ╔═╡ 99246dda-6df5-4f3e-adeb-9a3976c4bb51
"""
```julia
WideCell(something_to_display::Any; max_width::Int64=$DEFAULT_WIDTH)
```

Display something in an extra wide cell, breaking out of the usual margins of the Pluto notebook (usually constrained to be 700px wide). The second argument controls the new maximum width, in pixels.

The cell remains **responsive**: if the window is not wide enough to display the cell, the cell will resize to fit. In particular, on a screen less than 700px wide, this function has no effect.

# Example
This function has to be returned directly from a cell to work. For example:

```julia
let
	content = md"\""
	# Hello from an extra wide cell!
	Here is a picture:
	
	![panorama from the Vlieland lighthouse, Netherland](https://upload.wikimedia.org/wikipedia/commons/b/b0/Panorama_view_from_Vlieland_lighthouse_%28Netherlands_2015%29_%2820250182305%29.jpg)
	"\""

	WideCell(content)
end
```





# Combination with Layout
This function works well in combination with `PlutoUI.ExperimentalLayout` to create a dashboard-like experience. 


# Single-argument version
```julia
WideCell(; max_width::Int64=$DEFAULT_WIDTH)::Function
```

A single-argument method that returns an anonymous function that makes an object wider. This is useful together with the `|>` operator in Julia:

```julia
plot(x, y) |> WideCell(; max_width=1200)
```


"""
function WideCell(x; max_width::Int64=DEFAULT_WIDTH)
	if !(isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :DivElement))
		@warn """PlutoUI.WideCell failed to communicate with Pluto. This means that either:
		- This version of PlutoUI is not compatible with this version of Pluto. Try upgrading both to the latest versions.
		- WideCell is used in an unsupported way, e.g. embedded in another element.
		- WideCell is used outside of Pluto."""
		return x
	end

	children = [
		x,
		@htl("""<script>
			const PAD_RIGHT = 6 // this is padding-right from <main>
			const PAD_LEFT = 25 // this is padding-left from <main>
			const CELL_WIDTH = 700 // this is from the margin calculations of <main>
			
			const wrapper = currentScript.closest(".pui-big-wrapper")
			const cell = wrapper.closest("pluto-cell")
			const notebook = cell.closest("pluto-notebook")
			const editor = notebook.closest("pluto-editor")
			const max_width = $max_width

			if(wrapper.parentElement.tagName !== "PLUTO-OUTPUT") {
				console.error("Not directly displayed in the cell. ", wrapper.parentElement.tagName)
				return
			}

			if (max_width < CELL_WIDTH) return

			const clear_width = () => {
				cell.style.width = null
				cell.style.marginLeft = null
			}

			let last_width = -1
			const set_width = (entries) => {
				for(let e of entries) {
					
					const container_width = e.contentRect.width

					// No need to recompute
					if(last_width === container_width) return
					last_width = container_width

					// Window to small for this feature
					if(container_width < CELL_WIDTH + PAD_RIGHT + PAD_LEFT) {
						clear_width()
						return
					}

					const new_size = Math.min(container_width - PAD_LEFT - PAD_RIGHT, max_width)


					const left_margin = notebook.getBoundingClientRect().x - editor.getBoundingClientRect().x
					
					
					const max_pad = left_margin - PAD_LEFT
					const pad = Math.max(0, 
						Math.min(max_pad, (new_size - CELL_WIDTH) / 2)
					)
					
					cell.style.width = `\${new_size}px`
					cell.style.marginLeft = `\${-pad}px`
				}
			}

			const ro = new ResizeObserver(set_width)
			ro.observe(editor)
			invalidation.then(() => {
				ro.disconnect()
				clear_width()
			})
		</script>"""),
	]
	
	# Normally, you would just use PlutoUI.ExperimentalLayout.Div here
	# But because this is inside the source code of PlutoUI I am taking a shortcut
	Main.PlutoRunner.DivElement(; children, class="pui-big-wrapper")
end

# ╔═╡ bd9e8715-4f03-43f7-b279-3d1f68365656
export WideCell

# ╔═╡ 88d541c1-4e3f-4852-a58a-610a184f5e61
# ╠═╡ skip_as_script = true
#=╠═╡
const WideCellTest = WideCell
  ╠═╡ =#

# ╔═╡ c1db8e36-dfcc-41d3-9400-f99ebc9d9be4
#=╠═╡
md"""
# Hello from an extra wide cell!

![panorama from the Vlieland lighthouse, Netherland](https://upload.wikimedia.org/wikipedia/commons/b/b0/Panorama_view_from_Vlieland_lighthouse_%28Netherlands_2015%29_%2820250182305%29.jpg)
""" |> WideCellTest
  ╠═╡ =#

# ╔═╡ 14375edc-f9c4-4201-9c88-e039a986a6b7
# ╠═╡ skip_as_script = true
#=╠═╡
123 |> WideCellTest(max_width=900)
  ╠═╡ =#

# ╔═╡ 1310c8d2-16a6-4e94-8daa-3f3d9acc82d6
# ╠═╡ skip_as_script = true
#=╠═╡
@htl("""
<div style="height: 300px; background: yellow;">
	<h1>Here is an image</h1>
	<p>There is a button to generate a prompt about a cell with context from your notebook. When you ask a question like “What does this code do?” or “Help me add a linear trendline”, it helps to tell the AI model not just the code, but also code from other cells, packages, current output, etc. The prompt generation will automatically add the relevant context to the prompt, so you can get better answers from AI models.</p>
<img src="https://plutojl.org/assets/img/ai%20prompt%20generation%20beta.png">
</div>
""") |> WideCellTest(max_width=2000)
  ╠═╡ =#

# ╔═╡ c132d10a-c408-4697-95ee-c54c65119aa3
#=╠═╡
WideCellTest("adsf", max_width=200)
  ╠═╡ =#

# ╔═╡ a63eb2b8-a918-4242-9495-f3a4b2acad1b
#=╠═╡
@bind a Slider(1:10000)
  ╠═╡ =#

# ╔═╡ 7769987b-568c-4a5f-9be7-d1e95858efb6
#=╠═╡
let
	h = @htl """
		<div>
		$a
		<script>
		await new Promise((r) => {
			setTimeout(r, 500)
		})
		currentScript.parentElement.innerText = "done"
		</script>
		</div>
		"""
	
	a < 1000 ? h : WideCellTest(h, max_width=1000)
end
  ╠═╡ =#

# ╔═╡ 9ffb803d-60aa-4384-b377-ec37348c7a6a
# ╠═╡ skip_as_script = true
#=╠═╡
WideCellTest(rand(10), max_width=2000)
  ╠═╡ =#

# ╔═╡ 51a6de91-d2c1-4075-bc59-a04e7ed5bb41


# ╔═╡ d2b2bbf6-47f0-4438-b2f2-26f331414f42
# ╠═╡ skip_as_script = true
#=╠═╡
wide_text = WideCellTest(md"hello", max_width=2000)
  ╠═╡ =#

# ╔═╡ 5efc565d-d567-42dd-acd8-8d23a3cb2cbe
#=╠═╡
[wide_text, wide_text]
  ╠═╡ =#

# ╔═╡ 4ca41aa3-45d3-4059-a2a6-edd4041a12af
# ╠═╡ skip_as_script = true
#=╠═╡
[md"hello", md"hello"]
  ╠═╡ =#

# ╔═╡ 97b64bd7-49d0-4f7f-908d-06848abe6ab7
md"""
# asdf


## asdfsdfdsf

### asdfadsf

## asdfdsffd

## asdf


# adsfsdf
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.5"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.9"
manifest_format = "2.0"
project_hash = "e7223c1a7ed85110e7a6918a8fa41e0f1158e7b8"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═b44737dc-f36e-4c56-bf3d-e87d90da2d8d
# ╠═c1db8e36-dfcc-41d3-9400-f99ebc9d9be4
# ╠═376bc398-a982-4b01-bc2a-e894d15893ae
# ╠═bd9e8715-4f03-43f7-b279-3d1f68365656
# ╠═14375edc-f9c4-4201-9c88-e039a986a6b7
# ╠═f5882dbd-a603-4df8-8a20-3b2b34f0cf84
# ╠═4edba64f-4e71-4780-964a-d8635470a595
# ╠═99246dda-6df5-4f3e-adeb-9a3976c4bb51
# ╠═88d541c1-4e3f-4852-a58a-610a184f5e61
# ╠═1310c8d2-16a6-4e94-8daa-3f3d9acc82d6
# ╠═c132d10a-c408-4697-95ee-c54c65119aa3
# ╠═a63eb2b8-a918-4242-9495-f3a4b2acad1b
# ╠═7769987b-568c-4a5f-9be7-d1e95858efb6
# ╠═9ffb803d-60aa-4384-b377-ec37348c7a6a
# ╠═51a6de91-d2c1-4075-bc59-a04e7ed5bb41
# ╠═d2b2bbf6-47f0-4438-b2f2-26f331414f42
# ╠═5efc565d-d567-42dd-acd8-8d23a3cb2cbe
# ╠═4ca41aa3-45d3-4059-a2a6-edd4041a12af
# ╠═600b676e-19aa-11ef-0a02-cd61e0a3dff3
# ╠═48d03cad-0d61-4996-8458-ba39aa42efee
# ╠═97b64bd7-49d0-4f7f-908d-06848abe6ab7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
