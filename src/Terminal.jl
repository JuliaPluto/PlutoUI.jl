export with_terminal

import Suppressor: @color_output, @capture_out, @capture_err
import Logging:  ConsoleLogger, with_logger
import Markdown: htmlesc
import Base: show
import HypertextLiteral: @htl_str

struct WithTerminalOutput
    value::Any
    stdout::String
    stderr::String
end

module JustForShow
    """
    Fake WithTerminalOutput that I can show with the terminal.
    Was thinking this is useful for when you have a like `x =`, but people see the actual value...
    and then suddenly they are confused because `x` is actually a WithTerminalOutput!!
    But idk...
    """
    struct WithTerminalOutput
        value::Any
        stdout::String
        stderr::String
    end
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
    border: 10px solid #cedbd0; /* https://www.vintagecomputer.net/browse_thread.cfm?id=618 */
    border-radius: 15px;
    font-size: .65rem;
    background-color: #333;
    max-height: 300px;
    overflow: auto;
}
pluto-output div.PlutoUI_terminal pre:not(.no-block) {
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
with_terminal(show_value=true) do
    @time x=sum(1:100000)
end 
```

```julia
with_terminal(dump, [1,2,[3,4]])
```

See also [PlutoUI.Dump](@ref).
           
"""
function with_terminal(f::Function, args...; show_value=true, kwargs...)
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
    if show_value
        if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :embed_display)
            # fake_terminal_wrapper = JustForShow.WithTerminalOutput(value, spam_out, spam_err)
            htl"""
                $(Main.PlutoRunner.embed_display(value))
                $(WithTerminalOutput(value, spam_out, spam_err))
            """
        else
            htl"""
                <span>$(value)</span>
                $(WithTerminalOutput(value, spam_out, spam_err))
            """
        end
    else
        WithTerminalOutput(spam_out, spam_err, value)
    end
end
