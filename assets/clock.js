// const clock = this.querySelector("clock")
const clock = (currentScript ?? this.currentScript).previousElementSibling
const tpsInput = clock.querySelector("input")
const analogfront = clock.querySelector("plutoui-analog plutoui-front")
const analogzoof = clock.querySelector("plutoui-analog plutoui-zoof")
const unit = clock.querySelector("span#unit")
const button = clock.querySelector("button")

const max_value = +clock.dataset.maxValue
const repeat = clock.dataset.repeat === "true"

var t = (clock.value = 1)
var starttime = null
var dt = 1

tpsInput.oninput = (e) => {
    dt = tpsInput.valueAsNumber
    if (clock.classList.contains("inverted")) {
        dt = 1.0 / dt
    }
    dt = dt == Infinity || dt == 0 ? 1e9 : dt
    analogzoof.style.opacity = 0.8 - Math.pow(dt, 0.2)
    analogfront.style.animationDuration = dt + "s"
    e && e.stopPropagation()
}
tpsInput.oninput()

analogfront.onanimationiteration = (e) => {
    if (!clock.classList.contains("stopped")) {
        const running_time = (Date.now() - starttime) / 1000
        t = Math.max(t + 1, Math.floor(running_time / dt))
        if (!isNaN(max_value)) {
            if (repeat) {
                if(t > max_value) {
                    t = 1
                    starttime = Date.now()
                }
            } else {
                if (t >= max_value) {
                    clock.classList.add("stopped")
                    t = max_value
                }
            }
        }
        clock.value = t
        clock.dispatchEvent(new CustomEvent("input"))
    }
}
unit.onclick = (e) => {
    clock.classList.toggle("inverted")
    tpsInput.oninput()
}
button.onclick = (e) => {
    starttime = Date.now()
    clock.classList.toggle("stopped")
    if (!clock.classList.contains("stopped")) {
        t = 1
    }
}
