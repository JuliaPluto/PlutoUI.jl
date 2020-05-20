export Slider, NumberField, Button, CheckBox, TextField, Select

struct Slider
    range::AbstractRange
    default::Number
end

Slider(range::AbstractRange; default=missing) = Slider(range, (default === missing) ? first(range) : default)

function show(io::IO, ::MIME"text/html", slider::Slider)
    print(io, """<input type="range" min="$(first(slider.range))" step="$(step(slider.range))" max="$(last(slider.range))" value="$(slider.default)">""")
end

peek(slider::Slider) = slider.default


struct NumberField
    range::AbstractRange
    default::Number
end

NumberField(range::AbstractRange; default=missing) = NumberField(range, (default === missing) ? first(range) : default)

function show(io::IO, ::MIME"text/html", numberfield::NumberField)
    print(io, """<input type="number" min="$(first(numberfield.range))" step="$(step(numberfield.range))" max="$(last(numberfield.range))" value="$(numberfield.default)">""")
end

peek(numberfield::NumberField) = numberfield.default



struct Button
    label::AbstractString
end
Button() = Button("Click")

function show(io::IO, ::MIME"text/html", button::Button)
    print(io, """<input type="button" value="$(htmlesc(button.label))">""")
end

peek(button::Button) = button.label



struct CheckBox
    default::Bool
end

CheckBox(;default::Bool=false) = CheckBox(default)

function show(io::IO, ::MIME"text/html", button::CheckBox)
    print(io, """<input type="checkbox"$(button.default ? " checked" : "")>""")
end

peek(checkbox::CheckBox) = checkbox.default


"""A text input (`<input type="text">`) - the user can type text, the text is return as `String` via `@bind`.

If `dims` is a tuple `(cols::Integer, row::Integer)`, a `<textarea>` will be shown, with the given dimensions

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="text">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/text) and [`<textarea>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea)

# Examples
`TextField()`

`TextField((30,5); default="Hello\nJuliaCon!")`"""
struct TextField
    dims::Union{Tuple{Integer, Integer}, Nothing}
    default::AbstractString
end
TextField(dims::Union{Tuple{Integer, Integer}, Nothing}=nothing; default::AbstractString="") = TextField(dims, default)

function show(io::IO, ::MIME"text/html", textfield::TextField)
    if textfield.dims === nothing
        print(io, """<input type="text" value="$(htmlesc(textfield.default))">""")
    else
        print(io, """<textarea cols="$(textfield.dims[1])" rows="$(textfield.dims[2])">$(htmlesc(textfield.default))</textarea>""")
    end
end

peek(textfield::TextField) = textfield.default


"""A dropdown menu (`<select>`) - the user can choose one of the `options`, an array of `String`s. 

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

See the [Mozilla docs about `select`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select)

# Examples
`Select(["potato", "carrot"])`

`Select(["potato" => image_of_🥔, "carrot" => image_of_🥕])`"""
struct Select
    options::Array{Pair{AbstractString, Any}, 1}
end
Select(options::Array{<:AbstractString, 1}) = Select([o => o for o in options])

function show(io::IO, ::MIME"text/html", select::Select)
    println(io, """<select>""")
    for o in select.options
        print(io, """<option value="$(htmlesc(o.first))">""")
        if showable(MIME("text/html"), o.second)
            show(io, MIME("text/html"), o.second)
        else
            print(io, o.second)
        end
        print(io, """</option>""")
    end
    println(io, """</select>""")
end

peek(select::Select) = first(select.options).first