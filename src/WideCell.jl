### A Pluto.jl notebook ###
# v0.20.26

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
import AbstractPlutoDingetjes

# ╔═╡ f5882dbd-a603-4df8-8a20-3b2b34f0cf84
const DEFAULT_WIDTH = 1000

# ╔═╡ 4edba64f-4e71-4780-964a-d8635470a595
WideCell(; kwargs...) = x -> WideCell(x; kwargs...)

# ╔═╡ 8664c054-1cf5-41bb-9f86-c1ab408b1110
begin
	struct SafeReactDOMElement
		tag
		children
		attributes
	end

	# This one will take preference, if supported.
	function Base.show(io::IO, m::MIME"application/vnd.pluto.reactdomelement+object", s::SafeReactDOMElement)
		return AbstractPlutoDingetjes.Display.ReactDOMElement(
			tag=s.tag,
			children=s.children,
			attributes=s.attributes,
		)
	end

	# The fallback
	function Base.show(io::IO, m::MIME"text/html", s::SafeReactDOMElement)
		# Check if the old DivElement exists...
		if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :DivElement) && AbstractPlutoDingetjes.is_inside_pluto(io)
			de = Main.PlutoRunner.DivElement(
				children=s.children, 
				class=get(s.attributes, :class, get(s.attributes, "class", nothing)),
				style=get(s.attributes, :style, get(s.attributes, "style", "")),
			)

			show(io, m, de)
		else
			@warn """PlutoUI.WideCell failed to communicate with Pluto. This means that either:
			- This version of PlutoUI is not compatible with this version of Pluto. Try upgrading both to the latest versions.
			- WideCell is used in an unsupported way, e.g. embedded in another element.
			- WideCell is used outside of Pluto."""
			show(io, m, @htl """<$(s.tag) $(s.attributes)...>$(s.children)</$(s.tag)>""")
		end
	end
end

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

	SafeReactDOMElement("div", children, Dict(:class => "pui-big-wrapper"))
end

# ╔═╡ bd9e8715-4f03-43f7-b279-3d1f68365656
#=╠═╡
export WideCell
  ╠═╡ =#

# ╔═╡ 72a735ab-41bd-4ef3-ab2a-a019d9608731
let
	tag = "marquee"
	attributed = Dict(:style => "color: red;", "class"=>"asdfdfs")
	children = [1,2,3]

	@htl """<$(tag) $(attributed)...>$(children)</$(tag)>"""
end

# ╔═╡ 88d541c1-4e3f-4852-a58a-610a184f5e61
# ╠═╡ skip_as_script = true
#=╠═╡
# The point of this redirect is so we can "Disable in File" this cell, and every test will be disabled automatically.
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

# ╔═╡ bd860523-ec6e-41f0-90da-6f8a5b627d9e
md"""
# Test fallback display
"""

# ╔═╡ b681cfc2-a5f1-4d1f-942f-3847d8ddf58a
# ╠═╡ skip_as_script = true
#=╠═╡
hhh(x) = sprint() do io
	show(io, MIME"text/html"(), x)
end |> HTML
  ╠═╡ =#

# ╔═╡ ddde2dcb-e280-4c7d-ae50-f624222e6a41
#=╠═╡
hhh(WideCell([1,2,3, 999]))
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.4.0"
HypertextLiteral = "~1.0.0"
PlutoUI = "~0.7.80"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.11"
manifest_format = "2.0"
project_hash = "5ee44924343ee7c02f4257d59ecbaca664a19aef"

[[deps.AbstractPlutoDingetjes]]
git-tree-sha1 = "6c3913f4e9bdf6ba3c08041a446fb1332716cbc2"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

    [deps.ColorTypes.weakdeps]
    StyledStrings = "f489334b-da3d-4c2e-b8f0-e476e12c162b"

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
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "0ee181ec08df7d7c911901ea38baf16f755114dc"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

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
version = "2.28.1010+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.12.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "fbc875044d82c113a9dee6fc14e16cf01fd48872"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.80"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

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
# ╠═8664c054-1cf5-41bb-9f86-c1ab408b1110
# ╠═72a735ab-41bd-4ef3-ab2a-a019d9608731
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
# ╟─bd860523-ec6e-41f0-90da-6f8a5b627d9e
# ╠═b681cfc2-a5f1-4d1f-942f-3847d8ddf58a
# ╠═ddde2dcb-e280-4c7d-ae50-f624222e6a41
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
