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

# Converts a Julia array to a JS array in string form.
jsarray_string(a::AbstractArray{T}) where {T <: AbstractString} = string("[\"", join(map(htmlesc, a), "\",\""), "\"]")
jsarray_string(a::AbstractArray{T}) where {T} = string("[", join(a, ","), "]")

function show(io::IO, ::MIME"text/html", multicheckbox::MultiCheckBox)
    if multicheckbox.orientation == :column 
        flex_direction = "column"
    elseif multicheckbox.orientation == :row
        flex_direction = "row"
    else
        error("Invalid orientation $orientation. Orientation should be :row or :column")
    end

    js = read(joinpath(PKG_ROOT_DIR, "assets", "multicheckbox.js"), String)
    css = read(joinpath(PKG_ROOT_DIR, "assets", "multicheckbox.css"), String)

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

get(multicheckbox::MultiCheckBox) = multicheckbox.default
