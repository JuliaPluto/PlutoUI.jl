export TableOfContents

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

function Base.show(io::IO, ::MIME"text/html", toc::TableOfContents)

    withtag(io, :script) do
        print(io, """
            const getParentCellId = el => {
                // Traverse up the DOM tree until you reach a pluto-cell
                while (el.nodeName != 'PLUTO-CELL') {
                    el = el.parentNode;
                    if (!el) return null;
                }
                return el.id;
            }     

            const getElementsByNodename = nodeName => Array.from(
                document.querySelectorAll(
                    "pluto-notebook pluto-output " + nodeName
                )
            ).map(el => {
                return {
                    "nodeName" : el.nodeName,
                    "parentCellId": getParentCellId(el),
                    "innerText": el.innerText
                }
            })
            
            const getPlutoCellIds = () => Array.from(
                document.querySelectorAll(
                    "pluto-notebook pluto-cell"
                )
            ).map(el => el.id)
            
            const getHeaders = () => {
                const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
                const range = Array.from({length: depth}, (x, i) => i+1) // [1, ... depth]
                let headers = [].concat.apply([], range.map(i => getElementsByNodename("h"+i))); // flatten [[h1s...], [h2s...], ...]
                const plutoCellIds = getPlutoCellIds()
                headers.sort((a,b) => plutoCellIds.indexOf(a.parentCellId) - plutoCellIds.indexOf(b.parentCellId)); // sort in the order of appearance
                return headers
            }

            const tocIndentClass = '$(toc.indent ? "-indent" : "")'
            const render = (el) => `\${el.map(h => `<div class="toc-row">
                                            <a class="\${h.nodeName}\${tocIndentClass}" 
                                                href="#\${h.parentCellId}" 
                                                onmouseover="(()=>{document.getElementById('\${h.parentCellId}').firstElementChild.classList.add('highlight-pluto-cell-shoulder')})()" 
                                                onmouseout="(()=>{document.getElementById('\${h.parentCellId}').firstElementChild.classList.remove('highlight-pluto-cell-shoulder')})()"
                                                onclick="((e)=>{
                                                    e.preventDefault();
                                                    document.getElementById('\${h.parentCellId}').scrollIntoView({
                                                        behavior: 'smooth', 
                                                        block: 'center'
                                                    });
                                                })(event)"
                                                > \${h.innerText}</a>
                                        </div>`).join('')}`


            const tocClass = '$(toc.aside ? "toc-aside" : "")'

            const tocContentNode = html`<div class="toc-content" id="toc-content"></div>`
            const tocNode = html`<div class=\${tocClass} id="toc">
                <div class="markdown">
                    <p class="toc-title">$(toc.title)</p>
                    \${tocContentNode}
                </div>
            </div>`
            const updateCallback = e => {
                tocContentNode.innerHTML = render(getHeaders())                
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
            const notebookObserver = new MutationObserver(createCellObservers)
            notebookObserver.observe(notebook, {childList: true})
            
            createCellObservers()

            invalidation.then(() => {
                notebookObserver.disconnect()
                observers.current.forEach((o) => o.disconnect())
            })
            
            return tocNode
        """)
    end

    withtag(io, :style) do
        print(io, """
            @media screen and (min-width: 1081px) {
                .toc-aside {
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
                }
            }    

            .toc-title{
                display: block;
                font-size: 1.5em;
                margin-top: 0.67em;
                margin-bottom: 0.67em;
                margin-left: 0;
                margin-right: 0;
                font-weight: bold;
                border-bottom: 2px solid rgba(0, 0, 0, 0.15);
            }

            .toc-row {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                padding-bottom: 2px;
            }

            .highlight-pluto-cell-shoulder {
                background: rgba(0, 0, 0, 0.05);
                background-clip: padding-box;
            }

            a {
                text-decoration: none;
                font-weight: normal;
                color: gray;
            }
            a:hover {
                color: black;
            }
            a.H1-indent {
                padding: 0px 0px;
            }
            a.H2-indent {
                padding: 0px 10px;
            }
            a.H3-indent {
                padding: 0px 20px;
            }
            a.H4-indent {
                padding: 0px 30px;
            }
            a.H5-indent {
                padding: 0px 40px;
            }
            a.H6-indent {
                padding: 0px 50px;
            }
            """)
    end
end
