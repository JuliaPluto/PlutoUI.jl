module PlutoUI

import Base: show, get
import Markdown: htmlesc, withtag

using Reexport

const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))

@reexport module BuiltinsNotebook
    include("./Builtins.jl")
end
include("./Resource.jl")
include("./DisplayTricks.jl")

@reexport module RangeSliderNotebook
    include("./RangeSlider.jl")
end
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
@reexport module ConfirmNotebook
    include("./Confirm.jl")
end
module CombineNotebook
    include("./Combine.jl")
end
# not exporting to avoid clash with DataFrames.combine
const combine = CombineNotebook.combine

# this is a submodule
module ExperimentalLayout
    include("./Layout.jl")
end

end
