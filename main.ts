

var clockComponent = new clock(document.getElementById("timeline") as HTMLCanvasElement,200);
var register = new byteRegister(document.getElementById("timeline2") as HTMLCanvasElement);
var enableButton = new toggleSwitch(document.getElementById("componentsCanvas"),"enable");

var dataButton = new toggleSwitch(document.getElementById("componentsCanvas"),"data128");
var dataButton2 = new toggleSwitch(document.getElementById("componentsCanvas"),"data64");





register.clockPin = clockComponent.outputPin;
register.enablePin = enableButton.outputPin;
register.dataPins[0] = dataButton.outputPin;
register.dataPins[1] = dataButton2.outputPin;

//TODO - this will probably not work for more complex circuits - 
//may need to be evaluated in topological order in a delay based manner...
setInterval(()=>{
register.update();
},100)

clockComponent.startClock();



