/* 
 Slider styling javascript after  Márk Munkácsi. 
 This was public on codepen, so it is MIT: https://blog.codepen.io/documentation/licensing/
 See  https://dev.to/munkacsimark/styled-range-input-a-way-out-of-range-input-nightmare-jeo , 
 also for explanations.


 The javascript is used to set the progress bar.
*/

// Unmodified from the original (see above)
const handleInput = (inputElement) => {
  let isChanging = false;

    const setCSSProperty = () => {
    const percent =
      ((inputElement.value - inputElement.min) /
      (inputElement.max - inputElement.min)) *
      100;
    // Here comes the magic 🦄🌈
    inputElement.style.setProperty("--webkitProgressPercent", `${percent}%`);
  }

  // Set event listeners
  const handleMove = () => {
    if (!isChanging) return;
    setCSSProperty();
  };
  const handleUpAndLeave = () => isChanging = false;
  const handleDown = () => isChanging = true;

  inputElement.addEventListener("mousemove", handleMove);
  inputElement.addEventListener("mousedown", handleDown);
  inputElement.addEventListener("mouseup", handleUpAndLeave);
  inputElement.addEventListener("mouseleave", handleUpAndLeave);
  inputElement.addEventListener("click", setCSSProperty);

  // Init input
  setCSSProperty();
}


// This was the original code which would affect all sliders at once:

// const inputElements = document.querySelectorAll('[type="range"]');
// inputElements.forEach(handleInput)


// Modification for handle  only the currenly created slider in pluto.
// need to go two elements back because of the <output> follwing
// directly the <input>
const slider = (currentScript ?? this.currentScript).previousElementSibling.previousElementSibling
handleInput(slider)
