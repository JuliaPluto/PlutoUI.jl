module PlutoUI

import Base: show, peek
import Markdown: htmlesc

const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))

include("./Builtins.jl")
include("./Clock.jl")

end
