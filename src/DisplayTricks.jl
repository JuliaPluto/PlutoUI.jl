##
# MIME stuff
##

export as_mime

struct AsMIME
    mime::MIME
    x::Any
end

Base.showable(m::MIME, am::AsMIME) = m == am.mime
Base.show(io::IO, m::MIME, am::AsMIME) = Base.show(io, m, am.x)

function as_mime(m::MIME)
    x -> as_mime(m, x)
end

function as_mime(m::MIME, x)
    AsMIME(m, x)
end

export as_text, as_html, as_svg, as_png
const as_text = as_mime(MIME"text/plain"())
const as_html = as_mime(MIME"text/html"())
const as_svg = as_mime(MIME"image/svg+xml"())
const as_png = as_mime(MIME"image/png"())
# as_jpg = as_mime(MIME"image/jpg"())
# as_bmp = as_mime(MIME"image/bmp"())
# as_gif = as_mime(MIME"image/gif"())

##
# terminal classics
##

export Dump, Show, Print

"""
    Dump(x; maxdepth=8)

Every part of the representation of a value. The depth of the output is truncated at maxdepth. 

This is a variant of [`Base.dump`](@ref) that returns the representation directly, instead of printing it to stdout.

See also: [`Print`](@ref) and [`with_terminal`](@ref).
"""
function Dump(x; maxdepth=8)
	sprint() do io
		dump(io, x; maxdepth=maxdepth)
	end |> Text
end

"""
    Show(mime::MIME, data)

An object that can be rendered as the `mime` MIME type, by writing `data` to the IO stream. For use in environments with rich output support. Read more about [`Base.show`](@ref).

# Examples

```julia
Show(MIME"text/html"(), "I can be <b>rendered</b> as <em>HTML</em>!")
```

```julia
Show(MIME"image/png"(), read("dog.png"))
```

`Base.showable` and `Base.show` are defined for a `Show`.

```julia
s = Show(MIME"text/latex"(), "\\\\frac{hello}{world}")

showable(MIME"text/latex"(), s) == true

repr(MIME"text/latex"(), s) == "\\\\frac{hello}{world}"
```

"""
struct Show
    mime::MIME
    data
end

Base.showable(m::MIME, x::Show) = x.mime == m
Base.show(io::IO, ::MIME, x::Show) = write(io, x.data)


"""
    Print(xs...)

The text that would be printed when calling `print(xs...)`. Use `string(xs...)` if you want to use the result as a `String`.

See also: [`Dump`](@ref) and [`with_terminal`](@ref).
"""
Print(xs...) = Text(string(xs...))

##
# IO context
##

export WithIOContext

"""
    WithIOContext(x, properties::Pair...)

A wrapper around `x` with extra IOContext properties set, just for the display of `x`.

# Examples

```julia
WithIOContext(rand(100,100), :compact => false)
```

```julia
large_df = DataFrame(rand(100,100))
WithIOContext(large_df, :displaysize => (9999,9999))
```
"""
struct WithIOContext
    x
    context_properties
    WithIOContext(x, props::Pair...; moreprops...) = new(x, [props..., moreprops...])
end

function Base.show(io::IO, m::MIME, w::WithIOContext)
	Base.show(IOContext(io, w.context_properties...), m, w.x)
end
# we need to add a more specific method for text/plain because Julia base has a fallback method here
function Base.show(io::IO, m::MIME"text/plain", w::WithIOContext)
	Base.show(IOContext(io, w.context_properties...), m, w.x)
end

Base.showable(m::MIME, w::WithIOContext) = Base.showable(m, w.x)