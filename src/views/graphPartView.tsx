import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import * as _ from 'underscore';
import { IpartViewProps } from './partView';
import { grapher } from '../graphPart';
import SmoothieChart = require("smoothie");
import { simulatorExecution } from '../engine';

export class grapherPropsData {
    model: grapher
    simulator: simulatorExecution
}

export class GrapherPartView extends React.Component<grapherPropsData> {

    private timeSeries: TimeSeries
    private chart: SmoothieChart;
    private startTime: number;

    constructor(props: grapherPropsData) {
        super(props);
        this.state = {};
        this.timeSeries = new SmoothieChart.TimeSeries();
        this.chart = new SmoothieChart.SmoothieChart({millisPerPixel:100});
        this.startTime = new Date().getTime();

    }
    componentDidMount() {
        this.chart.streamTo(document.
            getElementById(this.props.model.id) as HTMLCanvasElement);
        this.chart.addTimeSeries(this.timeSeries);
    }

    componentDidUpdate(a, b, c) {
       // this.timeSeries.append(this.startTime + this.props.simulator.time*30, (this.props.model as grapher).getDataAsInteger());


    }

    style = {
        color: '41474E',
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        "textAlign": "center",
        borderWidth: "1px",
        fontFamily: 'system-ui',
    }



    public render() {

        return (<div style={this.style}>
            <canvas id={this.props.model.id}
                width={400} height={100}> </canvas>
        </div>)
    }
}
