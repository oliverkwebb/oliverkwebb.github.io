let circle_sec_div = document.getElementById("circle-sec");

function init_circle_sec(csdiv) {
	csdiv.innerHTML=`
		<input id="circle-sec-1" type="range" min="0" max="360" step="any" style="width: 60%;"> <label>Position X</label>
		</br>
		<input id="circle-sec-2" type="range" min="0" max="360" step="any" style="width: 60%;"> <label>Position Y</label>
		<p id="circle-sec-render">
		</p>
	`;
}

init_circle_sec(circle_sec_div);
let circle_sec_render = document.querySelector("#circle-sec-render");
let circle_sec_inp1 = document.querySelector("#circle-sec-1");
let circle_sec_inp2 = document.querySelector("#circle-sec-2");

function render_circle_sec(csrdiv, ang1, ang2) {
	let d = Math.abs(ang1 - ang2);
	if (d > 180) {
		d = 180 - (d-180);
	}
	let drad = d * (Math.PI / 180);
	let crd  = 2 * Math.sin(drad/2);
	csrdiv.innerHTML = `
	<table>
	<tr><td>Angle X</td><td>${ang1.toFixed(2)}</td></tr>
	<tr><td>Angle Y</td><td>${ang2.toFixed(2)}</td></tr>
	<tr><td>Distance</td><td>${d.toFixed(2)}</td></tr>
	<tr><td>Chord</td><td>${crd.toFixed(2)}</td></tr>
	<tr><td>Ratio</td><td>${(drad/crd).toFixed(3)}</td></tr>
	</table>
	`
}

circle_sec_inp1.addEventListener("input", (ev) => render_circle_sec(circle_sec_render, Number(circle_sec_inp1.value), Number(circle_sec_inp2.value)));
circle_sec_inp2.addEventListener("input", (ev) => render_circle_sec(circle_sec_render, Number(circle_sec_inp1.value), Number(circle_sec_inp2.value)));

render_circle_sec(circle_sec_render, 180, 180);
