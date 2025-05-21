function time_string() {
	return new Date().toTimeString().split(' ')[0];
}

function updatebox() {
	document.getElementById("tbox").innerHTML = time_string();
}

function initbox() {
	let e = document.getElementById("current-time");

	e.style["text-align"] = "center";
	e.innerHTML = "Current Time:</br><p id=\"tbox\"></p>"
	let b = document.getElementById("tbox");
}

initbox();
updatebox();
setInterval(updatebox, 1000);
