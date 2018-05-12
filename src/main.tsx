import { nRegister, Ipart } from "./primitives";
import { clock } from "./clock";


import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { PartView, IPartViewState } from "./views/partView";
import * as utils from "../test/8bitComputerTests";
import * as _ from "underscore";
import { WireView } from "./views/wireView";
import { wire } from "./pins_wires";
import { graph, simulatorExecution, graphNode } from "./engine";
import { CommandLineView } from "./views/console";
import { VoltageRail } from "./primitives";
export { VoltageRail };

interface ICanvasState {
  viewPortSelected: boolean;
  viewPorClicktOffset: { x: number, y: number };
  viewPortoffset: { x: number, y: number };
  parts: JSX.Element[];
  wires: JSX.Element[];

}

class App extends React.Component<{}, ICanvasState> {


  boundsData: { [id: string]: ClientRect } = {};
  zoom: number = 1;
  //TODO use type.
  orderedParts: graphNode[];

  style = {
    backgroundColor: 'rgb(42, 40, 39)',
    //set height based on children?
    zIndex: -2,
    width: '100%',
    height: '90%',
    overflow: 'hidden' as 'hidden'
  }

  private updatePartModel(newModel: Ipart, newPos?: { x: number, y: number }, newZoom?: number, newCanvasOffset?: { x: number, y: number }) {

    let newParts = this.state.parts.map((x, i) => {
      if (x.props.model.id == newModel.id) {
        let newPart = <PartView
          pos={newPos || x.props.pos}
          zoom={newZoom || x.props.zoom}
          canvasOffset={newCanvasOffset || x.props.canvasOffset}
          key={x.props.model.id}
          model={newModel}
          onMount={x.props.onMount}
          onMouseMove={x.props.onMouseMove} > </PartView>
        return newPart;
      }
      else {
        return x;
      }
    });
    this.setState({ parts: newParts })
  }

  private updateAllPartViews(newPos?: { x: number, y: number }, newZoom?: number, newCanvasOffset?: { x: number, y: number }) {

    let newParts = this.state.parts.map((x, i) => {
      let newPart = <PartView
        pos={newPos || x.props.pos}
        zoom={newZoom || x.props.zoom}
        canvasOffset={newCanvasOffset || x.props.canvasOffset}
        key={x.props.model.id}
        model={x.props.model}
        onMount={x.props.onMount}
        onMouseMove={x.props.onMouseMove} > </PartView>
      return newPart;
    });
    this.setState({ parts: newParts })
  }

  public addPart(part: Ipart) {
    //first generate a new graph including the part:
    let newParts = this.orderedParts.map(x=>x.pointer).concat(part);
    let gra = new graph(newParts);
    this.orderedParts = gra.topoSort();
    let newNode = this.orderedParts.filter(x=>x.pointer.id == part.id)[0];
    
    let onMount = (pinBoundsDataArray: { id: string, bounds: ClientRect }[]) => {
      pinBoundsDataArray.forEach(data => {
        this.boundsData[data.id] = data.bounds;
      });
    }
    let onMouseMove = (partView: PartView, data: React.MouseEvent<HTMLDivElement>) => {

      this.updatePartModel(partView.props.model,
        {
          x: ((data.clientX) + (partView.state.clickOffset.x) - (partView.props.canvasOffset.x * this.zoom)) / partView.props.zoom,
          y: ((data.clientY) + (partView.state.clickOffset.y) - (partView.props.canvasOffset.y * this.zoom)) / partView.props.zoom
        }, null, null);
    }

    let newPartElement = <PartView pos={newNode.pos} zoom={1} canvasOffset={{ x: 0, y: 0 }} key={part.id} model={part} onMount={onMount} onMouseMove={onMouseMove} > </PartView>
    
  this.setState({ parts: this.state.parts.concat(newPartElement)});

  }

  constructor(props: any) {
    super(props)
    this.state = {
      viewPortSelected: false,
      viewPorClicktOffset: { x: 0, y: 0 },
      viewPortoffset: { x: 0, y: 0 },
      parts: [],
      wires: []

    }

    let parts = utils.generate8bitComputerDesign();
    var clockcomp = (parts[0] as clock);

    let gra = new graph(parts);
    this.orderedParts = gra.topoSort();

    gra.calculateColumnLayout(1200, 400);

    let evaluator = new simulatorExecution(parts);
    //a hack for now...
    window["evaluator"] = evaluator;
    window["simulator"] = this;
    evaluator.Evaluate();

    //TODO collect some events from the parts... like updating or something and watch those.
    setInterval(() => {
      this.orderedParts.forEach((x) => {
        let part = x.pointer;
        return this.updatePartModel(part);
      });
      this.recreateAllWires();
    }, 20);

  }

  private createAllParts(parts: graphNode[]) {
    let newParts = parts.map((x) => {
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

        this.updatePartModel(partView.props.model,
          {
            x: ((data.clientX) + (partView.state.clickOffset.x) - (partView.props.canvasOffset.x * this.zoom)) / partView.props.zoom,
            y: ((data.clientY) + (partView.state.clickOffset.y) - (partView.props.canvasOffset.y * this.zoom)) / partView.props.zoom
          }, null, null);
      }

      return <PartView pos={pos} zoom={1} canvasOffset={{ x: 0, y: 0 }} key={model.id} model={model} onMount={onMount} onMouseMove={onMouseMove} > </PartView>
    });
    this.setState({ parts: newParts });
  }

  private recreateAllWires() {
    let allWires: wire[] = _.flatten(this.state.parts.map((x) => {
      return x.props.model.outputs.map(pin => { return pin.attachedWires });
    }));
    let newWires = allWires.map(x => {

      //find startView
      let start = _.find(this.state.parts, (p) => { return p.props.model == x.startPin.owner });
      //find endView
      let end = _.find(this.state.parts, (p) => { return p.props.model == x.endPin.owner });

      return <WireView model={x}
        startPos={{ x: this.boundsData[x.startPin.id].right + window.scrollX, y: this.boundsData[x.startPin.id].top + window.scrollY }}
        endPos={{ x: this.boundsData[x.endPin.id].left + window.scrollX, y: this.boundsData[x.endPin.id].top + window.scrollY }} />

    });
    this.setState({ wires: newWires });
  }

  //after this component is mounted, lets render the wires,
  //as we know all the parts will be rendered...
  componentDidMount() {
    this.createAllParts(this.orderedParts);
    this.recreateAllWires();
    //this.forceUpdate();
  }


  public render() {
    return (
      <div style={{ height: window.innerHeight, position: "relative", overflow: "hidden" }} >
        <div onWheel={(event) => {
          event.preventDefault();
          this.zoom = this.zoom - event.deltaY / 1000;
          //now we should recreate the elements with different zoom.
          this.updateAllPartViews(
            null, this.zoom, null)
        }}

          onMouseDown={(event) => {
            //if rightclick on canvas then we want to modify the offset.
            if (event.button == 2) {
              event.preventDefault();
              let bounds = ReactDOM.findDOMNode(this).getBoundingClientRect();
              let clickOffsetVector = {
                x: (this.state.viewPortoffset.x - event.clientX),
                y: (this.state.viewPortoffset.y - event.clientY)
              };
              this.setState({
                viewPortSelected: true,
                viewPorClicktOffset: clickOffsetVector
              });

            }
          }}

          onMouseUp={(event) => {
            if (event.button == 2) {
              this.setState({ viewPortSelected: false });
            }
          }}

          onMouseMove={(event) => {
            if (this.state.viewPortSelected) {
              let finalViewOffset = {
                x: (event.clientX) + ((this.state.viewPorClicktOffset.x)),
                y: (event.clientY) + ((this.state.viewPorClicktOffset.y))
              };
              this.setState({ viewPortoffset: finalViewOffset });
              this.updateAllPartViews(null, null, finalViewOffset);
            }
          }}

          onContextMenu={(event) => {
            event.preventDefault();
          }}

          style={this.style} >
          {this.state.parts}
          {this.state.wires}
        </div >
        <CommandLineView> </CommandLineView>
      </div>
    );
  }
}


ReactDOM.render(<App />, document.getElementById('app'));


