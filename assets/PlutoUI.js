// window.customPlutoListeners["⚡"] = ...

function onPlutoUIChange(e) {
    console.log(e)

    window.client.sendreceive("PlutoUI_update", {
        sym: e.target.getAttribute("defines"),
        val: e.target.valueAsNumber,
    })
}

document.addEventListener("celloutputchanged", (e) => {
    console.log(e)
    const cellNode = e.detail.cell
    const mime = e.detail.mime
    if(mime != "text/html"){
        return
    }

    const inputs = cellNode.querySelectorAll("input.⚡")

    console.log(inputs)

    inputs.forEach(input => {
        input.addEventListener("input", onPlutoUIChange)
    })

}, false)

console.log("⚡ addon loaded")
