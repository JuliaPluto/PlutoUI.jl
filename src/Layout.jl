### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ a1c603fc-2c9e-47bd-9c51-b25f7104deb5
using Hyperscript

# ╔═╡ dd45b118-7a4d-45b3-8961-0c4fb337841b
using HypertextLiteral

# ╔═╡ 753c42ad-ca1b-42b9-99f1-cfe18a1a74f4
function is_inside_pluto(m::Module)::Bool
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) === Main
	end
end

# ╔═╡ 87d8c9ad-0d67-409b-a1b7-ca40241225e3
"""
	@skip_as_script expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) is_inside_pluto(__module__) ? esc(ex) : nothing end

# ╔═╡ 9113b5a3-d1a6-4594-bb84-33f9ae56c9e5
@skip_as_script begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
end

# ╔═╡ b1e7e95f-d6af-47e5-b6d4-1252804331d9
md"""
# Grid
"""

# ╔═╡ cc64885c-d00e-4d9d-b542-94da606798b7
md"""
# hbox and vbox
"""

# ╔═╡ 29d510b1-667e-4211-acf7-ae872cd2d1a5
# @htl("""<div style=''>
# 	$("sfd") $("asdf") $([1,2,3])
# </div>""")

# ╔═╡ 4c0dc6e3-2596-40f6-8155-a1ae0326c33d
md"""
# Div (low-level)
"""

# ╔═╡ a17cdd72-a28e-4d2b-8ae1-31625d2bb870
md"""
# Flex
"""

# ╔═╡ 5f69cc1c-463e-4958-9f58-f669514d49ac
const Iterable = Union{AbstractVector,Base.Generator}

# ╔═╡ 9f5a12df-21c7-4f79-b1fb-908427943138
# flex(x::Iterable; kwargs...) = flex(x...; kwargs...)

# ╔═╡ fe3d08e3-29bd-4edf-9d69-4f8824f8bd28
const CSS = Union{Dict,Tuple,String}

# ╔═╡ ec9c2c0e-ef97-464b-b1f0-257d80f3bc9c
function to_css_string(d::CSS)
	h = @htl("<style>$(d)</style>")
	r = repr(MIME"text/html"(), h)
	r[8:end-8]
end

# ╔═╡ 60e07094-b102-48c0-8760-d94b9746fea1
to_css_string(Dict(:as => 12, :sdf=> 2))

# ╔═╡ d1878004-fe6f-483b-b06b-c88687680c86
repr(MIME"text/html"(), @htl("""
	<div class=$(nothing)>

	</div>
	"""))

# ╔═╡ df016b84-ab72-4659-9a5e-a63e4af85259
begin
	Base.@kwdef struct HTLDiv
		children::Any
		style::CSS=Dict()
		class::Union{String,Nothing}=nothing
	end
	
	function Base.show(io::IO, m::MIME"text/html", d::HTLDiv)
		h = @htl("""
			<div style=$(d.style) class=$(d.class)>
			$(d.children)
			</div>
			""")
		show(io, m, h)
	end
end

# ╔═╡ 487c0e33-18e0-4823-89e7-0008e390c93a
maybecollect(x::Iterable) = collect(x)

# ╔═╡ 4c5ca077-16db-4f10-af1a-ba510f4d6b49
maybecollect(x::Vector) = x

# ╔═╡ e01077d8-3c44-4c6f-8a50-a9a6189613be
# Div(x::Iterable, style::CSS; kwargs...) = Div(x; style=style, kwargs...)

# ╔═╡ d801dd15-9f0a-4448-9ab4-7786e4279547
Div(x; kwargs...) = Div([x]; kwargs...)

# ╔═╡ f24c4b3e-5155-46d5-a328-932719617ca6
md"""
## Triangle
"""

# ╔═╡ 9bb89479-fa6c-44d0-8bd1-bdd3db2880f6
function pascal_row(n)
	if n == 1
		[1]
	else
		prev = pascal_row(n-1)
		[prev; 0] .+ [0; prev]
	end
end

# ╔═╡ a81011d5-e10f-4a58-941c-f69c4150730e
pascal_row(3)

# ╔═╡ 229274f2-5b10-4d58-944f-30d4acde04d8
pascal(n) = pascal_row.(1:n)

# ╔═╡ b2ef0286-0ae5-4e2f-ac8d-18d7f48b5646
pascal(5)

# ╔═╡ 0c5b1f00-57a6-494e-a508-cbac8b23b72e
d = "a" => "3"

# ╔═╡ 9238ec64-a123-486e-a615-2e7631a1123f
repr(
	MIME"text/html"(),
	@htl("""
		<div style=$(d)>
		asdf
		</div>
		
		""")
) |> Text

# ╔═╡ 3666dc17-2e67-483c-9400-242453ce0ea1
Hyperscript.Calc(:(1px + 2px))

# ╔═╡ 9a9b39f4-7187-411e-8f50-3293f85a369e
123px |> string

# ╔═╡ 8eef743b-bea0-4a97-b539-0723a231441b
@htl("""
<style>
svg {
	max-width: 100%;
	height: auto;
}
</style>
""")

# ╔═╡ 081396af-0f8f-4d2a-b087-dfba01bfd7a7
# grid([
# 		p p data
# 		p p data
# 	])

# ╔═╡ 70652040-5bf9-4408-a33c-9716f3af39e8
macro canfail(expr)
quote
	try
		$(esc(expr))

	catch e
		Text(sprint() do io
			showerror(io, e, catch_backtrace())
		end)
	end
end
end

# ╔═╡ ec996b12-1678-406b-b5b6-dbb73eabc2bf
data = rand(3)

# ╔═╡ 916f95ff-f568-48cc-91c3-ef2d2c9e397a
embed_display(x) = if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :embed_display)
	Main.PlutoRunner.embed_display(x)
else
	@htl("$(x)")
end

# ╔═╡ ca2a5bce-6565-4678-baea-535ac8ca3ca9
Div(x::Iterable; style::CSS="", class::Union{Nothing,String}=nothing) = 
	if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :DivElement)
		Main.PlutoRunner.DivElement(; 
			children=maybecollect(x), 
			style=to_css_string(style),
			class=class,
		)
	else
		HTLDiv(;
			children=[embed_display(i) for i in x], 
			style=style,
			class=class,
		)
	end

# ╔═╡ d720ae98-f34f-4870-b09a-06499e2c936d
hbox(contents::Iterable; style::Dict=Dict(), class::Union{String,Nothing}=nothing) = Div(
	contents;
	style=Dict(
		"display" => "flex",
		"flex-direction" => "row",
		style...,
	),
	class=class
)

# ╔═╡ 06a2b4f2-056c-458e-9107-870ea7a25e2f
hbox([
	"sfd", "asdf", [1,2,3]
])

# ╔═╡ f363e639-3799-4507-869c-b63c777988f5
hbox([
	Div("left"; style="flex-grow: 1"), Div("on the right")
])

# ╔═╡ 762c27a1-c71b-4354-8794-621bd0020397
vbox(contents::Iterable; style::Dict=Dict(), class::Union{String,Nothing}=nothing) = Div(
	contents;
	style=Dict(
		"display" => "flex",
		"flex-direction" => "column",
		style...,
	),
	class=class
)

# ╔═╡ da22938c-ab2c-4a9a-9df3-c69000a33d78
export hbox, vbox

# ╔═╡ 13b03bde-3dec-4c56-8b8a-c484b2f644aa
vbox([
	"sfd", "asdf"
])

# ╔═╡ a3599e04-eaff-4be7-9ee0-a792274002b2
export Div

# ╔═╡ 05865376-f0ad-4d16-a9eb-336791315f75
Div(
	"hello";
	
	style=Dict(
		"background" => "pink",
		"padding" => 20px,
		"border-radius" => 1em,
	),
	class="coolbeans",
)

# ╔═╡ af48dde2-221b-4900-9719-df67dd5ae537
Div(
	["hello", "world"];
	
	style=Dict(
		"display" => "flex",
		"flex-direction" => "column",
		
		"background" => "pink",
		"padding" => 20px,
		"border-radius" => 1em,
	),
	class="coolbeans",
)

# ╔═╡ 6e1d6a42-51e5-4dad-b149-78c805b90afa
function flex(args::Iterable; kwargs...)
	Div(args;
		style=Dict("display" => "flex", ("flex-" * String(k) => string(v) for (k,v) in kwargs)...)
		)
end

# ╔═╡ 6eeec9ed-49bf-45dd-ae73-5cac8ca276f7
flex(rand(UInt8, 3))

# ╔═╡ cf9c83c6-ee74-4fd4-ade4-5cd3d409f13f
let
	p = pascal(5)
	
	padder = Div([], style=Dict("flex" => "1 1 auto"))
	
	rows = map(p) do row
		
		items = map(row) do item
			Div([item], style=Dict("margin" => "0px 5px"))
		end
		
		flex(
			[padder, items..., padder]
		)
	end
	flex(rows;
		direction="column"
	)
end

# ╔═╡ a8f02660-32d8-428f-a0aa-d8eb06efabda
@canfail repr(
	MIME"text/html"(),
	Div([], style=Dict("a" => 2))
) |> Text

# ╔═╡ 8fbd9087-c932-4a01-bd44-69007e9f6656
function grid(items::AbstractMatrix; 
		fill_width::Bool=true,
		column_gap::Union{String,Hyperscript.Unit}=1em,
		row_gap::Union{String,Hyperscript.Unit}=0em,
		class::Union{Nothing,String}=nothing,
		style::Dict=Dict()
	)
	Div(
		Div.(vec(permutedims(items, [2,1])));
		style=Dict(
			"display" => fill_width ? "grid" : "inline-grid", 
			"grid-template-columns" => "repeat($(size(items,2)), auto)",
			"column-gap" => string(column_gap),
			"row-gap" => string(row_gap),
			style...
		),
		class=class
	)
end

# ╔═╡ 306ee9a7-152f-4c4a-867d-a4303f4ddd6c
export grid

# ╔═╡ 574ef2ab-6438-49f5-ba63-12e0b4f69c7a
grid([
	md"a" md"b"
	md"c" md"d"
	md"e" md"f"
]; fill_width=false)

# ╔═╡ ba3bd054-a615-4c0e-9675-33f791f3faac
grid([
	md"a" md"b"
	md"c" md"d"
	md"e" md"f"
]; fill_width=false, column_gap=4em)

# ╔═╡ 59c3941b-7377-4dbd-b0d2-75bf3bc7a8d1
grid(rand(UInt8, 10,8))

# ╔═╡ 4726f3fe-a761-4a58-a177-a2ef79663a90
grid(rand(UInt8, 10,10); fill_width=false)

# ╔═╡ 18cc9fbe-a37a-11eb-082b-e99673bd677d
function aside(x)
	@htl("""
		<style>
		
		
		@media (min-width: calc(700px + 30px + 300px)) {
			aside.plutoui-aside-wrapper {
				position: absolute;
				right: -11px;
				width: 0px;
			}
			aside.plutoui-aside-wrapper > div {
				width: 300px;
			}
		}
		</style>
		
		<aside class="plutoui-aside-wrapper">
		<div>
		$(x)
		</div>
		</aside>
		
		""")
end

# ╔═╡ 9a166646-75c2-4711-9fad-665b01731759
sbig = md"""
To see the various ways we can pass dimensions to these functions, consider the following examples:
```jldoctest
julia> zeros(Int8, 2, 3)
2×3 Matrix{Int8}:
 0  0  0
 0  0  0

julia> zeros(Int8, (2, 3))
2×3 Matrix{Int8}:
 0  0  0
 0  0  0

julia> zeros((2, 3))
2×3 Matrix{Float64}:
 0.0  0.0  0.0
 0.0  0.0  0.0
```
Here, `(2, 3)` is a [`Tuple`](@ref) and the first argument — the element type — is optional, defaulting to `Float64`.

## [Array literals](@id man-array-literals)

Arrays can also be directly constructed with square braces; the syntax `[A, B, C, ...]`
creates a one dimensional array (i.e., a vector) containing the comma-separated arguments as
its elements. The element type ([`eltype`](@ref)) of the resulting array is automatically
determined by the types of the arguments inside the braces. If all the arguments are the
same type, then that is its `eltype`. If they all have a common
[promotion type](@ref conversion-and-promotion) then they get converted to that type using
[`convert`](@ref) and that type is the array's `eltype`. Otherwise, a heterogeneous array
that can hold anything — a `Vector{Any}` — is constructed; this includes the literal `[]`
where no arguments are given.
""";

# ╔═╡ d373edd9-5537-4f15-8c36-31aebc2569b5
export em, px, pt, vh, vw, vmin, vmax, pc, fr

# ╔═╡ 50c3dce4-48c7-46b4-80a4-5af9cd83a0a8
smid = md"""

## [Array literals](@id man-array-literals)

Arrays can also be directly constructed with square braces; the syntax `[A, B, C, ...]`
creates a one dimensional array (i.e., a vector) containing the comma-separated arguments as
its elements. The element type ([`eltype`](@ref)) of the resulting array is automatically
determined by the types of the arguments inside the braces. If all the arguments are the
same type, then that is its `eltype`. If they all have a common
[promotion type](@ref conversion-and-promotion) then they get converted to that type using
[`convert`](@ref) and that type is the array's `eltype`. Otherwise, a heterogeneous array
that can hold anything — a `Vector{Any}` — is constructed; this includes the literal `[]`
where no arguments are given.
"""

# ╔═╡ 87d374e1-e75f-468f-bc90-59d2013c361f
ssmall = md"""

Arrays can also be directly constructed with square braces; the syntax `[A, B, C, ...]`
creates a one dimensional array (i.e., a vector) containing the comma-separated arguments as
its elements.
"""

# ╔═╡ 32aea35b-7b19-4568-a569-7fe5ecb23d00
flex([smid, ssmall, ssmall]; direction="row")

# ╔═╡ b2aa64b7-8bbc-4dd6-86a6-731a7a2e9c14
md"""
# Aside
asdfsadf
a
sdf
asdf

$(aside(ssmall))

a
sdf
asd
f



asdfasdf

"""

# ╔═╡ 773685a4-a6f7-4f59-98d5-83adcd176a8e
begin
	struct Show{M <: MIME}
		mime::M
		data
	end

	Base.show(io::IO, ::M, x::Show{M}) where M <: MIME = write(io, x.data)
	
	Show
end

# ╔═╡ 9d82ca2b-664d-461e-a93f-61c467bd983a
p = let
	data = if is_inside_pluto(@__MODULE__)
		url = "https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg"
		read(download(url))
	else
		UInt8[]
	end
	Show(MIME"image/jpg"(), data)
end

# ╔═╡ ef2f1b47-bba7-48f7-96aa-e40349a9dca9
[
	p p embed_display(data)
	p p embed_display(data)
] |> grid

# ╔═╡ d24dfd97-5100-45f4-be12-ad30f98cc519
aside(embed_display(p))

# ╔═╡ Cell order:
# ╟─753c42ad-ca1b-42b9-99f1-cfe18a1a74f4
# ╟─87d8c9ad-0d67-409b-a1b7-ca40241225e3
# ╠═9113b5a3-d1a6-4594-bb84-33f9ae56c9e5
# ╟─b1e7e95f-d6af-47e5-b6d4-1252804331d9
# ╠═306ee9a7-152f-4c4a-867d-a4303f4ddd6c
# ╠═574ef2ab-6438-49f5-ba63-12e0b4f69c7a
# ╠═ba3bd054-a615-4c0e-9675-33f791f3faac
# ╠═59c3941b-7377-4dbd-b0d2-75bf3bc7a8d1
# ╠═4726f3fe-a761-4a58-a177-a2ef79663a90
# ╟─cc64885c-d00e-4d9d-b542-94da606798b7
# ╠═da22938c-ab2c-4a9a-9df3-c69000a33d78
# ╠═06a2b4f2-056c-458e-9107-870ea7a25e2f
# ╠═29d510b1-667e-4211-acf7-ae872cd2d1a5
# ╠═f363e639-3799-4507-869c-b63c777988f5
# ╠═13b03bde-3dec-4c56-8b8a-c484b2f644aa
# ╠═d720ae98-f34f-4870-b09a-06499e2c936d
# ╠═762c27a1-c71b-4354-8794-621bd0020397
# ╟─4c0dc6e3-2596-40f6-8155-a1ae0326c33d
# ╠═a3599e04-eaff-4be7-9ee0-a792274002b2
# ╠═05865376-f0ad-4d16-a9eb-336791315f75
# ╠═af48dde2-221b-4900-9719-df67dd5ae537
# ╟─a17cdd72-a28e-4d2b-8ae1-31625d2bb870
# ╠═32aea35b-7b19-4568-a569-7fe5ecb23d00
# ╠═6eeec9ed-49bf-45dd-ae73-5cac8ca276f7
# ╠═6e1d6a42-51e5-4dad-b149-78c805b90afa
# ╠═5f69cc1c-463e-4958-9f58-f669514d49ac
# ╠═9f5a12df-21c7-4f79-b1fb-908427943138
# ╠═fe3d08e3-29bd-4edf-9d69-4f8824f8bd28
# ╠═ec9c2c0e-ef97-464b-b1f0-257d80f3bc9c
# ╠═60e07094-b102-48c0-8760-d94b9746fea1
# ╠═d1878004-fe6f-483b-b06b-c88687680c86
# ╠═df016b84-ab72-4659-9a5e-a63e4af85259
# ╟─487c0e33-18e0-4823-89e7-0008e390c93a
# ╟─4c5ca077-16db-4f10-af1a-ba510f4d6b49
# ╠═ca2a5bce-6565-4678-baea-535ac8ca3ca9
# ╠═e01077d8-3c44-4c6f-8a50-a9a6189613be
# ╠═d801dd15-9f0a-4448-9ab4-7786e4279547
# ╟─f24c4b3e-5155-46d5-a328-932719617ca6
# ╠═9bb89479-fa6c-44d0-8bd1-bdd3db2880f6
# ╠═a81011d5-e10f-4a58-941c-f69c4150730e
# ╠═229274f2-5b10-4d58-944f-30d4acde04d8
# ╠═b2ef0286-0ae5-4e2f-ac8d-18d7f48b5646
# ╠═cf9c83c6-ee74-4fd4-ade4-5cd3d409f13f
# ╠═9238ec64-a123-486e-a615-2e7631a1123f
# ╠═a8f02660-32d8-428f-a0aa-d8eb06efabda
# ╠═0c5b1f00-57a6-494e-a508-cbac8b23b72e
# ╠═a1c603fc-2c9e-47bd-9c51-b25f7104deb5
# ╠═3666dc17-2e67-483c-9400-242453ce0ea1
# ╠═9a9b39f4-7187-411e-8f50-3293f85a369e
# ╠═8fbd9087-c932-4a01-bd44-69007e9f6656
# ╠═8eef743b-bea0-4a97-b539-0723a231441b
# ╠═081396af-0f8f-4d2a-b087-dfba01bfd7a7
# ╟─70652040-5bf9-4408-a33c-9716f3af39e8
# ╠═ef2f1b47-bba7-48f7-96aa-e40349a9dca9
# ╠═ec996b12-1678-406b-b5b6-dbb73eabc2bf
# ╠═b2aa64b7-8bbc-4dd6-86a6-731a7a2e9c14
# ╟─916f95ff-f568-48cc-91c3-ef2d2c9e397a
# ╠═d24dfd97-5100-45f4-be12-ad30f98cc519
# ╠═dd45b118-7a4d-45b3-8961-0c4fb337841b
# ╠═18cc9fbe-a37a-11eb-082b-e99673bd677d
# ╠═9a166646-75c2-4711-9fad-665b01731759
# ╠═d373edd9-5537-4f15-8c36-31aebc2569b5
# ╟─50c3dce4-48c7-46b4-80a4-5af9cd83a0a8
# ╟─87d374e1-e75f-468f-bc90-59d2013c361f
# ╟─773685a4-a6f7-4f59-98d5-83adcd176a8e
# ╟─9d82ca2b-664d-461e-a93f-61c467bd983a
