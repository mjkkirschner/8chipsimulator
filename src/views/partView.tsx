import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin } from '../pins_wires';

interface IpartViewProps {
    pos: { x: number, y: number },
    model: Ipart,
    key: string,
    //we can change this so pass the positions of any ports or something like that?
    onMount: (pinBoundsDataArray: { id: string, bounds: ClientRect }[]) => any
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
        top: 0,
        fontSize: "9pt"
    }

    componentDidMount() {

        let node = ReactDOM.findDOMNode(this);
        let inputPins = node.querySelectorAll("#inputPin");
        let outputPins = node.querySelectorAll("#outputPin");
        let bounds1 = [].slice.call(inputPins).map((element: Element, index) => {
            return {
                id: this.props.model.inputs[index].id,
                bounds: element.getBoundingClientRect()
            }
        });
        let bounds2 = [].slice.call(outputPins).map((element: Element, index) => {
            return {
                id: this.props.model.outputs[index].id,
                bounds: element.getBoundingClientRect()
            }
        });
        let allBounds = (bounds1 as any[]).concat(bounds2);
        console.log("gathered all pin bounds and positions...");
        this.props.onMount(allBounds);
    }

    private pinsToInt(pins: outputPin[]) {
        return parseInt(pins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    componentWillReceiveProps(props) {
        //      this.forceUpdate();
    }

    private dataStyle(data: boolean) {


        let style = {
            backgroundColor: "#FF5733"
        }
        if (data) {
            style.backgroundColor = "#DAF7A6";
        }
        return style;
    }

    public render() {

        let spanStyle = {
            backgroundColor: "lightGray"
        }

        let inputStyle = {
            backgroundColor: "darkGray",
            //            position: "absolute" as 'absolute',
            //left: '10px',
            //top: '1px'
        }



        let tableStyle = {
            'font-weight': 'normal'
        }

        if (Math.abs(this.style.left - this.props.pos.x) > 1) {
            this.style.left = this.props.pos.x;
            this.style.top = this.props.pos.y;
        }


        return (<div style={this.style}>


            <table >
                <th style={tableStyle}>
                    {this.props.model.inputs.map((x, i) => {

                        return (<tr>
                            <td style={inputStyle} id={"inputPin"} >{x.name} </td>
                        </tr>)
                    })}
                </th>
                <th>
                    <p>{this.props.model.constructor.name}</p>
                </th>
                <th style={tableStyle}>
                    {this.props.model.outputs.map((x, i) => {

                        return (<tr>
                            <td style={inputStyle} id={"outputPin"}> {x.name} </td>
                            <td style={this.dataStyle(x.value)} id={"value"}> {Number(x.value)} </td>
                        </tr>)
                    })}
                </th>
            </table>
            <div style={spanStyle} >{this.pinsToInt(this.props.model.outputs).toString()}</div>
        </div>)
    }
}