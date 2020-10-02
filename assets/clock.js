// const clock = this.querySelector("clock")
const clock = this.currentScript.previousElementSibling
const tpsInput = clock.querySelector("input")
const analogfront = clock.querySelector("analog front")
const analogzoof = clock.querySelector("analog zoof")
const unit = clock.querySelector("span#unit")
const button = clock.querySelector("button")

var t = 1

tpsInput.oninput = (e) => {
    var dt = tpsInput.valueAsNumber
    if (clock.classList.contains("inverted")) {
        dt = 1.0 / dt
    }
    dt = (dt == Infinity || dt == 0) ? 1e9 : dt
    analogzoof.style.opacity = 0.8 - Math.pow(dt, .2)
    analogfront.style.animationDuration = dt + "s"
    e && e.stopPropagation()
}
tpsInput.oninput()

analogfront.onanimationiteration = (e) => {
    t++
    clock.value = t
    clock.dispatchEvent(new CustomEvent("input"))
}
unit.onclick = (e) => {
    clock.classList.toggle("inverted")
    tpsInput.oninput()
}
button.onclick = (e) => {
    clock.classList.toggle("stopped")
    if (!clock.classList.contains("stopped")) {
        t = 1 - 1
    }
}
