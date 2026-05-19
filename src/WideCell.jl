### A Pluto.jl notebook ###
# v0.20.26

using Markdown
using InteractiveUtils

# ╔═╡ 600b676e-19aa-11ef-0a02-cd61e0a3dff3
using HypertextLiteral

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
		attributes
		children
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

	SafeReactDOMElement("div", Dict(:class => "pui-big-wrapper"), children)
end

# ╔═╡ bd9e8715-4f03-43f7-b279-3d1f68365656
export WideCell

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
# ╠═╡ skip_as_script = true
#=╠═╡
@bind a html"<input type=range max=2000>"
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
hhh(x) = repr(MIME"text/html"(), x) |> HTML
  ╠═╡ =#

# ╔═╡ ddde2dcb-e280-4c7d-ae50-f624222e6a41
#=╠═╡
hmm = hhh(WideCell([1,2,3, 999]))
  ╠═╡ =#

# ╔═╡ 101b0c39-3304-40a0-b322-24fa9b774eb7
#=╠═╡
hhh( WideCell(Base.HTML("asdf"))).content
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
AbstractPlutoDingetjes = "~1.4.0"
HypertextLiteral = "~1.0.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.11"
manifest_format = "2.0"
project_hash = "2b48ee1fe405bdc24db0e5050aec273e01896ef2"

[[deps.AbstractPlutoDingetjes]]
git-tree-sha1 = "6c3913f4e9bdf6ba3c08041a446fb1332716cbc2"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.4.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"
"""

# ╔═╡ Cell order:
# ╠═c1db8e36-dfcc-41d3-9400-f99ebc9d9be4
# ╠═376bc398-a982-4b01-bc2a-e894d15893ae
# ╠═bd9e8715-4f03-43f7-b279-3d1f68365656
# ╠═14375edc-f9c4-4201-9c88-e039a986a6b7
# ╠═f5882dbd-a603-4df8-8a20-3b2b34f0cf84
# ╠═4edba64f-4e71-4780-964a-d8635470a595
# ╠═99246dda-6df5-4f3e-adeb-9a3976c4bb51
# ╠═8664c054-1cf5-41bb-9f86-c1ab408b1110
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
# ╟─bd860523-ec6e-41f0-90da-6f8a5b627d9e
# ╠═b681cfc2-a5f1-4d1f-942f-3847d8ddf58a
# ╠═ddde2dcb-e280-4c7d-ae50-f624222e6a41
# ╠═101b0c39-3304-40a0-b322-24fa9b774eb7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
