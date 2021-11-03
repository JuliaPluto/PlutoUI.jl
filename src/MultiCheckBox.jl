### A Pluto.jl notebook ###
# v0.17.0

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

# ╔═╡ b65c67ec-b79f-4f0e-85e6-78ff22b279d4
using HypertextLiteral

# ╔═╡ a8c1e0d2-3604-4e1d-a87c-c8f5b86b79ed
md"""
# MultiCheckBox
"""

# ╔═╡ c8350f43-0d30-45d0-873b-ff56c5801ac1
md"""
## Definition
"""

# ╔═╡ 79c4dc76-efa2-4b7f-99ea-243e3a17f81c
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ 499ca710-1a50-4aa1-87d8-d213416e8e30
if skip_as_script(@__MODULE__)
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Text("Project env active")
end

# ╔═╡ 631c14bf-e2d3-4a24-8ddc-095a3dab80ef
import AbstractPlutoDingetjes.Bonds

# ╔═╡ c38de38d-e900-4309-a9f6-1392af2f245b
subarrays(x) = (
	x[collect(I)]
	for I in Iterators.product(Iterators.repeated([true,false],length(x))...) |> collect |> vec
)

# ╔═╡ 430e2c1a-832f-11eb-024a-13e3989fd7c2
begin
	export MultiCheckBox

"""A group of checkboxes (`<input type="checkbox">`) - the user can choose enable or disable of the `options`, an array of `Strings`.
The value returned via `@bind` is a list containing the currently checked items.

See also: [`MultiSelect`](@ref).

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

`defaults` specifies which options should be checked initally.

`orientation` specifies whether the options should be arranged in `:row`'s `:column`'s.

`select_all` specifies whether or not to include a "Select All" checkbox.

# Examples
`@bind snacks MultiCheckBox(["🥕", "🐟", "🍌"]))`

`@bind snacks MultiCheckBox(["🥕" => "🐰", "🐟" => "🐱", "🍌" => "🐵"]; default=["🥕", "🍌"])`

`@bind animals MultiCheckBox(["🐰", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, select_all=true)`"""
struct MultiCheckBox
    options::Array{Pair{<:AbstractString,<:Any},1}
    default::Union{Missing,AbstractVector{AbstractString}}
    orientation::Symbol
    select_all::Bool
end

MultiCheckBox(options::Array{<:AbstractString,1}; default=String[], orientation=:row, select_all=false) = MultiCheckBox([o => o for o in options], default, orientation, select_all)
MultiCheckBox(options::Array{<:Pair{<:AbstractString,<:Any},1}; default=String[], orientation=:row, select_all=false) = MultiCheckBox(options, default, orientation, select_all)

function Base.show(io::IO, m::MIME"text/html", multicheckbox::MultiCheckBox)
    if multicheckbox.orientation == :column 
        flex_direction = "column"
    elseif multicheckbox.orientation == :row
        flex_direction = "row"
    else
        error("Invalid orientation $orientation. Orientation should be :row or :column")
    end

    js = read(joinpath(@__DIR__, "..", "assets", "multicheckbox.js"), String)
    css = read(joinpath(@__DIR__, "..", "assets", "multicheckbox.css"), String)

    labels = String[]
    vals = String[]
    default_checked = Bool[]
    for (k, v) in multicheckbox.options
        push!(labels, v)
        push!(vals, k)
        push!(default_checked, k in multicheckbox.default)
    end

    show(io, m, @htl("""
    <multi-checkbox class="multicheckbox-container" style="flex-direction: $(flex_direction);"></multi-checkbox>
    <script type="text/javascript">
        const labels = $(labels);
        const values = $(vals);
        const checked = $(default_checked);
        const defaults = $(multicheckbox.default);
        const includeSelectAll = $(multicheckbox.select_all);
        $(HypertextLiteral.JavaScript(js))
    </script>
    <style type="text/css">
        $(css)
    </style>
    """))
end

Base.get(select::MultiCheckBox) = ismissing(select.default) ? Any[] : select.default

	Bonds.initial_value(select::MultiCheckBox) = 
		ismissing(select.default) ? Any[] : select.default
	Bonds.possible_values(select::MultiCheckBox) = 
		subarrays(first.(select.options))
	function Bonds.validate_value(select::MultiCheckBox, val)
		val isa Vector && val ⊆ (first(p) for p in select.options)
	end
end

# ╔═╡ 8bfaf4c8-557d-433e-a228-aac493746efc
@bind animals MultiCheckBox(["🐰", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, select_all=true)

# ╔═╡ 8e9f3962-d86c-4e07-b5d3-f31ee5361ca2
animals

# ╔═╡ a8a7e90d-8bbf-4ab6-90a8-24a10885fb0a
@bind animals2 MultiCheckBox(["\"🐰\\\"", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, default=["🐿️" , "🐝"])

# ╔═╡ 6123cf6d-fc29-4a8f-a5a1-4366cc6457b6
animals2

# ╔═╡ 60183ad1-4919-4402-83fb-d53b86dda0a6
MultiCheckBox(["🐰 &&\\a \$\$", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"])

# ╔═╡ Cell order:
# ╟─a8c1e0d2-3604-4e1d-a87c-c8f5b86b79ed
# ╠═8bfaf4c8-557d-433e-a228-aac493746efc
# ╠═8e9f3962-d86c-4e07-b5d3-f31ee5361ca2
# ╠═a8a7e90d-8bbf-4ab6-90a8-24a10885fb0a
# ╠═6123cf6d-fc29-4a8f-a5a1-4366cc6457b6
# ╠═60183ad1-4919-4402-83fb-d53b86dda0a6
# ╟─c8350f43-0d30-45d0-873b-ff56c5801ac1
# ╟─79c4dc76-efa2-4b7f-99ea-243e3a17f81c
# ╟─499ca710-1a50-4aa1-87d8-d213416e8e30
# ╠═631c14bf-e2d3-4a24-8ddc-095a3dab80ef
# ╠═b65c67ec-b79f-4f0e-85e6-78ff22b279d4
# ╠═430e2c1a-832f-11eb-024a-13e3989fd7c2
# ╠═c38de38d-e900-4309-a9f6-1392af2f245b
