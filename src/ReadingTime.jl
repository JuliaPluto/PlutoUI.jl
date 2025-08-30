### A Pluto.jl notebook ###
# v0.20.17

using Markdown
using InteractiveUtils

# ╔═╡ cec46184-6f17-4c74-9d01-ea21f1b276d3
using HypertextLiteral,  Markdown

# ╔═╡ 9abf5402-c506-4c8d-8cb2-4035cb179b85
"""
    reading_time(; wpm=200, position=:top, style=:minimal)

Add a reading time estimate to your Pluto notebook based on markdown content.

# Arguments
- `wpm::Int=200`: Words per minute reading speed (typical range: 150-300)
- `position::Symbol=:top`: Where to display (`:top` or `:floating`)
- `style::Symbol=:minimal`: Display style (`:minimal` or `:detailed`)

# Examples
```julia
reading_time()  # Simple "📖 5 min read"

reading_time(wpm=250, style=:detailed)  # "📖 Reading time: 4 minutes (850 words at 250 wpm)"

reading_time(position=:floating)  # Floating in corner
```
"""
struct ReadingTimeEstimator
    wpm::Int
    position::Symbol
    style::Symbol
end

# ╔═╡ fe6b6374-1209-45f0-b593-f5efdb28e821
const reading_time_js = (estimator) -> @htl("""
<script>
const wpm = $(estimator.wpm)
const position = $(string(estimator.position))
const style = $(string(estimator.style))

// Create the reading time display element
const readingTimeNode = html`<div class="pluto-reading-time \${position} \${style}">
    <span class="reading-time-content">📖 Calculating...</span>
</div>`

// Function to strip markdown and count words
function stripMarkdownAndCount(text) {
    // Remove code blocks
    text = text.replace(/```[\\s\\S]*?```/g, '')
    text = text.replace(/`[^`]+`/g, '')
    
    // Remove headers
    text = text.replace(/^#{1,6}\\s+/gm, '')
    
    // Remove links but keep text
    text = text.replace(/\\[([^\\]]+)\\]\\([^)]+\\)/g, '\$1')
    
    // Remove bold/italic
    text = text.replace(/\\*\\*([^*]+)\\*\\*/g, '\$1')
    text = text.replace(/\\*([^*]+)\\*/g, '\$1')
    
    // Remove other markdown symbols
    text = text.replace(/[#*_~`>\\-\\+]/g, '')
    
    // Clean up whitespace
    text = text.replace(/\\s+/g, ' ').trim()
    
    // Count words
    return text ? text.split(/\\s+/).length : 0
}

// Function to get markdown content from cells
function getMarkdownContent() {
    const markdownCells = Array.from(document.querySelectorAll('pluto-cell'))
        .filter(cell => {
            // Look for cells that contain markdown
            const cellContent = cell.querySelector('.cm-editor, pluto-output')
            if (!cellContent) return false
            
            // Check if it's a markdown cell by looking for md"" or markdown content
            const text = cellContent.textContent || ''
            return text.includes('md"') || text.includes('md\"""') || 
                   cellContent.querySelector('.markdown, .pluto-output .htmloutput')
        })
    
    let totalWords = 0
    
    markdownCells.forEach(cell => {
        // Get the rendered markdown content
        const markdownOutput = cell.querySelector('pluto-output .markdown, pluto-output .htmloutput')
        if (markdownOutput) {
            const text = markdownOutput.textContent || ''
            totalWords += stripMarkdownAndCount(text)
        } else {
            // Fallback: parse from cell content
            const cellText = cell.textContent || ''
            const mdMatch = cellText.match(/md"([\\s\\S]*?)"/m) || cellText.match(/md\"""([\\s\\S]*?)\"""/m)
            if (mdMatch) {
                totalWords += stripMarkdownAndCount(mdMatch[1])
            }
        }
    })
    
    return totalWords
}

// Function to calculate and display reading time
function updateReadingTime() {
    const wordCount = getMarkdownContent()
    const minutes = Math.ceil(wordCount / wpm)
    
    let displayText = ''
    
    switch(style) {
        case 'minimal':
            displayText = `📖 \${minutes} min read`
            break
        case 'detailed':
            displayText = `📖 Reading time: \${minutes} minute\${minutes !== 1 ? 's' : ''} (\${wordCount} words at \${wpm} wpm)`
            break
        default:
            displayText = `📖 \${minutes} min read`
    }
    
    readingTimeNode.querySelector('.reading-time-content').textContent = displayText
}

// Initial calculation
updateReadingTime()

// Set up observers similar to TableOfContents
const notebook = document.querySelector("pluto-notebook")

const mut_observers = { current: [] }

const createCellObservers = () => {
    mut_observers.current.forEach((o) => o.disconnect())
    mut_observers.current = Array.from(notebook.querySelectorAll("pluto-cell")).map(el => {
        const o = new MutationObserver(() => {
            setTimeout(updateReadingTime, 100) // Small delay to let content render
        })
        o.observe(el, {
            childList: true, 
            subtree: true, 
            characterData: true,
            attributes: true,
            attributeFilter: ["class"]
        })
        return o
    })
}

createCellObservers()

// Observer for new cells
const notebookObserver = new MutationObserver(() => {
    updateReadingTime()
    createCellObservers()
})
notebookObserver.observe(notebook, {childList: true})

// Cleanup on invalidation
invalidation.then(() => {
    notebookObserver.disconnect()
    mut_observers.current.forEach((o) => o.disconnect())
})

return readingTimeNode
</script>
""")

# ╔═╡ cd42ce90-6790-4d03-808e-7e4f206323ad
const reading_time_css = @htl """
<style>
.pluto-reading-time {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Cantarell, 
                 "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", system-ui, sans-serif;
    font-size: 0.9em;
    color: #666;
    z-index: 1000;
}

.pluto-reading-time.top {
    position: sticky;
    top: 0;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    padding: 0.5rem 1rem;
    border-bottom: 1px solid #eee;
    text-align: center;
    margin-bottom: 1rem;
}

.pluto-reading-time.floating {
    position: fixed;
    top: 1rem;
    right: 1rem;
    background: rgba(0, 0, 0, 0.8);
    color: white;
    padding: 0.25rem 0.5rem;
    border-radius: 15px;
    font-size: 0.8em;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}


@media (prefers-color-scheme: dark) {
    .pluto-reading-time.top,
    .pluto-reading-time.bottom {
        background: rgba(48, 48, 48, 0.95);
        border-color: #444;
        color: #ccc;
    }
}

@media print {
    .pluto-reading-time {
        display: none;
    }
}
</style>
"""

# ╔═╡ 3759fa8b-d992-451b-b57d-9898002627e6
function reading_time(; wpm::Int=200, position::Symbol=:top, style::Symbol=:minimal)
    estimator = ReadingTimeEstimator(wpm, position, style)
    return estimator
end

# ╔═╡ d4a16be1-2dbc-4625-92d0-8e1897247b5e
function Base.show(io::IO, m::MIME"text/html", estimator::ReadingTimeEstimator)
    Base.show(io, m, @htl("$(reading_time_js(estimator))$(reading_time_css)"))
end

# ╔═╡ cb1e6a6f-1201-4fcd-a805-863c29938be2
md"
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend nisi volutpat dui laoreet, nec fermentum elit convallis. Phasellus non tellus sed massa consequat consectetur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras eros tellus, gravida in nunc a, auctor condimentum libero. Cras tellus neque, lacinia a lorem ut, accumsan accumsan risus. Integer in luctus tellus. Vivamus bibendum leo hendrerit enim consequat, at eleifend lectus tempor.

Fusce eget tempus sem. Vivamus dictum rutrum consectetur. Morbi eu ante quis urna tincidunt blandit sit amet sed ex. Maecenas a vestibulum metus. Nunc malesuada dolor dui. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In et urna risus.

Nunc vulputate quis odio a sagittis. Nam malesuada malesuada tellus, nec fermentum orci tincidunt ultricies. Praesent sit amet congue velit. Mauris dictum scelerisque mi vel euismod. Donec pulvinar, mauris eget placerat consectetur, est turpis sodales justo, non convallis turpis tortor vitae augue. Donec lobortis erat sit amet cursus tristique. Mauris vel tempus velit.

In vitae tellus et elit hendrerit posuere. Nullam ac sagittis enim, et tristique mi. Proin laoreet augue quis orci rhoncus aliquam. Donec velit erat, sollicitudin ac arcu nec, fringilla facilisis dui. Vestibulum sed rutrum dolor. Sed maximus egestas odio eu suscipit. Fusce et bibendum ante. Duis dignissim tortor non lobortis tincidunt. Nullam vitae sagittis felis. Sed auctor imperdiet mauris. Sed mollis neque ut nisl feugiat rutrum. Donec sit amet diam et ante dapibus gravida. Nam viverra urna posuere eros feugiat, ut placerat massa dapibus. Aenean facilisis at mi vel commodo.

Morbi elementum tellus ipsum. Curabitur commodo risus id augue tincidunt vestibulum. Morbi scelerisque nibh vel augue faucibus, in eleifend elit hendrerit. Donec consectetur, odio eget convallis consectetur, metus augue malesuada ante, quis condimentum lacus lorem non velit. Proin ut viverra turpis. Curabitur condimentum congue maximus. Sed congue purus eget rutrum congue. Aliquam bibendum augue arcu. Mauris vel volutpat nibh nibh. 
"

# ╔═╡ 8443dbc2-70aa-4ebf-b12a-052170106330
reading_time(; style=:detailed)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"

[compat]
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.6"
manifest_format = "2.0"
project_hash = "7cfac8617422d64721b91bd687def76a3688061f"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "372b90fe551c019541fafc6ff034199dc19c8436"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.12"
"""

# ╔═╡ Cell order:
# ╠═cec46184-6f17-4c74-9d01-ea21f1b276d3
# ╠═9abf5402-c506-4c8d-8cb2-4035cb179b85
# ╠═fe6b6374-1209-45f0-b593-f5efdb28e821
# ╠═cd42ce90-6790-4d03-808e-7e4f206323ad
# ╠═3759fa8b-d992-451b-b57d-9898002627e6
# ╠═d4a16be1-2dbc-4625-92d0-8e1897247b5e
# ╟─cb1e6a6f-1201-4fcd-a805-863c29938be2
# ╠═8443dbc2-70aa-4ebf-b12a-052170106330
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
