import Base: show

struct Slider
    bound_assignee::Symbol
    range::AbstractRange
    Slider(bound_assignee::Symbol, range::AbstractRange) = begin
        println("Slider created for $(bound_assignee)")
        new(bound_assignee, range)
    end
end

function show(io::IO, ::MIME"text/html", slider::Slider)
    print(io, """<input type="range" class="⚡" min="$(slider.range.start)" max="$(slider.range.stop)" defines="$(slider.bound_assignee)"><script src="/addons/⚡.js"></script>""")
end