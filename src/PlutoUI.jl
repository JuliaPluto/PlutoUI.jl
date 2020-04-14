module PlutoUI

const PKG_ROOT_DIR = normpath(joinpath(@__DIR__, ".."))
is_pluto = false
PlutoRunner = missing

export @bind, Slider

include("./Slider.jl")
include("./Bind.jl")

include("./InjectPluto.jl")

end
