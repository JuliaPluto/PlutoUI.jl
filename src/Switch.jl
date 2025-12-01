### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ 34f32ff0-39f4-43d4-bef8-40a5ba7e494c
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
	Text("Project env active")
end
  ╠═╡ =#

# ╔═╡ b49fd16f-8fa5-407b-ab15-70f85800ca21
using AbstractPlutoDingetjes.Bonds

# ╔═╡ f6bd1df9-29b4-4ecc-85eb-72f3094e24f2
# ╠═╡ skip_as_script = true
#=╠═╡
# @bind switch Switch()
  ╠═╡ =#

# ╔═╡ 77abe3d8-bf1e-11f0-09fd-bfc6848520cd
begin
	local result = begin
		"""
		```julia
		Switch(; default::Bool=false)
		```

		A `false`/`true` input element, displayed as a sliding switch. This is the same as [`PlutoUI.CheckBox`](@ref), but with a different visual style.
		"""
		struct Switch
			default::Bool
		end
	end
	
	Switch(;default::Bool=false) = Switch(default)
	
	function Base.show(io::IO, ::MIME"text/html", button::Switch)
		print(io, """<input type="checkbox" $(button.default ? "checked" : "") class=pui-switch><style>
		.pui-switch {
			--width: 2.2em;
			--height: 1em;
			font-size: inherit;
			appearance: none;
			width: var(--width);
			height: var(--height);
			margin: 0;
			background: #ccc;
			border-radius: calc(var(--height) / 2);
			position: relative;
			cursor: pointer;
			transition: background 0.3s;
			vertical-align: -.1em;
		}
		.pui-switch:checked {
			background: #4caf50;
		}
		.pui-switch::before {
			content: "";
			position: absolute;
			--inset: .2em;
			top: var(--inset);
			left: var(--inset);

			width: calc(var(--height) - var(--inset) - var(--inset));
			height: calc(var(--height) - var(--inset) - var(--inset));
			background: white;
			border-radius: 50%;
			transition: transform 0.3s;
		}
		.pui-switch:checked::before {
			transform: translateX(calc(var(--width) - var(--height)));
		}
		</style>""")
	end
	
	Bonds.initial_value(b::Switch) = b.default
	Bonds.possible_values(b::Switch) = [false, true]
	function Bonds.validate_value(b::Switch, val)
		val isa Bool
	end

	result
end

# ╔═╡ 3ef7cf6a-c90e-429d-bdf1-003b4fc31817
export Switch

# ╔═╡ 153d8eca-4304-4093-b521-51ee0c6a2f84
# ╠═╡ skip_as_script = true
#=╠═╡
sb = @bind switch Switch(; default=true)
  ╠═╡ =#

# ╔═╡ 14b5ceca-958e-496c-837d-da9de1f6acce
# ╠═╡ skip_as_script = true
#=╠═╡
sb
  ╠═╡ =#

# ╔═╡ 28ebe177-2016-4613-93ea-d879000b5969
# ╠═╡ skip_as_script = true
#=╠═╡
switch
  ╠═╡ =#

# ╔═╡ 45b20caf-8b61-4cef-89c2-cc73e8bd24e4
# ╠═╡ skip_as_script = true
#=╠═╡
sb2 = @bind switch2 Switch()
  ╠═╡ =#

# ╔═╡ 7fadfd9b-9c82-41a6-80f0-217d8d2242e6
#=╠═╡
md"""
Iterate over the elements of the following matrix and multiply them with their row and column index. Return the sum of these multiplications. You can implement this in any way you Turn on $sb2 and $(sb2)? Also check out: Iterate over the elements of the following matrix and multiply them with their row and column index. Return the sum of these multiplications. You can implement this in any way you

$sb2

# Header switch $sb2
"""
  ╠═╡ =#

# ╔═╡ 4af02c27-4707-4618-9676-02897ea53ae0
# ╠═╡ skip_as_script = true
#=╠═╡

  ╠═╡ =#

# ╔═╡ Cell order:
# ╠═34f32ff0-39f4-43d4-bef8-40a5ba7e494c
# ╠═b49fd16f-8fa5-407b-ab15-70f85800ca21
# ╠═f6bd1df9-29b4-4ecc-85eb-72f3094e24f2
# ╠═3ef7cf6a-c90e-429d-bdf1-003b4fc31817
# ╠═153d8eca-4304-4093-b521-51ee0c6a2f84
# ╠═14b5ceca-958e-496c-837d-da9de1f6acce
# ╠═45b20caf-8b61-4cef-89c2-cc73e8bd24e4
# ╠═7fadfd9b-9c82-41a6-80f0-217d8d2242e6
# ╠═28ebe177-2016-4613-93ea-d879000b5969
# ╠═77abe3d8-bf1e-11f0-09fd-bfc6848520cd
# ╠═4af02c27-4707-4618-9676-02897ea53ae0
