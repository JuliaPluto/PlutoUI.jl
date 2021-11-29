### A Pluto.jl notebook ###
# v0.17.2

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

# ╔═╡ aab79d69-3435-48be-a8c2-752b55867468
using HypertextLiteral

# ╔═╡ d1db2fc1-f465-49e3-b6a7-848137c8948d
md"""
## Basic examples
"""

# ╔═╡ ce83a3d3-ed13-4b0a-80a4-a27f45c49b67


# ╔═╡ 0ebaa1fe-9eea-4c5e-9f3e-9498fefa2869
1:20 ⊆ 0:.2:30

# ╔═╡ 63998497-5fcf-440e-9e2b-d138f0bffbfe


# ╔═╡ 5e6f075e-9719-4ee3-9841-99a153f1f83b
md"""
The range is exact: you can even use rational numbers!
"""

# ╔═╡ 2576d239-2252-48ee-8999-8a3ee2b70a98
md"""
## Alignment
"""

# ╔═╡ eeed3ebd-0431-4fbe-8f1e-09f14df2f87e
import AbstractPlutoDingetjes

# ╔═╡ 2a7d7469-270d-4165-b167-e1dbeb0a9598
const show_compat_warning_ref = Ref{Bool}(false)

# ╔═╡ 8ac624df-306f-4a87-b25a-eb8cd9d1f30b
function closest(range::AbstractRange, x::Real)
	rmin = minimum(range)
	rmax = maximum(range)

	if x <= rmin
		rmin
	elseif x >= rmax
		rmax
	else
		rstep = step(range)

		int_val = (x - rmin) / rstep
		range[round(Int, int_val) + 1]
	end
end

# ╔═╡ 34553132-0392-45a2-8d6d-3c8c2252d01f
begin
	struct RangeSlider
		range::AbstractRange{<:Real}
		show_value::Bool
		default::AbstractRange

		RangeSlider(range::AbstractRange; 
				default::AbstractRange=range, 
				show_value::Bool=true,
				# for compat
				left=nothing,
				right=nothing,
			) = let
			
			if show_compat_warning_ref[] && (left !== nothing || right !== nothing)
				@warn "Compat: The keyword arguments `left` and `right` will be removed in the future, use the `default` keyword argument instead."
			end
			start = something(left, minimum(default))
			stop = something(right, maximum(default))

			default = start:step(range):stop
			
			@assert default ⊆ range "The default range is not a subset of the slidable range. Verify that the beginning and end of the default range are inside the slidable range."
			new(range, show_value, default)
		end
	end


	function Base.show(io, m::MIME"text/html", rs::RangeSlider)
		if !AbstractPlutoDingetjes.is_supported_by_display(io, AbstractPlutoDingetjes.Bonds.transform_value)
			write(io, "❌ Update Pluto to use this element.")
			return
		end
		show(io, m, @htl("""
		<span><link 
			href="https://cdn.jsdelivr.net/npm/nouislider@15.5.0/dist/nouislider.css" rel="stylesheet"/><style>
		.plutoui-rangeslider .noUi-connect {
			background: #0075ff;
		}
		
		.plutoui-rangeslider.noUi-horizontal {
			height: 10px;
		}
		
		.plutoui-rangeslider.noUi-horizontal .noUi-handle {
			width: 19px;
			height: 19px;
    		transform: translateX(-10px);
		}
		
		.plutoui-rangeslider .noUi-handle:before,
		.plutoui-rangeslider .noUi-handle:after {
			content: unset;
		}
		.plutoui-rangeslider.noUi-horizontal .noUi-tooltip {
			line-height: 1rem;
		}
		
		</style><script>
		const {default: noUiSlider} = await import( "https://cdn.jsdelivr.net/npm/nouislider@15.5.0/dist/nouislider.min.mjs")
		const {default: throttle} = await import("https://cdn.jsdelivr.net/npm/lodash-es@4.17.21/throttle.js")

		let show_value = $(rs.show_value)
		const el = html`<div style='
		    display: inline-block;
			font-family: system-ui; 
			font-size: .75rem; 
			min-width: 10rem;
			min-height: 10px;
			margin: \${show_value ? "2.5rem" : "0.5rem"} 1rem .5rem 1rem;
		' class='plutoui-rangeslider'></div>`

		const start = $(Float64(minimum(rs.range)))
		const stop = $(Float64(maximum(rs.range)))
		const step = $(Float64(step(rs.range)))

		let is_integer = Number.isInteger(step) && Number.isInteger(start)
		
		let num_decimals = Math.max(is_integer ? 0 : 1, -1 * Math.floor(Math.log10(step)))
		const formatter = {
		to: x => x.toLocaleString("en-US", { maximumFractionDigits: num_decimals, minimumFractionDigits: num_decimals })
		
		}
		
		const slider = noUiSlider.create(el, {
			start: [$(Float64(minimum(rs.default))), $(Float64(maximum(rs.default)))],
			connect: true,
			range: {
				'min': start,
				'max': stop,
			},
			tooltips: $(rs.show_value) && [formatter, formatter],
			step: step,
		});
		
		// console.log(slider)
		let root = currentScript.parentElement
		
		let busy = false
		slider.on("start", () => {busy = true})
		slider.on("end", () => {busy = false})
		
		let handler = (e) => {
			// console.warn(e, root.value, 123)
			root.dispatchEvent(new CustomEvent("input"))
		}
		
		slider.on("slide", handler)
		slider.on("drag", handler)
		invalidation.then(() => {
			slider.off("slide", handler)
			slider.off("drag", handler)
		})
		
		Object.defineProperty(root, 'value', {
		get: () => slider.get(true),
		set: (newval) => {
			if(!busy) {
				
				slider.set(newval)
			}
		}
		})
		
		
		return el
		</script></span>"""))
	end

	AbstractPlutoDingetjes.Bonds.initial_value(rs::RangeSlider) = rs.default

	function AbstractPlutoDingetjes.Bonds.transform_value(rs::RangeSlider, js_val::Any)
		if js_val isa Vector && length(js_val) == 2
			
			rounded_range = closest.([rs.range], js_val)
			rounded_range[1] : step(rs.range) : rounded_range[2]
		else
			rs.default
		end
	end
	

end

# ╔═╡ 2150eb64-4f79-11ec-1eec-a9db61b6d8f3
export RangeSlider

# ╔═╡ 8c2c225b-d142-451e-9a04-296230b73bf3
zbond = @bind z RangeSlider(0.0:π:100)

# ╔═╡ 891e953e-7f6c-4def-8ba0-91f351c5b283
z

# ╔═╡ 3764fff6-3f77-41dd-91fc-228d00474ab5
zbond

# ╔═╡ 48531527-c8ae-46f2-a6b9-d9056ef583bf
@htl("""<div style='display: flex; flex-direction: row;'>

<input type=range>
<span>asdf</span>
$(zbond)
<input type=range>
""")

# ╔═╡ ecce7dfb-9885-4fda-9ec0-fd4189b7bc06
z

# ╔═╡ ea0bf76f-e51b-471d-b958-d331b3a64bc8
@bind x RangeSlider(1:100; default=6:20, show_value=false)

# ╔═╡ 8da460e7-c1b6-45b0-aa12-5eab97cdcf24
x

# ╔═╡ 8ec7e04b-3c32-4b38-9aa5-38c14b742393
@bind rational RangeSlider(1:1//3:1000)

# ╔═╡ 1e86ff39-8cc2-4dcf-80a9-b0d45a1e7a0e
rational

# ╔═╡ b9066464-d4df-4a2c-82f4-34eaa50bb487
Float64.(rational)

# ╔═╡ c06b7708-f508-40c1-a34c-c64f17f04c74
md"""
Hello world!

Hello world! $(RangeSlider(1:10; show_value=true)) How are you?

Hello world! $(RangeSlider(1:10; show_value=false)) How are you?

Hello world!

Hello world!
"""

# ╔═╡ 128642a9-5f52-4712-b60b-cc7814a2401b
let
	show_compat_warning_ref[] = false
	result = RangeSlider(1:10; right=6), RangeSlider(1:10; left=6), RangeSlider(1:10; left=3, right=6)
	show_compat_warning_ref[] = true
	result
end

# ╔═╡ ab48cd4a-e4c3-4eca-84a1-689e874ce0e4
@bind closest_test html"<input type=range step=0.000001 max=5>"

# ╔═╡ 4f2f6baa-1deb-4132-bfe5-4a6ef1e8ec86
closest_test

# ╔═╡ 0a4bc67c-67e9-4001-a1c1-c079a984215d
closest(2:.3:4, closest_test isa Missing ? 0 : closest_test)

# ╔═╡ ec579632-c508-4ada-8561-1ed26f1a60cc
RangeSlider(0.0:π:100; show_value=false)

# ╔═╡ 18e7f591-1d3e-42da-84d6-bc5350f85535
RangeSlider(0:5:100; default=50:70)

# ╔═╡ f6a97b41-3513-4dc7-b767-d966c682956a
try
	RangeSlider(0:5:100; default=50:200)
catch e
	sprint(showerror, e) |> Text
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
AbstractPlutoDingetjes = "~1.1.1"
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0bc60e3006ad95b4bb7497698dd7c6d649b9bc06"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═2150eb64-4f79-11ec-1eec-a9db61b6d8f3
# ╟─d1db2fc1-f465-49e3-b6a7-848137c8948d
# ╠═8c2c225b-d142-451e-9a04-296230b73bf3
# ╠═891e953e-7f6c-4def-8ba0-91f351c5b283
# ╠═3764fff6-3f77-41dd-91fc-228d00474ab5
# ╟─ce83a3d3-ed13-4b0a-80a4-a27f45c49b67
# ╠═ea0bf76f-e51b-471d-b958-d331b3a64bc8
# ╠═8da460e7-c1b6-45b0-aa12-5eab97cdcf24
# ╠═0ebaa1fe-9eea-4c5e-9f3e-9498fefa2869
# ╟─63998497-5fcf-440e-9e2b-d138f0bffbfe
# ╟─5e6f075e-9719-4ee3-9841-99a153f1f83b
# ╠═8ec7e04b-3c32-4b38-9aa5-38c14b742393
# ╠═1e86ff39-8cc2-4dcf-80a9-b0d45a1e7a0e
# ╠═b9066464-d4df-4a2c-82f4-34eaa50bb487
# ╟─2576d239-2252-48ee-8999-8a3ee2b70a98
# ╠═48531527-c8ae-46f2-a6b9-d9056ef583bf
# ╠═c06b7708-f508-40c1-a34c-c64f17f04c74
# ╠═ecce7dfb-9885-4fda-9ec0-fd4189b7bc06
# ╠═eeed3ebd-0431-4fbe-8f1e-09f14df2f87e
# ╠═aab79d69-3435-48be-a8c2-752b55867468
# ╠═128642a9-5f52-4712-b60b-cc7814a2401b
# ╠═2a7d7469-270d-4165-b167-e1dbeb0a9598
# ╠═34553132-0392-45a2-8d6d-3c8c2252d01f
# ╠═8ac624df-306f-4a87-b25a-eb8cd9d1f30b
# ╠═ab48cd4a-e4c3-4eca-84a1-689e874ce0e4
# ╠═4f2f6baa-1deb-4132-bfe5-4a6ef1e8ec86
# ╠═0a4bc67c-67e9-4001-a1c1-c079a984215d
# ╠═ec579632-c508-4ada-8561-1ed26f1a60cc
# ╠═18e7f591-1d3e-42da-84d6-bc5350f85535
# ╠═f6a97b41-3513-4dc7-b767-d966c682956a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
