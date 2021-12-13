### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 1e992cf1-7ea6-4c23-a573-3c867c22ada0
md"""
# Scrubbable numbers

Try clicking and dragging the numbers in the text below:
"""

# ╔═╡ 023869e9-236d-426e-8419-d398f1d20c3e
html"""
<br>
<br>
<br>
"""

# ╔═╡ 7777f629-dc29-44a8-9127-8e236c88d1ef
# using PlutoUI

# ╔═╡ d86baba8-1207-466b-9170-fdc5f2616152
html"""
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
"""

# ╔═╡ 10494af3-3d7d-47ae-8844-3ca139e7708b
md"""
## Examples

We define a variable `x` as a _scrubbable number_ like so:
"""

# ╔═╡ 99a2907f-f748-47bd-92d2-88eb21e8e0f1
md"""
Using interpolation (with `$`), you can write this definition inside Markdown text:
"""

# ╔═╡ 0be135f4-ef36-41d1-8a20-1080ca8919a0
md"""
## Arguments

Besides an initial value, a scrubbable number also has an array of possible values that can be reached.

When you pass a **single number** to `Scrubbable`, this array is automatically created. Have a look at the minimum and maximum allowed values of the following scrubbables:
"""

# ╔═╡ 207d3d2f-2841-4eca-839d-88f80c80c788
md"""
_(Here we created a `Scrubbable` on its own, without binding its value to a variable. Not very useful!)_ 

You can also **specify the array manually**:
"""

# ╔═╡ a1d5ebd5-dec1-4486-9968-a9d6a539751a
md"""
If no `default` is specified, the middle value is used.
"""

# ╔═╡ 270beb18-8288-48eb-9165-423e12ec8411
md"""
### Formatting

The library [`d3-format`](https://github.com/d3/d3-format) is used to format floating-point numbers. You can specify a **format string** like `".2f"` to be used to format the scrubbable value. Have a look at their [documentation](https://github.com/d3/d3-format) to see more examples.
"""

# ╔═╡ c17663e3-8a3b-4d6b-8296-f8b996739a01
html"""<div style="height: 50vh"></div>"""

# ╔═╡ f8b9398e-afe6-4fdd-bc7a-9bb7b7c3cdc2
md"""
# Appendix
## What is a good default range?
"""

# ╔═╡ 4e40dcad-9840-4517-9947-7fcd4dce69cd
function default_range(x::Integer)
	if x == 0
		-10:10
	elseif 0 < x <= 10
		0:10
	elseif -10 <= x < 0
		-10:0
	else
		sort(round.([Int64], (0.0:0.1:2.0) .* x))
	end
end

# ╔═╡ e14b3395-831d-43d6-874e-cfb32f8edd05
up_or_down_one_order_of_magnitude = 10 .^ (-1.0:0.1:1.0)

# ╔═╡ 018035dd-78d7-46d3-bd3c-5c136fa47929
function default_range(x::Real) # not an integer
	if x == 0
		-1.0 : 0.1 : 1.0
	elseif 0 < x < 1
		between_zero_and_x = LinRange(0.0, x, 10)
		between_x_and_one = LinRange(x, 1.0, 10)
		[between_zero_and_x..., between_x_and_one[2:end]...]
	else
		sort(x .* up_or_down_one_order_of_magnitude)
	end
end

# ╔═╡ e0ea8328-ddcc-4130-b2f6-0079f98402ad
md"""
Integer inputs become integer ranges with constant step:
"""

# ╔═╡ e8a6ce9f-9f48-4e31-ad2a-e21d7e0415af
default_range(20)

# ╔═╡ 1e139b79-b703-43bf-a351-1a2d811aea6a
default_range(2000)

# ╔═╡ 1e60fea6-33dc-417b-9928-eb5922b41759
md"""
Floating points get a logarithmic scale across one order of magnitude:
"""

# ╔═╡ 6fe1f0f7-e8a1-441a-a676-ddd4b3b26668
default_range(1.0e6)

# ╔═╡ cfcc5fbb-72f7-4223-a83e-96fe6971b143
default_range(-2.0)

# ╔═╡ 1fa8edc6-9aa2-4082-bdeb-7517d9e2dd71
md"""
Zero becomes a range around zero:
"""

# ╔═╡ 3f1c3fa5-2257-4c3a-aa75-0b3c59a7fcdc
default_range(0)

# ╔═╡ 2554121f-13e6-4b07-9c45-b2ccf154d07d
default_range(0.0)

# ╔═╡ 8bce6b13-9600-49ca-a7ea-ba2f53028f1b
# using HypertextLiteral

# ╔═╡ d17d259b-8379-46a7-ab54-cd2f697ec713
# @htl("""
# 	$(bc)
# 	$(cool)
# 	""")

# ╔═╡ aed5fa58-4fe3-4596-b18d-a76cd98a5a1b
md"""
## Definition
"""

# ╔═╡ 1a649975-9e31-4ae8-8b2c-b615852cfc9d
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ 8c1d2b3b-8fa1-4356-8a9d-dff10cd0a336
if skip_as_script(@__MODULE__)
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Text("Project env active")
end

# ╔═╡ 58a5b0d2-88a6-4a83-bb26-05c05a51716b
import AbstractPlutoDingetjes

# ╔═╡ 9c7ce2da-4ad8-11eb-14cd-cfcc8d2a6bf8
begin
	"""
	
	An inline number that can be changed by clicking and dragging the mouse.
	
	# Examples
	```julia
	md\"\"\"
	_If Alice has \$(@bind a Scrubbable(20)) apples, 
	and she gives \$(@bind b Scrubbable(3)) apples to Bob..._
	\"\"\"
	```
	```julia
	md\"\"\"
	_...then Alice has **\$(a - b)** apples left._
	\"\"\"
	```
	
	In the examples above, we give the **initial value** as parameter, and the reader can change it to be lower or higher.
	
	## Custom range
	Besides an initial value, a scrubbable number also has an array of possible values that can be reached. When you pass a **single number** to `Scrubbable`, this array is automatically created.
	
	You can also **specify the array manually**:
	
	```julia
	@bind apples Scrubbable(200 : 300; default=220)
	```
	
	## Formatting

	The library [`d3-format`](https://github.com/d3/d3-format) is used to format floating-point numbers. You can specify a **format string** like `".2f"` to be used to format the scrubbable value. Have a look at their [documentation](https://github.com/d3/d3-format) to see more examples.
	
	`@bind money Scrubbable(30e6, format=".0s", prefix="€ ")`
	
	`@bind coolness Scrubbable(0.80 : 0.01 : 1.00, format=".0%", prefix="you are 🌝 ", suffix=" cool")`
	"""
	Base.@kwdef struct Scrubbable
		values::AbstractVector{<:Real}
		default::Real
		format::Union{AbstractString,Nothing}=nothing
		prefix::AbstractString=""
		suffix::AbstractString=""
        id::String=join(rand('a':'z', 16))
	end
	Scrubbable(range::AbstractVector; kwargs...) = Scrubbable(;values=range, default=range[1 + length(range) ÷ 2], kwargs...)
	Scrubbable(x::Number; kwargs...) = Scrubbable(;values=default_range(x), default=x, kwargs...)
	
	Base.get(s::Scrubbable) = s.default

	AbstractPlutoDingetjes.Bonds.initial_value(s::Scrubbable) = 
		s.default
	AbstractPlutoDingetjes.Bonds.possible_values(s::Scrubbable) = 
		s.values
	function AbstractPlutoDingetjes.Bonds.validate_value(s::Scrubbable, val)
		val isa Real && minimum(s.values) - 0.001 <= val <= maximum(s.values) + 0.001
	end
	
	function Base.show(io::IO, m::MIME"text/html", s::Scrubbable)
		format = if s.format === nothing
			# TODO: auto format
			if eltype(s.values) <: Integer
				""
			else
				".1f"
			end
		else
			String(s.format)
		end

		write(io, """<script id='$(s.id)'>
			// weird import to make it faster. The `await import` can still delay execution by one frame if it is already loaded...
			window.d3format = window.d3format ?? await import("https://cdn.jsdelivr.net/npm/d3-format@2/+esm")

			const argmin = xs => xs.indexOf(Math.min(...xs))
			const closest_index = (xs, y) => argmin(xs.map(x => Math.abs(x-y)))

			const values = $(string(collect(s.values)))

			const el = html`
			<span title="Click and drag this number left or right!" style="cursor: col-resize;
			touch-action: none;
			background: rgb(252, 209, 204);
			padding: 0em .2em;
			border-radius: .3em;
			font-weight: bold;">$(s.default)</span>
			`



			let old_x = 0
			let old_index = 0
			const initial_index = closest_index(values, $(s.default))
			let current_index = initial_index

			const formatter = s => $(repr(s.prefix)) + d3format.format($(repr(format)))(s) + $(repr(s.suffix))


			Object.defineProperty(el, 'value', {
				get: () => values[current_index],
				set: x => {
					current_index = closest_index(values, x)
					el.innerText = formatter(el.value)
				},
				configurable: true,
			});

			// initial value
			el.innerText = formatter($(s.default))

			const onScrub = (e) => {
				const offset = e.clientX - old_x
				const new_index = Math.min(values.length-1, Math.max(0, 
					Math.round(offset/10) + old_index
				))

				if(new_index !== current_index) {
					current_index = new_index
					el.innerText = formatter(el.value)
					el.dispatchEvent(new CustomEvent("input"))
				}
			}

			const onpointerdown = (e) => {
				window.getSelection().empty()
				old_x = e.clientX
				old_index = current_index
				window.addEventListener("pointermove", onScrub)
			}
			el.addEventListener("pointerdown", onpointerdown)

			const ondblclick = (e) => {
				current_index = initial_index
				el.innerText = formatter(el.value)
				el.dispatchEvent(new CustomEvent("input"))
			}
			el.addEventListener("dblclick", ondblclick)

			const onpointerup = () => {
				window.removeEventListener("pointermove", onScrub)
			}
			window.addEventListener("pointerup", onpointerup)

			el.onselectstart = () => false

			invalidation.then(() => {
				el.removeEventListener("pointerdown", onpointerdown)
				el.removeEventListener("dblclick", ondblclick)
				window.removeEventListener("pointerup", onpointerup)
			})

			return el

			</script>""")
	end
	
	Scrubbable
end

# ╔═╡ b62db8c0-4352-4d0f-83a2-ac170ef3337a
md"""
_If Alice has $(@bind a Scrubbable(20)) apples, 
and she gives $(@bind b Scrubbable(3)) apples to Bob..._
"""

# ╔═╡ 861a570a-3a77-4445-9217-3d38682cbb8c
md"""
_...then Alice has **$(a - b)** apples left._
"""

# ╔═╡ 5d6299e0-fb4a-448f-b87a-9d17b607fd6a
@bind x Scrubbable(5)

# ╔═╡ 188e548a-2d5d-4680-9b0a-7bfb03b24dab
1000 + x

# ╔═╡ e9169074-6fec-43a6-badc-4b20d05050ab
md"""
If Alice has $(@bind num_apples Scrubbable(20)) apples...
"""

# ╔═╡ 65584961-4085-4fd6-8968-6951056f3b1c
num_apples

# ╔═╡ 9e97e893-066c-4fc6-b380-9637994b7dac
(Scrubbable(5), Scrubbable(2000), Scrubbable(30.0))

# ╔═╡ b69fb562-7e8e-4366-a53d-85173afc49be
Scrubbable(200 : 300; default=220)

# ╔═╡ 19549e7c-cf8a-4d79-814b-db89efc91a15
md"""
# I spent $(@bind money Scrubbable(30e6, format=".0s", prefix="€ ")) on Pluto.jl stickers

And it was worth it!

"""

# ╔═╡ 71bb41eb-908c-4b43-881b-5b6726fc6d0a
@bind coolness Scrubbable(0.80 : 0.01 : 1.00, format=".0%", prefix="you are 🌝 ", suffix=" cool")

# ╔═╡ 574564ab-ab15-490e-aff6-6300718ae751
if coolness >= 1
	md"![](https://media.giphy.com/media/GwGXoeb0gm7sc/giphy.gif)"
end

# ╔═╡ b081aa76-f080-4dd0-bcff-4bcc82a1c50a
bc = @bind cool Scrubbable(199.1)

# ╔═╡ 5c78e637-5733-4b0a-8dab-bf1cd9656d11
HTML(join(repr.([MIME"text/html"()], [Scrubbable(1.0) for _ in 1:100])))

# ╔═╡ 1d34fec8-01cb-4bee-8144-d8cc13a87b8b
export Scrubbable

# ╔═╡ Cell order:
# ╟─1e992cf1-7ea6-4c23-a573-3c867c22ada0
# ╟─023869e9-236d-426e-8419-d398f1d20c3e
# ╠═7777f629-dc29-44a8-9127-8e236c88d1ef
# ╠═b62db8c0-4352-4d0f-83a2-ac170ef3337a
# ╠═861a570a-3a77-4445-9217-3d38682cbb8c
# ╟─d86baba8-1207-466b-9170-fdc5f2616152
# ╟─10494af3-3d7d-47ae-8844-3ca139e7708b
# ╠═5d6299e0-fb4a-448f-b87a-9d17b607fd6a
# ╠═188e548a-2d5d-4680-9b0a-7bfb03b24dab
# ╟─99a2907f-f748-47bd-92d2-88eb21e8e0f1
# ╠═e9169074-6fec-43a6-badc-4b20d05050ab
# ╠═65584961-4085-4fd6-8968-6951056f3b1c
# ╟─0be135f4-ef36-41d1-8a20-1080ca8919a0
# ╠═9e97e893-066c-4fc6-b380-9637994b7dac
# ╟─207d3d2f-2841-4eca-839d-88f80c80c788
# ╠═b69fb562-7e8e-4366-a53d-85173afc49be
# ╟─a1d5ebd5-dec1-4486-9968-a9d6a539751a
# ╟─270beb18-8288-48eb-9165-423e12ec8411
# ╟─19549e7c-cf8a-4d79-814b-db89efc91a15
# ╟─71bb41eb-908c-4b43-881b-5b6726fc6d0a
# ╟─574564ab-ab15-490e-aff6-6300718ae751
# ╟─c17663e3-8a3b-4d6b-8296-f8b996739a01
# ╟─f8b9398e-afe6-4fdd-bc7a-9bb7b7c3cdc2
# ╠═4e40dcad-9840-4517-9947-7fcd4dce69cd
# ╠═e14b3395-831d-43d6-874e-cfb32f8edd05
# ╠═018035dd-78d7-46d3-bd3c-5c136fa47929
# ╟─e0ea8328-ddcc-4130-b2f6-0079f98402ad
# ╠═e8a6ce9f-9f48-4e31-ad2a-e21d7e0415af
# ╠═1e139b79-b703-43bf-a351-1a2d811aea6a
# ╟─1e60fea6-33dc-417b-9928-eb5922b41759
# ╠═6fe1f0f7-e8a1-441a-a676-ddd4b3b26668
# ╠═cfcc5fbb-72f7-4223-a83e-96fe6971b143
# ╟─1fa8edc6-9aa2-4082-bdeb-7517d9e2dd71
# ╠═3f1c3fa5-2257-4c3a-aa75-0b3c59a7fcdc
# ╠═2554121f-13e6-4b07-9c45-b2ccf154d07d
# ╠═b081aa76-f080-4dd0-bcff-4bcc82a1c50a
# ╠═8bce6b13-9600-49ca-a7ea-ba2f53028f1b
# ╠═d17d259b-8379-46a7-ab54-cd2f697ec713
# ╠═5c78e637-5733-4b0a-8dab-bf1cd9656d11
# ╟─aed5fa58-4fe3-4596-b18d-a76cd98a5a1b
# ╟─1a649975-9e31-4ae8-8b2c-b615852cfc9d
# ╟─8c1d2b3b-8fa1-4356-8a9d-dff10cd0a336
# ╠═58a5b0d2-88a6-4a83-bb26-05c05a51716b
# ╠═9c7ce2da-4ad8-11eb-14cd-cfcc8d2a6bf8
# ╠═1d34fec8-01cb-4bee-8144-d8cc13a87b8b
