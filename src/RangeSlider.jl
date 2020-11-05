export RangeSlider

struct RangeSlider
    range::AbstractRange
    left::Number
    right::Number
    show_value::Bool
end

RangeSlider(range::AbstractRange; left=first(range), right=last(range), show_value=false) = 
left > right ? error("Left value cannot be bigger than right") : RangeSlider(range, left, right, show_value)

"""
A `RangeSlider` is a two thumb slider which returns the range between the two thumbs.

If you set `show_value` to `false`, the slider won't display its value. 

By default `show_value` is set to `true`

Use `left` and `right` to set default values for the slider thumbs.

## Examples
`@bind range RangeSlider(1:100)`

`@bind range RangeSlider(1:0.1:100, show_value=false)`

`@bind range RangeSlider(1:0.1:100, left=25, right=75)`
"""

function show(io::IO, ::MIME"text/html", slider::RangeSlider)
    js = read(joinpath(PKG_ROOT_DIR, "assets", "rangeslider.js"), String)
    css = read(joinpath(PKG_ROOT_DIR, "assets", "rangeslider.css"), String)

    result = """
    <multi-range-slider>
        <div class="middle">
            <input type="range" id="input-left" step="$(step(slider.range))" 
            min="$(first(slider.range))" max="$(last(slider.range))" 
            value="$(slider.left)">
            <input type="range" id="input-right" step="$(step(slider.range))" 
            min="$(first(slider.range))" max="$(last(slider.range))" 
            value="$(slider.right)">
    
            <div class="slider">
                <div class="track" onmousedown="event.preventDefault()"></div>
                <div class="range" onmousedown="event.preventDefault()"></div>
                <div class="thumb right"></div>
                <div class="thumb left"></div>
            </div>
        </div>
        $(slider.show_value ? """<output id=\"slider-output\"></output>""" : "")
        <script>
            $(js)
            </script>
        <style>
        $(css)
        </style>
    </multi-range-slider>
    """

    print(io, result)
end

get(slider::RangeSlider) = collect(slider.left:step(slider.range):slider.right)