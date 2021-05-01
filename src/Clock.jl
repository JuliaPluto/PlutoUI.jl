### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ e7a070ab-67e7-444b-88d8-87c14aaef046
names(@__MODULE__)

# ╔═╡ b1491ca6-f791-41d8-96b5-28971084f34c


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
	
	function Base.show(io::IO, ::MIME"text/html", clock::Clock)
		clock.interval < 0 && error("interval must be non-negative")
	    # We split the HTML string into multiple files, but you could also write all of this into a single (long) string 🎈
		cb = read(joinpath(@__DIR__, "..", "assets", "clock_back.svg"), String)
		cf = read(joinpath(@__DIR__, "..", "assets", "clock_front.svg"), String)
		cz = read(joinpath(@__DIR__, "..", "assets", "clock_zoof.svg"), String)
		js = read(joinpath(@__DIR__, "..", "assets", "clock.js"), String)
		css = read(joinpath(@__DIR__, "..", "assets", "clock.css"), String)
		
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
end

# ╔═╡ 06289ad2-9e2f-45b3-9d15-7c5a4167e138
@bind tick Clock()

# ╔═╡ 9ecd95f0-d7a5-4ee9-9e18-9d87e5d43ab7
tick; rand()

# ╔═╡ d82dae11-b2c6-42b5-8c52-67fbb6cc236a
tick

# ╔═╡ 80c6e80e-077a-4e31-9467-788a8c437bfc
@bind fasttick Clock(0.001, max_value=1000)

# ╔═╡ 63854404-e6a5-4dc6-a40e-b09b9f531465
fasttick

# ╔═╡ a5f8ed96-136c-4ff4-8275-bd569f0dae40
md"""
## Different constructors
"""

# ╔═╡ c3c07db2-bb9c-4521-83ab-e81fbb376b4e
Clock(3.0)

# ╔═╡ 83a021ab-7cca-47c7-a560-9cbf58b35ab7
Clock(3.0, true)

# ╔═╡ c96dfd13-ddd4-443f-ab09-30e15ea76785
Clock(3.0, true, true)

# ╔═╡ 78ee5465-ce3b-45f6-acec-aa69175807f5
Clock(3.0, true, true, 5)

# ╔═╡ 9115fbcd-1550-4439-a830-c69b83b774b3
Clock()

# ╔═╡ f4104cb3-7c07-4814-99f9-a00764ebadf6
@assert try
	
	# this should error:
	repr(MIME"text/html"(), Clock(-5))
	
	false
catch
	true
end

# ╔═╡ 21cba3fb-7bb0-43ae-b4c4-5c1eb7241fec
Clock(2.0, max_value=123)

# ╔═╡ Cell order:
# ╠═06289ad2-9e2f-45b3-9d15-7c5a4167e138
# ╠═9ecd95f0-d7a5-4ee9-9e18-9d87e5d43ab7
# ╠═d82dae11-b2c6-42b5-8c52-67fbb6cc236a
# ╠═80c6e80e-077a-4e31-9467-788a8c437bfc
# ╠═63854404-e6a5-4dc6-a40e-b09b9f531465
# ╠═e7a070ab-67e7-444b-88d8-87c14aaef046
# ╠═b1491ca6-f791-41d8-96b5-28971084f34c
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
