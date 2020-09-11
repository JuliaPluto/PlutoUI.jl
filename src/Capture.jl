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
return a tuple of stdout and stderr results collected while executing
`expr`
"""
macro capture(expr)
    quote
        original_stdout = stdout
        out_rd, out_wr = redirect_stdout()
        original_stderr = stderr
        err_rd, err_wr = redirect_stderr()
        # write just one character into the streams in order to
        # prevent readavailable from blocking if they would stay empty
        print(stderr," ")
	print(stdout," ")
        logger=SimpleLogger()
	with_logger(logger) do	
	    $(esc(expr))
	end
        result_out=String(readavailable(out_rd))
        result_err=String(readavailable(err_rd))
	redirect_stdout(original_stdout)
	redirect_stderr(original_stderr)
        close(out_wr)
	close(err_wr)
        # ignore the first character...
        (result_out[2:end],result_err[2:end])
    end
end



"""
Wrap code output into HTML <pre> element.
"""
function format_output(code_output)
    output=""
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

