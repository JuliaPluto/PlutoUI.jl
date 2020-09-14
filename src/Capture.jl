export @with_output, @cond, @capture


const _output_css="""
<style>
    div.output {}
    div.output pre {
      color: #000;
      border-radius: 3px;
      background-color: #efe;
      border: 1px solid #ddd;
      font-size: 65%;
    }
</style>"""




"""
    @capture expr

Capture the `output` and `stderr` streams for the given expression,
return results collected while executing `expr`
"""
macro capture(expr)
    quote
        original_stdout = stdout
        out_rd, out_wr = redirect_stdout()
        reader = @async read(out_rd, String)
        try
            # Redirect both logging output and print(stderr,...)
            # to stdout
	    with_logger(ConsoleLogger(stdout)) do	
	        redirect_stderr(()->$(esc(expr)),stdout)
	    end
        finally
	    redirect_stdout(original_stdout)
            close(out_wr)
        end
        fetch(reader)
    end
end



"""
Wrap code output into HTML <pre> element.
"""
function format_output(code_output)
    output=""
    if length(code_output)>0
        output=_output_css*"""<div class='output'><pre>"""*code_output*"""</pre></div>"""
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

