import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import * as _ from 'underscore';
import { IpartViewProps } from './partView';
import { grapher } from '../graphPart';
import { simulatorExecution } from '../engine';
import { Chart, ChartData, ChartPoint } from 'chart.js';
import { ipoint } from './wireView';
import { momentaryButton, toggleButton } from '../buttons';

export class buttonPartData {
    model: toggleButton | momentaryButton
    simulator: simulatorExecution
}

export class ToggleButtonPartView extends React.Component<buttonPartData> {


    constructor(props: buttonPartData) {
        super(props);
        this.state = {};

    }
    componentDidMount() {

    }

    componentDidUpdate() {

        //might need to do something here with the simulator?
    }

    style = {
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        "textAlign": "center" as "center",
        borderWidth: "1px",
        fontFamily: 'system-ui',
    }

    public render() {

        return (<div style={this.style}>
            <button onClick={(event) => {
                //on click set state inverse of what it's currently set to.
                this.props.model.state = !(this.props.model.state);
                let buttonTask1 = this.props.simulator.generateTaskAndDownstreamTasks(
                    this.props.simulator.rootOfAllTasks,
                    this.props.model, this.props.simulator.time + 1);


                this.props.simulator.insertTask(buttonTask1);

            }}> clickToToggle...  </button>

        </div>)
    }
}
