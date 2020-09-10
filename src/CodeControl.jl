export @with_output, @cond, @capture


const _stdout_css="""
<style>
    div.stdout {}
    div.stdout pre {
      color: #000;
      border-radius: 3px;
      background-color: #efe;
      border: 1px solid #ddd;
      font-size: 65%;
    }
</style>"""

const _stderr_css="""
<style>
    div.stderr {}
    div.stderr pre {
      color: #000;
      border-radius: 3px;
      background-color: #fee;
      border: 1px solid #ddd;
      font-size: 65%;
   }
</style>"""



"""
    @capture expr

Capture the `output` and `stderr` streams for the given expression,
return a tuple of stdout and stderr.
"""
macro capture(block)
    quote
        if ccall(:jl_generating_output, Cint, ()) == 0
            original_stdout = stdout
            out_rd, out_wr = redirect_stdout()
            out_reader = @async read(out_rd, String)

            original_stderr = stderr
            err_rd, err_wr = redirect_stderr()
            err_reader = @async read(err_rd, String)
            
            # approach adapted from https://github.com/JuliaLang/IJulia.jl/pull/667/files
            logstate = Base.CoreLogging._global_logstate
            logger = logstate.logger
            new_logstate = Base.CoreLogging.LogState(typeof(logger)(err_wr, logger.min_level))
            Core.eval(Base.CoreLogging, Expr(:(=), :(_global_logstate), new_logstate))
        end
        
        try
            $(esc(block))
        finally
            if ccall(:jl_generating_output, Cint, ()) == 0
                redirect_stdout(original_stdout)
                close(out_wr)

                redirect_stderr(original_stderr)
                close(err_wr)
                Core.eval(Base.CoreLogging, Expr(:(=), :(_global_logstate), logstate))
            end
        end

        if ccall(:jl_generating_output, Cint, ()) == 0
            (fetch(out_reader),fetch(err_reader))
        else
            ("","")
        end
    end
end



"""
Wrap code output into HTML <pre> element.
"""
function format_output(code_output)
    output=""
    @warn code_output[1]
    @warn code_output[2]
    if length(code_output[1])>0
        output="""$(_stdout_css)<div class='stdout'><pre>"""*code_output[1]*"""</pre></div>"""
    end
    if length(code_output[2])>0
        output=output*"""$(_stderr_css)<div class='stderr'><pre>"""*code_output[2]*"""</pre></div>"""
    end
    HTML(output)
end

"""
Run code, grab output from println, show etc and return it in a html string as <pre>.

Example:

````
@with_output begin
    x=1+1
    println(x)
end 
````
           
"""
macro with_output(expr)
    quote
	format_output(@capture($(esc(expr))))
    end
end



"""
Conditionally run code

Example:

````
md"### Test Example \$(@bind test_example CheckBox(default=false))"

@cond test_example begin
    x=1+1
end 
````
           
"""
macro cond(run,expr)
    # after an Idea of Benjamin Lungwitz
    quote
	if $(esc(run))
	    $(esc(expr))
	end
    end
end

