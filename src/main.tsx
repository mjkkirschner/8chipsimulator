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
import { grapher } from "./graphPart";
import { staticRam } from "./sram";
import { RegistersDebug } from "./debugParts/RegistersDebug";
//reexport objects into the chips object which gets injected into the window using browserify.
export { VoltageRail };
export { grapher };

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
  selectedPartId: string = null;
  //TODO use type.
  orderedParts: graphNode[];
  private dataMap = {};

  style = {
    backgroundColor: 'rgb(42, 40, 39)',
    //set height based on children?
    zIndex: -2,
    width: '100%',
    height: '100%',
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
          onSelectionChange={x.props.onSelectionChange}
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
        onSelectionChange={x.props.onSelectionChange}
        onMount={x.props.onMount}
        onMouseMove={x.props.onMouseMove} > </PartView>
      return newPart;
    });
    this.setState({ parts: newParts })
  }

  public addPart(part: Ipart) {
    //first generate a new graph including the part:
    let newParts = this.orderedParts.map(x => x.pointer).concat(part);
    let gra = new graph(newParts);
    this.orderedParts = gra.topoSort();
    let newNode = this.orderedParts.filter(x => x.pointer.id == part.id)[0];

    let onMount = (pinBoundsDataArray: { id: string, bounds: ClientRect }[]) => {
      pinBoundsDataArray.forEach(data => {
        this.boundsData[data.id] = data.bounds;
      });
    }
    let onMouseMove = (partView: PartView, data: React.MouseEvent<HTMLDivElement>) => {
      this.recreateAllWires();

      this.updatePartModel(partView.props.model,
        {
          x: ((data.clientX) + (partView.state.clickOffset.x) - (partView.props.canvasOffset.x * this.zoom)) / partView.props.zoom,
          y: ((data.clientY) + (partView.state.clickOffset.y) - (partView.props.canvasOffset.y * this.zoom)) / partView.props.zoom
        }, null, null);
    }

    let onSelectionChange = (id: string) => {
      this.selectedPartId = id;
    }

    let newPartElement = <PartView pos={newNode.pos} zoom={1} canvasOffset={{ x: 0, y: 0 }} key={part.id} model={part} onSelectionChange={onSelectionChange} onMount={onMount} onMouseMove={onMouseMove} > </PartView>

    this.setState({ parts: this.state.parts.concat(newPartElement) });

  }

  private hex2BinArray(hexString: string) {
    let binString = this.convertNumber(hexString, 16, 2);
    return binString.padStart(16, "0").split('').map(x => { return parseInt(x) });
  }

  private convertNumber(n: string, fromBase: number, toBase: number): string {
    if (fromBase === void 0) {
      fromBase = 10;
    }
    if (toBase === void 0) {
      toBase = 10;
    }
    return (parseInt(n, fromBase)).toString(toBase);
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
    //lets inject some debug parts
    parts.push(new RegistersDebug("register file"));




    let ram = parts.filter(x => x.displayName == "main_ram")[0] as staticRam;
    ram.writeData(0, this.hex2BinArray("0x0006").map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
    ram.writeData(1, this.hex2BinArray("0x0000").map(x => Boolean(x))); //0 - after this A should contain 0.
    
    ram.writeData(2, this.hex2BinArray("0x0003").map(x => Boolean(x))); // Put whatever follows at memory address 100 into B // then add to A.
    ram.writeData(3, this.hex2BinArray("0x0064").map(x => Boolean(x))); // 100
    ram.writeData(4, this.hex2BinArray("0x0002").map(x => Boolean(x))); // A transfer to Out reg.


    ram.writeData(5, this.hex2BinArray("0x000C").map(x => Boolean(x))); //loadBimmediate. - load what follows into B.
    ram.writeData(6, this.hex2BinArray("0x0010").map(x => Boolean(x))); //16 - after this B should contain 16.

    ram.writeData(7, this.hex2BinArray("0x000E").map(x => Boolean(x))); //update flag reg for jump

    //conditionally jump to 2 if A < B... if A < 16 keep looping 
    ram.writeData(8, this.hex2BinArray("0x0009").map(x => Boolean(x))); //jump to line:
    ram.writeData(9, this.hex2BinArray("0x0002").map(x => Boolean(x))); //address 2
    
    ram.writeData(10, this.hex2BinArray("0x0008").map(x => Boolean(x))); //jump to line:
    ram.writeData(11, this.hex2BinArray("0x0000").map(x => Boolean(x))); //address 2

    ram.writeData(100, this.hex2BinArray("0x0001").map(x => Boolean(x))); //1 at memory location 100


    var clockcomp = (parts[0] as clock);

    let gra = new graph(parts);
    this.orderedParts = gra.topoSort();
    gra.calculateColumnLayout(1500, 500);
    //get all parts into correct initial state.
    this.orderedParts.forEach((x) => {
      if (!(x.pointer instanceof clock)) {
        x.pointer.update();
      }
    });

    let evaluator = new simulatorExecution(parts);
    //a hack for now...
    window["evaluator"] = evaluator;
    window["simulator"] = this;
    evaluator.Evaluate();


    // for all parts except parts that need to be updated on a timer
    // add handler which fires when the part is updated.
    // do a compare to old data in this handler
    // and only update the model for the view if the data has changed.
    this.orderedParts.forEach(x => {
      let partId = x.pointer.id;
      x.pointer.registerCallbackOnUpdate((data) => {
        let oldData = this.dataMap[partId];
        let newData = x.pointer.outputs.map(x => x.value);
        //if they are not equal update.
        if ((oldData != null) && !(_.isEqual(newData, oldData))) {
          this.updatePartModel(x.pointer);
        }
        //update the map
        this.dataMap[partId] = newData;
      })
    });

    // only set interval for parts that need to be redraw like this
    // like the grapher
    setInterval(() => {
      this.orderedParts.forEach((x) => {
        let part = x.pointer;
        if (part.constructor.name == "grapher") {
          this.updatePartModel(part);
        }
      });
    }, 20);
    setTimeout(() => {
      this.recreateAllWires();
    }, 1000);
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
        this.recreateAllWires();

        this.updatePartModel(partView.props.model,
          {
            x: ((data.clientX) + (partView.state.clickOffset.x) - (partView.props.canvasOffset.x * this.zoom)) / partView.props.zoom,
            y: ((data.clientY) + (partView.state.clickOffset.y) - (partView.props.canvasOffset.y * this.zoom)) / partView.props.zoom
          }, null, null);
      }

      let onSelectionChange = (id: string) => {
        this.selectedPartId = id;
      }

      return <PartView pos={pos} zoom={1} canvasOffset={{ x: 0, y: 0 }} key={model.id} model={model} onSelectionChange={onSelectionChange} onMount={onMount} onMouseMove={onMouseMove} > </PartView>
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

      let color = null;
      if (end.props.model.id == this.selectedPartId) {
        color = "rgb(255, 0, 191)";
      }
      else if (start.props.model.id == this.selectedPartId) {
        color = "rgb(255, 243, 0)";
      }

      return <WireView
        model={x}
        color={color}
        startPos={{ x: this.boundsData[x.startPin.id].right + window.scrollX, y: this.boundsData[x.startPin.id].top + window.scrollY }}
        endPos={{ x: this.boundsData[x.endPin.id].left + window.scrollX, y: this.boundsData[x.endPin.id].top + window.scrollY }} />

    });
    this.setState({ wires: newWires });
  }

  //after this component is mounted, lets render the wires,
  //as we know all the parts will be rendered...
  componentDidMount() {
    this.createAllParts(this.orderedParts);
  }


  public render() {
    return (
      <div style={{ height: window.innerHeight, position: "relative", overflow: "hidden" }} >
        <div tabIndex={0} onWheel={(event) => {
          event.preventDefault();
          this.zoom = this.zoom - event.deltaY / 1000;
          //now we should recreate the elements with different zoom.
          this.updateAllPartViews(
            null, this.zoom, null);
          this.recreateAllWires();
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
              this.recreateAllWires();
              let finalViewOffset = {
                x: (event.clientX) + ((this.state.viewPorClicktOffset.x)),
                y: (event.clientY) + ((this.state.viewPorClicktOffset.y))
              };
              this.setState({ viewPortoffset: finalViewOffset });
              this.updateAllPartViews(null, null, finalViewOffset);
            }
          }}

          onKeyDown={(event) => {
            let offset = { x: 0, y: 0 };
            if (event.key == "ArrowLeft") {
              offset.x = 50;
            }
            if (event.key == "ArrowRight") {
              offset.x = -50;
            }
            if (event.key == "ArrowDown") {
              offset.y = -50;
            }
            if (event.key == "ArrowUp") {
              offset.y = 50;
            }
            let finalViewOffset = {
              x: (offset.x) + ((this.state.viewPorClicktOffset.x)),
              y: (offset.y) + ((this.state.viewPorClicktOffset.y))
            };
            this.setState({
              viewPorClicktOffset: finalViewOffset,
              viewPortoffset: finalViewOffset
            });
            this.updateAllPartViews(null, null, finalViewOffset);
            this.recreateAllWires();
          }}

          onContextMenu={(event) => {
            event.preventDefault();
          }}

          style={this.style} >
          {this.state.parts}
          {this.state.wires}
        </div >
      </div >
    );
  }
}


ReactDOM.render(<App />, document.getElementById('app'));


