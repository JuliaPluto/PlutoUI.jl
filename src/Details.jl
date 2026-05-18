### A Pluto.jl notebook ###
# v0.20.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

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
begin
	using HypertextLiteral, AbstractPlutoDingetjes
	import AbstractPlutoDingetjes.Display: @embed
end

# ╔═╡ b3732e34-d331-4dd2-b4fb-11b2f397d7c1
# ╠═╡ skip_as_script = true
#=╠═╡
const testslider = html"<input>"
  ╠═╡ =#

# ╔═╡ 13e81634-3b72-4b1d-a89b-36d184698d21
const details_css = @htl("""
<style type="text/css">
plutoui-detail {
	display: block;
	margin-block-end: var(--pluto-cell-spacing);
}

plutoui-detail:last-child {
	margin-block-end: 0;
}

pluto-output div.summary-title-outer {
	display: inline-flex;
	vertical-align: text-top;
	width: calc(100% - 1em);
	margin-left: -1em;
	padding-left: 1em;
}

pluto-output div.summary-title-outer > div.summary-title-inner {
	display: inline-block;
}
</style>
""")

# ╔═╡ df840588-23bd-4b03-b5ab-ef273052d198
const Iterable = Union{AbstractVector, Tuple, Base.Generator}

# ╔═╡ 46521e2b-ea06-491a-9842-13dff7dc8299
begin
	struct _SafeEmbed
		x
	end
	
	function Base.show(io::IO, m::MIME"text/html", d::_SafeEmbed)		
		if AbstractPlutoDingetjes.is_inside_pluto(io)
			if AbstractPlutoDingetjes.is_supported_by_display(io, var"@embed")
				Base.show(io, m, @embed(d.x))
				return
			elseif isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :embed_display)
				Base.show(io, m, Main.PlutoRunner.embed_display(d.x))
				return
			end
		end
		Base.show(io, m, d.x)
		return
	end
	
	embed_summary(summary) = @htl("""
		<div class='summary-title-outer'>
			<div class='summary-title-inner'>
				$(summary)
			</div>
		</div>
		""")
	embed_summary(summary::AbstractString) = summary

	embed_detail(detail) = _SafeEmbed(detail)
	embed_detail(detail::AbstractString) = detail
	
	function details(summary, contents::Iterable; open::Bool=false)
		@htl("""
		<details $(open ? (open=true,) : nothing)>
			<summary>$(embed_summary(summary))</summary>
			<div class="details-content">
				$(Iterators.map(contents) do detail
					@htl("<plutoui-detail>$(embed_detail(detail))</plutoui-detail>")
				end)
			</div>
		</details>
		$(details_css)
		""")
	end

	# Convenience function for when you just provide a single detail
	details(summary, contents; open::Bool=false) = details(summary, (contents,); open)

	"""
	```julia
	details(summary, contents; open::Bool=false)
	```
	
	Create a collapsable details disclosure element (`<details>`).
	
	Useful for initially hiding content that may be important yet overly verbose or exposing advanced variables that may not always need displayed.
	
	# Arguments
	
	- `summary::Any`: the always visible summary of the details element.
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
		You may want to `@bind` several variables within the `contents` argument by declaring a collection of `@bind` expressions. **Wrap each `@bind` expression in parenthesis** or interpolate them in `md` strings like the example above to prevent macro expansion from modifying how your collection declaration is interpreted.
	
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
	my_details = details(
		htl"I'm going to take over <u>the world!</u> Would you like to know more?", 
		[
			htl"<small>I'm going to start small</small>",
			"But not too small, mind you",
			htl"<big>Don't mark me down!</big>", # Even funnier now that this isn't md
			md"""
			## Here are my steps for world domination! 🌍
			- Perfect my **evil laugh** 🦹
			- Create **_Laser (Pointer) of Doom_™** ⚡
			- Train **ninja cats** 🥷🐈
			- Build **volcanic lair** 🌋
			""",
			@htl("<p style='font-variant: small-caps'>fantastic!</p>"),
			["Cat", "Laser (Pointer)", "Volcano"],
			Dict(
				:cat => "Fluffy",
				:laser => "Pointy",
				:volcano => "Toasty",
			),
		]; open=true
	)
	
	md"""
	# Details
	
	$(my_details)
	"""
end
  ╠═╡ =#

# ╔═╡ b8434c11-2bb5-47ba-8562-e1176cba0af7
# ╠═╡ skip_as_script = true
#=╠═╡
details("# Hello!", "**How are you?**")
  ╠═╡ =#

# ╔═╡ f833a0bf-f7f7-417d-8cd9-5f93a90aecf6
# ╠═╡ skip_as_script = true
#=╠═╡
details("# Hello!", "**How are you?**"; open=true)
  ╠═╡ =#

# ╔═╡ ef3ebb39-03ce-407b-9796-cae10d88f4a0
# ╠═╡ skip_as_script = true
#=╠═╡
details(md"# Hello!", md"**How are you?**"; open=true)
  ╠═╡ =#

# ╔═╡ 2f3bc9f1-3055-465a-8a29-792969279e06
# ╠═╡ skip_as_script = true
#=╠═╡
details(htl"<h1>Hello!</h1>", md"**How are you?**"; open=true)
  ╠═╡ =#

# ╔═╡ b7349133-2590-415c-9a11-15c85e897a5c
# ╠═╡ skip_as_script = true
#=╠═╡
details(
	"My summary",
	[
		"My first item",
		(@bind my_var testslider),
		md"How are you feeling? $(@bind feeling testslider)",
	],
	open=true,
)
  ╠═╡ =#

# ╔═╡ a5663932-9a19-4d6d-9b20-d6fefac8cf9d
#=╠═╡
my_var
  ╠═╡ =#

# ╔═╡ cd2bcfa2-5759-40d6-9358-3e7e605c5bc2
#=╠═╡
feeling
  ╠═╡ =#

# ╔═╡ ffb735cd-a98e-4e98-909e-4d7e9f2dec5e
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	bad_summary = Dict(
		:a => "A",
		:b => "B",
	)
	details(bad_summary, "Why have you done this?"; open=true)
end
  ╠═╡ =#

# ╔═╡ f18bf0a3-e59b-45d4-b8b1-5404145db44e
# ╠═╡ skip_as_script = true
#=╠═╡
details(md"This is a very long markdown summary to make sure everything is hunky-dory :)", "arst"; open=true)
  ╠═╡ =#

# ╔═╡ 5d28fa36-49dc-4d0f-a1c3-3fc2a5efdd0a
export details

# ╔═╡ 1a6003f5-0157-43cb-9316-bbdf9fccb438
# ╠═╡ skip_as_script = true
#=╠═╡
details(md"_I'm_ **going** _to_ **take** _over_ **the world!** _Would_ **you** _like_ **to** _know_ **more?** _Let's_ **make** _this_ **even** _longer_ **to** _check_ **how** _everything_ **wraps.**", "arst", open=true)
  ╠═╡ =#

# ╔═╡ 0bc0b59e-a84f-465a-9397-9d81db09a3b6
# ╠═╡ skip_as_script = true
#=╠═╡
details(htl"<em>I'm</em> <b>going</b> <em>to</em> <b>take</b> <em>over</em> <b>the world!</b> <em>Would</em> <b>you</b> <em>like</em> <b>to</b> <em>know</em> <b>more?</b> <em>Let's</em> <b>make</b> <em>this</em> <b>even</b> <em>longer</em> <b>to</b> <em>check</em> <b>how</b> <em>everything</em> <b>wraps.</b>", "arst", open=true)
  ╠═╡ =#

# ╔═╡ Cell order:
# ╟─81f5b495-76c4-4c54-93ab-b49c5ecb810a
# ╠═b7b18a54-afd7-4467-83ed-cc4f07c321fb
# ╠═da0fb772-9a70-4616-a540-5770a8d48476
# ╠═b8434c11-2bb5-47ba-8562-e1176cba0af7
# ╠═f833a0bf-f7f7-417d-8cd9-5f93a90aecf6
# ╠═ef3ebb39-03ce-407b-9796-cae10d88f4a0
# ╠═2f3bc9f1-3055-465a-8a29-792969279e06
# ╠═b3732e34-d331-4dd2-b4fb-11b2f397d7c1
# ╠═b7349133-2590-415c-9a11-15c85e897a5c
# ╠═a5663932-9a19-4d6d-9b20-d6fefac8cf9d
# ╠═cd2bcfa2-5759-40d6-9358-3e7e605c5bc2
# ╠═ffb735cd-a98e-4e98-909e-4d7e9f2dec5e
# ╠═f18bf0a3-e59b-45d4-b8b1-5404145db44e
# ╠═5d28fa36-49dc-4d0f-a1c3-3fc2a5efdd0a
# ╠═13e81634-3b72-4b1d-a89b-36d184698d21
# ╠═1a6003f5-0157-43cb-9316-bbdf9fccb438
# ╠═0bc0b59e-a84f-465a-9397-9d81db09a3b6
# ╟─df840588-23bd-4b03-b5ab-ef273052d198
# ╠═46521e2b-ea06-491a-9842-13dff7dc8299
