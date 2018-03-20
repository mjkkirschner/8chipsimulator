import { toggleSwitch, nRegister, Ipart } from "./primitives";
import { clock } from "./clock";


import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { PartView } from "./views/partView";
import * as utils from "../test/8bitComputerTests";
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
  zoom: number = 1;

  style = {
    backgroundColor: 'rgb(42, 40, 39)',
    //set height based on children?
    zIndex: -2,
    width: '100%',
    height: '5000px',
    overflow: 'hidden' as 'hidden'
  }

  private updatePartModels(newModel: Ipart, newPos?: { x: number, y: number }, updateInPlace?: Boolean, newZoom?: number): JSX.Element {

    var output;
    this.partElements.forEach((x, i) => {
      if (x.props.model.id == newModel.id) {

        output = <PartView
          pos={newPos || x.props.pos}
          zoom={newZoom || x.props.zoom}
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
    let parts = utils.generate8bitComputerDesign();
    var clockcomp = (parts[0] as clock);

    let gra = new graph(parts);
    let orderedParts = gra.topoSort();

    gra.calculateColumnLayout(1200, 400);

    clockcomp.startClock();



    setInterval(() => {
      let newPartViews = orderedParts.map((x) => {
        let part = x.pointer;
        if (!(part instanceof clock)) {
          //  part.update();
        }
        return this.updatePartModels(part);
      });
      this.partElements = newPartViews;
      this.forceUpdate();
      this.recreateAllWires();
      this.forceUpdate();


    }, 20);

    this.partElements = orderedParts.map((x) => {
      let pos = { x: x.pos.x, y: x.pos.y }
      let model = x.pointer;
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
            x: (data.clientX) + ((partView.state.clickOffset.x) + window.scrollX),
            y: (data.clientY) + ((partView.state.clickOffset.y) + window.scrollY)
          }, true);
      }

      return <PartView pos={pos} zoom={1} key={model.id} model={model} onMount={onMount} onMouseMove={onMouseMove} > </PartView>
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
        startPos={{ x: this.boundsData[x.startPin.id].right + window.scrollX, y: this.boundsData[x.startPin.id].top + window.scrollY }}
        endPos={{ x: this.boundsData[x.endPin.id].left + window.scrollX, y: this.boundsData[x.endPin.id].top + window.scrollY }} />
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
    return (<div onWheel={(event) => {
      event.preventDefault();
      this.zoom = this.zoom - event.deltaY / 1000;
      //now we should recreate the elements with different zoom.
     this.partElements =  this.partElements.map(partElement => {

        return this.updatePartModels(partElement.props.model,
          partElement.props.pos, false, this.zoom)
      })
    }}
      style={this.style}>
      {this.partElements}
      {this.wireElements}
    </div>
    );
  }
}


ReactDOM.render(<App />, document.getElementById('app'));


