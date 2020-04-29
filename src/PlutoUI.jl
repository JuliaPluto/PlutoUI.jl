module PlutoUI

import Base: show, peek

sanitize(str::AbstractString) = replace(str, "\"" => "\\\"")

const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))

include("./Builtins.jl")
include("./Timer.jl")

end
