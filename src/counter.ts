import { Ipart, basePart } from "./primitives";
import * as _ from "underscore";
import { clock } from "./clock";
import { inputPin, outputPin } from "./pins_wires";


function leadingNullString(value: string | number, minSize: number): string {
    if (typeof value == "number") {
        value = "" + value;
    }
    let outString: string = '';
    let counter: number = minSize - value.length;
    if (counter > 0) {
        for (let i = 0; i < counter; i++) {
            outString += '0';
        }
    }
    return (outString + value);
}

//modeled after the behavior of the 74ls161 async clear, sync load.
export class binaryCounter extends basePart implements Ipart {

    private currentState = 0;
    //default input pin disconnected;
    public clearPin = new inputPin("clear", this, true);
    public clockPin = new inputPin("clock", this);
    public loadPin = new inputPin("load", this, true);
    public dataPins: inputPin[];

    public outputEnablePin1 = new inputPin("outputEnable1", this, true);
    public outputEnablePin2 = new inputPin("outputEnable2", this, true);

    public outputPins: outputPin[];
    public rippleCarryOut: outputPin;

    private lastClockpinValue;

    public get inputs() {
        return this.dataPins.concat(this.clearPin, this.clockPin,
            this.outputEnablePin1, this.outputEnablePin2, this.loadPin);
    }

    public get outputs() {
        return this.outputPins.concat(this.rippleCarryOut);
    }

    constructor(n: number, name?: string) {
        super(name);

        this.outputPins = _.range(0, n).map((x,i) => { return new outputPin("output" + x, this,i) });
        this.rippleCarryOut = new outputPin("carryOut", this);
        this.dataPins = _.range(0, n).map((x,i) => { return new inputPin("input" + x, this,false,i) });
    }

    private setOutputPins(){
        let bitArray = leadingNullString(this.currentState.toString(2), this.outputPins.length).split("").map(bit => { return Boolean(parseInt(bit)); });
        bitArray.forEach((bit, ind) => { this.outputPins[ind].value = bit });
        //ripple carry out should mimic the value of MSB.
        this.rippleCarryOut.value = this.outputPins[0].value;
    }

    update() {

        let clockPinValue = this.clockPin.value;

        let clockPulsed = clockPinValue == true && this.lastClockpinValue == false;
        let countEnabled = this.outputEnablePin1.value == false && this.outputEnablePin2.value == false;

        //if we are loading, load the inputs
        if (clockPulsed && this.loadPin.value == false) {
            let inputCount = parseInt(this.dataPins.map(pin => { return Number(pin.value) }).join(""), 2);
            this.currentState = inputCount;
            this.setOutputPins();

            //else if the clock pulsed, but we're not loading - increment the state
        } else if (clockPulsed && countEnabled) {
            this.currentState = this.currentState + 1;
            //represent the number plus 0
            let requiredBits = Math.ceil(Math.log(this.currentState + 1) / Math.log(2));

            if (requiredBits > this.outputPins.length) {
                this.currentState = 0;
            }

           this.setOutputPins();
        }
        if (this.clearPin.value == false) {
            this.currentState = 0;
            this.setOutputPins();
        }

        this.lastClockpinValue = this.clockPin.value;
        super.update();

    }

    public countAsInteger() {
        return this.currentState;
    }

    public toOutputString(){
        return this.countAsInteger().toString();
    }

}