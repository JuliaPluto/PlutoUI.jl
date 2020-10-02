export with_terminal, Dump

import Suppressor: @color_output, @capture_out, @capture_err
import Logging:  ConsoleLogger, with_logger
import Markdown: htmlesc
import Base: show

struct WithTerminalOutput
    stdout::String
    stderr::String
    value::Any
end

function show(io::IO, mime::MIME"text/html", with_terminal::WithTerminalOutput)
	show(io, mime, HTML("""
		$(terminal_css)
        <div class="PlutoUI_terminal">
            <pre>$(htmlesc(with_terminal.stdout))</pre>
            $(isempty(with_terminal.stderr) ? "" : "<pre class='err'>" * htmlesc(with_terminal.stderr) * "</pre>")
        </div>
    """))
end

const terminal_css = """
<style>
div.PlutoUI_terminal {
    border: 10px solid #cedbd0;
    border-radius: 12px;
    font-size: .65rem;
    background-color: #333;
}
div.PlutoUI_terminal pre {
    color: #ddd;
    background-color: transparent;
    margin-block-end: 0;
    height: auto;
    max-height: 300px;
    overflow: auto;
    display: flex;
    flex-wrap: nowrap;
    flex-direction: column-reverse;
    white-space: pre-wrap;       
    word-wrap: break-word;      
}

div.PlutoUI_terminal pre.err {
    color: #ff5f5f;
}
</style>
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
	WithTerminalOutput(spam_out, spam_err, value)
end

"""
    Dump(x; maxdepth=8)

Every part of the representation of a value. The depth of the output is truncated at maxdepth. 

This is a variant of [`Base.dump`](@ref) that returns the representation directly, instead of printing it to stdout.
"""
function Dump(x; maxdepth=8)
	sprint() do io
		dump(io, x; maxdepth=maxdepth)
	end |> Text
end
