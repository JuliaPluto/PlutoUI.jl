### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 1a3f2d74-4a9d-11f0-01a5-7db63f85481f
using HypertextLiteral

# ╔═╡ 52147b93-5178-4041-aabd-5ffc629ad191


# ╔═╡ 6f8c5856-bf1a-4aa8-b9e1-fe58fb11f811
const white_svg_uri = """data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='100' height='100'><rect width='100%' height='100%' fill='ivory'/></svg>"""

# ╔═╡ ececef64-34d7-4697-ad13-0e014d8fa1fa
"""
```julia
NotebookCard(notebook_url::String; [link_text::String])
```

Create a nice-looking card to showcase another notebook. You can use this to create a link to a notebook that stands out clearly in your document.

This only works for notebooks hosted on websites that are generated with PlutoPages.jl or PlutoSliderServer.jl. Support for pluto.land notebooks can be added upon [request](https://github.com/JuliaPluto/PlutoUI.jl/issues).

The `notebook_url` argument should be the **public URL** where users can read the notebook. If you are working on a (course) website, go to your website, and just copy the URL of the web page that you want to link to. You can add a `#hash` subsection at the end of the URL if you wish.

# Frontmatter
The image, title and description will be taken from notebook frontmatter (of the notebook you are linking to). You can edit frontmatter of that notebook using Pluto's [built-in frontmatter editor](https://plutojl.org/en/docs/frontmatter/).

# Example
Here is an example card, linking to a page in the Pluto documentation website (generated with PlutoPages.jl):

```julia
NotebookCard("https://plutojl.org/en/docs/expressionexplorer/")
```

This is what it looks like in a notebook:

![Screenshot of the card in a notebook](https://imgur.com/tTtRkR7.png)

"""
function NotebookCard(notebook_url; link_text = "Read article")
	if !startswith(notebook_url, r"https?://")
		throw(ArgumentError("Notebook URL should start with https://"))
	end
	href = notebook_url
	
	# Initial placeholder values - will be replaced by JavaScript
	image_url = white_svg_uri
	title = "Loading..."
	description = ""
	
	
	@htl(
	"""<div class="pe-container">
	<div class="pe-card">
		<a href=$href aria-hidden="true"><img src=$image_url></a>
		<div class="pe-right">
			<div class="pe-about">
				<h2 class="no-toc">$title</h2>
				<p>$description</p>
			</div>
			<div class="pe-nav">
				<a href=$href>$link_text →</a>
			</div>
		</div>
	</div>

	<script>
		const notebook_html_url = $(href)
		const white_svg_uri = $white_svg_uri

		const html_data = await fetch(notebook_html_url).then(r => r.text()).catch(e => "")
		const doc = new DOMParser().parseFromString(html_data, "text/html");
		const head = doc.head

		console.log({doc, notebook_html_url})
		const q = sel => currentScript.parentElement.querySelector(".pe-card").querySelector(sel)

		q("a img").src = head.querySelector('meta[property="og:image"]')?.content ??
			white_svg_uri
		
		q(".pe-about h2").innerText = (doc.title == "" ? null : doc.title) ?? 
			new URL(notebook_html_url).pathname.split("/").map(decodeURIComponent).toReversed().find(s => s) ??
			"Notebook"
		
		q(".pe-about p").innerText = head.querySelector('meta[name="description"]')?.content ?? 
			""
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
	</div>""")
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
NotebookCard("http://pluto.land/n/cibk2zp8")
  ╠═╡ =#

# ╔═╡ dffaee00-8d1c-42ba-96ea-01d153c30660
# ╠═╡ skip_as_script = true
#=╠═╡
try
	NotebookCard("pluto.land/n/cibk2zp8")
catch e
	"yay", e
end
  ╠═╡ =#

# ╔═╡ 0a56a6cc-cbf3-4dd6-bfaa-8ab242ef4012
# ╠═╡ skip_as_script = true
#=╠═╡
NotebookCard("https://asdf.com")
  ╠═╡ =#

# ╔═╡ 5aa2e75b-86c8-420f-a35e-7463031b45bd
# ╠═╡ skip_as_script = true
#=╠═╡
@htl "<img src=$white_svg_uri >"
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.2"
manifest_format = "2.0"
project_hash = "de8c559f3dd69bd823c8bc954861ad3089248731"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"
"""

# ╔═╡ Cell order:
# ╠═5fc71edf-9959-43f0-b7ca-9eab85b80485
# ╠═96cd7388-02f6-4d59-9243-83c48c8b6098
# ╠═b504b24e-dd50-4f49-9756-f4cd5c7b7934
# ╠═a78fd4f9-c671-4e50-af4b-c7b1b3c5db40
# ╠═dffaee00-8d1c-42ba-96ea-01d153c30660
# ╠═0a56a6cc-cbf3-4dd6-bfaa-8ab242ef4012
# ╟─52147b93-5178-4041-aabd-5ffc629ad191
# ╠═ececef64-34d7-4697-ad13-0e014d8fa1fa
# ╠═1a3f2d74-4a9d-11f0-01a5-7db63f85481f
# ╠═6f8c5856-bf1a-4aa8-b9e1-fe58fb11f811
# ╠═5aa2e75b-86c8-420f-a35e-7463031b45bd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
