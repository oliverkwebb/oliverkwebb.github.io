function lpr(x, y) {
  let z = x % y;
  if (z < 0) {
    return z + y;
  } else {
    return z;
  }
}
Math.fract = (x) => lpr(x, 1);
function time_string2() {
	let d = new Date();
	let h = d.getHours();
	let m = d.getMinutes();
	let s = d.getSeconds();
	let deg = (h + (m/60) + (s / 3600))*15;
	let dr = [Math.trunc(deg), Math.trunc(Math.fract(deg) * 60), Math.fract(Math.fract(deg) * 60) * 60];
	return `${dr[0]}°${dr[1]}'${dr[2].toFixed(0)}"</br>${(deg*(Math.PI/180)).toFixed(2)} rad</br>${(deg/360).toFixed(3)} turns`
}

function updatebox2() {
	document.getElementById("tbox2").innerHTML = time_string2();
}

function initbox2() {
	let e = document.getElementById("current-time-angle");

	e.style["text-align"] = "center";
	e.innerHTML = "Current Time:</br><p id=\"tbox2\"></p>"
}

initbox2();
updatebox2();
setInterval(updatebox2, 1000);
