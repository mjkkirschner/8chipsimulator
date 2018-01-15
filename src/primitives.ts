import * as _ from "underscore";
import { SmoothieChart, TimeSeries } from 'smoothie';
import { error } from "util";
import { outputPin, pin, inputPin, wire, internalWire } from "./pins_wires";



/**
 * a component represented by an HTML button which sets it's output pin value
 * to its state. The state is inverted when the button is clicked.
 */
export class toggleSwitch {

    private state = false;
    private el: HTMLElement;
    private num
    public outputPin: outputPin = new outputPin();

    constructor(uniqueID: string, displayContainer?: HTMLElement) {
        this.outputPin.value = this.state;

        let button = $('<input type="button" value="test">');
        button.click(() => {
            this.state = !this.state;
            this.outputPin.value = this.state;
        });
        if (displayContainer) {
            $(displayContainer).append($('<p>' + uniqueID + '</p>'));
            $(displayContainer).append(button);
        }

    }
}


export interface Ipart {
    update();
}

export interface IAggregatePart {
    parts: Ipart[];
    getDataAsInteger(): number
    //internal wires are used to attach the external pins to the internal pins.
    internalWires: internalWire[];
}

/**
 * a flipFlop - this component has a single bit of memory, 3 inputs, and an output.
 * It loads the input bit to the output if enable is true and if the clock moves from low to high.
 */
class binaryCell implements Ipart {

    public clockPin: inputPin = new inputPin("clockPin", this);
    public dataPin: inputPin = new inputPin("data", this);
    public outputPin: outputPin = new outputPin();
    public enablePin: inputPin = new inputPin("data", this);

    private state: boolean = false;
    private lastClockpinValue;
    private smoothieChart;
    private timeSeries;


    constructor(signalDrawing?: HTMLCanvasElement) {

        //TODO rethink using smoothie here... maybe this should not be part of the model constructors.
        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        if (signalDrawing) {
            this.smoothieChart.streamTo(signalDrawing);
        }
        this.timeSeries = new TimeSeries();
        this.smoothieChart.addTimeSeries(this.timeSeries);
    }

    //this update method is called on all components - and their pins are evaluated to 
    // determine their state.
    public update() {

        let clockPinValue = this.clockPin.value;

        //when the clock pin goes from false to true, and the enable pin is true:
        //set the current input to the output and update the state to that value.

        if ((clockPinValue == true && this.lastClockpinValue == false) && this.enablePin.value == true) {
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

export class inverter implements Ipart {

    //default input pin disconnected;
    public dataPin = new inputPin("data", this);
    public outputEnablePin = new inputPin("outputEnable", this);
    public outputPin = new outputPin("invertedOut", this);

    constructor() {
    }

    update() {
        //if the output enable pin are high - output the input value.
        if (this.outputEnablePin && this.outputEnablePin.value == true) {
            this.outputPin.value = !(this.dataPin.value);
        }
    }
}

class buffer implements Ipart {

    //default input pin disconnected;
    public dataPin = new inputPin("data", this);

    public outputEnablePin = new inputPin("outputEnable", this);
    public outputPin = new outputPin("data out", this);


    constructor() {
    }

    update() {
        //if the output enable pin are high - output the input value.
        if (this.outputEnablePin && this.outputEnablePin.value == true) {
            this.outputPin.value = this.dataPin.value;
        }
    }
}

export class nBuffer implements Ipart, IAggregatePart {
    internalWires: internalWire[] = [];
    parts: buffer[];
    public dataPins: inputPin[] = [];
    public outputPins: outputPin[] = [];
    public outputEnablePin = new inputPin("outputEnable", this);

    constructor(n = 8) {

        this.parts = _.range(0, n).map((x, index) => {
            let part = new buffer();
            this.dataPins[index] = new inputPin("input" + index, this);
            this.outputPins[index] = new outputPin("output" + index, this);
            //build internal wires

            let intWire = new internalWire(this.dataPins[index], part.dataPin);
            let intWire2 = new internalWire(this.outputEnablePin, part.outputEnablePin);
            //note this is reversed from other wires
            let outWire = new internalWire(this.outputPins[index], part.outputPin);
            this.internalWires.push(intWire);
            this.internalWires.push(intWire2);
            this.internalWires.push(outWire);

            return part;
        });
    }

    update() {
        this.parts.forEach(part => { part.update(); })
    }

    public getDataAsInteger() {
        return parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

}

export class nRegister implements Ipart, IAggregatePart {
    internalWires: internalWire[] = [];
    public clockPin = new inputPin("clockPin", this);
    public dataPins: inputPin[] = [];
    public outputPins: outputPin[] = [];
    public enablePin = new inputPin("Enable", this);

    //build a bunch of internal parts and map the outputs of this chip to the
    //outputs of the internal parts.
    public parts: binaryCell[] = [];
    private lastClockpinValue;
    private smoothieChart;
    private timeSeries;


    constructor(n = 8, signalDrawing?: HTMLCanvasElement) {

        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        if (signalDrawing) {
            this.smoothieChart.streamTo(signalDrawing);
        }
        this.timeSeries = new TimeSeries();
        this.smoothieChart.addTimeSeries(this.timeSeries);

        this.parts = _.range(0, n).map((x, index) => {
            let part = new binaryCell();
            this.dataPins[index] = new inputPin("input" + index, this);
            this.outputPins[index] = new outputPin("output" + index, this);
            //build internal wires

            let clockWire = new internalWire(this.clockPin, part.clockPin);
            let enableWire = new internalWire(this.enablePin, part.enablePin);
            let intWire = new internalWire(this.dataPins[index], part.dataPin);
            //note this is reversed from other wires
            //TODO not sure it should be....
            let outWire = new internalWire(this.outputPins[index], part.outputPin);

            this.internalWires.push(intWire);
            this.internalWires.push(clockWire);
            this.internalWires.push(enableWire);
            this.internalWires.push(outWire);

            return part;
        });
    }

    public getDataAsInteger() {
        return parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    public update() {

        let clockPinValue = this.clockPin.value;

        this.parts.forEach(part => { part.update() });

        var outputAsInt = this.getDataAsInteger();
        this.timeSeries.append(new Date().getTime(), outputAsInt);

        console.log("register state is", outputAsInt);
        this.lastClockpinValue = this.clockPin.value;

    }

}

/**
 * this class represents a bus - it enables multiple input connections which
 * are then routed to a single output - it acts almost like a data selector 
 * but the input which is routed is implicitly controlled - not set with a selection
 * signal. Any number of input groups (of n pins) can be routed to the n output pins,
 * but only one will ever be active at a time.
 */
export class bus implements Ipart {

    public outputPins: outputPin[] = [];
    public inputGroups: Array<Array<inputPin>> = [];

    update() {
        // when the bus updates we need to identify which inputs are currently enabled(writing to the bus), if any - 
        // then send those signals out on the outputs
        //if we find two active input groups, then throw an exception for now.

        //TODO consider adding triState logic to pins instead of bools, then we don't care who owns this pin.
        let groupStates = this.inputGroups.map(group => {
            return _.any(group, (pin) => {
                //go walk the wire and find where this connector started...
                if (pin.attachedWire.startPin.owner == null) {
                    throw new Error("the pin does not have an owner assigned - we cannot compute which IC is writing to the bus.");
                }
                return (pin.attachedWire.startPin.owner as buffer).outputEnablePin.value == true
            });
        });

        var activeGroupCount = groupStates.filter((active) => { return active }).length;
        if (activeGroupCount > 1) {
            throw new Error("there are multiple active input groups on this bus, undefined behavior.");
        }

        if (activeGroupCount == 1) {
            let index = groupStates.indexOf(true);
            let activeinput = this.inputGroups[index];
            activeinput.forEach((pin, index) => this.outputPins[index].value = pin.value);
        }
        //if there is one writing to the bus, turn off all pins.
        else {
            this.outputPins.forEach(x => x.value = false);
        }

    }

    getDataAsInteger(): number {
        return parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    constructor(busWidth: number, NumberOfInputGroups: number) {
        //create output pins
        this.outputPins = _.range(0, busWidth).map((x, index) => { return new outputPin("output" + index, this) });
        this.inputGroups = _.range(0, NumberOfInputGroups).map((x, index) => {
            return _.range(0, busWidth).map(width => {
                return new inputPin("input" + index, this);
            });
        });

    }

}