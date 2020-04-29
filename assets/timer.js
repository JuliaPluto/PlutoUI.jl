const timer = this.querySelector("timer")
const tpsInput = timer.querySelector("input")
const clockfront = timer.querySelector("clock front")
const clockzoof = timer.querySelector("clock zoof")
const unit = timer.querySelector("span#unit")
const button = timer.querySelector("button")

var t = 1

tpsInput.oninput = (e) => {
    var dt = tpsInput.valueAsNumber
    if (timer.classList.contains("inverted")) {
        dt = 1.0 / dt
    }
    dt = (dt == Infinity || dt == 0) ? 1e9 : dt
    clockzoof.style.opacity = 0.8 - Math.pow(dt, .2)
    clockfront.style.animationDuration = dt + "s"
    e && e.stopPropagation()
}
tpsInput.oninput()

clockfront.onanimationiteration = (e) => {
    t++
    timer.value = t
    timer.dispatchEvent(new CustomEvent("input"))
}
unit.onclick = (e) => {
    timer.classList.toggle("inverted")
    tpsInput.oninput()
}
button.onclick = (e) => {
    timer.classList.toggle("stopped")
    if (!timer.classList.contains("stopped")) {
        t = 1 - 1
    }
}