### A Pluto.jl notebook ###
# v0.19.24

using Markdown
using InteractiveUtils

# ╔═╡ e3f5cbc5-a443-43d3-b15c-e33e2d655450
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
end
  ╠═╡ =#

# ╔═╡ 366a853d-3662-445a-940f-09e6e501a92a
using HypertextLiteral

# ╔═╡ ed0f13cc-4f7d-476b-a434-d14313d88eea
using Markdown: withtag

# ╔═╡ 3061a5a6-feda-4538-8076-30c70c9b8766
import AbstractPlutoDingetjes: AbstractPlutoDingetjes, Bonds

# ╔═╡ 6043d6c5-54e4-40c1-a8a5-aec3ad7e1aa0
md"# asdfsf"

# ╔═╡ 2e749ba7-3469-434d-9011-bb9396ffd149
# ╠═╡ skip_as_script = true
#=╠═╡
const p = md"""
Pluto uses syntax analysis to understand which packages are being used in a notebook, and it automatically manages a package environment for your notebook. You no longer need to install packages, you can directly import any registered package like Plots or DataFrames and use it.
"""
  ╠═╡ =#

# ╔═╡ fb46ccb4-0195-4b5c-9992-dc0d930ea868
md"""
# Julia code
"""

# ╔═╡ c98059f6-2078-46f6-a2ea-4e70c226b2be
md"""
# JS code
"""

# ╔═╡ b3f94978-cfdc-458a-b556-c828637fddc0
md"""
## Smooth scroll library
"""

# ╔═╡ aa7aeffb-f4e3-4e09-b99e-681720b04681
import Base64

# ╔═╡ dfd83110-fe76-4369-9981-fcdcb8d1fafe
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
To get the bundled library code below:
1. Run `deno bundle deno bundle https://esm.sh/smooth-scroll-into-view-if-needed@2.0.0\?target\=es2022`
2. *(optional)* Copy the output and put it in a JS minifier, like [https://www.toptal.com/developers/javascript-minifier](https://www.toptal.com/developers/javascript-minifier)
3. Paste it into the cell below
"""
  ╠═╡ =#

# ╔═╡ 8b9371fc-fa29-483f-8ee4-35338b47e596
const smooth_scoll_lib = raw"""var Q=e=>"object"==typeof e&&null!=e&&1===e.nodeType,U=(e,t)=>(!t||"hidden"!==e)&&"visible"!==e&&"clip"!==e,A=(e,t)=>{if(e.clientHeight<e.scrollHeight||e.clientWidth<e.scrollWidth){let l=getComputedStyle(e,null);return U(l.overflowY,t)||U(l.overflowX,t)||(e=>{let t=(e=>{if(!e.ownerDocument||!e.ownerDocument.defaultView)return null;try{return e.ownerDocument.defaultView.frameElement}catch{return null}})(e);return!!t&&(t.clientHeight<e.scrollHeight||t.clientWidth<e.scrollWidth)})(e)}return!1},X=(e,t,l,o,n,r,i,s)=>r<e&&i>t||r>e&&i<t?0:r<=e&&s<=l||i>=t&&s>=l?r-e-o:i>t&&s<l||r<e&&s>l?i-t+n:0,$=e=>e.parentElement??(e.getRootNode().host||null),tt=(e,t)=>{var l,o,n,r;if(typeof document>"u")return[];let{scrollMode:i,block:s,inline:a,boundary:h,skipOverflowHiddenElements:u}=t,g="function"==typeof h?h:e=>e!==h;if(!Q(e))throw TypeError("Invalid target");let v=document.scrollingElement||document.documentElement,m=[],w=e;for(;Q(w)&&g(w);){if((w=$(w))===v){m.push(w);break}null!=w&&w===document.body&&A(w)&&!A(document.documentElement)||null!=w&&A(w,u)&&m.push(w)}let W=null!=(o=null==(l=window.visualViewport)?void 0:l.width)?o:innerWidth,H=null!=(r=null==(n=window.visualViewport)?void 0:n.height)?r:innerHeight,{scrollX:_,scrollY:x}=window,{height:E,width:T,top:N,right:L,bottom:Y,left:C}=e.getBoundingClientRect(),R="start"===s||"nearest"===s?N:"end"===s?Y:N+E/2,V="center"===a?C+T/2:"end"===a?L:C,B=[];for(let D=0;D<m.length;D++){let O=m[D],{height:j,width:I,top:S,right:q,bottom:z,left:F}=O.getBoundingClientRect();if("if-needed"===i&&N>=0&&C>=0&&Y<=H&&L<=W&&N>=S&&Y<=z&&C>=F&&L<=q)break;let G=getComputedStyle(O),J=parseInt(G.borderLeftWidth,10),K=parseInt(G.borderTopWidth,10),P=parseInt(G.borderRightWidth,10),Z=parseInt(G.borderBottomWidth,10),ee=0,et=0,el="offsetWidth"in O?O.offsetWidth-O.clientWidth-J-P:0,eo="offsetHeight"in O?O.offsetHeight-O.clientHeight-K-Z:0,en="offsetWidth"in O?0===O.offsetWidth?0:I/O.offsetWidth:0,er="offsetHeight"in O?0===O.offsetHeight?0:j/O.offsetHeight:0;if(v===O)ee="start"===s?R:"end"===s?R-H:"nearest"===s?X(x,x+H,H,K,Z,x+R,x+R+E,E):R-H/2,et="start"===a?V:"center"===a?V-W/2:"end"===a?V-W:X(_,_+W,W,J,P,_+V,_+V+T,T),ee=Math.max(0,ee+x),et=Math.max(0,et+_);else{ee="start"===s?R-S-K:"end"===s?R-z+Z+eo:"nearest"===s?X(S,z,j,K,Z+eo,R,R+E,E):R-(S+j/2)+eo/2,et="start"===a?V-F-J:"center"===a?V-(F+I/2)+el/2:"end"===a?V-q+P+el:X(F,q,I,J,P+el,V,V+T,T);let{scrollLeft:ei,scrollTop:ed}=O;ee=Math.max(0,Math.min(ed+ee/er,O.scrollHeight-j/er+eo)),et=Math.max(0,Math.min(ei+et/en,O.scrollWidth-I/en+el)),R+=ed-ee,V+=ei-et}B.push({el:O,top:ee,left:et})}return B},f=e=>{var t;return!1===e?{block:"end",inline:"nearest"}:(t=e)===Object(t)&&0!==Object.keys(t).length?e:{block:"start",inline:"nearest"}};function c(e,t){var l;if(!e.isConnected||!(e=>{let t=e;for(;t&&t.parentNode;){if(t.parentNode===document)return!0;t=t.parentNode instanceof ShadowRoot?t.parentNode.host:t.parentNode}return!1})(e))return;if("object"==typeof(l=t)&&"function"==typeof l.behavior)return t.behavior(tt(e,t));let o="boolean"==typeof t||null==t?void 0:t.behavior;for(let{el:n,top:r,left:i}of tt(e,f(t)))n.scroll({top:r,left:i,behavior:o})}var d,p=()=>(d||(d="performance"in window?performance.now.bind(performance):Date.now),d());function b(e){let t=Math.min((p()-e.startTime)/e.duration,1),l=e.ease(t),o=e.startX+(e.x-e.startX)*l,n=e.startY+(e.y-e.startY)*l;e.method(o,n,t,l),o!==e.x||n!==e.y?requestAnimationFrame(()=>b(e)):e.cb()}function y(e,t,l){let o=arguments.length>3&&void 0!==arguments[3]?arguments[3]:600,n=arguments.length>4&&void 0!==arguments[4]?arguments[4]:e=>1+--e*e*e*e*e,r=arguments.length>5?arguments[5]:void 0,i=arguments.length>6?arguments[6]:void 0,s=e.scrollLeft,a=e.scrollTop;b({scrollable:e,method(t,l,o,n){let r=Math.ceil(t),s=Math.ceil(l);e.scrollLeft=r,e.scrollTop=s,i?.({target:e,elapsed:o,value:n,left:r,top:s})},startTime:p(),startX:s,startY:a,x:t,y:l,duration:o,ease:n,cb:r})}var M=e=>e&&!e.behavior||"smooth"===e.behavior,k=function(e,t){let l=t||{};return M(l)?c(e,{block:l.block,inline:l.inline,scrollMode:l.scrollMode,boundary:l.boundary,skipOverflowHiddenElements:l.skipOverflowHiddenElements,behavior:e=>Promise.all(e.reduce((e,t)=>{let{el:o,left:n,top:r}=t,i=o.scrollLeft,s=o.scrollTop;return i===n&&s===r?e:[...e,new Promise(e=>y(o,n,r,l.duration,l.ease,()=>e({el:o,left:[i,n],top:[s,r]}),l.onScrollChange))]},[]))}):Promise.resolve(c(e,t))};export{k as default};"""

# ╔═╡ 2c860192-3bef-4c76-8365-007182a6ed67
const smooth_scoll_lib_url = "data:text/javascript;base64,$(Base64.base64encode(smooth_scoll_lib))"

# ╔═╡ d6940210-4f9b-47b5-af74-e53700a42417
const toc_js = toc -> @htl """
<script>
	
// Load the library for consistent smooth scrolling
const {default: scrollIntoView} = await import($smooth_scoll_lib_url)

const indent = $(toc.indent)
const aside = $(toc.aside)
const title_text = $(toc.title)
const include_definitions = $(toc.include_definitions)


const tocNode = html`<nav class="plutoui-toc">
	<header>
	 <span class="toc-toggle open-toc"></span>
	 <span class="toc-toggle closed-toc"></span>
	 \${title_text}
	</header>
	<section></section>
</nav>`

tocNode.classList.toggle("aside", aside)
tocNode.classList.toggle("indent", indent)


const getParentCell = el => el.closest("pluto-cell")

const getHeaders = () => {
	const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
	const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
	
	const selector = [
		...(include_definitions ? [
			`pluto-notebook pluto-cell .pluto-docs-binding`, 
			`pluto-notebook pluto-cell assignee:not(:empty)`, 
		] : []),
		...range.map(i => `pluto-notebook pluto-cell h\${i}`)
	].join(",")
	return Array.from(document.querySelectorAll(selector)).filter(el => 
		// exclude headers inside of a pluto-docs-binding block
		!(el.nodeName.startsWith("H") && el.closest(".pluto-docs-binding"))
	)
}


const document_click_handler = (event) => {
	const path = (event.path || event.composedPath())
	const toc = path.find(elem => elem?.classList?.contains?.("toc-toggle"))
	if (toc) {
		event.stopImmediatePropagation()
		toc.closest(".plutoui-toc").classList.toggle("hide")
	}
}

document.addEventListener("click", document_click_handler)


const header_to_index_entry_map = new Map()
const currently_highlighted_set = new Set()

const last_toc_element_click_time = { current: 0 }

const intersection_callback = (ixs) => {
	let on_top = ixs.filter(ix => ix.intersectionRatio > 0 && ix.intersectionRect.y < ix.rootBounds.height / 2)
	if(on_top.length > 0){
		currently_highlighted_set.forEach(a => a.classList.remove("in-view"))
		currently_highlighted_set.clear()
		on_top.slice(0,1).forEach(i => {
			let div = header_to_index_entry_map.get(i.target)
			div.classList.add("in-view")
			currently_highlighted_set.add(div)
			
			/// scroll into view
			/*
			const toc_height = tocNode.offsetHeight
			const div_pos = div.offsetTop
			const div_height = div.offsetHeight
			const current_scroll = tocNode.scrollTop
			const header_height = tocNode.querySelector("header").offsetHeight
			
			const scroll_to_top = div_pos - header_height
			const scroll_to_bottom = div_pos + div_height - toc_height
			
			// if we set a scrollTop, then the browser will stop any currently ongoing smoothscroll animation. So let's only do this if you are not currently in a smoothscroll.
			if(Date.now() - last_toc_element_click_time.current >= 2000)
				if(current_scroll < scroll_to_bottom){
					tocNode.scrollTop = scroll_to_bottom
				} else if(current_scroll > scroll_to_top){
					tocNode.scrollTop = scroll_to_top
				}
			*/
		})
	}
}
let intersection_observer_1 = new IntersectionObserver(intersection_callback, {
	root: null, // i.e. the viewport
  	threshold: 1,
	rootMargin: "-15px", // slightly smaller than the viewport
	// delay: 100,
})
let intersection_observer_2 = new IntersectionObserver(intersection_callback, {
	root: null, // i.e. the viewport
  	threshold: 1,
	rootMargin: "15px", // slightly larger than the viewport
	// delay: 100,
})

const render = (elements) => {
	header_to_index_entry_map.clear()
	currently_highlighted_set.clear()
	intersection_observer_1.disconnect()
	intersection_observer_2.disconnect()

		let last_level = `H1`
	return html`\${elements.map(h => {
	const parent_cell = getParentCell(h)

		let [className, title_el] = h.matches(`.pluto-docs-binding`) ? ["pluto-docs-binding-el", h.firstElementChild] : [h.nodeName, h]

	const a = html`<a 
		class="\${className}" 
		title="\${title_el.innerText}"
		href="#\${parent_cell.id}"
	>\${title_el.innerHTML}</a>`
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
		last_toc_element_click_time.current = Date.now()
		scrollIntoView(h, {
			behavior: 'smooth', 
			block: 'start',
		}).then(() => 
			// sometimes it doesn't scroll to the right place
			// solution: try a second time!
			scrollIntoView(h, {
				behavior: 'smooth', 
				block: 'start',
			})
	   )
	}

	const row =  html`<div class="toc-row \${className} after-\${last_level}">\${a}</div>`
		intersection_observer_1.observe(title_el)
		intersection_observer_2.observe(title_el)
		header_to_index_entry_map.set(title_el, row)

	if(className.startsWith("H"))
		last_level = className
		
	return row
})}`
}

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
	document.removeEventListener("click", document_click_handler)
	m.removeListener(match_listener)
})

return tocNode
</script>
""";

# ╔═╡ c7b295dd-c5b7-4909-a589-ddec8f2e583d
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
> The code above is generated from [https://github.com/scroll-into-view/smooth-scroll-into-view-if-needed](https://github.com/scroll-into-view/smooth-scroll-into-view-if-needed)
> 
> Original license:
> ```
> MIT License
> 
> Copyright (c) 2023 Cody Olsen
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
> ```
"""
  ╠═╡ =#

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
	--icon-filter: unset;
}

@media (prefers-color-scheme: dark) {
	.plutoui-toc {
		--main-bg-color: #303030;
		--pluto-output-color: hsl(0, 0%, 90%);
		--pluto-output-h-color: hsl(0, 0%, 97%);
		--sidebar-li-active-bg: rgb(82, 82, 82);
		--icon-filter: invert(1);
	}
}

.plutoui-toc.aside {
	color: var(--pluto-output-color);
	position: fixed;
	right: 1rem;
	top: 5rem;
	width: min(80vw, 300px);
	padding: 0.5rem;
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
    line-height: 1em;
    display: flex;
}

.toc-toggle::before {
    content: "";
    display: inline-block;
    height: 1em;
    width: 1em;
    background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/list-outline.svg");
	/* generated using https://dopiaza.org/tools/datauri/index.php */
    background-image: url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiI+PHRpdGxlPmlvbmljb25zLXY1LW88L3RpdGxlPjxsaW5lIHgxPSIxNjAiIHkxPSIxNDQiIHgyPSI0NDgiIHkyPSIxNDQiIHN0eWxlPSJmaWxsOm5vbmU7c3Ryb2tlOiMwMDA7c3Ryb2tlLWxpbmVjYXA6cm91bmQ7c3Ryb2tlLWxpbmVqb2luOnJvdW5kO3N0cm9rZS13aWR0aDozMnB4Ii8+PGxpbmUgeDE9IjE2MCIgeTE9IjI1NiIgeDI9IjQ0OCIgeTI9IjI1NiIgc3R5bGU9ImZpbGw6bm9uZTtzdHJva2U6IzAwMDtzdHJva2UtbGluZWNhcDpyb3VuZDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLXdpZHRoOjMycHgiLz48bGluZSB4MT0iMTYwIiB5MT0iMzY4IiB4Mj0iNDQ4IiB5Mj0iMzY4IiBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojMDAwO3N0cm9rZS1saW5lY2FwOnJvdW5kO3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2Utd2lkdGg6MzJweCIvPjxjaXJjbGUgY3g9IjgwIiBjeT0iMTQ0IiByPSIxNiIgc3R5bGU9ImZpbGw6bm9uZTtzdHJva2U6IzAwMDtzdHJva2UtbGluZWNhcDpyb3VuZDtzdHJva2UtbGluZWpvaW46cm91bmQ7c3Ryb2tlLXdpZHRoOjMycHgiLz48Y2lyY2xlIGN4PSI4MCIgY3k9IjI1NiIgcj0iMTYiIHN0eWxlPSJmaWxsOm5vbmU7c3Ryb2tlOiMwMDA7c3Ryb2tlLWxpbmVjYXA6cm91bmQ7c3Ryb2tlLWxpbmVqb2luOnJvdW5kO3N0cm9rZS13aWR0aDozMnB4Ii8+PGNpcmNsZSBjeD0iODAiIGN5PSIzNjgiIHI9IjE2IiBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojMDAwO3N0cm9rZS1saW5lY2FwOnJvdW5kO3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2Utd2lkdGg6MzJweCIvPjwvc3ZnPg==");
    background-size: 1em;
	filter: var(--icon-filter);
}

.aside .toc-toggle.open-toc:hover::before {
    background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-forward-outline.svg");
	/* generated using https://dopiaza.org/tools/datauri/index.php */
    background-image: url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiI+PHRpdGxlPmlvbmljb25zLXY1LWE8L3RpdGxlPjxwb2x5bGluZSBwb2ludHM9IjI2OCAxMTIgNDEyIDI1NiAyNjggNDAwIiBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojMDAwO3N0cm9rZS1saW5lY2FwOnJvdW5kO3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2Utd2lkdGg6NDhweCIvPjxsaW5lIHgxPSIzOTIiIHkxPSIyNTYiIHgyPSIxMDAiIHkyPSIyNTYiIHN0eWxlPSJmaWxsOm5vbmU7c3Ryb2tlOiMwMDA7c3Ryb2tlLWxpbmVjYXA6cm91bmQ7c3Ryb2tlLWxpbmVqb2luOnJvdW5kO3N0cm9rZS13aWR0aDo0OHB4Ii8+PC9zdmc+");
}
.aside .toc-toggle.closed-toc:hover::before {
    background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-back-outline.svg");
	/* generated using https://dopiaza.org/tools/datauri/index.php */
    background-image: url("data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiI+PHRpdGxlPmlvbmljb25zLXY1LWE8L3RpdGxlPjxwb2x5bGluZSBwb2ludHM9IjI0NCA0MDAgMTAwIDI1NiAyNDQgMTEyIiBzdHlsZT0iZmlsbDpub25lO3N0cm9rZTojMDAwO3N0cm9rZS1saW5lY2FwOnJvdW5kO3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2Utd2lkdGg6NDhweCIvPjxsaW5lIHgxPSIxMjAiIHkxPSIyNTYiIHgyPSI0MTIiIHkyPSIyNTYiIHN0eWxlPSJmaWxsOm5vbmU7c3Ryb2tlOiMwMDA7c3Ryb2tlLWxpbmVjYXA6cm91bmQ7c3Ryb2tlLWxpbmVqb2luOnJvdW5kO3N0cm9rZS13aWR0aDo0OHB4Ii8+PC9zdmc+");
}



.plutoui-toc header {
	display: flex;
	align-items: center;
	gap: .3em;
	font-size: 1.5em;
	/* margin-top: -0.1em; */
	margin-bottom: 0.4em;
	padding: 0.5rem;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	/* border-bottom: 2px solid rgba(0, 0, 0, 0.15); */
	position: sticky;
	top: 0px;
	background: var(--main-bg-color);
	z-index: 41;
}
.plutoui-toc.aside header {
	padding-left: 0;
	padding-right: 0;
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


.plutoui-toc.aside section .toc-row.in-view {
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

.plutoui-toc.indent section .after-H2 a { padding-left: 10px; }
.plutoui-toc.indent section .after-H3 a { padding-left: 20px; }
.plutoui-toc.indent section .after-H4 a { padding-left: 30px; }
.plutoui-toc.indent section .after-H5 a { padding-left: 40px; }
.plutoui-toc.indent section .after-H6 a { padding-left: 50px; }

.plutoui-toc.indent section a.H1 { padding-left: 0px; }
.plutoui-toc.indent section a.H2 { padding-left: 10px; }
.plutoui-toc.indent section a.H3 { padding-left: 20px; }
.plutoui-toc.indent section a.H4 { padding-left: 30px; }
.plutoui-toc.indent section a.H5 { padding-left: 40px; }
.plutoui-toc.indent section a.H6 { padding-left: 50px; }


.plutoui-toc.indent section a.pluto-docs-binding-el,
.plutoui-toc.indent section a.ASSIGNEE
	{
	font-family: JuliaMono, monospace;
	font-size: .8em;
	/* background: black; */
	font-weight: 700;
    font-style: italic;
	color: var(--cm-var-color); /* this is stealing a variable from Pluto, but it's fine if that doesnt work */
}
.plutoui-toc.indent section a.pluto-docs-binding-el::before,
.plutoui-toc.indent section a.ASSIGNEE::before
	{
	content: "> ";
	opacity: .3;
}
</style>
""";

# ╔═╡ 434cc67b-a1e8-4804-b7ba-f47d0f879046
begin
	local result = begin
	Base.@kwdef struct TableOfContents
		title::AbstractString="Table of Contents"
		indent::Bool=true
		depth::Integer=3
		aside::Bool=true
		include_definitions::Bool=false
	end
	@doc """
	Generate Table of Contents using Markdown cells. Headers h1-h6 are used. 

	# Keyword arguments:
	`title` header to this element, defaults to "Table of Contents"

	`indent` flag indicating whether to vertically align elements by hierarchy

	`depth` value to limit the header elements, should be in range 1 to 6 (default = 3)

	`aside` fix the element to right of page, defaults to true
		
	`include_definitions` add cells that start with docstrings to the ToC, defaults to false

	# Examples:

	```julia
	TableOfContents()

	TableOfContents(title="Experiments 🔬")

	TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)
	```
	"""
	TableOfContents
	
	end
	function Base.show(io::IO, m::MIME"text/html", toc::TableOfContents)
		Base.show(io, m, @htl("$(toc_js(toc))$(toc_css)"))
	end
	result
end

# ╔═╡ 98cd39ae-a93c-40fe-a5d1-0883e1542e22
export TableOfContents

# ╔═╡ fdf8750b-653e-4f23-8f8f-9e2ef4e24e75
# ╠═╡ skip_as_script = true
#=╠═╡
TableOfContents(; include_definitions=true)
  ╠═╡ =#

# ╔═╡ 7c32fd56-6cc5-420b-945b-53446833a125
# ╠═╡ skip_as_script = true
#=╠═╡
TableOfContents(; aside = false)
  ╠═╡ =#

# ╔═╡ 3ab2da5f-943e-42e8-8e46-4a7031ba4227
#=╠═╡
md"""

# L1 The <em>fun</em> stuff: playing with transforms

## L2 Pedagogical note: Why the Module 1 application = image processing

# L1 Last Lecture Leftovers

asdfasdf


## L2 Interesting question about linear transformations

$p


## L2 Julia style (a little advanced): Reminder about defining vector valued functions


$p


## L2 Functions with parameters

$p


# L1 Linear transformations: a collection


$p

$p

# L1 Nonlinear transformations: a collection


$p


$p



# L1 Composition


$p


## L2 Composing functions in mathematics

$p


## L2 Composing functions in computer science
$p

"""
  ╠═╡ =#

# ╔═╡ 7b27a858-9d3a-4324-a56c-98e6f31d5929
# ╠═╡ skip_as_script = true
#=╠═╡
"""
lkjasfdlk jasdflkj asdf
"""
fff(x) = x
  ╠═╡ =#

# ╔═╡ 27adc83b-c052-40fb-8a8d-7d6fcb7c8e30
# ╠═╡ skip_as_script = true
#=╠═╡
fff2 = 123
  ╠═╡ =#

# ╔═╡ b3e73e1a-f8b3-4973-a052-69c8f12ebbf1
#=╠═╡
md"""
### L3 something inbetween

hello

## L2 Composition of software at a higher level

$p
$p


### L3 Find your own examples
$p
# L1 Linear transformations: See a matrix, think beyond number arrays
### L3 The matrix
$p

### L3 Matrix multiply: You know how to do it, but why?
$p

# L1 Coordinate transformations vs object transformations
$p

### L3 Coordinate transform of an array ( 𝑖 , 𝑗 ) vs points ( 𝑥 , 𝑦 )
$p
$p
$p

# L1 Inverses
$p
$p
$p

## L2 Using `inv` vs using `max`
$p
## L2 Using ``\int`` vs using ``\sqrt{x}``
$p
## L2 Example: Scaling up and down
$p
## L2 Inverses: Solving equations
$p
### L3 Inverting Linear Transformations
$p
### L3 Inverting nonlinear transformations
$p
# L1 The Big Diagram of Transforming Images
$p
$p
$p
## L2 Collisions
$p
$p
## L2 Why are we doing this backwards?
$p
# L1 Appendix
"""
  ╠═╡ =#

# ╔═╡ Cell order:
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
# ╟─b3f94978-cfdc-458a-b556-c828637fddc0
# ╠═aa7aeffb-f4e3-4e09-b99e-681720b04681
# ╟─dfd83110-fe76-4369-9981-fcdcb8d1fafe
# ╟─8b9371fc-fa29-483f-8ee4-35338b47e596
# ╟─2c860192-3bef-4c76-8365-007182a6ed67
# ╟─c7b295dd-c5b7-4909-a589-ddec8f2e583d
# ╟─354d8ac1-5c55-4765-8681-656c0da2f1a9
# ╠═731a4662-c329-42a2-ae71-7954140bb290
# ╠═3ab2da5f-943e-42e8-8e46-4a7031ba4227
# ╠═7b27a858-9d3a-4324-a56c-98e6f31d5929
# ╠═27adc83b-c052-40fb-8a8d-7d6fcb7c8e30
# ╠═b3e73e1a-f8b3-4973-a052-69c8f12ebbf1
