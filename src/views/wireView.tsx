import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin, wire, internalWire } from '../pins_wires';
import { PartView } from './partView';
import * as _ from 'underscore';

interface IWireViewProps {
    model: wire | internalWire,
    //TODO these should be portViews in the future...
    startPos: {x:number,y:number}
    endPos: {x:number,y:number}
}

export class WireView extends React.Component<IWireViewProps> {

    constructor(props: IWireViewProps) {
        super(props);
        this.state = {};
    }

    style = {
        stroke: "black",
        strokeWidth: "1",
        fill: "none"
    }

    svgStyle = {
        overflow: 'visible' as 'visible',
        width: '100%',
        position: 'absolute' as 'absolute'
    }

    private generateHermitePointsandTangents(start:ipoint, end:ipoint) {
  
        var tan1 = new ipoint(Math.abs((start.x - end.x)) * 2,0 );
        var tan2 = new ipoint(Math.abs((end.x - start.x)) * 2,0);
        return [start, tan1, end, tan2];
    
      }
    
      private evaluateCubicHermiteAtParamter(p0: ipoint, p1: ipoint, tan1: ipoint, tan2: ipoint, parameter: number) {
        return p0.scale((((2 * (Math.pow(parameter, 3))) - (3 * Math.pow(parameter, 2)) + 1))).sum
          (tan1.scale((parameter * parameter * parameter) - (2 * (parameter * parameter)) + parameter)).sum
          (p1.scale((-2 * (Math.pow(parameter, 3))) + (3 * Math.pow(parameter, 2)))).sum
          (tan1.scale((parameter * parameter * parameter) - (parameter * parameter)))
      }

    public render() {

        let pointsAndTans = this.generateHermitePointsandTangents(
            new ipoint(this.props.startPos.x,this.props.startPos.y),
            new ipoint(this.props.endPos.x,this.props.endPos.y));

        let finalPoints = _.range(0,100).map(x=>{return x/100}).map(x=>{
            return this.evaluateCubicHermiteAtParamter(pointsAndTans[0],pointsAndTans[2],pointsAndTans[1],pointsAndTans[3],x)});

      return (<svg style ={this.svgStyle}> <polyline style = {this.style}
        points = {finalPoints.join(" ")}/>
    </svg>);
    }
    
}

class ipoint {
    x: number
    y: number
    constructor(x: number, y: number) {
      this.x = x;
      this.y = y;
  
    }
    scale(z: number) {
      return new ipoint(this.x * z, this.y * z);
    }
  
    sum(point2: ipoint) {
      return new ipoint(this.x + point2.x, this.y + point2.y);
    }
    subtact(point2: ipoint) {
      return new ipoint(this.x - point2.x, this.y - point2.y);
    }
    toString(){
        return this.x.toString()+','+this.y.toString()
    }

  }