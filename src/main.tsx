import { toggleSwitch, nRegister } from "./primitives";
import { clock } from "./clock";


/** 
var clockComponent = new clock(200,document.getElementById("timeline") as HTMLCanvasElement);
var enableButton = new toggleSwitch(document.getElementById("componentsCanvas"), "enable");

var register = new nRegister(clockComponent.outputPin, enableButton.outputPin,8, document.getElementById("timeline2") as HTMLCanvasElement);
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
*/

import * as React from 'react';
import * as ReactDOM from 'react-dom';

const App = () => {
  return (
    <div>
      <p>Hello world!</p>
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('app'));


