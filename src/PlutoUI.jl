module PlutoUI

import Base: show, get
import Markdown: htmlesc, withtag

using Reexport

const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))

@reexport module BuiltinsNotebook
    include("./Builtins.jl")
end
include("./Resource.jl")
include("./RangeSlider.jl")
include("./DisplayTricks.jl")

@reexport module TerminalNotebook
    include("./TerminalNotebook.jl")
end
@reexport module MultiCheckBoxNotebook
    include("./MultiCheckBox.jl")
end
@reexport module TableOfContentsNotebook
    include("./TableOfContents.jl")
end
@reexport module ClockNotebook
    include("./Clock.jl")
end
@reexport module ScrubbableNotebook
    include("./Scrubbable.jl")
end

# this is a submodule
module ExperimentalLayout
    include("./Layout.jl")
end

is_sliderserver_static_export() =
    isdefined(Main, :PlutoRunner) && isdefined(getfield(Main, :PlutoRunner), :should_set_possible_bind_values) && Main.PlutoRunner.should_set_possible_bind_values()

function __init__()
    is_sliderserver_static_export() && eval(quote
	function Main.PlutoRunner._get_possible_values(slider::Slider)
	    slider.range
	end

	function Main.PlutoRunner._get_possible_values(::CheckBox)
	    Set{Bool}([true, false])
	end
    end)
end

end
