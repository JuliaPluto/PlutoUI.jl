export with_terminal, Dump, Show, Print

import Suppressor: @color_output, @capture_out, @capture_err
import Logging:  ConsoleLogger, with_logger
import Markdown: htmlesc
import Base: show

@widget WithTerminalOutput """
<style>
div.PlutoUI_terminal {
    border: 10px solid #cedbd0; /* https://www.vintagecomputer.net/browse_thread.cfm?id=618 */
    border-radius: 15px;
    font-size: .65rem;
    background-color: #333;
    max-height: 300px;
    overflow: auto;
}
div.PlutoUI_terminal pre {
    color: #ddd;
    background-color: transparent;
    margin-block-end: 0;
    height: auto;
    white-space: pre-wrap;
    word-wrap: break-word;
}

div.PlutoUI_terminal pre.err {
    color: #ff5f5f;
}
</style>

<div class="PlutoUI_terminal">
<pre>{{stdout}}</pre>
{{@stderr}}<pre class='err'>{{stderr}}</pre>{{/stderr}}
</div>
"""

"""
Run the function, and capture all messages to `stdout`. The result will be a small terminal displaying the captured text.

This allows you to to see the messages from `println`, `dump`, `Pkg.status`, etc.

Example:

```julia
with_terminal() do
    x=1+1
    println(x)
    @warn "Oopsie!"
end 
```

```julia
with_terminal(dump, [1,2,[3,4]])
```

See also [PlutoUI.Dump](@ref).
           
"""
function with_terminal(f::Function, args...; kwargs...)
    local spam_out, spam_err, value
	@color_output false begin
		spam_out = @capture_out begin
            spam_err = @capture_err begin
                with_logger(ConsoleLogger(stdout)) do	
                    value = f(args...; kwargs...)
                end
			end
		end
    end
	WithTerminalOutput(spam_out, spam_err)
end

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
