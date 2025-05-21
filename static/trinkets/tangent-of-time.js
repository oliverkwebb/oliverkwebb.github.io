function time_string3() {
	let d = new Date();
	let h = d.getHours();
	let m = d.getMinutes();
	let s = d.getSeconds();
	let deg = (h + (m/60) + (s / 3600))*15;
	let rad = (deg*(Math.PI/180));
	return `sin: ${Math.sin(rad).toFixed(3)}, cos: ${Math.cos(rad).toFixed(3)}</br>tan: ${Math.tan(rad).toFixed(3)}, sec: ${(1/Math.cos(rad)).toFixed(3)}</br>cot: ${(1/Math.tan(rad)).toFixed(3)}, csc: ${(1/Math.sin(rad)).toFixed(3)}`
}

function updatebox3() {
	document.getElementById("tbox3").innerHTML = time_string3();
}

function initbox3() {
	let e = document.getElementById("tangent-of-time");

	e.style["text-align"] = "center";
	e.innerHTML = "Current Time:</br><p id=\"tbox3\"></p>"
}

initbox3();
updatebox3();
setInterval(updatebox3, 1000);
