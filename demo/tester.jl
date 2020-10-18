### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ c8a92546-1147-11eb-042c-437210cca71b
include("templates.jl")

# ╔═╡ 059247c8-1164-11eb-3cfb-2f853212914f
@bind sl Slider(1:0.1:100; default=0.8)

# ╔═╡ 3770bcbe-1166-11eb-3233-a71ecbe56fe2
sl # good

# ╔═╡ 344f56e4-1166-11eb-1a30-63d2885de66e
@bind nf NumberField(1:100; default=10)

# ╔═╡ 38fd0fc6-1166-11eb-126f-fda7cd735d76
nf # good

# ╔═╡ e08d89b8-1147-11eb-27c7-f766bfbcd119
@bind tf TextField(; dims=(3,8))

# ╔═╡ 742de95e-114a-11eb-37f3-ef8642108bf5
tf  # good

# ╔═╡ 7202dfec-114a-11eb-2f9f-e735cc2501ea
@bind tf2 TextField(; default="xx")

# ╔═╡ 75a126d4-114a-11eb-192f-afc757d8ac20
tf2  # good

# ╔═╡ 8b0d2e34-1148-11eb-32d6-a52ef910b42b
@bind pf PasswordField()

# ╔═╡ 97dc0ffe-1148-11eb-2524-c5972ea63e17
pf  # good

# ╔═╡ 90af075e-1148-11eb-1db8-c13efe7e574e
@bind s Select(options=[1=>"a", 2=>"b", 3=>"c"], default="2")

# ╔═╡ 42308a20-1149-11eb-30be-9f9bd068673b
s  # good

# ╔═╡ 8f8d56de-1148-11eb-2860-f93970443fc8
@bind fp FilePicker()

# ╔═╡ cbb2d090-1148-11eb-2db8-49456f468715
fp  # good

# ╔═╡ d1956402-1148-11eb-3071-07630c34c89c
@bind cb CheckBox(default=true)

# ╔═╡ 351cb584-1149-11eb-0732-55df5a37f745
cb # good

# ╔═╡ 76a1aa6e-1149-11eb-07ed-33d7df9e1986
@bind ms MultiSelect(options=["potato" => "🥔", "carrot" => "🥕"], default=["carrot"])

# ╔═╡ 5aa9e294-114a-11eb-181d-73d76de49ccb
ms # good

# ╔═╡ 626cb8a8-114a-11eb-1d75-5d57d4688ea7
@bind df DateField()

# ╔═╡ 39090d7c-114f-11eb-04ee-cfe6d86b8803
df  # good

# ╔═╡ cf0793c0-114a-11eb-1a5d-b169102a6b3b
@bind timef TimeField()

# ╔═╡ 3af3baec-114f-11eb-0f57-9f44681f2351
timef  # good

# ╔═╡ 26cac33e-114b-11eb-0ad9-5364dc135bf0
@bind csp ColorStringPicker(; default="#ffffff")

# ╔═╡ 3c997394-114f-11eb-29b4-636089d85738
csp   # good

# ╔═╡ Cell order:
# ╠═c8a92546-1147-11eb-042c-437210cca71b
# ╠═059247c8-1164-11eb-3cfb-2f853212914f
# ╠═3770bcbe-1166-11eb-3233-a71ecbe56fe2
# ╠═344f56e4-1166-11eb-1a30-63d2885de66e
# ╠═38fd0fc6-1166-11eb-126f-fda7cd735d76
# ╠═e08d89b8-1147-11eb-27c7-f766bfbcd119
# ╠═742de95e-114a-11eb-37f3-ef8642108bf5
# ╠═7202dfec-114a-11eb-2f9f-e735cc2501ea
# ╠═75a126d4-114a-11eb-192f-afc757d8ac20
# ╠═8b0d2e34-1148-11eb-32d6-a52ef910b42b
# ╠═97dc0ffe-1148-11eb-2524-c5972ea63e17
# ╠═90af075e-1148-11eb-1db8-c13efe7e574e
# ╠═42308a20-1149-11eb-30be-9f9bd068673b
# ╠═8f8d56de-1148-11eb-2860-f93970443fc8
# ╠═cbb2d090-1148-11eb-2db8-49456f468715
# ╠═d1956402-1148-11eb-3071-07630c34c89c
# ╠═351cb584-1149-11eb-0732-55df5a37f745
# ╠═76a1aa6e-1149-11eb-07ed-33d7df9e1986
# ╠═5aa9e294-114a-11eb-181d-73d76de49ccb
# ╠═626cb8a8-114a-11eb-1d75-5d57d4688ea7
# ╠═39090d7c-114f-11eb-04ee-cfe6d86b8803
# ╠═cf0793c0-114a-11eb-1a5d-b169102a6b3b
# ╠═3af3baec-114f-11eb-0f57-9f44681f2351
# ╠═26cac33e-114b-11eb-0ad9-5364dc135bf0
# ╠═3c997394-114f-11eb-29b4-636089d85738
