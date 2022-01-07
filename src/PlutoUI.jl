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


"""
Components in this module are still experimental, and after a trial period (with breaking changes!), they will be added to PlutoUI as public API. Use with caution.

Currently included: [`PlutoUI.Experimental.transformed_value`](@ref).
"""
module Experimental
module TransformedValueNotebook
    include("./TransformedValue.jl")
end

const transformed_value = TransformedValueNotebook.transformed_value

module WrappedNotebook
    import ...PlutoUI: combine
    import ..Experimental: transformed_value
    include("./Wrapped.jl")
end
const wrapped = WrappedNotebook.wrapped

end
end
