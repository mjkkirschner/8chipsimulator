import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';

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
        color: 'black',
        'backgroundColor': "#808B96",
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

    public render() {
        this.style.left = this.props.pos.x;
        this.style.top = this.props.pos.y;

        return (<div style={this.style}>
            <p>{this.props.model.constructor.name}</p>
        </div>)
    }
}