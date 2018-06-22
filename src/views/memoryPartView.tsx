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
        gridTemplateColumns: 'auto auto auto auto auto auto auto auto',
        "textAlign": "center" as "center",
        borderWidth: "1px",
        fontFamily: 'system-ui',
    }

    protected boolsToInt(values: Boolean[]) {
        return parseInt(values.map(value => { return Number(value) }).join(""), 2);
    }


    protected dataStyle(data: boolean[], index: number) {


        let style = {
            backgroundColor: "rgba(224,103,103,.71)",
            padding: '0 4px'
        }
        if (_.any(data, (x) => { return x == true })) {
            style.backgroundColor = "#DAF7A6";
        }

        let addressToRead = parseInt(this.props.model.addressPins.map(pin => { return Number(pin.value) }).join(""), 2);

        if (addressToRead == index) {
            style.backgroundColor = "#F43FF7";
        }

        return style;
    }


    public render() {

        return (<div style={this.style}>
            {this.props.model.data.map((word, i) => {
                return <div style={this.dataStyle(word, i)} > {this.boolsToInt(word)} </div>
            })}
        </div>)
    }
}
