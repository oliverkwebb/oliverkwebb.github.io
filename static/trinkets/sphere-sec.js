let sphere_sec_div = document.getElementById("sphere-sec");

function init_sphere_sec(ssdiv) {
	ssdiv.innerHTML=`
		<input id="sphere-sec-1" type="range" min="-90" max="90" step="any" style="width: 60%;"> <label>Latitude X</label>
		</br>
		<input id="sphere-sec-2" type="range" min="-180" max="180" step="any" style="width: 60%;"> <label>Longitude X</label>
		</br>
		<input id="sphere-sec-3" type="range" min="-90" max="90" step="any" style="width: 60%;"> <label>Latitude Y</label>
		</br>
		<input id="sphere-sec-4" type="range" min="-180" max="180" step="any" style="width: 60%;"> <label>Longitude Y</label>
		<p id="sphere-sec-render">
		</p>
	`;
}

init_sphere_sec(sphere_sec_div);
let sphere_sec_render = document.querySelector("#sphere-sec-render");
let sphere_sec_inp1 = document.querySelector("#sphere-sec-1");
let sphere_sec_inp2 = document.querySelector("#sphere-sec-2");
let sphere_sec_inp3 = document.querySelector("#sphere-sec-3");
let sphere_sec_inp4 = document.querySelector("#sphere-sec-4");

function sphere_sec_angbetween(a1, d1, a2, d2) {
	return Math.acos(Math.cos(a1-a2) * Math.cos(d1) * Math.cos(d2) + Math.sin(d1) * Math.sin(d2));
}

function render_sphere_sec(ssrdiv, ang1, ang2, ang3, ang4) {
	let a1 = ang1 * (Math.PI/180);
	let a2 = ang2 * (Math.PI/180);
	let a3 = ang3 * (Math.PI/180);
	let a4 = ang4 * (Math.PI/180);
	let drad  = sphere_sec_angbetween(a1, a2, a3, a4);
	let d = drad * (Math.PI / 180);
	let crd  = 2 * Math.sin(drad/2);
	ssrdiv.innerHTML = `
	<table>
	<tr><td>LatLong X<td> ${ang1.toFixed(2)}, ${ang2.toFixed(2)}</td></tr>
	<tr><td>LatLong Y<td> ${ang3.toFixed(2)}, ${ang4.toFixed(2)}</td></tr>
	<tr><td>Distance (Radii)</td><td>${d.toFixed(2)}</td>
	<tr><td>Chord</td><td>${crd.toFixed(2)}</td></tr>
	<tr><td>Ratio</td><td>${(drad/crd).toFixed(3)}</td></tr>
	<tr><td>Distance (Earth, km)</td><td>${(crd*6371).toFixed(2)}km</td></tr>
	</table>
	`
}

sphere_sec_inp1.addEventListener("input", (ev) => render_sphere_sec(sphere_sec_render,
	Number(sphere_sec_inp1.value), Number(sphere_sec_inp2.value),
	Number(sphere_sec_inp3.value), Number(sphere_sec_inp4.value)
	));
sphere_sec_inp2.addEventListener("input", (ev) => render_sphere_sec(sphere_sec_render,
	Number(sphere_sec_inp1.value), Number(sphere_sec_inp2.value),
	Number(sphere_sec_inp3.value), Number(sphere_sec_inp4.value),
	));
sphere_sec_inp3.addEventListener("input", (ev) => render_sphere_sec(sphere_sec_render,
	Number(sphere_sec_inp1.value), Number(sphere_sec_inp2.value),
	Number(sphere_sec_inp3.value), Number(sphere_sec_inp4.value)
	));
sphere_sec_inp4.addEventListener("input", (ev) => render_sphere_sec(sphere_sec_render,
	Number(sphere_sec_inp1.value), Number(sphere_sec_inp2.value),
	Number(sphere_sec_inp3.value), Number(sphere_sec_inp4.value),
	));

render_sphere_sec(sphere_sec_render, 0, 0, 0, 0);
