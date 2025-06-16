
document.addEventListener("DOMContentLoaded", (e) => {
});

//const seatInput = document.querySelectorAll('input[type="checkbox"]');
const selectedSeatText = document.getElementById('seat-selected-list');
const seatSelectionWrapper = document.querySelector('.seat-selection-wrapper');
let seatMax = 10;

const confirmButton = document.getElementById("confirmButton");
if(confirmButton){
    confirmButton.addEventListener("click", function (e) {
        if (seatSelectionWrapper.hasAttribute("data-seat-booked") && selectedSeat.length !== seatMax) {
            e.preventDefault();
            alert(`Please select exactly ${seatMax} seat${seatMax > 1 ? 's' : ''}.`);
        }
    });
    
}


if (seatSelectionWrapper) {
    if (seatSelectionWrapper.hasAttribute("data-seat-booked")) {
        seatMax = parseInt(seatSelectionWrapper.getAttribute("data-seat-booked"));
    }
}

let selectedSeat = [];
function addSeat(id) {

    const label = document.querySelector(`label[for="${id}"]`);
    const checkbox = document.getElementById(id);

    if (!label.classList.contains("reserved")) {
        if (label.classList.contains("available")) {
            if (selectedSeat.length < seatMax) {
                label.classList.remove("available");
                label.classList.add("selected");
                selectedSeat.push(id);
            } else {
                if (seatSelectionWrapper.hasAttribute("data-seat-booked")) {
                    alert(`Please select ${seatMax} seat${seatMax > 1 ? 's' : ''}`);
                } else {
                    alert("Cannot book more than " + seatMax + " tickets for one purchase.");
                }
                checkbox.checked = false;
            }
        } else if (label.classList.contains("selected")) {
            label.classList.remove("selected");
            label.classList.add("available");
            selectedSeat = selectedSeat.filter(seat => seat !== id);
        }

        // Optional: Update selected seat list in real-time
        document.getElementById('seat-selected-list-text').innerText = selectedSeat.join(", ");
    }

    // Function to toggle the visibility of the submit button based on checkbox selection
    var checkboxes = document.getElementsByName("seat"); // Get all checkboxes with name 'option'
    var selectedSeatPara = document.querySelector(".selected-seat-text");
    var submitButton = document.getElementById("submitButton"); // Get the submit button
//    var anyChecked = false;
//
//    // Loop through checkboxes to check if any is checked
//    for (var i = 0; i < checkboxes.length; i++) {
//        if (checkboxes[i].checked) {
//            anyChecked = true;
//            break;
//        }
//    }

    // Only enforce exact seat count if it's an edit-booking page (has data-seat-booked)
    if (seatSelectionWrapper.hasAttribute("data-seat-booked")) {
        if (selectedSeat.length >0) {
            selectedSeatPara.style.display = "block";
            if(selectedSeat.length === seatMax){
            submitButton.style.display = "inline-block";
            }
        } else {
            selectedSeatPara.style.display = "none";
            submitButton.style.display = "none";
        }
    } else {
        // On regular booking page: allow up to seatMax (not exact match)
        if (selectedSeat.length > 0 && selectedSeat.length <= seatMax) {
            selectedSeatPara.style.display = "block";
            submitButton.style.display = "inline-block";
        } else {
            selectedSeatPara.style.display = "none";
            submitButton.style.display = "none";
        }
    }

    // Show or hide the submit button based on the checkbox selection
//    if (anyChecked) {
//        selectedSeatPara.style.display = "block"; // Show selected seat if at least one checkbox is selected
//        submitButton.style.display = "inline-block"; // Show button if at least one checkbox is selected
//    } else {
//        selectedSeatPara.style.display = "none"; // Hide selected seat if no checkbox is selected
//        submitButton.style.display = "none"; // Hide button if no checkbox is selected
//        console.log(submitButton.style.display);
//
//    }
}



// Function to edit the modal content
const confirmModal = document.getElementById('confirmModal');
if (confirmModal) {

    confirmModal.addEventListener('shown.bs.modal', function () {
        const tableBody = document.querySelector("#confirmModal table tbody");
        tableBody.innerHTML = "";
        let totalPrice = 0;



        selectedSeat.forEach(seatId => {
            const checkbox = document.getElementById(seatId);
            const price = parseFloat(checkbox.dataset.price || 0);
            totalPrice += price;
            const row = document.createElement("tr");

            row.innerHTML = `<td>SINGLE SEAT - ${seatId}</td>`;
            if (!seatSelectionWrapper.hasAttribute("data-seat-booked")) {
                row.innerHTML += `<td>RM ${price.toFixed(2)}</td>`;
            }

            tableBody.appendChild(row);
        });
        if (!seatSelectionWrapper.hasAttribute("data-seat-booked")) {

            //  add total price row
            const totalRow = document.createElement("tr");
            totalRow.innerHTML = `
        <td class="fw-bold">Total</td>
        <td class="fw-bold">RM ${totalPrice.toFixed(2)}</td>
    <input type="hidden" name="total-price" value="${totalPrice.toFixed(2)}"/>
    `;
            tableBody.appendChild(totalRow);
        }

    });
}





//Format date in date selection
//function updateDateFormat() {
//
//    let inputCheckboxes = document.querySelectorAll(".date-input");
//
//    inputCheckboxes.forEach((checkbox) => {
//        const rawDate = checkbox.getAttribute('data-date');
//        const formatted = formatDateString(rawDate);
//        const label = checkbox.nextElementSibling;
//        if (label && label.classList.contains('date-label')) {
//            label.textContent = `${formatted}`;
//        }
//    });
//}

//Formate time in time selection
//function updateTimeFormat() {
//
//    let inputCheckboxes = document.querySelectorAll(".time-input");
//
//    inputCheckboxes.forEach((checkbox) => {
//        const rawDate = checkbox.getAttribute('data-time');
//        const formatted = formatTimeString(rawDate);
//        const label = checkbox.nextElementSibling;
//        if (label && label.classList.contains('time-label')) {
//            label.textContent = `${formatted}`;
//        }
//    })
//}

// Function to save the current scroll position
function saveScrollPosition() {
    sessionStorage.setItem('scrollPosition', window.scrollY);
}

function updateDateAndTime() {
//let inputCheckboxes = document.querySelectorAll(".time-input");
//
//    inputCheckboxes.forEach((checkbox) => {
//        const rawDate = checkbox.getAttribute('data-time');
//        const formatted = formatTimeString(rawDate);
//        const label = checkbox.nextElementSibling;
//        if (label && label.classList.contains('time-label')) {
//            label.textContent = `${formatted}`;
//        }
//    })
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);

    let date = urlParams.get("date");
    let time = urlParams.get("time");


    if (date !== null) {
        let dateCheckboxes = document.querySelectorAll(".date-input");
        dateCheckboxes.forEach((checkbox) => {
            let dateVal = checkbox.getAttribute("data-date");
            if (dateVal === date) {
                // Remove the "Selected" class from all radio buttons
                var radios = document.querySelectorAll('input[name="date"]');
                radios.forEach(function (radio) {
                    radio.classList.remove("selected");
                });

                // Add a class "Selected" to the selected radio button
                checkbox.classList.add("selected");
                checkbox.checked = true;
            }
        });
        // Disable the selected radio button dynamically
        disableSelectedRadioButtonDate();
    }
    if (time !== null) {
        let timeCheckboxes = document.querySelectorAll(".time-input");
        timeCheckboxes.forEach((checkbox) => {
            let timeVal = checkbox.getAttribute("data-time");
            if (timeVal == time) {
                // Remove the "Selected" class from all radio buttons
                var radios = document.querySelectorAll('input[name="time"]');
                radios.forEach(function (radio) {
                    radio.classList.remove("selected");
                });

                // Add a class "Selected" to the selected radio button
                checkbox.classList.add("selected");
                checkbox.checked = true;
                // Disable the already selected radio button dynamically
            }
        }
        )
        disableSelectedRadioButtonTime();
    }


}




//Check date and select
function checkDate() {
    saveScrollPosition();

    // Get the selected radio button
    var date = document.querySelector('input[name="date"]:checked');
    // If no radio button is selected, exit
    if (!date)
        return;

    var dateValue = date.value; // Get the value of the selected date

    saveScrollPosition();

    // Get the selected radio button
    var date = document.querySelector('input[name="date"]:checked');
    if (!date)
        return;

    var dateValue = date.value;

    // Use the URL and URLSearchParams API
    var currentUrl = new URL(window.location.href);
    var params = currentUrl.searchParams;


    // Remove the "time" parameter (since a new date will have different times)
    params.delete("time");
    // Set or update the "date" parameter (preserve all others)
    params.set("date", dateValue);
    currentUrl.search = params.toString();

    // Update the URL without reloading the page
    history.pushState(null, null, currentUrl.toString());

// Disable the already selected radio button dynamically
    disableSelectedRadioButtonDate();


    // Reload the page
    location.reload();


//    // Update the URL without reloading the page
//    history.pushState(null, null, url.toString());
//
//    // Trigger the page reload (reload with the updated URL)
//    location.reload();
}

//Check time and select
function checkTime() {
    saveScrollPosition();
    // Get the selected radio button
    var date = document.querySelector('input[name="time"]:checked');
    // If no radio button is selected, exit
    if (!date)
        return;

    var dateValue = date.value; // Get the value of the selected date
    var currentUrl = window.location.href; // Get the current URL

    var separator = currentUrl.indexOf('?') === -1 ? '?' : '&';

    // Handle the date parameter in the URL
    if (currentUrl.indexOf("time=") === -1) {
        var newUrl = currentUrl + separator + "time=" + dateValue;
    } else {
        var newUrl = currentUrl.replace(/([&?])time=[^&]*/, '$1time=' + dateValue);
        if (!newUrl.includes('time=')) {
            newUrl = currentUrl + separator + "time=" + dateValue;
        }
    }

    // Update the URL without reloading the page
    history.pushState(null, null, newUrl);

    // Disable the already selected radio button dynamically
    disableSelectedRadioButtonTime();

    // Trigger the page reload (reload with the updated URL)
    location.reload();
}

function disableSelectedRadioButtonDate() {

    var selectedRadio = document.querySelector('input[name="date"]:checked');
    if (selectedRadio) {
        selectedRadio.disabled = true;
    }

    // Optionally: Disable other radios based on conditions
    var radios = document.querySelectorAll('input[name="date"]');
    radios.forEach(function (radio) {
        // Check if the radio is already selected
        if (radio.value !== selectedRadio.value) {
            radio.disabled = false;
        }
    });
}

function disableSelectedRadioButtonTime() {
    var selectedRadio = document.querySelector('input[name="time"]:checked');
    if (selectedRadio) {
        selectedRadio.disabled = true;
    }

    // Disable other radios based on conditions
    var radios = document.querySelectorAll('input[name="time"]');
    radios.forEach(function (radio) {
        // Check if the radio is already selected
        if (radio.value !== selectedRadio.value) {
            radio.disabled = false;
        }
    });
}


// Function to restore the scroll position after the page reloads
function restoreScrollPosition() {
    var savedScrollPosition = sessionStorage.getItem('scrollPosition');
    if (savedScrollPosition) {
        window.scrollTo(0, savedScrollPosition);
        sessionStorage.removeItem('scrollPosition'); // Clear the saved position after restoring it
    }
}

// Call this function on page load (or after the page reloads)
window.onload = function () {
    restoreScrollPosition();
    updateDateAndTime();
};