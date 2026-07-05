/*Admin sidebar submenu buttons*/
document.addEventListener("DOMContentLoaded", function() {

	const submenuBtn =
		document.querySelector(".submenu-btn");

	const submenu =
		document.querySelector(".submenu");

	submenuBtn.addEventListener("click", function() {

		submenu.classList.toggle("active");

	});

});


/* Employee Section Script */
const fromDate = document.getElementById("fromDate");

const toDate = document.getElementById("toDate");

const totalDays = document.getElementById("totalDays");

function calculateDays() {

	if (fromDate.value && toDate.value) {

		let start = new Date(fromDate.value);

		let end = new Date(toDate.value);

		let diff = end - start;

		let days = (diff / (1000 * 60 * 60 * 24)) + 1;

		totalDays.value = days > 0 ? days : 0;
	}
}

fromDate.addEventListener("change", calculateDays);

toDate.addEventListener("change", calculateDays);