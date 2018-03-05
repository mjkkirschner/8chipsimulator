import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin } from '../pins_wires';
import { staticRam } from '../sram';
import { MemoryDataView } from './memoryPartView';

export interface IPartViewState {
    selected: Boolean
    clickOffset: { x: number, y: number };
}

export interface IpartViewProps {
    pos: { x: number, y: number },
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
        fontSize: "9pt",
        zIndex: 0,
        resize: 'both',
        overflow: 'auto' as 'auto'
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
        console.log("gathered all pin bounds and positions...");
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
        console.log("gathered all pin bounds and positions...");
        this.props.onMount(allBounds);
    }

    protected pinsToInt(pins: outputPin[]) {
        return parseInt(pins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    componentWillReceiveProps(props) {
    }

    protected dataStyle(data: boolean) {


        let style = {
            backgroundColor: "#FF5733"
        }
        if (data) {
            style.backgroundColor = "#DAF7A6";
        }
        return style;
    }


    private addSpecificPartView(model: Ipart) {
        //TODO we want to check if its a memory...
        if (model instanceof staticRam) {
            return (<MemoryDataView model={model}>
            </MemoryDataView>)
        }
    }

    public render() {

        let spanStyle = {
            backgroundColor: "lightGray"
        }

        let inputStyle = {
            backgroundColor: "darkGray",
        }



        let tableStyle = {
            'font-weight': 'normal'
        }

        return (<div style={{ ...this.style, left: this.props.pos.x, top: this.props.pos.y, zIndex: this.state.selected ? 1 : 0 }}
            
            onMouseDown={(event) => {
                event.preventDefault()
                this.setState({
                    selected: true,
                    clickOffset: {
                        x: this.bounds.left - event.clientX,
                        y: this.bounds.top - event.clientY
                    }
                })
            }}
            //TODO may want to put these on the document instead...
            //when the mouseDown event gets called.
            onMouseUp={(event) => { this.setState({ selected: false }) }}
            onMouseMove={(event) => {
                event.preventDefault()
                if (this.state.selected) {
                    this.props.onMouseMove(this, event);
                }
            }}
            //if the mouse leaves but we're still selected - also update the position to the new mouse position...
            onMouseLeave={(event) => {
                if (this.state.selected) {
                    this.props.onMouseMove(this, event);
                }
            }}
        >


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
        </div>)
    }
}
