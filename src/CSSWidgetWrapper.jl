export CSSWidgetWrapper

"""
CSS widget Wrapper

Generates a div element and delegates the input event to the it. 
In addition the widget style properties can be set via javascript.

Arguments:
widget: PlutoUI widget
style: Dict of javascript style properties

Example:
Generate a text field with a red background and white text
CSSWidgetWrapper(Textfield(),Dict("backgroundColor"=>"red","color"=>"white"))
"""
struct CSSWidgetWrapper
    widget
    style
end

"""
Output the html needed to wrap a widget and apply changes via javascript.
"""
function show(io::IO, m::MIME"text/html", w::CSSWidgetWrapper)
    style = join(["widget.style.$k = '$v';" for (k,v) in w.style],"\n")
    
    result = """
        <script>
        var widget = currentScript.parentElement.firstElementChild
        $style    
        </script>
    """
    show(io,m,w.widget)
    print(io,result)
end

"""
Use the default value of the widget
"""
Base.get(w::CSSWidgetWrapper) = get(w.widget)