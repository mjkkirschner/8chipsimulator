import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin } from '../pins_wires';
import { Imemory } from '../sram';
import * as _ from 'underscore';

export interface ImemoryDataProps {
    model: Imemory
}

export class MemoryDataView extends React.Component<ImemoryDataProps> {

    constructor(props: ImemoryDataProps) {
        super(props);
        this.state = {};
    }

    style = {
        color: '41474E',
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        display: "grid",
        gridTemplateColumns: 'auto auto auto',
        "textAlign": "center",
        borderWidth: "1px",
        fontFamily: 'system-ui',
        fontSize: "9pt"
    }

    protected boolsToInt(values: Boolean[]) {
        return parseInt(values.map(value => { return Number(value) }).join(""), 2);
    }


    protected dataStyle(data: boolean[]) {


        let style = {
            backgroundColor: "#FF5733"
        }
        if (_.any(data, (x) => { return x == true })) {
            style.backgroundColor = "#DAF7A6";
        }
        return style;
    }

    public render() {

        return (<div style={this.style}>
            {this.props.model.data.map(word => {
                return <div style={this.dataStyle(word)} > {this.boolsToInt(word)} </div>
            })}
        </div>)
    }
}
