using PlutoUI
using Test

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

        
    @test repr(MIME"text/plain"(), WithIOContext(1.345234523452, compact=true)) == "1.34523"
    @test repr(MIME"text/plain"(), WithIOContext(1.345234523452, compact=false)) == "1.345234523452"
    

    m = MIME"hello"()
    Base.istextmime(::MIME"hello") = true

    Base.show(io::IO, ::MIME"hello", ::Uhm) = print(io, get(io, :prop, missing))

    u = Uhm()

    @test repr(m, WithIOContext(u, prop=1)) == "1"
end





