function chooseColor(value) {
  var redPhase = 0;
  var greenPhase = 0.33 * Math.PI;
  var bluePhase = 0.66 * Math.PI;

  var frequency = Math.PI * 2 / 100;

  var red = Math.sin(value * frequency + redPhase) * 128;
  var green = Math.sin(value * frequency + greenPhase) * 128;
  var blue = Math.sin(value * frequency + bluePhase) * 128;

  return [parseInt(red, 10) + 128, parseInt(green, 10) + 128, parseInt(blue, 10) + 128];
}
