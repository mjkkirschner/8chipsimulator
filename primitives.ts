import * as _ from "underscore";
import {SmoothieChart,TimeSeries} from 'smoothie';


/**
 * pin holds a value and enables connecting components together.
 */
export class pin {

    value = false;
    constructor() {

    }

}

/**
 * a component represented by an HTML button which sets it's output pin value
 * to its state. The state is inverted when the button is clicked.
 */
export class toggleSwitch {

    private state = false;
    private el: HTMLElement;
    private num
    public outputPin: pin = new pin();

    constructor(displayContainer: HTMLElement, uniqueID: string) {
        this.outputPin.value = this.state;

        $(displayContainer).append($('<p>' + uniqueID + '</p>'));

        let button = $('<input type="button" value="test">');
        button.click(() => {
            this.state = !this.state;
            this.outputPin.value = this.state;
        })
        $(displayContainer).append(button);
    }
}


export interface Ipart {
    update();
    assignInputPin(pin: pin, index: number);


}

export interface IAggregatePart {
    parts: Ipart[];
}

/**
 * a flipFlop - this component has a single bit of memory, 3 inputs, and an output.
 * It loads the input bit to the output if enable is true and if the clock moves from low to high.
 */
class binaryCell implements Ipart {

    public clockPin: pin;
    public dataPin: pin;
    public outputPin: pin = new pin();
    public enablePin: pin;

    private state: boolean = false;
    private lastClockpinValue;
    private smoothieChart;
    private timeSeries;


    constructor(signalDrawing?: HTMLCanvasElement) {
        if (signalDrawing) {
            this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
            this.smoothieChart.streamTo(signalDrawing);
            this.timeSeries = new TimeSeries();
            this.smoothieChart.addTimeSeries(this.timeSeries);
        }
    }

    public assignInputPin(pin: pin, index: number) {
        this.dataPin = pin;
    }

    //this update method is called on all components - and their pins are evaluated to 
    // determine their state.
    public update() {

        let clockPinValue = this.clockPin.value;

        //when the clock pin goes from false to true, and the enable pin is true:
        //set the current input to the output and update the state to that value.

        if ((clockPinValue == true && this.lastClockpinValue == false) && this.enablePin.value == true) {
            //this.state = this.dataPin ? this.dataPin.value : false;
            this.state = this.dataPin.value;
        }
        //TODO is this correct?
        this.outputPin.value = this.state;

        if (this.timeSeries) {
            this.timeSeries.append(new Date().getTime(), this.outputPin.value);

        }
        console.log("register state is", this.state);
        this.lastClockpinValue = this.clockPin.value;

    }

}

export class byteRegister implements Ipart, IAggregatePart {

    public clockPin: pin;
    private dataPins: pin[] = [];
    public outputPins: pin[] = [];
    public enablePin: pin;

    //build a bunch of internal parts and map the outputs of this chip to the
    //outputs of the internal parts.
    public parts: binaryCell[] = [];
    private lastClockpinValue;
    private smoothieChart;
    private timeSeries;


    constructor(clockpin: pin, enablePin: pin, signalDrawing?: HTMLCanvasElement, ) {
        if (signalDrawing) {
            this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
            this.smoothieChart.streamTo(signalDrawing);
            this.timeSeries = new TimeSeries();
            this.smoothieChart.addTimeSeries(this.timeSeries);
        }
        this.clockPin = clockpin;
        this.enablePin = enablePin;

        this.parts = _.range(0, 8).map((x, index) => {
            let part = new binaryCell();
            part.clockPin = this.clockPin;
            part.enablePin = this.enablePin;
            this.outputPins[index] = part.outputPin;
            return part;
        });

        //as default state, connect the inputs of this part to some floating pins.
        this.parts.forEach((part, index) => this.assignInputPin(new pin(), index));

    }

    public assignInputPin(pin: pin, index: number) {
        this.parts[index].assignInputPin(pin, 0);
    }

    public update() {

        let clockPinValue = this.clockPin.value;

        this.parts.forEach(part => { part.update() });

        var outputAsInt = parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
        this.timeSeries.append(new Date().getTime(), outputAsInt);

        console.log("register state is", outputAsInt);
        this.lastClockpinValue = this.clockPin.value;

    }

}