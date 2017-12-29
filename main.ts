import { toggleSwitch, byteRegister } from "./primitives";
import { clock } from "./clock";



var clockComponent = new clock(document.getElementById("timeline") as HTMLCanvasElement, 200);
var enableButton = new toggleSwitch(document.getElementById("componentsCanvas"), "enable");

var register = new byteRegister(clockComponent.outputPin, enableButton.outputPin, document.getElementById("timeline2") as HTMLCanvasElement);
var dataButton = new toggleSwitch(document.getElementById("componentsCanvas"), "data128");

var dataButton2 = new toggleSwitch(document.getElementById("componentsCanvas"), "data64");


register.assignInputPin(dataButton.outputPin,0);
register.assignInputPin(dataButton2.outputPin,1);

//TODO - this will probably not work for more complex circuits - 
//may need to be evaluated in topological order in a delay based manner...
setInterval(() => {
    register.update();
}, 100)

clockComponent.startClock();



