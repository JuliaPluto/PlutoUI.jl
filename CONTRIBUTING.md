# Contributing to Pluto.jl

Great that you want to contribute! Its an easy package to cnotribute to, and you will make lots of people happy!

One tip: _use Revise_!

Setup step:

1. add Pluto
2. clone PlutoUI to your computer and open it as a project in VS Code
3. 
```julia
julia> ]
(v1.5) pkg> dev path/to/clone/of/PlutoUI.jl
(v1.5) pkg> add Revise
```

4. create a new notebook, and start with:
```julia
begin
    using Revise
    using PlutoUI
end
```

5. Now, whenever you change the PlutoUI code in VS Code, you can **re-run cells** in your notebook, and they use the latest code!

have fun!

-fonsi
