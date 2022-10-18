### A Pluto.jl notebook ###
# v0.19.12

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

# ╔═╡ dadf2f40-1764-47a4-b560-683b6479d77f
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
end
  ╠═╡ =#

# ╔═╡ 1b737805-a411-4585-b215-d0f99eafac0c
using HypertextLiteral

# ╔═╡ 38b7eeb9-80bb-4a3a-a2d2-809fc423625c
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	using PlutoUI
	using PlutoUI: combine
end
  ╠═╡ =#

# ╔═╡ 5028fc01-4e14-4550-8ae6-48703b86dc21
import AbstractPlutoDingetjes.Bonds

# ╔═╡ e9d5e84d-b6b1-434d-9580-c08b0c45b9dd
import AbstractPlutoDingetjes

# ╔═╡ ccbe4423-801b-4c20-ad2d-ee89d5cfa859
md"""
# Holding intermediate updates
"""

# ╔═╡ 85918609-5e1f-4040-99be-61c2dd8ff654
md"""
## The magic
"""

# ╔═╡ 957858f8-4ace-4cae-bb16-49569daa9869
const set_input_value_compat = HypertextLiteral.JavaScript("""
(() => {
	let result = null
	try {
	result = setBoundElementValueLikePluto
} catch (e) {
	result = ((input, new_value) => {
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
}
return result
})()
""")

# ╔═╡ 19613f3f-5825-45a4-8951-8ff1043d0867
begin
	Base.@kwdef struct ConfirmBond
		element::Any
		secret_key::String=String(rand('a':'z', 10))
	end

	function Base.show(io::IO, m::MIME"text/html", cb::ConfirmBond)
		if !AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.transform_value)
			return Base.show(io, m, HTML("<span>❌ You need to update Pluto to use this PlutoUI element.</span>"))
		end
		output = @htl(
			"""<span style='display: contents;'>$(
				cb.element
			)<input type=submit id=$(cb.secret_key)><script id=$(cb.secret_key)>
		
		let key = $(cb.secret_key)
		
		let div = currentScript.parentElement
		let button = currentScript.previousElementSibling
		let input = div.firstElementChild
		if(input === button) {
			return
		}

		
		let set_input_value = $(set_input_value_compat)


		let private_value = null
		let public_value = null

		

		
		private_value = public_value = div.value
		if(private_value != null) {
			set_input_value(input, private_value)
		} else {
		
			// private_value = public_value = input.value
		}
		
		input.oninput = (e) => {
			e.stopPropagation()
		}
		const gen = Generators.input(input)

		// If the child does not have an initial value, the `gen.next().value` promise will never resolve. If it does, then it resolves instantly.
		let first_value = await Promise.any([
			gen.next().value,
			Promise.resolve(undefined)
		])
		private_value = public_value = first_value
		
		;(async () => {
			while(true) {
				private_value = await gen.next().value
				// div.dispatchEvent(new CustomEvent("input", {}))
			}
		})()

		button.addEventListener("click", () => {
			public_value = private_value
			div.dispatchEvent(new CustomEvent("input", {}))
		})

	
		Object.defineProperty(div, 'value', {
			get: () => public_value,
			set: (newval) => {
				private_value = newval
				public_value = newval
				
				set_input_value(input, newval)
			},
			configurable: true,
		});
	
		</script></span>""")
		Base.show(io, m, output)
	end

	function Bonds.initial_value(cb::ConfirmBond)
		Bonds.initial_value(cb.element)
	end
	function Bonds.validate_value(cb::ConfirmBond, from_js)
		Bonds.validate_value(cb.element, from_js)
	end
	function Bonds.transform_value(cb::ConfirmBond, from_js)
		Bonds.transform_value(cb.element, from_js)
	end
	function Bonds.possible_values(cb::ConfirmBond)
		Bonds.possible_values(cb.element)
	end
	
end

# ╔═╡ a20da18f-7a74-43ca-9b66-1f3b82efa0c3
"""
```julia
confirm(element::Any)
```

Normally, when you move a [`Slider`](@ref) or type in a [`TextField`](@ref), all intermediate values are sent back to `@bind`.

By wrapping an input element in `confirm`, you get a button to manually control when the value is sent, intermediate updates are hidden from Pluto.

One case where this is useful is a notebook that does a long computation based on a `@bind` input.

# Examples

```julia
@bind x confirm(Slider(1:100))

x == 1 # (initially)
```

Now, when you move the slider, nothing happens, until you click the `"Confirm"` button, and `x` is set to the new slider value.

> The result looks like:
> 
> ![screenshot of running the code above in pluto](https://user-images.githubusercontent.com/6933510/145615211-2731f1f5-5c7d-4aac-9aa5-8afe89e24a6b.png)

# See also

You can combine this with [`PlutoUI.combine`](@ref)!

```julia
@bind speeds confirm(
	combine() do Child
		@htl(""\"
		<h3>Wind speeds</h3>
		<ul>
		\$([
			@htl("<li>\$(name): \$(Child(name, Slider(1:100)))")
			for name in ["North", "East", "South", "West"]
		])
		</ul>
		""\")
	end
)
```

> The result looks like:
> 
> ![screenshot of running the code above in pluto](https://user-images.githubusercontent.com/6933510/145614965-7a1e8630-4766-4589-8a84-b022bdfb09fc.gif)

"""
function confirm(element::Any)
	ConfirmBond(;
		element=element,
	)
end

# ╔═╡ ad5cffa5-313c-4de9-9360-005365b40780
export confirm

# ╔═╡ 6c8a03e4-7d8e-4aa4-a750-7b815622147d
md"""
## Examples
"""

# ╔═╡ f08680b2-ed28-4fac-838c-2eca7e75c6dc
# ╠═╡ skip_as_script = true
#=╠═╡
xb = @bind x confirm(Slider([sin, cos, tan, sqrt, floor]))
  ╠═╡ =#

# ╔═╡ 41d64a95-6c03-4a5d-9fd7-496d0e6c0346
#=╠═╡
xb
  ╠═╡ =#

# ╔═╡ 8dcb2498-00cf-49a8-8074-301fe88b76ea
#=╠═╡
x(234)
  ╠═╡ =#

# ╔═╡ fc92b3fc-6143-477c-a413-84dcd1b4cfc0
# ╠═╡ skip_as_script = true
#=╠═╡
@bind t confirm(html"<input>")
  ╠═╡ =#

# ╔═╡ 363a65ec-218c-43a2-b740-8061fac25011
#=╠═╡
t
  ╠═╡ =#

# ╔═╡ a61f27d1-4043-48f1-a974-7d1a0ae65407
md"""
### Bad usage *(should not break)*
[https://github.com/fonsp/Pluto.jl/issues/1929](https://github.com/fonsp/Pluto.jl/issues/1929)
"""

# ╔═╡ aa399a36-7fea-4912-89ef-4bd5de173c69
# ╠═╡ skip_as_script = true
#=╠═╡
@bind asdf confirm(html"<span>asdf</span>")
  ╠═╡ =#

# ╔═╡ 00ec98e4-4913-4e85-9d71-eaf6aedd1265
#=╠═╡
asdf, rand()
  ╠═╡ =#

# ╔═╡ 5d9eeddb-5d18-4510-ae04-1b1806eb19ca
# ╠═╡ skip_as_script = true
#=╠═╡
@bind asdf2 confirm(html"<span>")
  ╠═╡ =#

# ╔═╡ 0d84e69b-c55e-448c-8710-97bede80f924
#=╠═╡
asdf2, rand()
  ╠═╡ =#

# ╔═╡ bac9ea52-ee38-40bf-8d54-9ece7f5b372f
# ╠═╡ skip_as_script = true
#=╠═╡
@bind asdf3 confirm(html"asdf")
  ╠═╡ =#

# ╔═╡ 58105619-978a-450e-a06d-bbdfbbec8a66
#=╠═╡
asdf3, rand()
  ╠═╡ =#

# ╔═╡ 42791264-2c15-427a-a398-aedbb76b5288
# ╠═╡ skip_as_script = true
#=╠═╡
@bind asdf4 confirm(@bind asdf5 Slider(1:100))
  ╠═╡ =#

# ╔═╡ 3f871bb5-a907-40d2-8ea2-35e0df041565
#=╠═╡
asdf4, rand()
  ╠═╡ =#

# ╔═╡ 8c9cc28c-2684-4b1c-b990-3f55b6d55aec
#=╠═╡
asdf5
  ╠═╡ =#

# ╔═╡ 801fb021-73a0-4114-a36a-328e84f00b51
# ╠═╡ skip_as_script = true
#=╠═╡
@bind speeds identity(
	combine() do Child
		@htl("""
		<h3>Wind speeds</h3>
		<ul>
		$([
			@htl("<li>$(name): $(Child(name, Slider(1:100)))")
			for name in ["North", "East", "South", "West"]
		])
		</ul>
		""")
	end
)
  ╠═╡ =#

# ╔═╡ d7985844-5944-42b9-ad41-599cd72eea82
#=╠═╡
speeds
  ╠═╡ =#

# ╔═╡ 5a0196d0-e19f-4202-b36d-18ab9be839b3
md"""
## Tests
"""

# ╔═╡ 3d3a6abb-bea7-41e2-862d-9536a9687ea5
md"""
### Initial value & transform
"""

# ╔═╡ 451c3c11-c3dc-4d6e-b9e5-c3904e405812
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	itvs = []

	itb = @bind itv confirm(Slider([sin, cos]))
end
  ╠═╡ =#

# ╔═╡ bb9eddc3-208c-4113-8988-311eb1dcfcd4
#=╠═╡
push!(itvs, itv)
  ╠═╡ =#

# ╔═╡ 7de50435-e962-4405-b06d-83fbe9436cff
md"""
### Combine inside combine
"""

# ╔═╡ 829f90ac-c4d9-4af9-984a-b4e52a075460
# ╠═╡ skip_as_script = true
#=╠═╡
cb2b = @bind wowz confirm(confirm(Slider(1:1//3:10)))
  ╠═╡ =#

# ╔═╡ a1a9b22f-9df7-4c5f-a73d-38e184da7c35
#=╠═╡
let
	sleep(1)
	wowz
end
  ╠═╡ =#

# ╔═╡ c7a32ab2-2a5b-485b-9795-4a743604de82
#=╠═╡
cb2b
  ╠═╡ =#

# ╔═╡ Cell order:
# ╟─dadf2f40-1764-47a4-b560-683b6479d77f
# ╠═1b737805-a411-4585-b215-d0f99eafac0c
# ╠═5028fc01-4e14-4550-8ae6-48703b86dc21
# ╠═e9d5e84d-b6b1-434d-9580-c08b0c45b9dd
# ╟─ccbe4423-801b-4c20-ad2d-ee89d5cfa859
# ╠═ad5cffa5-313c-4de9-9360-005365b40780
# ╠═a20da18f-7a74-43ca-9b66-1f3b82efa0c3
# ╟─85918609-5e1f-4040-99be-61c2dd8ff654
# ╠═19613f3f-5825-45a4-8951-8ff1043d0867
# ╟─957858f8-4ace-4cae-bb16-49569daa9869
# ╟─6c8a03e4-7d8e-4aa4-a750-7b815622147d
# ╠═38b7eeb9-80bb-4a3a-a2d2-809fc423625c
# ╠═f08680b2-ed28-4fac-838c-2eca7e75c6dc
# ╠═41d64a95-6c03-4a5d-9fd7-496d0e6c0346
# ╠═8dcb2498-00cf-49a8-8074-301fe88b76ea
# ╠═fc92b3fc-6143-477c-a413-84dcd1b4cfc0
# ╠═363a65ec-218c-43a2-b740-8061fac25011
# ╟─a61f27d1-4043-48f1-a974-7d1a0ae65407
# ╠═aa399a36-7fea-4912-89ef-4bd5de173c69
# ╠═00ec98e4-4913-4e85-9d71-eaf6aedd1265
# ╠═5d9eeddb-5d18-4510-ae04-1b1806eb19ca
# ╠═0d84e69b-c55e-448c-8710-97bede80f924
# ╠═bac9ea52-ee38-40bf-8d54-9ece7f5b372f
# ╠═58105619-978a-450e-a06d-bbdfbbec8a66
# ╠═42791264-2c15-427a-a398-aedbb76b5288
# ╠═3f871bb5-a907-40d2-8ea2-35e0df041565
# ╠═8c9cc28c-2684-4b1c-b990-3f55b6d55aec
# ╠═801fb021-73a0-4114-a36a-328e84f00b51
# ╠═d7985844-5944-42b9-ad41-599cd72eea82
# ╟─5a0196d0-e19f-4202-b36d-18ab9be839b3
# ╟─3d3a6abb-bea7-41e2-862d-9536a9687ea5
# ╠═451c3c11-c3dc-4d6e-b9e5-c3904e405812
# ╠═bb9eddc3-208c-4113-8988-311eb1dcfcd4
# ╟─7de50435-e962-4405-b06d-83fbe9436cff
# ╠═829f90ac-c4d9-4af9-984a-b4e52a075460
# ╠═a1a9b22f-9df7-4c5f-a73d-38e184da7c35
# ╠═c7a32ab2-2a5b-485b-9795-4a743604de82
