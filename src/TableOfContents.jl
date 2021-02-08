export TableOfContents

using Markdown: withtag

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

const toc_js = toc -> """
const getParentCell = el => el.closest("pluto-cell")

const getHeaders = () => {
	const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
	const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
	
	const selector = range.map(i => `pluto-notebook pluto-cell h\${i}`).join(",")
	return Array.from(document.querySelectorAll(selector))
}

const indent = $(repr(toc.indent))
const aside = $(repr(toc.aside))

const render = (el) => html`\${el.map(h => {
	const parent_cell = getParentCell(h)

	const a = html`<a 
		class="\${h.nodeName}" 
		href="#\${parent_cell.id}"
	>\${h.innerText}</a>`
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
			block: 'center'
		})
	}

	return html`<div class="toc-row">\${a}</div>`
})}`


const tocContentNode = html`<section></section>`

const tocNode = html`<nav class="plutoui-toc">
	<header>$(toc.title)</header>
	\${tocContentNode}
</nav>`
tocNode.classList.toggle("aside", aside)
tocNode.classList.toggle("indent", aside)

const updateCallback = e => {
	tocContentNode.innerHTML = ""
	tocContentNode.appendChild(render(getHeaders()))
}
updateCallback()

const observers = {
	current: [],
}

const notebook = document.querySelector("pluto-notebook")
const createCellObservers = () => {
	observers.current.forEach((o) => o.disconnect())
	observers.current = Array.from(notebook.querySelectorAll("pluto-cell")).map(el => {
		const o = new MutationObserver(updateCallback)
		o.observe(el, {attributeFilter: ["class"]})
		return o
	})
}
const notebookObserver = new MutationObserver(() => {
	updateCallback()
	createCellObservers()
})
notebookObserver.observe(notebook, {childList: true})

createCellObservers()

invalidation.then(() => {
	notebookObserver.disconnect()
	observers.current.forEach((o) => o.disconnect())
})

return tocNode
"""

const toc_css = """
@media screen and (min-width: 1081px) {
	.plutoui-toc.aside {
		position:fixed; 
		right: 1rem;
		top: 5rem; 
		width:25%; 
		padding: 10px;
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
		max-height: 500px;
		overflow: auto;
		z-index: 5;
		background: white;
	}
}

.plutoui-toc header {
	display: block;
	font-size: 1.5em;
	margin-top: 0.67em;
	margin-bottom: 0.67em;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	border-bottom: 2px solid rgba(0, 0, 0, 0.15);
}

.plutoui-toc section .toc-row {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	padding-bottom: 2px;
}

.highlight-pluto-cell-shoulder {
	background: rgba(0, 0, 0, 0.05);
	background-clip: padding-box;
}

.plutoui-toc section a {
	text-decoration: none;
	font-weight: normal;
	color: gray;
}
.plutoui-toc section a:hover {
	color: black;
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
"""

function Base.show(io::IO, ::MIME"text/html", toc::TableOfContents)
    withtag(io, :script) do
        print(io, toc_js(toc))
    end
    withtag(io, :style) do
        print(io, toc_css)
    end
end