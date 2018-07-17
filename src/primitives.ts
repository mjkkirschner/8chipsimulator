import * as _ from "underscore";
import { outputPin, pin, inputPin, wire, internalWire } from "./pins_wires";
import { simulatorExecution } from "./engine";
import { ipoint } from "./views/wireView";
import * as fs from 'fs';
import * as Console from 'console';


const output = fs.createWriteStream('./stdout.log');
const errorOutput = fs.createWriteStream('./stderr.log');
// custom simple logger
const logger = new Console.Console(output, errorOutput);
// use it like console


export interface Ipart extends IObservablePart {
    update(simulator?: simulatorExecution);
    outputs: Array<outputPin>
    inputs: Array<inputPin>
    id: string
    displayName?: string
    toOutputString?(): string
}

export interface IObservablePart {
    registerCallbackOnUpdate(callback: (data: boolean[]) => void)
}


export abstract class basePart implements Ipart {
    id: string
    displayName: string = ""
    private updateCallbacks = [];
    protected uuidv4() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }
    registerCallbackOnUpdate(callback) {
        this.updateCallbacks.push(callback);
    }

    update(simulator?: simulatorExecution) {
       
        this.updateCallbacks.forEach(x => x());
    }

    get outputs() {
        return [];
    }
    get inputs() {
        return [];
    }



    constructor(name?: string) {
        this.id = this.uuidv4();
        if (name) {
            this.displayName = name;
        }
    }
}

export interface IAggregatePart {
    parts: Ipart[];
    getDataAsInteger(): number
    //internal wires are used to attach the external pins to the internal pins.
    internalWires: internalWire[];
}



export class VoltageRail extends basePart implements Ipart {

    public outputPin: outputPin;
    constructor(name?: string) {
        super(name);
        this.outputPin = new outputPin(name, this);
    }
    update() {
        super.update();
    }
    get outputs() {
        return [this.outputPin];
    }
    get inputs() {
        return [];
    }
}

/**
 * a flipFlop - this component has a single bit of memory, 3 inputs, and an output.
 * It loads the input bit to the output if enable is true and if the clock moves from low to high.
 */
class binaryCell extends basePart implements Ipart {

    public clockPin: inputPin = new inputPin("clockPin", this);
    public dataPin: inputPin = new inputPin("data", this);
    public outputPin: outputPin = new outputPin("output",this);
    public enablePin: inputPin = new inputPin("enable", this);

    private state: boolean = false;
    private lastClockpinValue;
    private smoothieChart;
    private timeSeries;

    public get inputs() {
        return [this.clockPin, this.dataPin, this.enablePin];
    }

    public get outputs() {
        return [this.outputPin];
    }


    constructor(name?: string) {
        super(name);
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

        this.lastClockpinValue = this.clockPin.value;
        super.update();
    }

}

export class ANDGATE extends basePart implements Ipart {

    public dataPin1 = new inputPin("data1", this);
    public dataPin2 = new inputPin("data2", this);

    public outputPin = new outputPin("andedOut", this);

    public get inputs() {
        return [this.dataPin1, this.dataPin2];
    }

    public get outputs() {
        return [this.outputPin];
    }

    constructor(name?: string) {
        super(name);
    }

    update() {

        this.outputPin.value = (this.dataPin1.value && this.dataPin2.value);
        super.update();
    }
}


export class ORGATE extends basePart implements Ipart {

    public dataPin1 = new inputPin("data1", this);
    public dataPin2 = new inputPin("data2", this);

    public outputPin = new outputPin("ordOUT", this);

    public get inputs() {
        return [this.dataPin1, this.dataPin2];
    }

    public get outputs() {
        return [this.outputPin];
    }

    constructor(name?: string) {
        super(name);
    }

    update() {

        this.outputPin.value = (this.dataPin1.value || this.dataPin2.value);
        super.update();
    }
}



export class inverter extends basePart implements Ipart {

    //default input pin disconnected;
    public dataPin = new inputPin("data", this);
    public outputEnablePin = new inputPin("outputEnable", this);
    public outputPin = new outputPin("invertedOut", this);

    public get inputs() {
        return [this.dataPin, this.outputEnablePin];
    }

    public get outputs() {
        return [this.outputPin];
    }

    constructor(name?: string) {
        super(name);
    }

    update() {
        //if the output enable pin are high - output the input value.
        if (this.outputEnablePin && this.outputEnablePin.value == true) {
            this.outputPin.value = !(this.dataPin.value);
        }
        super.update();
    }
}

class buffer extends basePart implements Ipart {

    //default input pin disconnected;
    public dataPin = new inputPin("data", this);

    public outputEnablePin = new inputPin("outputEnable", this);
    public outputPin = new outputPin("data out", this);

    public get inputs() {
        return [this.dataPin, this.outputEnablePin];
    }

    public get outputs() {
        return [this.outputPin];
    }

    constructor(name?: string) {
        super(name);
    }

    update() {
        //if the output enable pin are high - output the input value.
        if (this.outputEnablePin && this.outputEnablePin.value == true) {
            this.outputPin.value = this.dataPin.value;
        }else{
            this.outputPin.value = false;
        }
        super.update();
    }
}

export class nBuffer extends basePart implements Ipart, IAggregatePart {
    internalWires: internalWire[] = [];
    parts: buffer[];
    public dataPins: inputPin[] = [];
    public outputPins: outputPin[] = [];
    public outputEnablePin = new inputPin("outputEnable", this);

    public get inputs() {
        return this.dataPins.concat(this.outputEnablePin)
    }

    public get outputs() {
        return this.outputPins;
    }

    constructor(n = 8, name?: string, names?: string[]) {
        super(name);
        if (names != null && names.length != n) {
            throw new Error("names list length must match n")
        }

        this.parts = _.range(0, n).map((x, index) => {
            let part = new buffer();
            let name = "data";
            if (names) {
                name = names[index];
            }

            this.dataPins[index] = new inputPin(name + index, this);
            this.outputPins[index] = new outputPin(name + index, this);
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
        super.update();
    }

    public getDataAsInteger() {
        return parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

}

export class nRegister extends basePart implements Ipart, IAggregatePart {
    internalWires: internalWire[] = [];
    public clockPin = new inputPin("clockPin", this);
    public dataPins: inputPin[] = [];
    public outputPins: outputPin[] = [];
    public enablePin = new inputPin("Enable", this);

    //build a bunch of internal parts and map the outputs of this chip to the
    //outputs of the internal parts.
    public parts: binaryCell[] = [];
    private lastClockpinValue;

    public get inputs() {
        return this.dataPins.concat(this.clockPin, this.enablePin)
    }

    public get outputs() {
        return this.outputPins;
    }

    constructor(n = 8, name?: string) {
        super(name);
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
        this.parts.slice().reverse().forEach(part => { part.update() });
        var outputAsInt = this.getDataAsInteger();
        this.lastClockpinValue = this.clockPin.value;
        super.update();

    }

    public toOutputString() {
        return parseInt(this.outputs.map(pin => { return Number(pin.value) }).join(""), 2).toString();
    }

}

/**
 * this class represents a bus - it enables multiple input connections which
 * are then routed to a single output - it acts almost like a data selector 
 * but the input which is routed is implicitly controlled - not set with a selection
 * signal. Any number of input groups (of n pins) can be routed to the n output pins,
 * but only one will ever be active at a time.
 */
export class bus extends basePart implements Ipart {

    public outputPins: outputPin[] = [];
    public inputGroups: Array<Array<inputPin>> = [];

    public get inputs() {
        return _.flatten(this.inputGroups);
    }

    public get outputs() {
        return this.outputPins;
    }

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
        //if there is no one writing to the bus, turn off all pins.
        else {
            this.outputPins.forEach(x => x.value = false);
        }

    }

    getDataAsInteger(): number {
        return parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

    constructor(busWidth: number, NumberOfInputGroups: number, name?: string) {
        super(name);
        //create output pins
        this.outputPins = _.range(0, busWidth).map((x, index) => { return new outputPin("output" + index, this) });
        this.inputGroups = _.range(0, NumberOfInputGroups).map((x, index) => {
            return _.range(0, busWidth).map(width => {
                return new inputPin("input" + index, this);
            });
        });

    }

}