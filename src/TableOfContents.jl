export TableOfContents

"""Generate Table of Contents using Markdown cells. Headers h1-h6 are used. 

`title` header to this element, defaults to "Table of Contents"

`indent` flag indicating whether to vertically align elements by hierarchy

`depth` value to limit the header elements, should be in range 1 to 6 (default = 3)

`aside` fix the element to right of page, defaults to true

# Examples:

`TableOfContents()`

`TableOfContents("Experiments 🔬")`

`TableOfContents("📚 Table of Contents", true, 4, true)`
"""
struct TableOfContents
    title::AbstractString
    indent::Bool
    depth::Int
    aside::Bool
end
TableOfContents(title::AbstractString; indent::Bool=true, depth::Int=3, aside::Bool=true) = TableOfContents(title, indent, depth, aside)
TableOfContents() = TableOfContents("Table of Contents", true, 3, true)

function show(io::IO, ::MIME"text/html", toc::TableOfContents)

    if toc.title === nothing || toc.title === missing 
        toc.title = ""
    end

    withtag(io, :script) do
        print(io, """

            if (document.getElementById("toc") !== null){
                return html`<div>TableOfContents already added. Cannot add another.</div>`
            }

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
            
            const isSelf = el => {
                try {
                    return el.childNodes[1].id === "toc"
                } catch {                    
                }
                return false
            }            

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

            const updateCallback = e => {
                if (isSelf(e.detail.cell_id)) return
                document.getElementById('toc-content').innerHTML = render(getHeaders())                
            }

            window.addEventListener('cell_output_changed', updateCallback)

            const tocClass = '$(toc.aside ? "toc-aside" : "")'
            return html`<div class=\${tocClass} id="toc">
                            <div class="markdown">
                                <p class="toc-title">$(toc.title)</p>
                                <div class="toc-content" id="toc-content">
                                        \${render(getHeaders())}
                                </div>
                            </div>
                        </div>`
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

get(toc::TableOfContents) = toc.default