using Documenter, PlutoUI

# i can't convice Documenter.jl to stop printing `PlutoUI.BuiltinsNotebook.Slider`, etc, so here is a nasty override:
Base.show(io::IO, m::Module) =
    if parentmodule(m) === PlutoUI
        write(io, "PlutoUI")
    else
        write(io, nameof(m))
    end

makedocs(;
    sitename = "PlutoUI",
    modules = [PlutoUI]
)