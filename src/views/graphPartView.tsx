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

    private datas: ChartData[]
    private charts: Chart[];
    private startTime: number;

    constructor(props: grapherPropsData) {
        super(props);
        this.state = {};
        this.datas = this.props.model.dataPins.map((x) => {

            let randomColorr = Math.random() * 128;
            let randomColorg = Math.random() * 128;
            let randomColorb = Math.random() * 128;

            return {
                datasets: [{
                    data: [],
                    label: x.name,
                    pointRadius: 0,
                    backgroundColor: 'rgba(' + randomColorr + ',' + randomColorg + ',' + randomColorb + ',' + '0.1)',
                    borderColor: 'rgba(' + randomColorr + ',' + randomColorg + ',' + randomColorb + ',' + '.7)',
                    borderWidth: 2,
                }]
            }
        });
        this.startTime = 0;

    }
    componentDidMount() {
        //TODO potentially create new charts for each input pin so scales are correct?
        this.charts = this.props.model.dataPins.map((x, i) => {
            return new Chart((document.getElementById(this.props.model.id + i.toString()) as HTMLCanvasElement).getContext("2d"),
                {
                    type: 'scatter',
                    data: this.datas[i],
                    options: { showLines: true }
                });
        })

        this.charts.forEach(x => x.update());
    }

    componentDidUpdate() {


        this.props.model.dataPins.forEach((pin, index) => {
            (this.datas[index].datasets[0].data as ChartPoint[]).push(new ipoint(this.startTime + this.props.simulator.time, Number(pin.value)));
            if (this.datas[index].datasets[0].data.length > 500) {
                this.datas[index].datasets[0].data = _.rest<ChartPoint>(this.datas[index].datasets[0].data as ChartPoint[], 250);
            }
        });
        this.charts.forEach(x => x.update());
    }

    style = {
        //color: '41474E',
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        "textAlign": "center" as "center",
        borderWidth: "1px",
        fontFamily: 'system-ui',
    }



    public render() {

        return (<div style={this.style}>
            {this.props.model.dataPins.map((x, i) => {
                return (
                    <canvas id={this.props.model.id + i.toString()}
                        width={400} height={100}> </canvas>)
            })}

        </div>)
    }
}
