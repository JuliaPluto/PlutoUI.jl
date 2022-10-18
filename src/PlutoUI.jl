module PlutoUI

import Base: show, get
import Markdown: htmlesc, withtag

using Reexport


const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))

@reexport module BuiltinsNotebook
    include("./Builtins.jl")
end # 0.2 second
include("./Resource.jl") # 0.2 second
include("./DisplayTricks.jl") # 0.1 second

@reexport module RangeSliderNotebook
    include("./RangeSlider.jl")
end # 0.05 second
@reexport module TerminalNotebook
    include("./TerminalNotebook.jl")
end # 0.1 second
@reexport module MultiCheckBoxNotebook
    include("./MultiCheckBox.jl")
end # 0.1 second
@reexport module TableOfContentsNotebook
    include("./TableOfContents.jl")
end # 0.1 second
@reexport module ClockNotebook
    include("./Clock.jl")
end # 0.04 second
@reexport module ScrubbableNotebook
    include("./Scrubbable.jl")
end # 0.2 second
@reexport module WebcamInputNotebook
    include("./WebcamInput.jl")
end # ? second
@reexport module ConfirmNotebook
    include("./Confirm.jl")
end # 0 second
module CombineNotebook
    include("./Combine.jl")
end # 0.06 second
# not exporting to avoid clash with DataFrames.combine
const combine = CombineNotebook.combine

# this is a submodule
using HypertextLiteral
using Hyperscript
module ExperimentalLayout
    include("./Layout.jl")
end # 0.2 second


"""
Components in this module are still experimental, and after a trial period (with breaking changes!), they will be added to PlutoUI as public API. Use with caution.

Currently included: [`PlutoUI.Experimental.transformed_value`](@ref).
"""
module Experimental
module TransformedValueNotebook
    include("./TransformedValue.jl")
end # 0.1 second

const transformed_value = TransformedValueNotebook.transformed_value

module WrappedNotebook
    import ...PlutoUI: combine
    import ..Experimental: transformed_value
    include("./Wrapped.jl")
end # 0 second
const wrapped = WrappedNotebook.wrapped

end
end
