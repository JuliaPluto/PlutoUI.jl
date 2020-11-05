const container = currentScript.parentElement
const inputLeft = container.querySelector("#input-left");
const inputRight = container.querySelector("#input-right");
const thumbLeft = container.querySelector(".slider > .thumb.left");
const thumbRight = container.querySelector(".slider > .thumb.right");
const range = container.querySelector(".slider > .range");
const display = container.querySelector("#slider-output")

const min = parseFloat(inputLeft.min);
const max = parseFloat(inputLeft.max);

function setLeftValue() {
	inputLeft.value = Math.min(parseFloat(inputLeft.value), parseFloat(inputRight.value));

	const percent = ((inputLeft.value - min) / (max - min)) * 100;

	thumbLeft.style.left = percent + "%";
	range.style.left = percent + "%";

	const leftValue = parseFloat(inputLeft.value),
		rightValue = parseFloat(inputRight.value);

	if (rightValue === leftValue) {
		inputRight.hidden = true;
	} else {
		inputRight.hidden = false;
    }
    
	var returnValue = []
	var i = leftValue;
	while (i <= rightValue) {
		returnValue.push(i);
		i += parseFloat(inputLeft.step);
    }
    
	container.value = returnValue;	
    container.dispatchEvent(new CustomEvent("input"));
}
setLeftValue();

function setRightValue() {
    inputRight.value = Math.max(parseFloat(inputRight.value), parseFloat(inputLeft.value));
    
	const percent = ((inputRight.value - min) / (max - min)) * 100;
    
	thumbRight.style.right = (100 - percent) + "%";
	range.style.right = (100 - percent) + "%";
    
	const leftValue = parseFloat(inputLeft.value),
        rightValue = parseFloat(inputRight.value);
    
	if(rightValue === leftValue) {
        inputLeft.hidden = true;
	} else {
        inputLeft.hidden = false;
    }
    
	var returnValue = []
	var i = leftValue;
	while (i <= rightValue) {
        returnValue.push(i);
		i += parseFloat(inputLeft.step);
    }
    
	container.value = returnValue;
    container.dispatchEvent(new CustomEvent("input"));
}
setRightValue();

inputLeft.addEventListener("input", setLeftValue);
inputRight.addEventListener("input", setRightValue);

function updateDisplay() {
	if(display != null) {
		display.value = (inputLeft.step == 1) ? `${inputLeft.value}:${inputRight.value}` 
							: `${inputLeft.value}:${inputLeft.step}:${inputRight.value}`;
	}
}
inputLeft.addEventListener("input", updateDisplay)
inputRight.addEventListener("input", updateDisplay)
updateDisplay()