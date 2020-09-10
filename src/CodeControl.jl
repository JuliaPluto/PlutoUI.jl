export @with_stdout, @cond, @cond_with_stdout, @bind_cond, stdout_style, stdout_styles

"""
     Dict containing predefined style sheets for `div.stdout`
"""
_predefined_css=Dict(

    :default =>"""<style>
         div.stdout {}
         div.stdout pre {
                color: #000;
                    border-radius: 1px;
                background-color: #dfd;
                    border: 0px solid #ddd;
                font-size: 65%;
          }
           </style>""",

    :nowrap =>"""<style>
         div.stdout {}
         div.stdout pre {
                color: #000;
                border-radius: 1px;
                background-color: #dfd;
                border: 0px solid #ddd;
                font-size: 65%;
                word-break: normal !important;
                word-wrap: normal !important;
                white-space: pre !important;
      	        overflow: auto;
          }
           </style>""",

    :vintage =>"""<style>
              div.stdout {}
              div.stdout pre {
                color: #2f2;
                border-radius: 10px;
                background-color: #333;
                border: 5px solid #aaa;
                font-size: 65%;
          }
          </style>""")

# Initialize with default css
_stdout_css=_predefined_css[:default]

"""
   Set style sheet for output of stdout. Either one of
   $(keys(_predefined_css)) or a string containing a css style sheet.
"""
function stdout_style(s)
    global _stdout_css
    if s in keys(_predefined_css)
        _stdout_css=_predefined_css[s]
    else
        _stdout_css=s
    end
end


"""
    Return current stdout css style string
"""
stdout_style()=_stdout_css

"""
    List predefined stdout css styles
"""
stdout_styles()=keys(_predefined_css)


"""
Wrap code output into HTML <pre> element.
"""
format_stdout(code_output)=HTML("""$(_stdout_css)<div class='stdout'><pre>"""*code_output*"""</pre></div>""")


"""
Run code, grab output from println, show etc and return it in a html string as <pre>.

Example:

````
@with_stdout begin
    x=1+1
    println(x)
end 
````
           
"""
macro with_stdout(expr)
    quote
	format_stdout(Suppressor.@capture_out($(esc(expr))))
    end
end


"""
Conditionally run code, grab output from println, show etc and return it in a html string as <pre>.

Example:

````
md"### Test Example \$(@bind test_example CheckBox(default=false))"

@with_stdout test_example begin
    x=1+1
    println(x)
end 
````
           
"""
macro cond_with_stdout(run,expr)
    # after an Idea of Benjamin Lungwitz
    quote
	if $(esc(run))
	    format_stdout(Suppressor.@capture_out($(esc(expr))))
	end
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


"""
Wanted:

Bind condition variable to checkbox and display it prefixed with label

Example: 
````
@bind_cont test_example "### Test Example"
````
"""
