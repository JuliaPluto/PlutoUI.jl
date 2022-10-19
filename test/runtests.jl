using PlutoUI
using Test
import AbstractPlutoDingetjes
using HypertextLiteral
import ColorTypes: RGB, N0f8, Colorant
import Logging
using Dates

# has to be outside of the begin block for julia 1.0 compat
struct Uhm end


@testset "DisplayTricks" begin

    x = "asdf"

    # Show

    @test repr(MIME"derp1"(), Show(MIME"derp1"(), x)) == codeunits(x)

    Base.istextmime(::MIME"derp2") = true

    @test repr(MIME"derp2"(), Show(MIME"derp2"(), codeunits(x))) == x


    s = Show(MIME"cool1"(), x)


    @test Base.showable(MIME"text/plain"(), x)
    @test !Base.showable(MIME"cool1"(), x)
    # everything is plaintext showable
    @test Base.showable(MIME"text/plain"(), s)
    @test Base.showable(MIME"cool1"(), s)


    # AsMIME

    mimer = as_mime(MIME"cool2"())
    am = mimer(s)

    @test Base.showable(MIME"cool1"(), s)
    @test !Base.showable(MIME"cool2"(), s)
    @test Base.showable(MIME"text/plain"(), s)

    @test !Base.showable(MIME"cool1"(), am)
    @test Base.showable(MIME"cool2"(), am)
    @test Base.showable(MIME"text/plain"(), am)


    # WithIOContext

    @test WithIOContext(s, :a => 1, :b => 2) ==
          WithIOContext(s, :a => 1; b = 2) ==
          WithIOContext(s, a = 1; b = 2) ==
          WithIOContext(s; a = 1, b = 2)


    @test repr(MIME"text/plain"(), WithIOContext(1.345234523452, compact = true)) == "1.34523"
    @test repr(MIME"text/plain"(), WithIOContext(1.345234523452, compact = false)) == "1.345234523452"


    m = MIME"hello"()
    Base.istextmime(::MIME"hello") = true

    Base.show(io::IO, ::MIME"hello", ::Uhm) = print(io, get(io, :prop, missing))

    u = Uhm()

    @test repr(m, WithIOContext(u, prop = 1)) == "1"
end

@testset "Resource" begin
    f1 = tempname() * ".js"
    f2 = tempname() * ".jpg"
    f3 = tempname()
    u4 = "https://asdf.com/a/b/c.mp4?b=23f&c=asdf.png#asdfjk"
    
    write(f1, "asdf")
    write(f2, "asdf")
    write(f3, "asdf")
    
    
    r1 = LocalResource(f1)
    r2 = LocalResource(f2)
    r3 = LocalResource(f3)
    r4 = Resource(u4)
    r5 = Resource(u4, :asdf => "123px")
    
    hr(x) = repr(MIME"text/html"(), x)
    
    h1 = hr(r1)
    h2 = hr(r2)
    h3 = hr(r3)
    h4 = hr(r4)
    h5 = hr(r5)
    
    @test occursin(r"<script.+src\=.+base64.+<\/script>", h1)
    @test occursin(r"<img.+src=.+base64.+>", h2)
    @test occursin(r"type=[\'\"]image/jp", h2)
    @test occursin(r"<data.+src=.+base64.+>", h3)
    @test !occursin(r"type=", h3)
    @test occursin(r"<video.+src=.+>", h4)
    @test (
        occursin("https://asdf.com/a/b/c.mp4?b=23f&c=asdf.png", h4) ||
        # This one is fine too, you can verify this by rendering HTML("<img src="https://asdf.com/a/b/c.mp4?b=23f&amp;c=asdf.png">") in a cell, and in the Network panel in the chrome devtools, you will see a request to https://asdf.com/a/b/c.mp4?b=23f&c=asdf.png, which is what we want.
        occursin("https://asdf.com/a/b/c.mp4?b=23f&amp;c=asdf.png", h4)
    )
    @test occursin(r"asdf=[\'\"]123px", h5)
    
        
end

function default(x)
    new = AbstractPlutoDingetjes.Bonds.initial_value(x)
    if Core.applicable(Base.get, x)
        # if the default value is defined with both the new and old API, make sure that both APIs return the same value.
        @assert Base.get(x) == new
    end
    new
end
transform(el, x) = AbstractPlutoDingetjes.Bonds.transform_value(el, x)

@testset "Public API" begin
    el = Button()
    el = Button("asdf")
    @test default(el) == "asdf"
    el = LabelButton("asdf")
    @test default(el) == "asdf"
    el = CounterButton()
    @test default(el) == 0
    el = CounterButton("asdf")
    @test default(el) == 0

    el = CheckBox()
    @test default(el) == false
    el = CheckBox(true)
    @test default(el) == true
    el = CheckBox(default = true)
    @test default(el) == true

    el = Clock(2.0, max_value = 123)
    @test default(el) == 1
    Clock(3.0)
    Clock(3.0, true)
    Clock(3.0, true, true)
    Clock(3.0, true, true, 5)
    Clock()

    el = ColorStringPicker()
    @test default(el) == "#000000"
    el = ColorStringPicker("#0f0f0f")
    @test default(el) == "#0f0f0f"
    el = ColorStringPicker(default = "#0f0f0f")

    gray = RGB{N0f8}(0.5, 0.5, 0.5)
    el = ColorPicker()
    @test default(el) == RGB{N0f8}(0.0, 0.0, 0.0)
    el = ColorPicker(gray)
    @test default(el) == gray
    el = ColorPicker(default = gray)
    @test default(el) == gray


    el = DateField()
    @test default(el) === nothing
    el = DatePicker()
    @test default(el) === nothing
    el = DatePicker(Dates.Date(2022, 4, 20))
    @test default(el) == Dates.Date(2022, 4, 20)
    el = DatePicker(default=Dates.Date(2022, 4))
    @test default(el) == Dates.Date(2022, 4, 1)
    el = DatePicker(default=Dates.DateTime(2022, 12, 31, 23, 59, 59))
    @test default(el) == Dates.Date(2022, 12, 31)
    el = TimeField()
    @test default(el) === "" # ugh 
    el = TimePicker()
    @test default(el) === nothing
    el = TimePicker(Dates.Time(23,59,44))
    @test default(el) == Dates.Time(23,59,00)
    el = TimePicker(default=Dates.Time(23,59,44), show_seconds=true)
    @test default(el) === Dates.Time(23,59,44)

    el = FilePicker()
    @test default(el) === nothing


    @testset "MultiSelect" for f in [MultiSelect, MultiCheckBox]
        el = f(["asdf", "x"])
        @test default(el) == []
        el = f(["asdf"])
        @test default(el) == []
        el = f(["sin" => "asdf"])
        @test default(el) == []
        el = f(["sin" => "asdf"]; default = ["sin"])
        @test default(el) == ["sin"]
        
        el = f([sin, cos, tan, sqrt])
        @test default(el) |> isempty
        @test default(el) isa Vector{Function}
        el = f([
            cos => "cosine function", 
            sin => "sine function",
        ])
        @test default(el) |> isempty
        @test default(el) isa Vector{Function}
    end
    
    el = MultiCheckBox(
        ["🐱" => "🐝", "🐵" => "🦝", "🐱" => "🐿️"]; 
        default=["🐱", "🐱"]
    )
    @test default(el) == ["🐱", "🐱"]
    el = MultiCheckBox(
        ["🐱" => "🐝", "🐵" => "🦝", "🐱" => "🐿️"]; 
        default=["🐱"]
    )
    @test default(el) == ["🐱"]


    el = Select(["asdf", "x"])
    @test default(el) == "asdf"
    el = Select(["asdf"])
    @test default(el) == "asdf"
    el = Select([sin => "asdf"])
    @test default(el) == sin
    el = Select([sin => "asdf", cos => "cos"]; default = cos)
    @test default(el) == cos

    el = Radio(["asdf", "x"])
    @test default(el) == nothing
    el = Radio(["asdf"])
    @test default(el) == nothing
    el = Radio(["sin" => "asdf"])
    @test default(el) == nothing
    el = Radio(["sin" => "asdf", "cos" => "cos"]; default = "cos")
    @test default(el) == "cos"






    el = Slider(0.0:π:20)
    @test default(el) == 0
    el = Slider(0.0:π:20; show_value = true)
    el = Slider(0.0:π:20; default = π)
    @test default(el) == Float64(π) # should have been converted to Float64 because our range has been
    el = Slider(1:1//3:20; default = 7 // 3)
    @test default(el) === 7 // 3
    el = Slider(1:1//3:20)
    @test default(el) === 1 // 1
    el = Slider([sin, cos, tan])
    @test default(el) == sin
    el = Slider([sin, cos, tan]; default = tan)
    @test default(el) == tan



    # Downsampling Slider ranges
    x1 = [1,2,3]
    x2 = rand(500)

    @test PlutoUI.BuiltinsNotebook.downsample(x1, 3) == x1
    @test PlutoUI.BuiltinsNotebook.downsample(x1, 3) === x1
    @test PlutoUI.BuiltinsNotebook.downsample(x1, 30) === x1
    @test PlutoUI.BuiltinsNotebook.downsample(x1, 2) == [1,3]

    @test PlutoUI.BuiltinsNotebook.downsample(x2, 500) == x2
    @test PlutoUI.BuiltinsNotebook.downsample(x2, 500) === x2
    y2 = PlutoUI.BuiltinsNotebook.downsample(x2, 400)
    @test 250 <= length(y2) <= 400
    @test y2[begin] == x2[begin]
    @test y2[end] == x2[end] 

    x3 = rand(50_000_000)
    max_downsample_time = 0.001 # seconds
    # this should take less than 0.1ms
    @test max_downsample_time >= @elapsed PlutoUI.BuiltinsNotebook.downsample(x3, 100)


    

    el = Scrubbable(60)
    @test default(el) === 60
    el = Scrubbable(60.0)
    @test default(el) === 60.0

    el = Scrubbable(0.0:π:20)
    @test 0.0 < default(el) < 20
    el = Scrubbable(0.0:π:20; default = π)
    # @test default(el) == Float64(π) # should have been converted to Float64 because our range has been
    el = Scrubbable(1:1//3:20; default = 7 // 3)
    @test default(el) === 7 // 3
    el = Scrubbable(1:1//3:20)
    @test default(el) isa Rational


    @testset "Rounding default value: $f" for f in [Slider, NumberField]
        el = f(1:10; default = 5.2)
        @test default(el) == 5
        @test transform(el, 1) === 1
        el = f(1:.5:10; default = 5.4)
        @test default(el) == 5.5
        @test transform(el, 1) === 1.0
        if f !== NumberField
            el = f([60,10,-80]; default = 5.4)
            @test default(el) == 10
            el = Slider([sin, cos]; default = tan)
            @test default(el) == sin # default is not in the list
        end
    end



    el = NumberField(0.0:π:20)
    @test default(el) == 0
    el = NumberField(0.0:π:20; default = π)
    @test default(el) == Float64(π) # should have been converted to Float64 because our range has been


    el = TextField()
    @test default(el) == ""
    el = TextField(; default = "xoxo")
    @test default(el) == "xoxo"
    el = TextField((5, 50); default = "xoxo")
    @test default(el) == "xoxo"

    el = PasswordField()
    @test default(el) == ""
    el = PasswordField(; default = "xoxo")
    @test default(el) == "xoxo"


    el = RangeSlider(1:10)
    @test default(el) == 1:10
    el = RangeSlider(1:10; show_value = true)
    @test default(el) == 1:10

    el = RangeSlider(0.0:π:10; default = 0:10)
    @test default(el) == 0.0:π:10

    el = RangeSlider(1:(1//3):10)
    @test default(el) == 1:(1//3):10
    el = RangeSlider(1:(1//3):10; default = 4:5)
    @test default(el) == 4:1//3:5
    el = RangeSlider(1:(1//3):10; default = 4:1//3:(17//3))
    @test default(el) == 4:1//3:(17//3)
    
    el = WebcamInput(; help=false)
    @test default(el) isa Matrix{RGB{N0f8}}
    @test size(default(el)) == (1,1)
    
    el = WebcamInput(; help=false, avoid_allocs=true)
    @test !(default(el) isa Matrix{RGB{N0f8}})
    @test default(el) isa AbstractMatrix{RGB{N0f8}}
    @test size(default(el)) == (1,1)


    el = confirm(Slider([sin, cos]))
    @test default(el) == sin

    import PlutoUI: combine
    el = combine() do Child
        # @htl instead of md" because Julia VS Code is too buggy
        @htl("""
        # Hi there!

        I have $(Child(Slider([sin, cos]))) dogs and $(Child(Slider(5:10))) cats.

        Would you like to see them? $(Child(CheckBox(true)))
        """)
    end

    @test default(el) == (sin, 5, true)

    el = combine() do Child
        # @htl instead of md" because Julia VS Code is too buggy
        @htl("""
        # Hi there!

        I have $(Child(:fun, Slider([sin, cos]))) dogs and $(Child(:x, Slider(5:10))) cats.

        Would you like to see them? $(Child(:y, CheckBox(true)))
        """)
    end

    @test default(el) == (fun = sin, x = 5, y = true)

    el = combine() do Child
        @htl("""
        $(Child(html"<input>"))
        """)
    end

    @test default(el) === (missing,)
    
    
    import PlutoUI.Experimental: transformed_value
    
    el = let
        old_widget = PlutoUI.combine() do Child
            @htl("""$(Child(TextField(default="fons"))) $(Child(Slider(1:10; default=3)))""")
        end
        
        # Note that the input to `transform` is now a Tuple!
        # (This is the output of `PlutoUI.combine`)
        transform = input -> repeat(input[1], input[2])

        # use `transformed_value` to add the value tranformation to our widget
        transformed_value(transform, old_widget)
    end
    
    @test default(el) == "fonsfonsfons"
    
    el = transformed_value(
        transformed_value(
            PlutoUI.combine() do Child
                @htl("""
                $(Child(Slider([sin, cos])))			
                $(Child(Slider(5:7)))
                """)
            end
        ) do x
            Ref(reverse(x))
        end
    ) do x
        first(x[])
    end
    
    @test_logs min_level=Logging.Info transformed_value(log, html"<input type=range>")
    
    @test default(el) == 5
    
    import PlutoUI.Experimental: wrapped
    
    el = wrapped() do Child
        @htl("""
        Hello!
        $(Child(Slider([sin, cos])))
        """)
    end
    
    @test default(el) == sin
    
    A = rand(3,2)
    el = Scrubbable(A)
    @test default(el) == A
end

