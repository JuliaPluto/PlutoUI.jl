using PlutoUI
using Test

@testset "builtins" begin
    for s in [
        Slider(1:0.2:3; default=0.4, style="{width=100px;}"),
        Button(; style="{width=100px;}"),
        FilePicker(; style="{width=100px;}"),
        Radio(["A", "B", "C"]; style="{width=100px;}"),
        Select(["A", "B", "C"]; style="{width=100px;}"),
        MultiSelect(["A", "B", "C"]; style="{width=100px;}"),
        CheckBox(; default=true, style="{width=100px;}"),
        TextField(; style="{width=100px;}"),
        NumberField(1:0.2:3; default=2, style="{width=100px;}"),
        ]
        io = IOBuffer()
        show(io, MIME("text/html"), s)
        @test !isempty(take!(io))
    end
end
