import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin } from '../pins_wires';

interface IpartViewProps {
    pos: { x: number, y: number },
    model: Ipart,

}

export class PartView extends React.Component<IpartViewProps> {

    constructor(props: IpartViewProps) {
        super(props);
        this.state = {};
    }

    style = {
        color: '41474E',
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        display: "inline-block",
        "minWidth": "150px",
        "textAlign": "center",
        borderWidth: "1px",
        fontFamily: 'system-ui',
        position: 'absolute' as 'absolute',
        left: 0,
        top: 0
    }



    private pinsToInt(pins: outputPin[]) {
        return parseInt(pins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    public render() {

        let spanStyle = {
            backgroundColor: "lightGray"
        }

        this.style.left = this.props.pos.x;
        this.style.top = this.props.pos.y;

        return (<div style={this.style}>
            <p>{this.props.model.constructor.name}</p>
            <div style={spanStyle} >{this.pinsToInt(this.props.model.outputs).toString()}</div>
        </div>)
    }
}