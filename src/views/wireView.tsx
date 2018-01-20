import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin, wire, internalWire } from '../pins_wires';
import { PartView } from './partView';

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
        stroke: "red",
        strokeWidth: "3",
        fill: "none"
    }

    svgStyle = {
        overflow: 'visible' as 'visible',
        width: '100%',
        position: 'absolute' as 'absolute'
    }
    public render() {

        let point1x = this.props.startPos.x
        let point1y = this.props.startPos.y

        let point2x =this.props.endPos.x
        let point2y = this.props.endPos.y

      return (<svg style ={this.svgStyle}> <polyline style = {this.style}
        points = {point1x.toString()+','+point1y.toString()+" "+point2x.toString()+','+point2y.toString()}/>
    </svg>);
    }
}