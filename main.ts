
var clockComponent = new clock(document.getElementById("timeline") as HTMLCanvasElement,200);
var register = new binaryCell(document.getElementById("timeline2") as HTMLCanvasElement);
var enableButton = new toggleSwitch(document.getElementById("componentsCanvas"),"enable");
var dataButton = new toggleSwitch(document.getElementById("componentsCanvas"),"data");

register.clockPin = clockComponent.outputPin;
register.enablePin = enableButton.outputPin;
register.dataPin = dataButton.outputPin;

//TODO - this will probably not work for more complex circuits - 
//may need to be evaluated in topological order in a delay based manner...
setInterval(()=>{
register.update();
},100)

clockComponent.startClock();



