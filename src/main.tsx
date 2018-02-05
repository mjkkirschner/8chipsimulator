import { toggleSwitch, nRegister, Ipart } from "./primitives";
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
import { PartView } from "./views/partView";
import * as testHelpers from "../test/graphTestHelpers";
import * as _ from "underscore";
import { WireView } from "./views/wireView";
import { wire } from "./pins_wires";
import { stat } from "fs";
import { graph } from "./engine";
import { setInterval } from "timers";


class App extends React.Component {

  partElements: JSX.Element[];
  wireElements: JSX.Element[];

  boundsData: { [id: string]: ClientRect } = {};

  private updatePartModels(newModel: Ipart, newPos?: { x: number, y: number }, updateInPlace?: Boolean): JSX.Element {

    var output;
    this.partElements.forEach((x, i) => {
      if (x.props.model.id == newModel.id) {

        //let pos = { x: Math.random() * 10 -5 + x.props.pos.x, y: Math.random() * 10 -5 + x.props.pos.y };
        output = <PartView pos={newPos || x.props.pos}
          key={x.props.id}
          model={newModel}
          onMount={x.props.onMount}
          onMouseMove={x.props.onMouseMove} > </PartView>

        if (updateInPlace) {
          this.partElements[i] = output;
        }
      }
    });
    return output;
  }

  constructor(props: any) {
    super(props)
    let parts = testHelpers.generate2RegistersAdderAndStaticRam();
    var clockcomp = (parts[0] as clock);

    let gra = new graph(parts);
    let orderedParts = gra.topoSort();

    clockcomp.startClock();



    setInterval(() => {
      let newPartViews = orderedParts.map((x) => {
        if (!(x instanceof clock)) {
          x.update();
        }
        //let newModel = Object.assign({}, x);

        return this.updatePartModels(x);
      });
      this.partElements = newPartViews;
      this.forceUpdate();
      this.recreateAllWires();
      this.forceUpdate();


    }, 20);

    this.partElements = parts.map(x => {
      let pos = { x: Math.random() * 1000, y: Math.random() * 400 };

      //when all the parts are rendered, we will gather their attached wires
      //and generate 
      let onMount = (pinBoundsDataArray: { id: string, bounds: ClientRect }[]) => {
        pinBoundsDataArray.forEach(data => {
          this.boundsData[data.id] = data.bounds;
        });
      }
      let onMouseMove = (partView: PartView, data: React.MouseEvent<HTMLDivElement>) => {
        let bound = ReactDOM.findDOMNode(partView).getBoundingClientRect();
        //if this gets called we're selected and should move...

        this.updatePartModels(partView.props.model,
          {
            x: (data.clientX) + ((partView.state.clickOffset.x)),
            y: (data.clientY) + ((partView.state.clickOffset.y))
          }, true);
      }

      return <PartView pos={pos} key={x.id} model={x} onMount={onMount} onMouseMove={onMouseMove} > </PartView>
    });
  }

  private recreateAllWires() {
    let allWires: wire[] = _.flatten(this.partElements.map((x) => {
      return x.props.model.outputs.map(pin => { return pin.attachedWires });
    }));
    let wireElements = allWires.map(x => {

      //find startView
      let start = _.find(this.partElements, (p) => { return p.props.model == x.startPin.owner });
      //find endView
      let end = _.find(this.partElements, (p) => { return p.props.model == x.endPin.owner });

      return <WireView model={x}
        startPos={{ x: this.boundsData[x.startPin.id].right, y: this.boundsData[x.startPin.id].top }}
        endPos={{ x: this.boundsData[x.endPin.id].left, y: this.boundsData[x.endPin.id].top }} />
    });
    this.wireElements = wireElements;
  }

  //after this component is mounted, lets render the wires,
  //as we know all the parts will be rendered...
  componentDidMount() {
    this.recreateAllWires();
    this.forceUpdate();
  }

  public render() {
    return (<div>
      {this.partElements}
      {this.wireElements}
    </div>
    );
  }
}


ReactDOM.render(<App />, document.getElementById('app'));


