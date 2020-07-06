# STILL WORK IN PROGRESS
# include in PlutoUI.jl when done <3

export ImageInput

struct ImageInput
    use_camera::Bool
    default_url::AbstractString
    maxsize::Integer
end

function show(io::IO, ::MIME"text/html", img::ImageInput)
    result = if img.use_camera

    else
        """
        <span>
        <input type='file' accept="image/*">
        <script>
        const span = this.currentScript.parentElement
        const input = span.querySelector("input")
        const img = html`<img crossOrigin="anonymous">`
        
        const maxsize = $(img.maxsize)
        
        img.onload = () => {
            const scale = Math.min(1.0, maxsize / img.width, maxsize / img.height)
        
            const width = Math.floor(img.width * scale)
            const height = Math.floor(img.height * scale)
        
            const canvas = html`<canvas width=\${width} height=\${height}>`
            const ctx = canvas.getContext("2d")
            ctx.drawImage(img, 0, 0, width, height)
        
            span.value = {
                width: width,
                height: height,
                data: Array.from(ctx.getImageData(0, 0, width, height).data),
            }
            span.dispatchEvent(new CustomEvent("input"))
        }
        
        input.oninput = (e) => {
            img.src = URL.createObjectURL(input.files[0])
            e.stopPropagation()
        }
        
        // set default URL so that you have something to look at:
        img.src = "$(img.default_url)"
        
        </script>
        </span>
        """
    end
    write(io, result)
end

# the default is a 0x0 image
get(img::ImageInput) = zeros(Float64, 0, 0)