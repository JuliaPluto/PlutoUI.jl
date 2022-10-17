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

# ╔═╡ 3689bb1b-23f8-41ae-a392-fb2ee2ec40d7
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
end
  ╠═╡ =#

# ╔═╡ e7a070ab-67e7-444b-88d8-87c14aaef046
# ╠═╡ skip_as_script = true
#=╠═╡
names(@__MODULE__)
  ╠═╡ =#

# ╔═╡ fed9022f-1e8e-4f47-92d8-f99065023d29
import AbstractPlutoDingetjes.Bonds

# ╔═╡ 05804305-cb1f-4c97-8937-f56289222bd7
md"""
Rerun the big cell after you edit one of the JS/CSS assets.
"""

# ╔═╡ 9be4d586-76d8-11eb-06ed-c53d3aef0469
begin
	export Clock
	
	Base.@kwdef struct Clock
		interval::Real = 1
		fixed::Bool = false
		start_running::Bool = false
		max_value::Union{Int64,Nothing} = nothing
		
		# Clock(interval, fixed, start_running, max_value) = interval >= 0 ? new(interval, fixed, start_running, max_value) : error("interval must be non-negative")
	end
	
	# for backwards compat
	Clock(interval; kwargs...) = Clock(interval=interval; kwargs...)

	Clock(interval, fixed, start_running=false) = Clock(interval, fixed, start_running, nothing)
	
	# We split the HTML string into multiple files, but you could also write all of this into a single (long) string 🎈
	const cb = read(joinpath(@__DIR__, "..", "assets", "clock_back.svg"), String)
	const cf = read(joinpath(@__DIR__, "..", "assets", "clock_front.svg"), String)
	const cz = read(joinpath(@__DIR__, "..", "assets", "clock_zoof.svg"), String)
	const js = read(joinpath(@__DIR__, "..", "assets", "clock.js"), String)
	const css = read(joinpath(@__DIR__, "..", "assets", "clock.css"), String)
	
	function Base.show(io::IO, ::MIME"text/html", clock::Clock)
		clock.interval < 0 && error("interval must be non-negative")
		
		result = """
		<plutoui-clock class='$(clock.fixed ? " fixed" : "")$(clock.start_running ? "" : " stopped")' data-max-value=$(repr(clock.max_value))>
			<plutoui-analog>
				<plutoui-back>$(cb)</plutoui-back>
				<plutoui-front>$(cf)</plutoui-front>
				<plutoui-zoof style="opacity: 0">$(cz)</plutoui-zoof>
			</plutoui-analog>
			<button></button>
			<span>speed: </span>
			<input type="number" value="$(clock.interval)"  min=0 step=any lang="en-001">
			<span id="unit" title="Click to invert"></span>
		</plutoui-clock>
		<script>
			$(js)
		</script>
		<style>
			$(css)
		</style>
	    """
	    write(io, result)
	end
	
	Base.get(clock::Clock) = 1
	Bonds.initial_value(c::Clock) = 1
	Bonds.possible_values(c::Clock) = 
		c.max_value === nothing ? 
			Bonds.InfinitePossibilities() :
			1:c.max_value
	function Bonds.validate_value(c::Clock, val)
		val isa Integer && 1 <= val && (c.max_value === nothing || val <= c.max_value)
	end
end

# ╔═╡ 06289ad2-9e2f-45b3-9d15-7c5a4167e138
# ╠═╡ skip_as_script = true
#=╠═╡
@bind tick Clock()
  ╠═╡ =#

# ╔═╡ 9ecd95f0-d7a5-4ee9-9e18-9d87e5d43ab7
#=╠═╡
tick; rand()
  ╠═╡ =#

# ╔═╡ d82dae11-b2c6-42b5-8c52-67fbb6cc236a
#=╠═╡
tick
  ╠═╡ =#

# ╔═╡ 80c6e80e-077a-4e31-9467-788a8c437bfc
# ╠═╡ skip_as_script = true
#=╠═╡
@bind fasttick Clock(0.001, max_value=1000)
  ╠═╡ =#

# ╔═╡ 63854404-e6a5-4dc6-a40e-b09b9f531465
#=╠═╡
fasttick
  ╠═╡ =#

# ╔═╡ a5f8ed96-136c-4ff4-8275-bd569f0dae40
md"""
## Different constructors
"""

# ╔═╡ c3c07db2-bb9c-4521-83ab-e81fbb376b4e
# ╠═╡ skip_as_script = true
#=╠═╡
Clock(3.0)
  ╠═╡ =#

# ╔═╡ 83a021ab-7cca-47c7-a560-9cbf58b35ab7
# ╠═╡ skip_as_script = true
#=╠═╡
Clock(3.0, true)
  ╠═╡ =#

# ╔═╡ c96dfd13-ddd4-443f-ab09-30e15ea76785
# ╠═╡ skip_as_script = true
#=╠═╡
Clock(3.0, true, true)
  ╠═╡ =#

# ╔═╡ 78ee5465-ce3b-45f6-acec-aa69175807f5
# ╠═╡ skip_as_script = true
#=╠═╡
Clock(3.0, true, true, 5)
  ╠═╡ =#

# ╔═╡ 9115fbcd-1550-4439-a830-c69b83b774b3
# ╠═╡ skip_as_script = true
#=╠═╡
Clock()
  ╠═╡ =#

# ╔═╡ f4104cb3-7c07-4814-99f9-a00764ebadf6
# ╠═╡ skip_as_script = true
#=╠═╡
@assert try
	
	# this should error:
	repr(MIME"text/html"(), Clock(-5))
	
	false
catch
	true
end
  ╠═╡ =#

# ╔═╡ 21cba3fb-7bb0-43ae-b4c4-5c1eb7241fec
# ╠═╡ skip_as_script = true
#=╠═╡
Clock(2.0, max_value=123)
  ╠═╡ =#

# ╔═╡ 9ece9332-0e36-4f4a-aefb-5e793dbe080a
# ╠═╡ skip_as_script = true
#=╠═╡
@bind a Clock()
  ╠═╡ =#

# ╔═╡ 1459d85a-aecd-4eae-8074-f93c65f500a2
#=╠═╡
a
  ╠═╡ =#

# ╔═╡ Cell order:
# ╠═06289ad2-9e2f-45b3-9d15-7c5a4167e138
# ╠═9ecd95f0-d7a5-4ee9-9e18-9d87e5d43ab7
# ╠═d82dae11-b2c6-42b5-8c52-67fbb6cc236a
# ╠═80c6e80e-077a-4e31-9467-788a8c437bfc
# ╠═63854404-e6a5-4dc6-a40e-b09b9f531465
# ╠═e7a070ab-67e7-444b-88d8-87c14aaef046
# ╠═3689bb1b-23f8-41ae-a392-fb2ee2ec40d7
# ╠═fed9022f-1e8e-4f47-92d8-f99065023d29
# ╟─05804305-cb1f-4c97-8937-f56289222bd7
# ╠═9be4d586-76d8-11eb-06ed-c53d3aef0469
# ╟─a5f8ed96-136c-4ff4-8275-bd569f0dae40
# ╠═c3c07db2-bb9c-4521-83ab-e81fbb376b4e
# ╠═83a021ab-7cca-47c7-a560-9cbf58b35ab7
# ╠═c96dfd13-ddd4-443f-ab09-30e15ea76785
# ╠═78ee5465-ce3b-45f6-acec-aa69175807f5
# ╠═9115fbcd-1550-4439-a830-c69b83b774b3
# ╠═f4104cb3-7c07-4814-99f9-a00764ebadf6
# ╠═21cba3fb-7bb0-43ae-b4c4-5c1eb7241fec
# ╠═9ece9332-0e36-4f4a-aefb-5e793dbe080a
# ╠═1459d85a-aecd-4eae-8074-f93c65f500a2
