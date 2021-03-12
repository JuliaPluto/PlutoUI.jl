### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 34012b14-d597-4b9d-b23d-66b638e4c282
using Markdown: htmlesc

# ╔═╡ a8c1e0d2-3604-4e1d-a87c-c8f5b86b79ed
md"""
# MultiCheckBox
"""

# ╔═╡ c8350f43-0d30-45d0-873b-ff56c5801ac1
md"""
## Definition
"""

# ╔═╡ 144bff17-30eb-458a-8e94-33e1f11edbeb
"Convert a Julia array to a JS array in string form."
function jsarray_string(a::AbstractVector{T}) where {T <: AbstractString}
	string("[\"", join(map(htmlesc, a), "\",\""), "\"]")
end

# ╔═╡ 91a08b98-52b5-4a2a-8180-7cba6d7232cd
function jsarray_string(a::AbstractVector{T}) where {T}
	string("[", join(a, ","), "]")
end

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

function Base.show(io::IO, ::MIME"text/html", multicheckbox::MultiCheckBox)
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

    print(io, """
    <multi-checkbox class="multicheckbox-container" style="flex-direction:$(flex_direction);"></multi-checkbox>
    <script type="text/javascript">
        const labels = $(jsarray_string(labels));
        const values = $(jsarray_string(vals));
        const checked = $(jsarray_string(default_checked));
        const defaults = $(jsarray_string(multicheckbox.default));
        const includeSelectAll = $(multicheckbox.select_all);
        $(js)
    </script>
    <style type="text/css">
        $(css)
    </style>
    """)
end

Base.get(multicheckbox::MultiCheckBox) = multicheckbox.default
end

# ╔═╡ 8bfaf4c8-557d-433e-a228-aac493746efc
@bind animals MultiCheckBox(["🐰", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, select_all=true)

# ╔═╡ 8e9f3962-d86c-4e07-b5d3-f31ee5361ca2
animals

# ╔═╡ 60183ad1-4919-4402-83fb-d53b86dda0a6
MultiCheckBox(["🐰 &&\\a \$\$", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"])

# ╔═╡ Cell order:
# ╟─a8c1e0d2-3604-4e1d-a87c-c8f5b86b79ed
# ╠═8bfaf4c8-557d-433e-a228-aac493746efc
# ╠═8e9f3962-d86c-4e07-b5d3-f31ee5361ca2
# ╠═60183ad1-4919-4402-83fb-d53b86dda0a6
# ╟─c8350f43-0d30-45d0-873b-ff56c5801ac1
# ╠═430e2c1a-832f-11eb-024a-13e3989fd7c2
# ╠═34012b14-d597-4b9d-b23d-66b638e4c282
# ╠═144bff17-30eb-458a-8e94-33e1f11edbeb
# ╠═91a08b98-52b5-4a2a-8180-7cba6d7232cd
