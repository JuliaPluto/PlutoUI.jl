### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 366a853d-3662-445a-940f-09e6e501a92a
using HypertextLiteral

# ╔═╡ ed0f13cc-4f7d-476b-a434-d14313d88eea
using Markdown: withtag

# ╔═╡ 3bf83b12-9932-49cd-83ab-f091e3b5fdb3
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ e3f5cbc5-a443-43d3-b15c-e33e2d655450
if skip_as_script(@__MODULE__)
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Text("Project env active")
end

# ╔═╡ 3061a5a6-feda-4538-8076-30c70c9b8766
import AbstractPlutoDingetjes: AbstractPlutoDingetjes, Bonds

# ╔═╡ 7c32fd56-6cc5-420b-945b-53446833a125
# TableOfContents(; aside = false)

# ╔═╡ 6043d6c5-54e4-40c1-a8a5-aec3ad7e1aa0
md"# asdfsf"

# ╔═╡ 2e749ba7-3469-434d-9011-bb9396ffd149
const p = md"""
Pluto uses syntax analysis to understand which packages are being used in a notebook, and it automatically manages a package environment for your notebook. You no longer need to install packages, you can directly import any registered package like Plots or DataFrames and use it.
"""

# ╔═╡ fb46ccb4-0195-4b5c-9992-dc0d930ea868
md"""
# Julia code
"""

# ╔═╡ c98059f6-2078-46f6-a2ea-4e70c226b2be
md"""
# JS code
"""

# ╔═╡ d6940210-4f9b-47b5-af74-e53700a42417
const toc_js = toc -> @htl """
<script>
const getParentCell = el => el.closest("pluto-cell")

const getHeaders = () => {
	const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
	const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
	
	const selector = range.map(i => `pluto-notebook pluto-cell h\${i}`).join(",")
	return Array.from(document.querySelectorAll(selector))
}

const indent = $(toc.indent)
const aside = $(toc.aside)
const title_text = $(toc.title)

const clickHandler = (event) => {
	const path = (event.path || event.composedPath())
	const toc = path.find(elem => elem?.classList?.contains?.("toc-toggle"))
	if (toc) {
		event.stopImmediatePropagation()
		toc.closest(".plutoui-toc").classList.toggle("hide")
	}
}

document.addEventListener("click", clickHandler)


const header_to_index_entry_map = new Map()
const currently_highlighted_set = new Set()

const intersection_callback = (ixs) => {
	let on_top = ixs.filter(ix => ix.intersectionRatio > 0 && ix.intersectionRect.y < ix.rootBounds.height / 2)
	// console.log(ixs)
	// console.log(on_top.map(i => header_to_index_entry_map.get(i.target)))
	if(on_top.length > 0){
		currently_highlighted_set.forEach(a => a.classList.remove("in-view"))
		currently_highlighted_set.clear()
		on_top.slice(0,1).forEach(i => {
			let div = header_to_index_entry_map.get(i.target)
			div.classList.add("in-view")
			currently_highlighted_set.add(div)
		})
	}
}
let intersection_observer_1 = new IntersectionObserver(intersection_callback, {
	root: null, // i.e. the viewport
  	threshold: 1,
	rootMargin: "-15px", // slightly smaller than the viewport
})
let intersection_observer_2 = new IntersectionObserver(intersection_callback, {
	root: null, // i.e. the viewport
  	threshold: 1,
	rootMargin: "15px", // slightly larger than the viewport
})

const render = (elements) => {
	header_to_index_entry_map.clear()
	currently_highlighted_set.clear()
	intersection_observer_1.disconnect()
	intersection_observer_2.disconnect()
	
	return html`\${elements.map(h => {
	const parent_cell = getParentCell(h)

	const a = html`<a 
		class="\${h.nodeName}" 
		title="\${h.innerText}"
		href="#\${parent_cell.id}"
	>\${h.innerHTML}</a>`
	/* a.onmouseover=()=>{
		parent_cell.firstElementChild.classList.add(
			'highlight-pluto-cell-shoulder'
		)
	}
	a.onmouseout=() => {
		parent_cell.firstElementChild.classList.remove(
			'highlight-pluto-cell-shoulder'
		)
	} */
		
		
	a.onclick=(e) => {
		e.preventDefault();
		h.scrollIntoView({
			behavior: 'smooth', 
			block: 'start'
		})
	}

	const row =  html`<div class="toc-row \${h.nodeName}">\${a}</div>`
		intersection_observer_1.observe(h)
		intersection_observer_2.observe(h)
		header_to_index_entry_map.set(h, row)
		
	return row
})}`
}

const tocNode = html`<nav class="plutoui-toc">
	<header>
	 <span class="toc-toggle open-toc">📖</span>
	 <span class="toc-toggle closed-toc">📕</span>
	 \${title_text}
	</header>
	<section></section>
</nav>`

tocNode.classList.toggle("aside", aside)
tocNode.classList.toggle("indent", indent)

const invalidated = { current: false }

const updateCallback = () => {
	if (!invalidated.current) {
		tocNode.querySelector("section").replaceWith(
			html`<section>\${render(getHeaders())}</section>`
		)
	}
}
updateCallback()
setTimeout(updateCallback, 100)
setTimeout(updateCallback, 1000)
setTimeout(updateCallback, 5000)

const notebook = document.querySelector("pluto-notebook")


// We have a mutationobserver for each cell:
const mut_observers = {
	current: [],
}

const createCellObservers = () => {
	mut_observers.current.forEach((o) => o.disconnect())
	mut_observers.current = Array.from(notebook.querySelectorAll("pluto-cell")).map(el => {
		const o = new MutationObserver(updateCallback)
		o.observe(el, {attributeFilter: ["class"]})
		return o
	})
}
createCellObservers()

// And one for the notebook's child list, which updates our cell observers:
const notebookObserver = new MutationObserver(() => {
	updateCallback()
	createCellObservers()
})
notebookObserver.observe(notebook, {childList: true})

// And finally, an observer for the document.body classList, to make sure that the toc also works when it is loaded during notebook initialization
const bodyClassObserver = new MutationObserver(updateCallback)
bodyClassObserver.observe(document.body, {attributeFilter: ["class"]})

// Hide/show the ToC when the screen gets small
let m = matchMedia("(max-width: 1000px)")
let match_listener = () => 
	tocNode.classList.toggle("hide", m.matches)
match_listener()
m.addListener(match_listener)

invalidation.then(() => {
	invalidated.current = true
	intersection_observer_1.disconnect()
	intersection_observer_2.disconnect()
	notebookObserver.disconnect()
	bodyClassObserver.disconnect()
	mut_observers.current.forEach((o) => o.disconnect())
	document.removeEventListener("click", clickHandler)
	m.removeListener(match_listener)
})

return tocNode
</script>
""";

# ╔═╡ 354d8ac1-5c55-4765-8681-656c0da2f1a9
md"""
# CSS code
"""

# ╔═╡ 731a4662-c329-42a2-ae71-7954140bb290
const toc_css = @htl """
<style>
@media not print {

.plutoui-toc {
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Cantarell, Helvetica, Arial, "Apple Color Emoji",
		"Segoe UI Emoji", "Segoe UI Symbol", system-ui, sans-serif;
	--main-bg-color: #fafafa;
	--pluto-output-color: hsl(0, 0%, 36%);
	--pluto-output-h-color: hsl(0, 0%, 21%);
	--sidebar-li-active-bg: rgb(235, 235, 235);
}

@media (prefers-color-scheme: dark) {
	.plutoui-toc {
		--main-bg-color: #303030;
		--pluto-output-color: hsl(0, 0%, 90%);
		--pluto-output-h-color: hsl(0, 0%, 97%);
		--sidebar-li-active-bg: rgb(82, 82, 82);
	}
}

.plutoui-toc.aside {
	color: var(--pluto-output-color);
	position: fixed;
	right: 1rem;
	top: 5rem;
	width: min(80vw, 300px);
	padding: 0.5em;
	padding-top: 0em;
	/* border: 3px solid rgba(0, 0, 0, 0.15); */
	border-radius: 10px;
	/* box-shadow: 0 0 11px 0px #00000010; */
	max-height: calc(100vh - 5rem - 90px);
	overflow: auto;
	z-index: 40;
	background-color: var(--main-bg-color);
	transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
}

.plutoui-toc.aside.hide {
	transform: translateX(calc(100% - 28px));
}
.plutoui-toc.aside.hide section {
	display: none;
}
.plutoui-toc.aside.hide header {
	margin-bottom: 0em;
	padding-bottom: 0em;
	border-bottom: none;
}
}  /* End of Media print query */
.plutoui-toc.aside.hide .open-toc,
.plutoui-toc.aside:not(.hide) .closed-toc,
.plutoui-toc:not(.aside) .closed-toc {
	display: none;
}

@media (prefers-reduced-motion) {
  .plutoui-toc.aside {
	transition-duration: 0s;
  }
}

.toc-toggle {
	cursor: pointer;
	padding: 1em;
	margin: -1em;
	margin-right: -0.7em;
}

.plutoui-toc header {
	display: block;
	font-size: 1.5em;
	/* margin-top: -0.1em; */
	margin-bottom: 0.4em;
	padding: 0.4em 0;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	/* border-bottom: 2px solid rgba(0, 0, 0, 0.15); */
	position: sticky;
	top: 0px;
	background: var(--main-bg-color);
}

.plutoui-toc section .toc-row {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	padding: .1em;
	border-radius: .2em;
}

.plutoui-toc section .toc-row.H1 {
	margin-top: 1em;
}


.plutoui-toc section .toc-row.in-view {
	background: var(--sidebar-li-active-bg);
}


	
.highlight-pluto-cell-shoulder {
	background: rgba(0, 0, 0, 0.05);
	background-clip: padding-box;
}

.plutoui-toc section a {
	text-decoration: none;
	font-weight: normal;
	color: var(--pluto-output-color);
}
.plutoui-toc section a:hover {
	color: var(--pluto-output-h-color);
}

.plutoui-toc.indent section a.H1 {
	font-weight: 700;
	line-height: 1em;
}

.plutoui-toc.indent section a.H1 {
	padding-left: 0px;
}
.plutoui-toc.indent section a.H2 {
	padding-left: 10px;
}
.plutoui-toc.indent section a.H3 {
	padding-left: 20px;
}
.plutoui-toc.indent section a.H4 {
	padding-left: 30px;
}
.plutoui-toc.indent section a.H5 {
	padding-left: 40px;
}
.plutoui-toc.indent section a.H6 {
	padding-left: 50px;
}
</style>
""";

# ╔═╡ 434cc67b-a1e8-4804-b7ba-f47d0f879046
begin
	"""Generate Table of Contents using Markdown cells. Headers h1-h6 are used. 

	# Keyword arguments:
	`title` header to this element, defaults to "Table of Contents"

	`indent` flag indicating whether to vertically align elements by hierarchy

	`depth` value to limit the header elements, should be in range 1 to 6 (default = 3)

	`aside` fix the element to right of page, defaults to true

	# Examples:

	```julia
	TableOfContents()

	TableOfContents(title="Experiments 🔬")

	TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)
	```
	"""
	Base.@kwdef struct TableOfContents
		title::AbstractString="Table of Contents"
		indent::Bool=true
		depth::Integer=3
		aside::Bool=true
	end
	function Base.show(io::IO, m::MIME"text/html", toc::TableOfContents)
		Base.show(io, m, @htl("$(toc_js(toc))$(toc_css)"))
	end
end

# ╔═╡ 98cd39ae-a93c-40fe-a5d1-0883e1542e22
export TableOfContents

# ╔═╡ fdf8750b-653e-4f23-8f8f-9e2ef4e24e75
TableOfContents()

# ╔═╡ f11f9ead-bbe9-4fa5-b99c-408cc4a69a7e
md"""

# The <em>fun</em> stuff: playing with transforms

## Pedagogical note: Why the Module 1 application = image processing

# Last Lecture Leftovers

asdfasdf


## Interesting question about linear transformations

$p


## Julia style (a little advanced): Reminder about defining vector valued functions


$p


## Functions with parameters

$p


# Linear transformations: a collection


$p

$p

# Nonlinear transformations: a collection


$p


$p



# Composition


$p


## Composing functions in mathematics

$p


## Composing functions in computer science
$p


## Composition of software at a higher level

$p
$p


### Find your own examples
$p
# Linear transformations: See a matrix, think beyond number arrays
### The matrix
$p

### Matrix multiply: You know how to do it, but why?
$p

# Coordinate transformations vs object transformations
$p

### Coordinate transform of an array ( 𝑖 , 𝑗 ) vs points ( 𝑥 , 𝑦 )
$p
$p
$p

# Inverses
$p
$p
$p

## Using `inv` vs using `max`
$p
## Using ``\int`` vs using ``\sqrt{x}``
$p
## Example: Scaling up and down
$p
## Inverses: Solving equations
$p
### Inverting Linear Transformations
$p
### Inverting nonlinear transformations
$p
# The Big Diagram of Transforming Images
$p
$p
$p
## Collisions
$p
$p
## Why are we doing this backwards?
$p
# Appendix
"""


# ╔═╡ Cell order:
# ╠═3bf83b12-9932-49cd-83ab-f091e3b5fdb3
# ╠═e3f5cbc5-a443-43d3-b15c-e33e2d655450
# ╠═3061a5a6-feda-4538-8076-30c70c9b8766
# ╠═366a853d-3662-445a-940f-09e6e501a92a
# ╠═98cd39ae-a93c-40fe-a5d1-0883e1542e22
# ╠═ed0f13cc-4f7d-476b-a434-d14313d88eea
# ╠═fdf8750b-653e-4f23-8f8f-9e2ef4e24e75
# ╠═7c32fd56-6cc5-420b-945b-53446833a125
# ╟─6043d6c5-54e4-40c1-a8a5-aec3ad7e1aa0
# ╠═2e749ba7-3469-434d-9011-bb9396ffd149
# ╟─fb46ccb4-0195-4b5c-9992-dc0d930ea868
# ╠═434cc67b-a1e8-4804-b7ba-f47d0f879046
# ╟─c98059f6-2078-46f6-a2ea-4e70c226b2be
# ╠═d6940210-4f9b-47b5-af74-e53700a42417
# ╟─354d8ac1-5c55-4765-8681-656c0da2f1a9
# ╠═731a4662-c329-42a2-ae71-7954140bb290
# ╠═f11f9ead-bbe9-4fa5-b99c-408cc4a69a7e
