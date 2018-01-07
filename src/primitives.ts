import * as _ from "underscore";
import { SmoothieChart, TimeSeries } from 'smoothie';
import { error } from "util";


/**
 * pin holds a value and enables connecting components together.
 */
export class pin {

    value = false;
    name: String;
    owner: Ipart;
    constructor(name?: string, owner?: Ipart) {
        if (name) {
            this.name = name;
        }
        if (owner) {
            this.owner = owner;
        }
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
    assignInputPin(pin: pin, index: number);

}

export interface IAggregatePart {
    parts: Ipart[];
    getDataAsInteger(): number
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

        //TODO rethink using smoothie here... maybe this should not be part of the model constructors.
        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        if (signalDrawing) {
            this.smoothieChart.streamTo(signalDrawing);
        }
        this.timeSeries = new TimeSeries();
        this.smoothieChart.addTimeSeries(this.timeSeries);
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

class buffer implements Ipart {

    //default input pin disconnected;
    private dataPin = new pin();

    public outputEnablePin: pin;
    public outputPin: pin = new pin();

    constructor(outputEnablePin: pin) {
        this.outputEnablePin = outputEnablePin;
    }

    update() {
        //if the output enable pin are high - output the input value.
        if (this.outputEnablePin && this.outputEnablePin.value == true) {
            this.outputPin.value = this.dataPin.value;
        }
    }
    assignInputPin(pin: pin, index: number) {
        this.dataPin = pin;
    }

}

export class nBuffer implements Ipart, IAggregatePart {
    parts: buffer[];
    private dataPins: pin[] = [];
    public outputPins: pin[] = [];
    public outputEnablePin: pin;

    constructor(outputEnablePin: pin, n = 8) {
        this.outputEnablePin = outputEnablePin;

        this.parts = _.range(0, n).map((x, index) => {
            let part = new buffer(this.outputEnablePin);
            this.outputPins[index] = part.outputPin;
            part.outputPin.owner = this;
            return part;
        });

        //as default state, connect the inputs of this part to some floating pins.
        this.parts.forEach((part, index) => this.assignInputPin(new pin(), index));
    }

    update() {
        this.parts.forEach(part => { part.update(); })
    }
    //TODO do this same thing for other nbitParts.
    assignInputPin(pin: pin | pin[], index: number) {
        if (pin instanceof Array) {
            if (pin.length != this.parts.length) {
                console.log("mismatch between parts and pins, some internal pins will be disconnected.")
            }
            pin.forEach((pin, i) => { this.parts[i].assignInputPin(pin, 0) })
        }
        else {
            this.parts[index].assignInputPin(pin, 0);

        }
    }

    public getDataAsInteger() {
        return parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

}

export class nRegister implements Ipart, IAggregatePart {

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


    constructor(clockpin: pin, enablePin: pin, n = 8, signalDrawing?: HTMLCanvasElement, ) {

        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        if (signalDrawing) {
            this.smoothieChart.streamTo(signalDrawing);
        }
        this.timeSeries = new TimeSeries();
        this.smoothieChart.addTimeSeries(this.timeSeries);

        this.clockPin = clockpin;
        this.enablePin = enablePin;

        this.parts = _.range(0, n).map((x, index) => {
            let part = new binaryCell();
            part.clockPin = this.clockPin;
            part.enablePin = this.enablePin;
            this.outputPins[index] = part.outputPin;
            part.outputPin.owner = this;

            return part;
        });

        //as default state, connect the inputs of this part to some floating pins.
        this.parts.forEach((part, index) => this.assignInputPin(new pin(), index));

    }

    assignInputPin(pin: pin | pin[], index: number) {
        if (pin instanceof Array) {
            if (pin.length != this.parts.length) {
                console.log("mismatch between parts and pins, some internal pins will be disconnected.")
            }
            pin.forEach((pin, i) => { this.parts[i].assignInputPin(pin, 0) })
        }
        else {
            this.parts[index].assignInputPin(pin, 0);

        }
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

    public outputPins: pin[] = [];
    public inputGroups: Array<Array<pin>> = [];

    update() {
        // when the bus updates we need to identify which inputs are currently enabled(writing to the bus), if any - 
        // then send those signals out on the outputs
        //if we find two active input groups, then throw an exception for now.

        //TODO consider adding triState logic to pins instead of bools, then we don't care who owns this pin.
        let groupStates = this.inputGroups.map(group => {
            return _.any(group, (pin) => {
                if (pin.owner == null) {
                    throw new Error("the pin does not have an owner assigned - we cannot compute which IC is writing to the bus.");
                }
                return (pin.owner as buffer).outputEnablePin.value == true
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

    assignInputPin(pin: pin | pin[], index: number) {

        if (pin instanceof Array) {
            this.inputGroups[index] = pin;
        }
        else {
            throw new Error("have not implemented passing single pins to bus yet.");
        }


    }

    getDataAsInteger(): number {
        return parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    constructor(parity: number) {
        //create output pins
        this.outputPins = _.range(0, parity).map((x, index) => { return new pin("output" + index, this) });
    }

}