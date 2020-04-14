macro bind(sym, expr)
    if sym isa Symbol && expr isa Expr && expr.head == :call && expr.args[1] == :Slider
        if is_pluto
            quote
                # $(PlutoRunner).declare_assignments($(Meta.quot(sym)))
                local vals = $(expr.args[2])
                $(esc(sym)) = vals |> Base.first
                Slider($(Meta.quot(sym)), vals)
            end
        else
            quote
                local vals = $(expr.args[2])
                $(esc(sym)) = vals |> Base.first
                Slider($(Meta.quot(sym)), vals)
            end
        end
    else
        :(throw(ArgumentError("\nMacro example usage: \n\n\t@bind my_number Slider(1:9)\n\n")))
    end
end