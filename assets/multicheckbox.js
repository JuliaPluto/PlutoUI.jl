const container = (currentScript ? currentScript : this.currentScript)
  .previousElementSibling;

const my_id = crypto.getRandomValues(new Uint32Array(1))[0].toString(36)

// Add checkboxes
const inputEls = [];
for (let i = 0; i < labels.length; i++) {
  const boxId = `${my_id}-box-${i}`;

  const item = document.createElement("div");

  const checkbox = document.createElement("input");
  checkbox.type = "checkbox";
  checkbox.id = boxId;
  checkbox.name = labels[i];
  checkbox.value = values[i];
  checkbox.checked = checked[i];
  inputEls.push(checkbox);
  item.appendChild(checkbox);

  const label = document.createElement("label");
  label.htmlFor = boxId;
  label.innerText = labels[i];
  item.appendChild(label);

  container.appendChild(item);
}

function setValue() {
  container.value = inputEls.filter((o) => o.checked).map((o) => o.value);
}
// Add listeners
function sendEvent() {
  setValue()
  container.dispatchEvent(new CustomEvent("input"));
}

function updateSelectAll() {}

if (includeSelectAll) {
  // Add select-all checkbox.
  const selectAllItem = document.createElement("div");
  selectAllItem.classList.add(`select-all`);

  const selectID = `${my_id}-select-all`
  
  const selectAllInput = document.createElement("input");
  selectAllInput.type = "checkbox";
  selectAllInput.id = selectID;
  selectAllItem.appendChild(selectAllInput);

  const selectAllLabel = document.createElement("label");
  selectAllLabel.htmlFor = selectID;
  selectAllLabel.innerText = "Select All";
  selectAllItem.appendChild(selectAllLabel);

  container.prepend(selectAllItem);

  function onSelectAllClick(event) {
    event.stopPropagation();
    inputEls.forEach((o) => (o.checked = this.checked));
    sendEvent();
  }
  selectAllInput.addEventListener("click", onSelectAllClick);

  /// Taken from: https://stackoverflow.com/questions/10099158/how-to-deal-with-browser-differences-with-indeterminate-checkbox
  /// Determine the checked state to give to a checkbox
  /// with indeterminate state, so that it becomes checked
  /// on click on IE, Chrome and Firefox 5+
  function getCheckedStateForIndeterminate() {
    // Create a unchecked checkbox with indeterminate state
    const test = document.createElement("input");
    test.type = "checkbox";
    test.checked = false;
    test.indeterminate = true;

    // Try to click the checkbox
    const body = document.body;
    body.appendChild(test); // Required to work on FF
    test.click();
    body.removeChild(test); // Required to work on FF

    // Check if the checkbox is now checked and cache the result
    if (test.checked) {
      getCheckedStateForIndeterminate = function () {
        return false;
      };
      return false;
    } else {
      getCheckedStateForIndeterminate = function () {
        return true;
      };
      return true;
    }
  }

  updateSelectAll = function () {
    const checked = inputEls.map((o) => o.checked);
    if (checked.every((x) => x)) {
      selectAllInput.checked = true;
      selectAllInput.indeterminate = false;
    } else if (checked.some((x) => x)) {
      selectAllInput.checked = getCheckedStateForIndeterminate();
      selectAllInput.indeterminate = true;
    } else {
      selectAllInput.checked = false;
      selectAllInput.indeterminate = false;
    }
  };
  // Call once at the beginning to initialize.
  updateSelectAll();
}

function onItemClick(event) {
  event.stopPropagation();
  updateSelectAll();
  sendEvent();
}
setValue()
inputEls.forEach((el) => el.addEventListener("click", onItemClick));
