export Slider, Button, CheckBox, TextField, Select

struct Slider
    range::AbstractRange
end

function show(io::IO, ::MIME"text/html", slider::Slider)
    print(io, """<input type="range" min="$(slider.range.start)" max="$(slider.range.stop)" value="$(slider.range.start)">""")
end

peek(slider::Slider) = first(slider.range)



struct Button
    label::String
end
Button() = Button("Click")

function show(io::IO, ::MIME"text/html", button::Button)
    print(io, """<input type="button" value="$(sanitize(button.label))">""")
end

peek(button::Button) = button.label



struct CheckBox
end

function show(io::IO, ::MIME"text/html", button::CheckBox)
    print(io, """<input type="checkbox">""")
end

peek(checkbox::CheckBox) = false



struct TextField
    defaultvalue::AbstractString
end
TextField() = TextField("")

function show(io::IO, ::MIME"text/html", textfield::TextField)
    print(io, """<input type="text">""")
end

peek(textfield::TextField) = textfield.defaultvalue



struct Select
    options::Array{Pair{AbstractString, Any}, 1}
end
Select(options::Array{AbstractString, 1}) = Select([o => o for o in options])

function show(io::IO, ::MIME"text/html", select::Select)
    println(io, """<select>""")
    for o in select.options
        print(io, """<option value="$(sanitize(o.first))">""")
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