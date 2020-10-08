using PlutoUI
using Test

using Documenter

DocMeta.setdocmeta!(PlutoUI, :DocTestSetup, :(using PlutoUI; macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end
))
doctest(PlutoUI; manual = false)

@testset "builtins" begin
    for s in [
        Slider(1:0.2:3; default=0.4, style="width:100px"),
        Button(; style="width:100px"),
        FilePicker(; style="width:100px"),
        Radio(["A", "B", "C"]; style="width:100px"),
        Select(["A", "B", "C"]; style="width:100px"),
        MultiSelect(["A", "B", "C"]; style="width:100px"),
        CheckBox(; default=true, style="width:100px"),
        TextField(; style="width=100px"),
        NumberField(1:0.2:3; default=2, style="width:100px"),
        ]
        io = IOBuffer()
        show(io, MIME("text/html"), s)
        @test !isempty(take!(io))
    end
end

@testset "clock" begin
    c = Clock(0.1; stopped=false, fixed=false)
    @test c.fixed == false
    @test c.stopped == false
    c = Clock(0.2; stopped=true, fixed=true)
    @test c.fixed == true
    @test c.stopped == true
end
