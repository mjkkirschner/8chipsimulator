import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import * as _ from 'underscore';
import { IpartViewProps } from './partView';
import { grapher } from '../graphPart';
import { simulatorExecution } from '../engine';
import { Chart, ChartData, ChartPoint } from 'chart.js';
import { ipoint } from './wireView';

export class grapherPropsData {
    model: grapher
    simulator: simulatorExecution
}

export class GrapherPartView extends React.Component<grapherPropsData> {

    private data: ChartData
    private chart: Chart;
    private startTime: number;

    constructor(props: grapherPropsData) {
        super(props);
        this.state = {};
        this.data = { datasets: [{ data: [] }] }
        this.startTime = 0;

    }
    componentDidMount() {
        this.chart = new Chart((document.getElementById(this.props.model.id) as HTMLCanvasElement).getContext("2d"),
            {
                type: 'scatter',
                data: this.data,
                options: { showLines: true }
            });

        this.chart.update();
    }

    componentDidUpdate() {
        (this.data.datasets[0].data as ChartPoint[]).push(new ipoint(this.startTime + this.props.simulator.time, (this.props.model as grapher).getDataAsInteger()));
        if (this.data.datasets[0].data.length > 500) {
            this.data.datasets[0].data = _.rest<ChartPoint>(this.data.datasets[0].data as ChartPoint[], 250);
        }
        this.chart.update();
    }

    style = {
        color: '41474E',
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        "textAlign": "center" as "center",
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
