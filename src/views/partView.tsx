import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin } from '../pins_wires';
import { staticRam } from '../sram';
import { MemoryDataView } from './memoryPartView';
import { grapher } from '../graphPart';
import { GrapherPartView } from './graphPartView';

export interface IPartViewState {
    selected: Boolean
    clickOffset: { x: number, y: number };
}

export interface IpartViewProps {
    pos: { x: number, y: number },
    zoom: number,
    canvasOffset: { x: number, y: number }
    model: Ipart,
    key: string,
    //we can change this so pass the positions of any ports or something like that?
    onMount: (pinBoundsDataArray: { id: string, bounds: ClientRect }[]) => any
    //onMouseDown: (partView: PartView, data: React.MouseEvent<HTMLDivElement>) => any
    onMouseMove: (partView: PartView, data: React.MouseEvent<HTMLDivElement>) => any
}

export class PartView extends React.Component<IpartViewProps, IPartViewState> {

    bounds: ClientRect;

    constructor(props: IpartViewProps) {
        super(props);
        this.state = { selected: false, clickOffset: { x: 0, y: 0 } };
    }

    style = {
        color: '41474E',
        'backgroundColor': "rgb(45, 64, 46)",
        'borderStyle': 'solid',
        borderColor: "rgb(95, 255, 187)",
        display: "inline-block",
        "minWidth": "150px",
        "textAlign": "center",
        borderWidth: "2px",
        fontFamily: 'system-ui',
        position: 'absolute' as 'absolute',
        left: 0,
        top: 0,
        fontSize: "9pt",
        zIndex: 0,
        resize: 'both',
        overflow: 'auto' as 'auto',
        boxShadow: '0 0 5px rgb(95, 255, 187)'
    }

    componentDidMount() {

        let node = ReactDOM.findDOMNode(this);
        this.bounds = node.getBoundingClientRect();
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
        this.props.onMount(allBounds);
    }

    componentDidUpdate() {
        let node = ReactDOM.findDOMNode(this);
        this.bounds = node.getBoundingClientRect();
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
        this.props.onMount(allBounds);
    }

    protected pinsToInt(pins: outputPin[]) {
        return parseInt(pins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    componentWillReceiveProps(props) {
    }

    protected dataStyle(data: boolean) {


        let style = {
            backgroundColor: "rgba(224,103,103,.71)",
            padding: '0 4px'
        }
        if (data) {
            style.backgroundColor = "#DAF7A6";
        }
        return style;
    }


    private addSpecificPartView(model: Ipart) {
        if (model instanceof staticRam) {
            return (<MemoryDataView model={model}>
            </MemoryDataView>)
        }
        if (model instanceof grapher) {
            return (<GrapherPartView model={model}>
            </GrapherPartView>)

        }
    }

    private onMouseUp() {
        document.removeEventListener('mouseup', this.mouseupWrapper, true);
        document.removeEventListener('mousemove', this.mouseMoveWrapper, true);
        this.setState({ selected: false })
    }
    private mouseupWrapper = () => {
        this.onMouseUp();
    }

    private onMouseMove(event: React.MouseEvent<HTMLDivElement>) {
        event.preventDefault()
        if (this.state.selected) {
            this.props.onMouseMove(this, event);
        }
    }
    private mouseMoveWrapper = (event) => {
        this.onMouseMove(event)
    }

    public render() {

        let spanStyle = {
            backgroundColor: "rgb(55, 89, 49)",
            color: "rgb(95, 255, 187)"
        }

        let inputStyle = {
            backgroundColor: "rgba(218,247,166,.2)",
            color: 'white'
        }

        let tableStyle = {
            'font-weight': 'lighter',
            letterSpacing: '2px'
        }

        return (<div style={{
            ...this.style,
            fontSize: 9 * this.props.zoom,
            left: (this.props.pos.x + this.props.canvasOffset.x) * this.props.zoom,
            top: (this.props.pos.y + this.props.canvasOffset.y) * this.props.zoom,
            zIndex: this.state.selected ? 1 : 0
        }}

            onMouseDown={(event) => {
                event.preventDefault()
                let clickOffsetVector = {
                    x: this.bounds.left - event.clientX,
                    y: this.bounds.top - event.clientY
                };

                this.setState({
                    selected: true,
                    clickOffset: clickOffsetVector,
                });
                document.addEventListener('mouseup', this.mouseupWrapper, true);
                document.addEventListener('mousemove', this.mouseMoveWrapper, true);
            }
            }
        >

            <div style={spanStyle}> {this.props.model.constructor.name}</div>
            <div style={spanStyle}> {this.props.model.displayName}</div>
            <table >
                <th style={tableStyle}>
                    {this.props.model.inputs.map((x, i) => {

                        return (<tr>
                            <td style={inputStyle} id={"inputPin"} >{x.name} </td>
                        </tr>)
                    })}
                </th>
                <th>

                    {
                        this.addSpecificPartView(this.props.model)
                    }
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
        </div >)
    }
}
