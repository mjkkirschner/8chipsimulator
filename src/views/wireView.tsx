import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin, wire, internalWire } from '../pins_wires';
import { PartView } from './partView';
import * as _ from 'underscore';
import { Color } from '../../node_modules/csstype';

interface IWireViewProps {
    model: wire | internalWire,
    //TODO these should be portViews in the future...
    startPos: {x:number,y:number}
    endPos: {x:number,y:number}
    color:string
}

export class WireView extends React.Component<IWireViewProps> {

    constructor(props: IWireViewProps) {
        super(props);
        this.state = {};
    }

    svgStyle = {
        overflow: 'visible' as 'visible',
        width: '100%',
        position: 'absolute' as 'absolute',
        zIndex:0,
    }

    private generatePolyLinePoints(start:ipoint, end:ipoint) {
  
        var horizontal2 = new ipoint((end.x - start.x)*.5,0 );
        var verticalVector1 = new ipoint(0,end.y - start.y)
        var point2 =start.sum(horizontal2);
        return [start, start.sum(new ipoint(100,0)), start.sum(horizontal2), start.sum(horizontal2).sum(verticalVector1), end.subtact(new ipoint(100,0)), end];
    
      }
    
      private evaluateCubicHermiteAtParamter(p0: ipoint, p1: ipoint, tan1: ipoint, tan2: ipoint, parameter: number) {
        return p0.scale((((2 * (Math.pow(parameter, 3))) - (3 * Math.pow(parameter, 2)) + 1))).sum
          (tan1.scale((parameter * parameter * parameter) - (2 * (parameter * parameter)) + parameter)).sum
          (p1.scale((-2 * (Math.pow(parameter, 3))) + (3 * Math.pow(parameter, 2)))).sum
          (tan1.scale((parameter * parameter * parameter) - (parameter * parameter)))
      }

      private generatePolyLineStyle(){

    let style = {
        stroke: "rgb(95, 255, 187)",
        strokeWidth: "1",
        fill: "none",
        strokeDasharray:"2, 2"
    }
        if(this.props.color){
            style.stroke = this.props.color;
        }
        return style;
      }

    public render() {

        let pointsAndTans = this.generatePolyLinePoints(
            new ipoint(this.props.startPos.x,this.props.startPos.y),
            new ipoint(this.props.endPos.x,this.props.endPos.y));

        let finalPoints = pointsAndTans;

      return (<svg style ={this.svgStyle}> 
        <polyline style = {{...this.generatePolyLineStyle()}} 
        points = {finalPoints.join(" ")} />
    </svg>);
    }
    
}

export class ipoint {
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