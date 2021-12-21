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

# ╔═╡ ea9b4e8b-cfc1-4177-bd3e-45608aca9398
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ f85cb5fc-246d-46a1-9875-9c06b7f102d6
if skip_as_script(@__MODULE__)
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Text("Project env active")
end

# ╔═╡ eab272db-413a-44e4-9c07-b1c1b96e9a5c
if skip_as_script(@__MODULE__)
	using PlutoUI
end

# ╔═╡ 4d94fbcd-f53f-4a90-b01c-f4dbe83313d1
"""
	@skip_as_script expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 460e57a6-d40e-4892-a945-55b03141b1d7
macro only_as_script(ex) skip_as_script(__module__) ? nothing : esc(ex) end

# ╔═╡ b88673ff-30b2-4aca-b0d1-b55a1cd393e7
import AbstractPlutoDingetjes.Bonds

# ╔═╡ b230e180-8e51-4490-8c3e-66a8829a3b7e
import AbstractPlutoDingetjes

# ╔═╡ 80906b18-59b2-4fdf-ba8b-e8080da7066e
md"""
# `transformed_value`

A high-level widget to transform a bond value.
"""

# ╔═╡ 36ff1ff5-cd12-4d66-835b-2b1a6aa9020d
md"""
## Examples
"""

# ╔═╡ 906a7a0c-3ae6-42e6-be62-89d504c348ba
md"""
## The magic
"""

# ╔═╡ 70f18bbf-c933-4017-a1e4-e4dc84f6e696
const compat_error = HTML("<span>❌ You need to update Pluto to use this PlutoUI element.</span>")

# ╔═╡ 666c938a-87fd-4db2-b4f6-992e3c7ef0d9
begin
	struct TransformedWidget{T}
		x::T
		transform::Function
		get_initial_value::Union{Nothing,Function}
	end

	function Base.show(io::IO, m::MIME"text/html", tw::TransformedWidget)
		supported = AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.transform_value) && AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.initial_value)
		
		return Base.show(io, m, supported ? tw.x : compat_error)
	end

	# AbstractPlutoDingetjes.jl
	
	function Bonds.transform_value(tw::TransformedWidget, from_js)
		tw.transform(Bonds.transform_value(tw.x, from_js))
	end

	function Bonds.initial_value(tw::TransformedWidget)
		if tw.get_initial_value !== nothing
			tw.get_initial_value()
		else
			child_initial_value = Bonds.initial_value(tw.x)
			if child_initial_value === missing
				missing
			else
				try
					tw.transform(child_initial_value)
				catch e
					@warn "`PlutoUI.transformed_value`: Failed to apply my transform function to the initial value of my contained element." child_initial_value exception=(e,catch_backtrace())
					missing
				end
			end
		end
	end

	# These next two methods are about the value *before* transformation
	# so the user does not need to define those. Yay!
	Bonds.possible_values(tw::TransformedWidget) = 
		Bonds.possible_values(tw.x)
	
	Bonds.validate_value(tw::TransformedWidget, from_browser) = 
		Bonds.validate_value(tw.x, from_browser)

	TransformedWidget
end

# ╔═╡ 78795f88-46b9-40af-8100-4e05cfaf3b85
"""
```julia
transformed_value(transform::Function, widget::Any)
```

Create a new widget that wraps around an existing one, with a **value transformation**. 

This function creates a so-called *high-level widget*: it returns your existing widget, but with additional functionality. You can use it in your package 

# Example
A simple example to get the point accross:
```julia
function RepeatedTextSlider(text::String)	
	old_widget = PlutoUI.Slider(1:10)

	# our transformation function
	transform = input -> repeat(text, input)
	
	# use `transformed_value` to add the value tranformation to our widget
	new_widget = transformed_value(transform, old_widget)
	return new_widget
end

@bind greeting RepeatedTextSlider("hello")

# moving the slider to the right...

greeting == "hellohellohello"
```

![screenshot of the above code in action](https://user-images.githubusercontent.com/6933510/146782076-a993f50c-de27-4a6b-956d-264a5002bfba.gif)

---

This function is very useful in combination with `PlutoUI.combine`. Let's enhance our previous example by **adding a text box** where the repeated text can be entered. If you have not used `PlutoUI.combine` yet, you should read about that first.

```julia
function RepeatedTextSlider()
	old_widget = PlutoUI.combine() do Child
		md""\" \$(Child(PlutoUI.TextField())) \$(Child(PlutoUI.Slider(1:10)))""\"
	end
	
	# Note that the input to `transform` is now a Tuple!
	# (This is the output of `PlutoUI.combine`)
	transform = input -> repeat(input[1], input[2])

	# use `transformed_value` to add the value tranformation to our widget
	new_widget = transformed_value(transform, old_widget)
	return new_widget
end
```

![screenshot of the above code in action](https://user-images.githubusercontent.com/6933510/146782947-45d67770-03fe-4cf7-82ce-0b9f877688f4.gif)

"""
function transformed_value(f::Function, x::Any; get_initial_value::Union{Nothing,Function}=nothing)
	TransformedWidget(
		x,
		f,
		get_initial_value
	)
end

# ╔═╡ 22109e0c-1815-4b70-9f8c-182b8fe186ea
@skip_as_script function RepeatedTextSlider(text::String)	
	old_widget = PlutoUI.Slider(1:10)

	# our transformation function
	transform = input -> repeat(text, input)
	
	# use `transformed_value` to add the value tranformation to our widget
	new_widget = transformed_value(transform, old_widget)
	return new_widget
end

# ╔═╡ 99df4d14-4fa3-47f1-a002-047d1be18e27
@skip_as_script function RepeatedTextSlider()
	old_widget = PlutoUI.combine() do Child
		md""" $(Child(PlutoUI.TextField())) $(Child(PlutoUI.Slider(1:10)))"""
	end
	
	# Note that the input to `transform` is now a Tuple!
	# (This is the output of `PlutoUI.combine`)
	transform = input -> repeat(input[1], input[2])

	# use `transformed_value` to add the value tranformation to our widget
	new_widget = transformed_value(transform, old_widget)
	return new_widget
end

# ╔═╡ 7d449272-2e96-418a-80a8-50479cefea7c
@skip_as_script @bind greeting RepeatedTextSlider("hello")

# ╔═╡ 3ab47131-fa65-4e6b-8205-b11620795bfc
@skip_as_script greeting

# ╔═╡ 22004433-904a-42ae-8407-db87a6417389
@skip_as_script @bind custom_greeting RepeatedTextSlider()

# ╔═╡ aecc84f8-3024-4441-ae00-ca1c00db72c0
@skip_as_script custom_greeting

# ╔═╡ Cell order:
# ╟─ea9b4e8b-cfc1-4177-bd3e-45608aca9398
# ╟─4d94fbcd-f53f-4a90-b01c-f4dbe83313d1
# ╟─460e57a6-d40e-4892-a945-55b03141b1d7
# ╟─f85cb5fc-246d-46a1-9875-9c06b7f102d6
# ╠═b88673ff-30b2-4aca-b0d1-b55a1cd393e7
# ╠═b230e180-8e51-4490-8c3e-66a8829a3b7e
# ╠═eab272db-413a-44e4-9c07-b1c1b96e9a5c
# ╟─80906b18-59b2-4fdf-ba8b-e8080da7066e
# ╟─36ff1ff5-cd12-4d66-835b-2b1a6aa9020d
# ╠═22109e0c-1815-4b70-9f8c-182b8fe186ea
# ╠═7d449272-2e96-418a-80a8-50479cefea7c
# ╠═3ab47131-fa65-4e6b-8205-b11620795bfc
# ╠═99df4d14-4fa3-47f1-a002-047d1be18e27
# ╠═22004433-904a-42ae-8407-db87a6417389
# ╠═aecc84f8-3024-4441-ae00-ca1c00db72c0
# ╟─906a7a0c-3ae6-42e6-be62-89d504c348ba
# ╠═78795f88-46b9-40af-8100-4e05cfaf3b85
# ╠═666c938a-87fd-4db2-b4f6-992e3c7ef0d9
# ╟─70f18bbf-c933-4017-a1e4-e4dc84f6e696
