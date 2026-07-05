/*Calendar dashboard*/
document.addEventListener("DOMContentLoaded", function() {

	const monthYear =
		document.getElementById("monthYear");

	const calendarDays =
		document.getElementById("calendarDays");

	let currentDate = new Date();

	function renderCalendar() {

		let year = currentDate.getFullYear();
		let month = currentDate.getMonth();

		let firstDay =
			new Date(year, month, 1).getDay();

		let totalDays =
			new Date(year, month + 1, 0).getDate();

		monthYear.innerHTML =
			currentDate.toLocaleString(
				'default',
				{
					month: 'long',
					year: 'numeric'
				});

		calendarDays.innerHTML = "";

		for (let i = 0; i < firstDay; i++) {
			calendarDays.innerHTML += "<div></div>";
		}

		let today = new Date();

		for (let day = 1; day <= totalDays; day++) {

			let className = "";

			if (
				day === today.getDate() &&
				month === today.getMonth() &&
				year === today.getFullYear()
			) {
				className = "today";
			}

			calendarDays.innerHTML +=
				`<div class="${className}">
                ${day}
            </div>`;
		}
	}

	document.getElementById("prevMonth")
		.addEventListener("click", function() {
			currentDate.setMonth(
				currentDate.getMonth() - 1
			);
			renderCalendar();
		});

	document.getElementById("nextMonth")
		.addEventListener("click", function() {
			currentDate.setMonth(
				currentDate.getMonth() + 1
			);
			renderCalendar();
		});

	renderCalendar();

});