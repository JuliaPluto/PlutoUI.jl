import Random: randstring

export Slider, NumberField, Button, CheckBox, TextField, Select, FilePicker, Radio

struct Slider
    range::AbstractRange
    default::Number
end

Slider(range::AbstractRange; default=missing) = Slider(range, (default === missing) ? first(range) : default)

function show(io::IO, ::MIME"text/html", slider::Slider)
    print(io, """<input type="range" min="$(first(slider.range))" step="$(step(slider.range))" max="$(last(slider.range))" value="$(slider.default)">""")
end

get(slider::Slider) = slider.default


struct NumberField
    range::AbstractRange
    default::Number
end

NumberField(range::AbstractRange; default=missing) = NumberField(range, (default === missing) ? first(range) : default)

function show(io::IO, ::MIME"text/html", numberfield::NumberField)
    print(io, """<input type="number" min="$(first(numberfield.range))" step="$(step(numberfield.range))" max="$(last(numberfield.range))" value="$(numberfield.default)">""")
end

get(numberfield::NumberField) = numberfield.default



struct Button
    label::AbstractString
end
Button() = Button("Click")

function show(io::IO, ::MIME"text/html", button::Button)
    print(io, """<input type="button" value="$(htmlesc(button.label))">""")
end

get(button::Button) = button.label



struct CheckBox
    default::Bool
end

CheckBox(;default::Bool=false) = CheckBox(default)

function show(io::IO, ::MIME"text/html", button::CheckBox)
    print(io, """<input type="checkbox"$(button.default ? " checked" : "")>""")
end

get(checkbox::CheckBox) = checkbox.default


"""A text input (`<input type="text">`) - the user can type text, the text is return as `String` via `@bind`.

If `dims` is a tuple `(cols::Integer, row::Integer)`, a `<textarea>` will be shown, with the given dimensions

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="text">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/text) and [`<textarea>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea)

# Examples
`TextField()`

`TextField((30,5); default="Hello\nJuliaCon!")`"""
struct TextField
    dims::Union{Tuple{Integer,Integer},Nothing}
    default::AbstractString
end
TextField(dims::Union{Tuple{Integer,Integer},Nothing}=nothing; default::AbstractString="") = TextField(dims, default)

function show(io::IO, ::MIME"text/html", textfield::TextField)
    if textfield.dims === nothing
        print(io, """<input type="text" value="$(htmlesc(textfield.default))">""")
    else
        print(io, """<textarea cols="$(textfield.dims[1])" rows="$(textfield.dims[2])">$(htmlesc(textfield.default))</textarea>""")
    end
end

get(textfield::TextField) = textfield.default


"""A dropdown menu (`<select>`) - the user can choose one of the `options`, an array of `String`s. 

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

See the [Mozilla docs about `select`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select)

# Examples
`Select(["potato", "carrot"])`

`Select(["potato" => "🥔", "carrot" => "🥕"])`"""
struct Select
    options::Array{Pair{AbstractString,Any},1}
end
Select(options::Array{<:AbstractString,1}) = Select([o => o for o in options])

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

get(select::Select) = first(select.options).first


struct FilePicker
    accept::Array{String,1}
end
FilePicker() = FilePicker(String[])

function show(io::IO, ::MIME"text/html", filepicker::FilePicker)
    print(io, """<input type='file' accept='""")
    join(io, filepicker.accept, ",")
    print(io, "'>")
end

get(select::FilePicker) = Dict("name" => "", "data" => [], "type" => "")

struct Radio
    options::Array{Pair{AbstractString,Any},1}
    default::AbstractString
end
Radio(options::Array{<:AbstractString,1}; default::AbstractString="") = Radio([o => o for o in options], default)

function show(io::IO, ::MIME"text/html", radio::Radio)
    groupname = randstring(12)
    println(io, """<form id="$(groupname)">""")
    for o in radio.options
        print(io, "<div>")
        print(io, """<input type="radio" id="$(groupname * htmlesc(o.first))" name="$(groupname)" value="$(htmlesc(o.first))" $(radio.default == o.first ? "checked" : "")>""")
        print(io, """<label for="$(groupname * htmlesc(o.first))">""")
        if showable(MIME"text/html"(), o.second)
            show(io, MIME"text/html"(), o.second)
        else
            print(io, o.second)
        end
        print(io, """</label>""")
        println(io, """</div>""")
    end
    println(io, """</form>""")
    println(io, """<script>""")
    println(io, """
    const form = this.querySelector('#w7qQcdzzKNuF')

    form.oninput = (e) => {
        form.value = e.target.value
        // and bubble upwards
    }

    // set initial value:
    const selected_radio = form.querySelector('input[checked]')
    if(selected_radio != null){
        form.value = selected_radio.value
    }
    """)
    println(io, """</script>""")
end