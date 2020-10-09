import Random: randstring
import Dates

export Slider, NumberField, Button, CheckBox, TextField, PasswordField, Select, MultiSelect, Radio, FilePicker, DateField, TimeField

mkattr(kwargs) = join(["$(htmlesc(k))=\"$(htmlesc(v))\"" for (k, v) in kwargs], " ")

struct Slider
    range::AbstractRange
    default::Number
    show_value::Bool
    attributes::Dict
end

"""
    Slider(range, default, show_value, attributes)
    Slider(range; default=missing, show_value=false, kwargs...)

A Slider on the given `range`.

## Examples
```jldoctest
julia> @bind x Slider(1:10)
Slider(1:10, 1, false, Dict{Union{},Union{}}())

julia> @bind x Slider(0.00 : 0.01 : 0.30)
Slider(0.0:0.01:0.3, 0.0, false, Dict{Union{},Union{}}())

julia> @bind x Slider(1:10; default=8, show_value=true)
Slider(1:10, 8, true, Dict{Union{},Union{}}())

julia> @bind x Slider(1:10; default=8, show_value=true, id="slider1")
Slider(1:10, 8, true, Dict(:id => "slider1"))

julia> @bind x Slider(1:10, 8, true, Dict("id"=>"slider1"))
Slider(1:10, 8, true, Dict("id" => "slider1"))
```
"""
Slider(range::AbstractRange; default=missing, show_value=false, kwargs...) = Slider(range, (default === missing) ? first(range) : default, show_value, kwargs)

function show(io::IO, ::MIME"text/html", slider::Slider)
    print(io, """<input 
        type="range" 
        min="$(first(slider.range))" 
        step="$(step(slider.range))" 
        max="$(last(slider.range))" 
        value="$(slider.default)"
        $(mkattr(slider.attributes))
        $(slider.show_value ? "oninput=\"this.nextElementSibling.value=this.value\"" : "")
        >""")
    
    if slider.show_value
        print(io, """<output>$(slider.default)</output>""")
    end
end

get(slider::Slider) = slider.default

"""A box where you can type in a number, within a specific range.

## Examples
```jldoctest
julia> @bind x NumberField(1:10)
NumberField(1:10, 1, Dict{Union{},Union{}}())

julia> @bind x NumberField(0.00 : 0.01 : 0.30)
NumberField(0.0:0.01:0.3, 0.0, Dict{Union{},Union{}}())

julia> @bind x NumberField(1:10; default=8)
NumberField(1:10, 8, Dict{Union{},Union{}}())```
"""
struct NumberField
    range::AbstractRange
    default::Number
    attributes::Dict
end

NumberField(range::AbstractRange; default=missing, kwargs...) = NumberField(range, (default === missing) ? first(range) : default, kwargs)

function show(io::IO, ::MIME"text/html", numberfield::NumberField)
    print(io, """<input type="number" min="$(first(numberfield.range))" step="$(step(numberfield.range))" max="$(last(numberfield.range))" value="$(numberfield.default)" $(mkattr(numberfield.attributes))>""")
end

get(numberfield::NumberField) = numberfield.default


"""A button that sends back the same value every time that it is clicked.

You can use it to _trigger reactive cells_.

## Examples

In one cell:

```jldoctest
julia> @bind go Button("Go!")
Button("Go!", Dict{Union{},Union{}}())
```

and in a second cell:

```jldoctest
julia> begin
           # reference the bound variable - clicking the button will run this cell
           go

           md"My favorite number is $(rand())!"
       end
  My favorite number is 0.5100336734986661!```
"""
struct Button
    label::AbstractString
    attributes::Dict
end
Button(; kwargs...) = Button("Click", kwargs)
Button(label; kwargs...) = Button(label, kwargs)

function show(io::IO, ::MIME"text/html", button::Button)
    print(io, """<input type="button" value="$(htmlesc(button.label))" $(mkattr(button.attributes))>""")
end

get(button::Button) = button.label


"""A checkbox to choose a Boolean value `true`/`false`.

## Examples

```jldoctest
julia> @bind programming_is_fun CheckBox()
CheckBox(false, Dict{Union{},Union{}}())

julia> @bind julia_is_fun CheckBox(default=true)
CheckBox(true, Dict{Union{},Union{}}())

julia> md"Would you like the thing? \$(@bind enable_thing CheckBox())"
  Would you like the thing? \$(@bind enable_thing CheckBox())
"""
struct CheckBox
    default::Bool
    attributes::Dict
end

CheckBox(;default::Bool=false, kwargs...) = CheckBox(default, kwargs)

function show(io::IO, ::MIME"text/html", button::CheckBox)
    print(io, """<input type="checkbox"$(button.default ? " checked" : "") $(mkattr(button.attributes))>""")
end

get(checkbox::CheckBox) = checkbox.default


"""A text input (`<input type="text">`) - the user can type text, the text is returned as `String` via `@bind`.

If `dims` is a tuple `(cols::Integer, row::Integer)`, a `<textarea>` will be shown, with the given dimensions

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="text">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/text) and [`<textarea>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea)

## Examples
```jldoctest
julia> @bind poem TextField()
TextField(nothing, "", Dict{Union{},Union{}}())

julia> @bind poem TextField((30,5); default="Hello\\nJuliaCon!")
TextField((30, 5), "Hello\\nJuliaCon!", Dict{Union{},Union{}}())
```
"""
struct TextField
    dims::Union{Tuple{Integer,Integer},Nothing}
    default::AbstractString
    attributes::Dict
end
TextField(dims::Union{Tuple{Integer,Integer},Nothing}=nothing; default::AbstractString="", kwargs...) = TextField(dims, default, kwargs)

function show(io::IO, ::MIME"text/html", textfield::TextField)
    if textfield.dims === nothing
        print(io, """<input type="text" value="$(htmlesc(textfield.default))" $(mkattr(textfield.attributes))>""")
    else
        print(io, """<textarea cols="$(textfield.dims[1])" rows="$(textfield.dims[2])" $(mkattr(textfield.attributes))>$(htmlesc(textfield.default))</textarea>""")
    end
end

get(textfield::TextField) = textfield.default



"""A password input (`<input type="password">`) - the user can type text, the text is returned as `String` via `@bind`.

This does not provide any special security measures, it just renders black dots (•••) instead of the typed characters.

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="password">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/password)

## Examples
```jldoctest
julia> @bind secret_poem PasswordField()
PasswordField("", Dict{Union{},Union{}}())

julia> @bind secret_poem PasswordField(default="Te dansen omdat men leeft")
PasswordField("Te dansen omdat men leeft", Dict{Union{},Union{}}())```
"""
struct PasswordField
    default::AbstractString
    attributes::Dict
end

PasswordField(; default="", kwargs...) = PasswordField(default, kwargs)

function show(io::IO, ::MIME"text/html", passwordfield::PasswordField)
    print(io, """<input type="password" value="$(htmlesc(passwordfield.default))" $(mkattr(passwordfield.attributes))>""")
end

get(passwordfield::PasswordField) = passwordfield.default


"""A dropdown menu (`<select>`) - the user can choose one of the `options`, an array of `String`s.

See [`MultiSelect`](@ref) for a version that allows multiple selected items.

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

See the [Mozilla docs about `select`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select)

## Examples
```jldoctest
julia> @bind veg Select(["potato", "carrot"])
Select(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "potato", "carrot" => "carrot"], missing, Dict{Union{},Union{}}())

julia> @bind veg Select(["potato" => "🥔", "carrot" => "🥕"])
Select(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "🥔", "carrot" => "🥕"], missing, Dict{Union{},Union{}}())

julia> @bind veg Select(["potato" => "🥔", "carrot" => "🥕"], default="carrot")
Select(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "🥔", "carrot" => "🥕"], "carrot", Dict{Union{},Union{}}())
"""
struct Select
    options::Array{Pair{<:AbstractString,<:Any},1}
    default::Union{Missing, AbstractString}
    attributes::Dict
end
Select(options::Array{<:AbstractString,1}; default=missing, kwargs...) = Select([o => o for o in options], default, kwargs)
Select(options::Array{<:Pair{<:AbstractString,<:Any},1}; default=missing, kwargs...) = Select(options, default, kwargs)

function show(io::IO, ::MIME"text/html", select::Select)
    withtag(io, :select, select.attributes...) do
        for o in select.options
            print(io, """<option value="$(htmlesc(o.first))"$(select.default === o.first ? " selected" : "")>""")
            if showable(MIME"text/html"(), o.second)
                show(io, MIME"text/html"(), o.second)
            else
                print(io, o.second)
            end
            print(io, "</option>")
        end
    end
end

get(select::Select) = ismissing(select.default) ? first(select.options).first : select.default


"""A multi-selector (`<select multi>`) - the user can choose one or more of the `options`, an array of `Strings.

See [`Select`](@ref) for a version that allows only one selected item.

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.

See the [Mozilla docs about `select`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select)

## Examples
```jldoctest
julia> @bind veg MultiSelect(["potato", "carrot"])
MultiSelect(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "potato", "carrot" => "carrot"], missing, Dict{Union{},Union{}}())

julia> @bind veg MultiSelect(["potato" => "🥔", "carrot" => "🥕"])
MultiSelect(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "🥔", "carrot" => "🥕"], missing, Dict{Union{},Union{}}())

julia> @bind veg MultiSelect(["potato" => "🥔", "carrot" => "🥕"], default=["carrot"])
MultiSelect(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "🥔", "carrot" => "🥕"], AbstractString["carrot"], Dict{Union{},Union{}}())
"""
struct MultiSelect
    options::Array{Pair{<:AbstractString,<:Any},1}
    default::Union{Missing, AbstractVector{AbstractString}}
    attributes::Dict
end
MultiSelect(options::Array{<:AbstractString,1}; default=missing, kwargs...) = MultiSelect([o => o for o in options], default, kwargs)
MultiSelect(options::Array{<:Pair{<:AbstractString,<:Any},1}; default=missing, kwargs...) = MultiSelect(options, default, kwargs)

function show(io::IO, ::MIME"text/html", select::MultiSelect)
    withtag(io, Symbol("select multiple")) do
        for o in select.options
            print(io, """<option value="$(htmlesc(o.first))"$(!ismissing(select.default) && o.first ∈ select.default ? " selected" : "") $(mkattr(select.attributes))>""")
            if showable(MIME"text/html"(), o.second)
                show(io, MIME"text/html"(), o.second)
            else
                print(io, o.second)
            end
            print(io, "</option>")
        end
    end
end

get(select::MultiSelect) = ismissing(select.default) ? Any[] : select.default

"""A file upload box. The chosen file will be read by the browser, and the bytes are sent back to Julia.

The optional `accept` argument can be an array of `MIME`s. The user can only select files with these MIME. If only `image/*` MIMEs are allowed, then smartphone browsers will open the camera instead of a file browser.

## Examples

```jldoctest
julia> @bind file_data FilePicker()
FilePicker(MIME[], Dict{Union{},Union{}}())

julia> file_data["data"]
UInt8[]
```

You can limit the allowed MIME types:

```jldoctest
julia> @bind image_data FilePicker([MIME("image/jpg"), MIME("image/png")])
FilePicker(MIME[MIME type image/jpg, MIME type image/png], Dict{Union{},Union{}}())

julia> @bind image_data FilePicker([MIME("image/*")]) # use MIME groups
FilePicker(MIME[MIME type image/*], Dict{Union{},Union{}}())```
"""
struct FilePicker
    accept::Array{MIME,1}
    attributes::Dict
end
FilePicker(; kwargs...) = FilePicker(MIME[], kwargs)
FilePicker(accept; kwargs...) = FilePicker(accept, kwargs)

function show(io::IO, ::MIME"text/html", filepicker::FilePicker)
    print(io, """<input type='file' accept='""")
    join(io, string.(filepicker.accept), ",")
    print(io, "' $(mkattr(filepicker.attributes))>")
end

get(select::FilePicker) = Dict("name" => "", "data" => UInt8[], "type" => "")

"""A group of radio buttons - the user can choose one of the `options`, an array of `String`s. 

`options` can also be an array of pairs `key::String => value::Any`. The `key` is returned via `@bind`; the `value` is shown.


## Examples
```jldoctest
julia> @bind veg Radio(["potato", "carrot"])
Radio(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "potato", "carrot" => "carrot"], missing, Dict{Union{},Union{}}())

julia> @bind veg Radio(["potato" => "🥔", "carrot" => "🥕"])
Radio(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "🥔", "carrot" => "🥕"], missing, Dict{Union{},Union{}}())

julia> @bind veg Radio(["potato" => "🥔", "carrot" => "🥕"], default="carrot")
Radio(Pair{var"#s16",var"#s15"} where var"#s15" where var"#s16"<:AbstractString["potato" => "🥔", "carrot" => "🥕"], "carrot", Dict{Union{},Union{}}())```
"""
struct Radio
    options::Array{Pair{<:AbstractString,<:Any},1}
    default::Union{Missing, AbstractString}
    attributes::Dict
end
Radio(options::Array{<:AbstractString,1}; default=missing, kwargs...) = Radio([o => o for o in options], default, kwargs)
Radio(options::Array{<:Pair{<:AbstractString,<:Any},1}; default=missing, kwargs...) = Radio(options, default, kwargs)

function show(io::IO, ::MIME"text/html", radio::Radio)
    groupname = randstring('a':'z')
    withtag(io, :form, :id=>groupname) do
        for o in radio.options
            withtag(io, :div) do
                print(io, """<input type="radio" id="$(htmlesc(groupname * o.first))" name="$(groupname)" value="$(htmlesc(o.first))"$(radio.default === o.first ? " checked" : "") $(mkattr(radio.attributes))>""")

                withtag(io, :label, :for=>(groupname * o.first)) do
                    if showable(MIME"text/html"(), o.second)
                        show(io, MIME"text/html"(), o.second)
                    else
                        print(io, o.second)
                    end
                end
            end
        end
    end
    withtag(io, :script) do
        print(io, """
        const form = this.querySelector('#$(groupname)')

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
    end
end

get(radio::Radio) = radio.default

"""A date input (`<input type="date">`) - the user can pick a date, the date is returned as `Dates.DateTime` via `@bind`.

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="date">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/date)

## Examples
```jldoctest
julia> using Dates

julia> @bind best_day_of_my_live DateField()
DateField(missing)

julia> @bind best_day_of_my_live DateField(default=today())
DateField(Date("2020-10-08"))
```
"""
Base.@kwdef struct DateField
    default::Union{Dates.TimeType,Missing}=missing
end

function show(io::IO, ::MIME"text/html", datefield::DateField)
    withtag(() -> (), io, :input, :type=>"date", :value=>datefield.default === missing ? "" : Dates.format(datefield.default, "Y-mm-dd"))
end
get(datefield::DateField) = datefield.default


"""A time input (`<input type="time">`) - the user can pick a time, the time is returned as `Dates.DateTime` via `@bind`.

Use `default` to set the initial value.

See the [Mozilla docs about `<input type="time">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/time)

## Examples
```jldoctest
julia> @bind lunch_time TimeField()
TimeField(missing)

julia> @bind lunch_time TimeField(default=now())
TimeField(DateTime("2020-10-08T20:49:09.106"))```
"""
Base.@kwdef struct TimeField
    default::Union{Dates.TimeType,Missing}=missing
end

function show(io::IO, ::MIME"text/html", timefield::TimeField)
    withtag(() -> (), io, :input, :type=>"time", :value=>timefield.default === missing ? "" : Dates.format(timefield.default, "HH:MM:SS"))
end
get(timefield::TimeField) = timefield.default
