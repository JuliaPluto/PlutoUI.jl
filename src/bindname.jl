import HypertextLiteral

"""
```julia
@bindname name Slider(1:10)
```

Like `@bind` in Pluto, but it also displays the name of the variable before the input widget.
"""
macro bindname(name::Symbol, ex::Expr)
    
    # Some macro magic to call the `@bind` macro without hygiene. This will use whatever `@bind` is defined in the scope of the caller of this macro.
    # We could just do `Main.PlutoRunner.@bind`, but then if you run the notebook.jl as a standalone script, it does not find the mock `@bind`.
    bindcall = Expr(:macrocall, 
        Symbol("@bind"),
        __source__,
        name,
        ex
    )
    
    # Messy HTML to avoid unintended whitespace, which can show up in rare cases.
    quote
        bond = $(esc(bindcall))
        
        HypertextLiteral.@htl(
            """<div style='display: flex; flex-wrap: wrap; align-items: baseline;'><code style='color: var(--cm-color-variable) !important; font-weight: 700;'>$(
                $(String(name))
            )&nbsp<span style="opacity: .6">=</span>&nbsp</code>$(
                bond
            )</div>"""
        )
    end
end

export @bindname