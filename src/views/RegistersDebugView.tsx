import { Ipart, nRegister } from "../primitives";
import { simulatorExecution } from "../engine";
import * as React from 'react';
import * as _ from 'underscore';


interface IRegisterDebugProps {
    simulator: simulatorExecution
}

export class RegistersDebugView extends React.Component<IRegisterDebugProps> {

    constructor(props: any) {
        super(props);
        this.state = {};
    }

    style = {
        color: '41474E',
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        display: "grid",
        gridTemplateColumns: 'auto auto',
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

        return style;
    }


    public render() {

        return (<div style={this.style}>
            {this.props.simulator.parts.filter(x=>x.constructor.name == "nRegister").map((reg, i) => {
                let word = (reg as nRegister).outputPins.map(x => x.value);
                return ([<div> {reg.displayName} </div>, <div style={this.dataStyle(word, i)} > {this.boolsToInt(word)} </div>])
            })}
        </div>)
    }
}
