### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ 77abe3d8-bf1e-11f0-09fd-bfc6848520cd
begin
	using AbstractPlutoDingetjes.Bonds
	local result = begin
	struct Toggle
		default::Bool
	end
	end
	
	Toggle(;default::Bool=false) = Toggle(default)
	
	function Base.show(io::IO, ::MIME"text/html", button::Toggle)
		print(io, """<input type="checkbox" $(button.default ? "checked" : "") class=pui-toggle><style>
		.pui-toggle {
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
		.pui-toggle:checked {
			background: #4caf50;
		}
		.pui-toggle::before {
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
		.pui-toggle:checked::before {
			transform: translateX(calc(var(--width) - var(--height)));
		}
		</style>""")
	end
	
	Bonds.initial_value(b::Toggle) = b.default
	Bonds.possible_values(b::Toggle) = [false, true]
	function Bonds.validate_value(b::Toggle, val)
		val isa Bool
	end

	result
end

# ╔═╡ f6bd1df9-29b4-4ecc-85eb-72f3094e24f2
# ╠═╡ skip_as_script = true
#=╠═╡
# @bind toggle Toggle()
  ╠═╡ =#

# ╔═╡ 3ef7cf6a-c90e-429d-bdf1-003b4fc31817
export Toggle

# ╔═╡ 153d8eca-4304-4093-b521-51ee0c6a2f84
# ╠═╡ skip_as_script = true
#=╠═╡
tb = @bind toggle Toggle(; default=true)
  ╠═╡ =#

# ╔═╡ 14b5ceca-958e-496c-837d-da9de1f6acce
# ╠═╡ skip_as_script = true
#=╠═╡
tb
  ╠═╡ =#

# ╔═╡ 45b20caf-8b61-4cef-89c2-cc73e8bd24e4
# ╠═╡ skip_as_script = true
#=╠═╡
tb2 = @bind toggle2 Toggle()
  ╠═╡ =#

# ╔═╡ 7fadfd9b-9c82-41a6-80f0-217d8d2242e6
#=╠═╡
md"""
Iterate over the elements of the following matrix and multiply them with their row and column index. Return the sum of these multiplications. You can implement this in any way you Turn on $tb2 and $(tb2)? Also check out: Iterate over the elements of the following matrix and multiply them with their row and column index. Return the sum of these multiplications. You can implement this in any way you

$tb2

# Header toggle $tb2
"""
  ╠═╡ =#

# ╔═╡ 28ebe177-2016-4613-93ea-d879000b5969
# ╠═╡ skip_as_script = true
#=╠═╡
toggle
  ╠═╡ =#

# ╔═╡ 4af02c27-4707-4618-9676-02897ea53ae0
# ╠═╡ skip_as_script = true
#=╠═╡

  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"

[compat]
AbstractPlutoDingetjes = "~1.3.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "b0d6284657a06218615530676a0bdf9fa2ce8cf1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═f6bd1df9-29b4-4ecc-85eb-72f3094e24f2
# ╠═3ef7cf6a-c90e-429d-bdf1-003b4fc31817
# ╠═153d8eca-4304-4093-b521-51ee0c6a2f84
# ╠═14b5ceca-958e-496c-837d-da9de1f6acce
# ╠═45b20caf-8b61-4cef-89c2-cc73e8bd24e4
# ╠═7fadfd9b-9c82-41a6-80f0-217d8d2242e6
# ╠═28ebe177-2016-4613-93ea-d879000b5969
# ╠═77abe3d8-bf1e-11f0-09fd-bfc6848520cd
# ╠═4af02c27-4707-4618-9676-02897ea53ae0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
