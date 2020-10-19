import Mustache
import Pluto
using Random: randstring

function gettokens!(ps, tokens)
    for token in ps.tokens
        if token._type != "text"
            if length(token.value) >= 1 && token.value[1] == ':'
                sym = token.value[2:end]
            else
                sym = token.value
            end
            token.value != "default" && push!(tokens, Symbol(token.value))
        end
    end
    return tokens
end

"""
    @widget TypeName template

```example
@widget FileInput "<input type='file' id='{{:id}}' accept='{{#:accepts}}{{.}}, {{/:accepts}}'" accepts=[]
```

It will generate a type `FileInput` that with constructor `FileInput(; accepts=[], id, default)`.
Any template variable marked with `{{:varname}}` will be put into the constructor of `FileInput`,
and one can specify their initial values by appending key word arguments to this macro call.
Here, the `default` is a special in that it represents the default value of the widget.
It will be there even if not used in the template.
"""
macro widget(T, template, defaults...)
    ps = Mustache.parse(template, ("{{", "}}"))
    args = push!(unique(gettokens!(ps, Any[])), :default)
    for d in defaults
        if d isa Expr && d.head == :(=)
            for i=1:length(args)
                if args[i] == d.args[1]
                    args[i] = d
                    break
                end
            end
        end
    end
    constr = Expr(:struct, false, T, Expr(:block, args...))
    docstr = """
    $T(; kwargs...)
HTML widget with `kwargs`

    * $(join(args, "\n    * "))
"""

    esc(quote
        @doc $docstr
        Base.@kwdef $constr

        function Base.show(io::IO, ::MIME"text/html", obj::$T)
            ret = $(Mustache.render)($ps, obj)
            print(io, ret)
        end

        Pluto.get(x::$T) = x.default
    end)
end
