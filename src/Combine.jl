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

# ╔═╡ 1b737805-a411-4585-b215-d0f99eafac0c
using HypertextLiteral

# ╔═╡ 881b75d3-cebe-4a53-8cf5-beaeeddafd35
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ dadf2f40-1764-47a4-b560-683b6479d77f
if skip_as_script(@__MODULE__)
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Text("Project env active")
end

# ╔═╡ 38b7eeb9-80bb-4a3a-a2d2-809fc423625c
if skip_as_script(@__MODULE__)
	using PlutoUI
end

# ╔═╡ ba94c9b3-55bf-486a-8bf3-eb0b3e65e536
"""
	@skip_as_script expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 9e56dbb9-2e93-4136-b10b-7b1ecb07e6f1
macro only_as_script(ex) skip_as_script(__module__) ? nothing : esc(ex) end

# ╔═╡ 5028fc01-4e14-4550-8ae6-48703b86dc21
import AbstractPlutoDingetjes.Bonds

# ╔═╡ ccbe4423-801b-4c20-ad2d-ee89d5cfa859
md"""
# Combining bonds
"""

# ╔═╡ 85918609-5e1f-4040-99be-61c2dd8ff654
md"""
## The magic
"""

# ╔═╡ 957858f8-4ace-4cae-bb16-49569daa9869
const set_input_value_compat = HypertextLiteral.JavaScript("""
setBoundElementValueLikePluto ?? ((input, new_value) => {
	// fallback in case https://github.com/fonsp/Pluto.jl/pull/1755 is not available
    if (new_value == null) {
        //@ts-ignore
        input.value = new_value
        return
    }
    if (input instanceof HTMLInputElement) {
        switch (input.type) {
            case "range":
            case "number": {
                if (input.valueAsNumber !== new_value) {
                    input.valueAsNumber = new_value
                }
                return
            }
            case "date": {
                if (input.valueAsDate == null || Number(input.valueAsDate) !== Number(new_value)) {
                    input.valueAsDate = new_value
                }
                return
            }
            case "checkbox": {
                if (input.checked !== new_value) {
                    input.checked = new_value
                }
                return
            }
            case "file": {
                // Can't set files :(
                return
            }
        }
    } else if (input instanceof HTMLSelectElement && input.multiple) {
        for (let option of Array.from(input.options)) {
            option.selected = new_value.includes(option.value)
        }
        return
    }
    //@ts-ignore
    if (input.value !== new_value) {
        //@ts-ignore
        input.value = new_value
    }
})
""")

# ╔═╡ 19613f3f-5825-45a4-8951-8ff1043d0867
begin
	Base.@kwdef struct CombinedBonds
		display_content::Any
		captured_bonds::Vector{Any}
		secret_key::String
	end

	function Base.show(io::IO, m::MIME"text/html", cb::CombinedBonds)
		output = @htl("""
		<span>
		$(cb.display_content)
		<script id=$(cb.secret_key)>
		const div = currentScript.parentElement
		let key = $(cb.secret_key)
		const inputs = div.querySelectorAll(`pl-combined_child[key='\${key}'] > *:first-child`)
		
		const values = Array(inputs.length)
		
		inputs.forEach(async (el,i) => {
			el.oninput = (e) => {
				e.stopPropagation()
			}
			const gen = Generators.input(el)
			while(true) {
				values[i] = await gen.next().value
				div.dispatchEvent(new CustomEvent("input", {}))
			}
		})


		let set_input_value = $(set_input_value_compat)
	
		Object.defineProperty(div, 'value', {
			get: () => values,
			set: (newvals) => {
				if(!newvals) {
					return
				}
				inputs.forEach((el, i) => {
					values[i] = newvals[i]
					set_input_value(el, newvals[i])
				})
		},
			configurable: true,
		});
	
		</script>
		</span>
		""")
		Base.show(io, m, output)
	end

	function Bonds.initial_value(cb::CombinedBonds)
		map(Bonds.initial_value, cb.captured_bonds)
	end
	function Bonds.validate_value(cb::CombinedBonds, from_js)
		if from_js isa Vector && length(from_js) == length(cb.captured_bonds)
			all((
				Bonds.validate_value(bond, val_js)
				for (bond, val_js) in zip(cb.captured_bonds, from_js)
			))
		else
			false
		end
	end
	function Bonds.transform_value(cb::CombinedBonds, from_js)
		@assert from_js isa Vector
		@assert length(from_js) == length(cb.captured_bonds)

		[
			Bonds.transform_value(bond, val_js)
			for (bond, val_js) in zip(cb.captured_bonds, from_js)
		]
	end
	
	# TODO:
	# function Bonds.possible_values (cb::CombinedBonds, from_js)
	# end
	
end

# ╔═╡ a20da18f-7a74-43ca-9b66-1f3b82efa0c3
"""
```julia
combine(render_function::Function)
```

Combine multiple input elements into one.

# Examples

## 🐶 & 🐱

```julia
@bind values combine() do Child
	md""\"
	# Hi there!

	I have \$(Child(Slider(1:10))) dogs and \$(Child(Slider(5:10))) cats.

	Would you like to see them? \$(Child(CheckBox(true)))
	""\"
end

values == [1, 5, true] # (initially)
```


> The output looks like:
> 
> ![screenshot of running the code above inside Pluto](https://user-images.githubusercontent.com/6933510/145589918-25a3c732-c02e-482b-831b-06131b283597.png)

## 🎏


The `combine` function is most useful when you want to generate your input elements _dynamically_. This example uses [HypertextLiteral.jl](https://github.com/MechanicalRabbit/HypertextLiteral.jl) for the `@htl` macro:

```julia
@bind speeds combine() do Child
	@htl(""\"
	<h6>Wind speeds</h6>
	<ul>
	\$([
		@htl("<li>\$(name): \$(Child(Slider(1:100)))")
		for name in ["North", "East", "South", "West"]
	])
	</ul>
	""\")
end

speeds == [1, 1, 1, 1] # (initially)

# after moving the sliders:
speeds == [100, 36, 73, 60]
```

> The output looks like:
> 
> ![screenshot of running the code above inside Pluto](https://user-images.githubusercontent.com/6933510/145588612-14824654-5c73-45f8-983c-8913c7101a78.png)

# Why?
The standard way to combine multiple inputs into one output is to use `@bind` multiple times. Our initial example could more easily be written as:
```julia
md""\"
# Hi there!

I have \$(@bind num_dogs Slider(1:10)) dogs and \$(@bind num_cats Slider(5:10)) cats.

Would you like to see them? \$(@bind want_to_see CheckBox(true))
""\"
```

The `combine` function is useful when you are generating inputs **dynamically**, like in our second example. This is useful when:
- The number of parameters is very large, and you don't want to write `@bind parameter1 ...`, `@bind parameter2 ...`, etc. 
- The number of parameters is dynamic! For example, you can load in a table in one cell, and then use `combine` in another cell to select which rows you want to use.

"""
function combine(f::Function)
	key = String(rand('a':'z', 10))

	captured_bonds = []

	function combined_child(x)
		push!(captured_bonds, x)
		@htl("""<pl-combined_child key=$(key)>$(x)</pl-combined_child>""")
	end

	result = f(combined_child)
	
	CombinedBonds(;
		secret_key = key,
		captured_bonds = captured_bonds,
		display_content = result,
	)
end

# ╔═╡ ad5cffa5-313c-4de9-9360-005365b40780
export combine

# ╔═╡ 6c8a03e4-7d8e-4aa4-a750-7b815622147d
md"""
## Examples
"""

# ╔═╡ f08680b2-ed28-4fac-838c-2eca7e75c6dc
@skip_as_script @bind values combine() do Child
	md"""
	# Hi there!

	I have $(Child(Slider(1:10))) dogs and $(Child(Slider(5:10))) cats.

	Would you like to see them? $(Child(CheckBox(true)))
	"""
end

# ╔═╡ 8dcb2498-00cf-49a8-8074-301fe88b76ea
@skip_as_script values

# ╔═╡ 801fb021-73a0-4114-a36a-328e84f00b51
@skip_as_script @bind speeds combine() do Child
	@htl("""
	<h3>Wind speeds</h3>
	<ul>
	$([
		@htl("<li>$(name): $(Child(Slider(1:100)))")
		for name in ["North", "East", "South", "West"]
	])
	</ul>
	""")
end

# ╔═╡ d7985844-5944-42b9-ad41-599cd72eea82
@skip_as_script speeds

# ╔═╡ c3176549-7c46-4d89-9c76-817c6bfcbb71
@skip_as_script rb = @bind together combine() do Child
	@htl("""
	<p>Hello world!</p>
	$(Child(TextField()))
	$(Child(Slider([sin, cos, tan])))
	$([
		Child(Scrubbable(7))
		for _ in 1:3
	])
	
	""")
end

# ╔═╡ 5300b80d-4097-4b85-ad2a-3a54b01559bf
@skip_as_script let
	sleep(.5)
	together
end

# ╔═╡ 6d4f62a6-e3d9-416f-a1e3-694c31cfbb31
@skip_as_script rb

# ╔═╡ 5a0196d0-e19f-4202-b36d-18ab9be839b3
md"""
## Tests
"""

# ╔═╡ 3d3a6abb-bea7-41e2-862d-9536a9687ea5
md"""
### Initial value & transform
"""

# ╔═╡ 0b643ed9-914a-475b-a1ce-d840df1fc223
@skip_as_script begin
	itvs = []
	itb = @bind itv combine() do Child
		@htl("""
		<p>Hello world!</p>
		$(Child(@htl("<input type=range>")))
		$(Child(Slider([sin, cos, tan])))
		
		""")
	end
end

# ╔═╡ 59a199f4-4ccc-4319-9d32-03da3adbb5db
@skip_as_script itb

# ╔═╡ cc3e475e-d2c2-4b40-a1ba-033576aefdae
md"""
Should be `[[missing, sin], [50, sin]]`
"""

# ╔═╡ 127dd58b-9ba0-41d8-91e6-357d9ec63e6b
@skip_as_script push!(itvs, itv)

# ╔═╡ 7de50435-e962-4405-b06d-83fbe9436cff
md"""
### Combine inside combine
"""

# ╔═╡ 3396a5ba-533e-4e0d-ab4f-c633459bd81a
@skip_as_script cb1 = combine() do Child
	md"""
	Left: $(Child(Slider(1:10))), right: $(Child(Scrubbable(5)))
	"""
end

# ╔═╡ 829f90ac-c4d9-4af9-984a-b4e52a075460
@skip_as_script cb2b = @bind wowz combine() do Child
	md"""
	Do a thing: $(Child(CheckBox()))
	
	#### Up
	$(Child(cb1))

	#### Down
	$(Child(cb1))
	
	"""
end

# ╔═╡ a1a9b22f-9df7-4c5f-a73d-38e184da7c35
@skip_as_script wowz

# ╔═╡ c7a32ab2-2a5b-485b-9795-4a743604de82
@skip_as_script cb2b

# ╔═╡ Cell order:
# ╟─881b75d3-cebe-4a53-8cf5-beaeeddafd35
# ╟─ba94c9b3-55bf-486a-8bf3-eb0b3e65e536
# ╟─9e56dbb9-2e93-4136-b10b-7b1ecb07e6f1
# ╟─dadf2f40-1764-47a4-b560-683b6479d77f
# ╠═1b737805-a411-4585-b215-d0f99eafac0c
# ╠═5028fc01-4e14-4550-8ae6-48703b86dc21
# ╟─ccbe4423-801b-4c20-ad2d-ee89d5cfa859
# ╠═ad5cffa5-313c-4de9-9360-005365b40780
# ╠═a20da18f-7a74-43ca-9b66-1f3b82efa0c3
# ╟─85918609-5e1f-4040-99be-61c2dd8ff654
# ╠═19613f3f-5825-45a4-8951-8ff1043d0867
# ╟─957858f8-4ace-4cae-bb16-49569daa9869
# ╟─6c8a03e4-7d8e-4aa4-a750-7b815622147d
# ╠═38b7eeb9-80bb-4a3a-a2d2-809fc423625c
# ╠═f08680b2-ed28-4fac-838c-2eca7e75c6dc
# ╠═8dcb2498-00cf-49a8-8074-301fe88b76ea
# ╠═801fb021-73a0-4114-a36a-328e84f00b51
# ╠═d7985844-5944-42b9-ad41-599cd72eea82
# ╠═c3176549-7c46-4d89-9c76-817c6bfcbb71
# ╠═5300b80d-4097-4b85-ad2a-3a54b01559bf
# ╠═6d4f62a6-e3d9-416f-a1e3-694c31cfbb31
# ╟─5a0196d0-e19f-4202-b36d-18ab9be839b3
# ╟─3d3a6abb-bea7-41e2-862d-9536a9687ea5
# ╠═0b643ed9-914a-475b-a1ce-d840df1fc223
# ╠═59a199f4-4ccc-4319-9d32-03da3adbb5db
# ╟─cc3e475e-d2c2-4b40-a1ba-033576aefdae
# ╠═127dd58b-9ba0-41d8-91e6-357d9ec63e6b
# ╟─7de50435-e962-4405-b06d-83fbe9436cff
# ╠═3396a5ba-533e-4e0d-ab4f-c633459bd81a
# ╠═829f90ac-c4d9-4af9-984a-b4e52a075460
# ╠═a1a9b22f-9df7-4c5f-a73d-38e184da7c35
# ╠═c7a32ab2-2a5b-485b-9795-4a743604de82
