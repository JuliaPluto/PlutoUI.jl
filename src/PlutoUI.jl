module PlutoUI

import Base: show, get
import Markdown: htmlesc, withtag
import Logging:  ConsoleLogger, with_logger

const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))

include("./Builtins.jl")
include("./Clock.jl")
include("./Resource.jl")
include("./Terminal.jl")

end
