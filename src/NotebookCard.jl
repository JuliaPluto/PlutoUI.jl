### A Pluto.jl notebook ###
# v0.20.9

using Markdown
using InteractiveUtils

# ╔═╡ 1a3f2d74-4a9d-11f0-01a5-7db63f85481f
using HypertextLiteral

# ╔═╡ 52147b93-5178-4041-aabd-5ffc629ad191


# ╔═╡ 97b04c4e-d9a7-4862-98e0-ad7b36e85181
import JSON

# ╔═╡ 3da3063a-a99c-4db9-8f94-796104ecddfd
import Downloads

# ╔═╡ 74ee1aef-defb-41d0-85ab-40a76481b3dc
function downloads_get(args...; kwargs...)
	local resp
	s = sprint() do io
		resp = Downloads.request(args...; kwargs..., output=io, throw=false)
	end
	s, resp
end

# ╔═╡ 2182628d-2ce5-4486-8dd3-ddf52694b5bc
import URIs

# ╔═╡ 1eda68a2-cef6-4f58-a7d0-068a731ae8b8
function find_root_json(notebook_html_url)
	url = URIs.URI(notebook_html_url)
	path_parts = split(url.path, "/")
	for i in eachindex(path_parts)
		newpath = join([path_parts[begin:i]..., "pluto_export.json"], "/")
		newurl = URIs.URI(url; path=newpath)

		htmlpath_relative = join(path_parts[i+1:end], "/")

		data, resp = downloads_get(string(newurl))
		
		if resp.status ∈ 200:299
			data_parsed = JSON.parse(data)
			nbs = data_parsed["notebooks"]

			clean(x) = replace(lowercase(x), r"(index)?\.html$" => "")
			matches_html = filter(nbs) do (_jl, nbdata)
				clean(URIs.escapepath(nbdata["html_path"])) == clean(htmlpath_relative)
			end

			if length(matches_html) == 0
				error("The `pluto_export.json` was found, but this notebook does not appear in the json file. Weird! Are you sure that the notebook URL is correct?")
			end

			jlpath_relative = only(keys(matches_html))
			notebook_data = only(values(matches_html))
			
			return (
				json_url=newurl,
				json_data=data_parsed,
				htmlpath_relative,
				jlpath_relative,
				notebook_data,
			)
		end
	end
	error("Not found. Are you sure that this website is generated with PlutoSliderServer or PlutoPages?")
end

# ╔═╡ 6f8c5856-bf1a-4aa8-b9e1-fe58fb11f811
const white_svg_uri = """data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='100' height='100'><rect width='100%' height='100%' fill='white'/></svg>"""

# ╔═╡ ececef64-34d7-4697-ad13-0e014d8fa1fa
"""
```julia
NotebookCard(notebook_url::String; [link_text::String])
```

Create a nice-looking card to showcase another notebook. You can use this to create a link to a notebook that stands out clearly in your document.

This only works for notebooks hosted on websites that are generated with PlutoPages.jl or PlutoSliderServer.jl. Support for pluto.land notebooks can be added upon [request](https://github.com/JuliaPluto/PlutoUI.jl/issues).

The `notebook_url` argument should be the **public URL** where users can read the notebook. If you are working on a (course) website, go to your website, and just copy the URL of the web page that you want to link to. You can add a `#hash` subsection at the end of the URL if you wish.

# Frontmatter
The image, title and description will be taken from notebook frontmatter (of the notebook you are linking to). You can edit frontmatter of that notebook using Pluto's [built-in frontmatter editor](https://github.com/fonsp/Pluto.jl/pull/2104).

# Example
Here is an example card, linking to a page in the Pluto documentation website (generated with PlutoPages.jl):

```julia
NotebookCard("https://plutojl.org/en/docs/expressionexplorer/")
```

This is what it looks like in a notebook:

![Screenshot of the card in a notebook](https://imgur.com/tTtRkR7.png)

"""
function NotebookCard(notebook_url; link_text = "Read article")
	if URIs.URI(notebook_url).host == "pluto.land"
		error("Displaying cards for pluto.land notebooks is not yet supported!")
	end
	href = notebook_url
	json_result = try
		find_root_json(href)
	catch
		@error "This only works for notebooks hosted on websites that are generated with PlutoPages.jl or PlutoSliderServer.jl."
		rethrow()
	end
	frontmatter = let
		json_result.notebook_data["frontmatter"]
	end

	
	image_url = get(frontmatter, "image", white_svg_uri)
	title = get(frontmatter, "title", nothing)
	description = get(frontmatter, "description", nothing)
	
	
	@htl(
	"""
	<div class="pe-container">
		<div class="pe-card">
			<a href=$href aria-hidden="true"><img src=$image_url></a>
			<div class="pe-right">
				<div class="pe-about">
					<h2>$title</h2>
					<p>$description</p>
				</div>
				<div class="pe-nav">
					<a href=$href>$link_text →</a>
				</div>
			</div>
		</div>
	
		<script>
			const json_url = $(json_result.json_url |> string)
			const jlpath_relative = $(json_result.jlpath_relative)
	
			const json_data = await (await fetch(json_url)).json()
			console.log(json_data)
	
			const frontmatter = json_data.notebooks[jlpath_relative].frontmatter
			console.log(frontmatter)
	
			const q = sel => currentScript.parentElement.querySelector(".pe-card").querySelector(sel)
	
			q("a img").src = frontmatter.image ?? $white_svg_uri
			q(".pe-about h2").innerText = frontmatter.title
			q(".pe-about p").innerText = frontmatter.description
		</script>
	
		<style>

			.pe-container {
				container-type: inline-size;
			}
			
			.pe-card {
				display: flex;
				flex-direction: row;
    			max-width: 700px;
	
				border-radius: 6px;
				background: salmon;
	      background: linear-gradient(80deg, #e9dbe3, #ffdabe);
	    padding: 10px;
	    gap: 20px;
	    margin: 10px 0;
	    box-shadow: 0 2px 10px rgb(0 0 0 / 14%);

			}

			@container (max-width: 400px) {
			  .pe-card {
				  flex-direction: column;
				  gap: 0;
			  }
			.pe-about {
				margin: 0 10px 10px 10px;
			}
			}
	
			.pe-card > a {
				overflow: hidden;
				border-radius: 5px;
	
				flex: 0 0 35%;
			    aspect-ratio: 3 / 2;
			}
			
			.pe-card > a > img {
				height: 100%;
				width: 100%;
				
			    object-fit: cover;
			}
	
			div.pe-about :is(p, h2) {
				color: black;
				text-decoration: none;
				border-bottom: none;
				margin-block-end: 0;
			}
			div.pe-about h2 {
			}
	
			.pe-right {
				flex: 1 1 auto;
				display: flex;
				flex-direction: column;
				justify-content: space-between;
			}
	
			.pe-nav {
				display: flex;
				flex-direction: row;
				justify-content: flex-end;
			}
	
			.pe-nav a {
				text-decoration: none;
				font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Cantarell, "Apple Color Emoji", "Segoe UI Emoji",
	        "Segoe UI Symbol", system-ui, sans-serif;
				font-weight: 700;
				background: white;
				color: black;
				padding: 8px 14px;
				border-radius: 1000px;
			}
		</style>
	</div>
	""")
end

# ╔═╡ 5fc71edf-9959-43f0-b7ca-9eab85b80485
export NotebookCard

# ╔═╡ 96cd7388-02f6-4d59-9243-83c48c8b6098
# ╠═╡ skip_as_script = true
#=╠═╡
NotebookCard("https://plutojl.org/en/docs/expressionexplorer/")
  ╠═╡ =#

# ╔═╡ b504b24e-dd50-4f49-9756-f4cd5c7b7934
# ╠═╡ skip_as_script = true
#=╠═╡
NotebookCard("https://featured.plutojl.org/basic/basic%20mathematics"; link_text="Yes I want pizzaaa")
  ╠═╡ =#

# ╔═╡ a78fd4f9-c671-4e50-af4b-c7b1b3c5db40
# ╠═╡ skip_as_script = true
#=╠═╡
NotebookCard("https://pluto.land/n/cibk2zp8")
  ╠═╡ =#

# ╔═╡ 5aa2e75b-86c8-420f-a35e-7463031b45bd
# ╠═╡ skip_as_script = true
#=╠═╡
@htl "<img src=$white_svg_uri >"
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
URIs = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"

[compat]
HypertextLiteral = "~0.9.5"
JSON = "~0.21.4"
URIs = "~1.5.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.9"
manifest_format = "2.0"
project_hash = "9032b5d55a17c263eedc82b9e91ed00863a30db8"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"
"""

# ╔═╡ Cell order:
# ╠═5fc71edf-9959-43f0-b7ca-9eab85b80485
# ╠═96cd7388-02f6-4d59-9243-83c48c8b6098
# ╠═b504b24e-dd50-4f49-9756-f4cd5c7b7934
# ╠═a78fd4f9-c671-4e50-af4b-c7b1b3c5db40
# ╟─52147b93-5178-4041-aabd-5ffc629ad191
# ╠═ececef64-34d7-4697-ad13-0e014d8fa1fa
# ╟─74ee1aef-defb-41d0-85ab-40a76481b3dc
# ╟─1eda68a2-cef6-4f58-a7d0-068a731ae8b8
# ╠═1a3f2d74-4a9d-11f0-01a5-7db63f85481f
# ╠═97b04c4e-d9a7-4862-98e0-ad7b36e85181
# ╠═3da3063a-a99c-4db9-8f94-796104ecddfd
# ╠═2182628d-2ce5-4486-8dd3-ddf52694b5bc
# ╠═6f8c5856-bf1a-4aa8-b9e1-fe58fb11f811
# ╠═5aa2e75b-86c8-420f-a35e-7463031b45bd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
