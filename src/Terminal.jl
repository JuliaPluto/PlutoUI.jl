export with_terminal

import Suppressor: @color_output, @capture_out, @capture_err
import Markdown: htmlesc

const terminal_css = """
<style>
div.PlutoUI_terminal {
    border: 5px solid pink;
    border-radius: 12px;
    font-size: .65rem;
    background-color: #333;
}
div.PlutoUI_terminal pre {
    color: #ddd;
    background-color: transparent;
    margin-block-end: 0;
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
end 
```
           
"""
function with_terminal(f::Function)
    local spam_out, spam_err
	@color_output false begin
		spam_out = @capture_out begin
			spam_err = @capture_err begin
				f()
			end
		end
    end
	
	HTML("""
		$(terminal_css)
        <div class="PlutoUI_terminal">
            <pre>$(htmlesc(spam_out))</pre>
            $(isempty(spam_err) ? "" : "<pre class='err'>" * htmlesc(spam_err) * "</pre>")
        </div>
        """)
end