### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 81f5b495-76c4-4c54-93ab-b49c5ecb810a
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
	md"**Project env active**"
end
  ╠═╡ =#

# ╔═╡ b7b18a54-afd7-4467-83ed-cc4f07c321fb
using HypertextLiteral

# ╔═╡ 13e81634-3b72-4b1d-a89b-36d184698d21
const details_css = @htl("""
<style type="text/css">
pluto-output details {
	border: 1px solid var(--rule-color);
	border-radius: 4px;
	padding: 0.5em 0.5em 0;
	margin-block-start: 0;
	margin-block-end: var(--pluto-cell-spacing);
}

pluto-output details:first-child {
	margin-block-start: 0;
}

pluto-output details:last-child {
	margin-block-end: 0;
}

pluto-output summary {
	cursor: pointer;
	font-weight: bold;
	margin: -0.5em -0.5em 0;
	padding: 0.5em;
}

pluto-output details[open] {
	padding: 0.5em;
}

pluto-output details[open] summary {
	border-bottom: 1px solid var(--rule-color);
	margin-bottom: 0.5em;
}

plutoui-detail {
	display: block;
	line-height: 1.45em;
	word-spacing: .053em;
	margin-block-end: var(--pluto-cell-spacing);
}

plutoui-detail:last-child {
	margin-block-end: 0;
}
</style>
""")

# ╔═╡ df840588-23bd-4b03-b5ab-ef273052d198
const Iterable = Union{AbstractVector, Tuple, Base.Generator}

# ╔═╡ 46521e2b-ea06-491a-9842-13dff7dc8299
begin
	embed_detail(detail::AbstractString) = detail
	embed_detail(detail) = if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :embed_display)
		Main.PlutoRunner.embed_display(detail)
	else
		@htl("$(detail)")
	end
	
	function details(summary::AbstractString, contents::Iterable; open::Bool=false)
		@htl("""
		$(details_css)
		<details $(open ? (open=true,) : nothing)>
			<summary>$(summary)</summary>
			<div class="summary-details">
				$(Iterators.map(contents) do detail
					@htl("<plutoui-detail>$(embed_detail(detail))</plutoui-detail>")
				end)
			</div>
		</details>
		""")
	end

	# Convenience function for when you just provide a single detail
	details(summary::AbstractString, contents; open::Bool=false) = details(summary, [contents], open=open)

	"""
	```julia
	details(summary::AbstractString, contents; open::Bool=false)
	```
	
	Create a collapsable details disclosure element (`<details>`).
	
	Useful for initially hiding content that may be important yet overly verbose or exposing advanced variables that may not always need displayed.
	
	# Arguments
	
	- `summary::AbstractString`: the always visible summary of the details element.
	- `contents::Any`: the item(s) to nest within the details element.
	
	# Keyword arguments
	
	- `open::Bool=false`: whether the details element is initially open.
	
	# Examples
	
	```julia
	details("My summary", "Some contents")
	```
	
	```julia
	details(
		"My summary",
		[
			"My first item",
			(@bind my_var Slider(1:10)),
			md"How are you feeling? \$(@bind feeling Slider(1:10))",
		],
		open=true,
	)
	```
	
	!!! warning "Beware @bind in collection declaration"
		You may want to `@bind` several variables within the `contents` argument by declaring a collection of `@bind` expressions. Wrap each `@bind` expression in parenthesis or interpolate them in `md` strings like the example above to prevent macro expansion from modifying how your collection declaration is interpreted.
	
	```julia
	# This example will cause an error
	details(
		"My summary",
		[
			"My first item",
			@bind my_var Slider(1:10),
		]
	)
	```
	"""
	details
end

# ╔═╡ da0fb772-9a70-4616-a540-5770a8d48476
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	my_details = details("I'm going to take over the world! Would you like to know more?", [
		"I'm going to start small",
		md"#### But don't mark me down just yet!",
		md"""
		Here are my steps for world domination! 🌍
		- Perfect my **evil laugh** 🦹
		- Create **_Laser (Pointer) of Doom_™** ⚡
		- Train **ninja cats** 🥷🐈
		- Build **volcanic lair** 🌋
		""",
		["Cat", "Laser (Pointer) ", "Volcano"],
		Dict(
			:cat => "Fluffy",
			:laser => "Pointy",
			:volcano => "Toasty",
		),
	])
	
	md"""
	# Details
	
	$(my_details)
	"""
end
  ╠═╡ =#

# ╔═╡ 5d28fa36-49dc-4d0f-a1c3-3fc2a5efdd0a
export details

# ╔═╡ Cell order:
# ╟─81f5b495-76c4-4c54-93ab-b49c5ecb810a
# ╠═b7b18a54-afd7-4467-83ed-cc4f07c321fb
# ╟─da0fb772-9a70-4616-a540-5770a8d48476
# ╠═5d28fa36-49dc-4d0f-a1c3-3fc2a5efdd0a
# ╟─13e81634-3b72-4b1d-a89b-36d184698d21
# ╟─df840588-23bd-4b03-b5ab-ef273052d198
# ╠═46521e2b-ea06-491a-9842-13dff7dc8299
