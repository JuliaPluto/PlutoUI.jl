var inputLeft = currentScript.closest("pluto-output").querySelector("#input-left");
var inputRight = currentScript.closest("pluto-output").querySelector("#input-right");
var thumbLeft = currentScript.closest("pluto-output").querySelector(".slider > .thumb.left");
var thumbRight = currentScript.closest("pluto-output").querySelector(".slider > .thumb.right");
var range = currentScript.closest("pluto-output").querySelector(".slider > .range");
var values = currentScript.closest("pluto-output").querySelector(".values");
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
    
	values.value = returnValue;	
    values.dispatchEvent(new CustomEvent("input"));
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
    
	values.value = returnValue;
    values.dispatchEvent(new CustomEvent("input"));
}
setRightValue();

inputLeft.addEventListener("input", setLeftValue);
inputRight.addEventListener("input", setRightValue);

function updateValues() {
    var display = currentScript.closest("pluto-output").querySelector("#slider-output");
    display.value = (inputLeft.step == 1) ? `${inputLeft.value}:${inputRight.value}` 
                        : `${inputLeft.value}:${inputLeft.step}:${inputRight.value}`;
}