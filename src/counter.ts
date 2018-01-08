import { Ipart, pin } from "./primitives";
import * as _ from "underscore";
import { clock } from "./clock";
import { request } from "http";


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
export class binaryCounter implements Ipart {

    private currentState = 0;
    //default input pin disconnected;
    private clearPin = new pin();
    private clockPin = new pin();
    private loadPin = new pin();
    private dataPins: pin[];

    public outputEnablePin1: pin;
    public outputEnablePin2: pin;

    public outputPins: pin[];
    public rippleCarryOut: pin;

    private lastClockpinValue;


    constructor(outputEnablePin1: pin,
        outputEnablePin2: pin,
        clearPin: pin,
        clockPin: pin,
        loadPin: pin,
        n: number) {

        this.outputEnablePin1 = outputEnablePin1;
        this.outputEnablePin2 = outputEnablePin2;
        this.clearPin = clearPin;
        this.clockPin = clockPin;
        this.loadPin = loadPin;

        this.outputPins = _.range(0, n).map(x => { return new pin("output" + x) });
        this.rippleCarryOut = new pin("carryOut");
    }

    update() {

        let clockPinValue = this.clockPin.value;

        let clockPulsed = clockPinValue == true && this.lastClockpinValue == false;
        let countEnabled = this.outputEnablePin1.value == true && this.outputEnablePin2.value == true;

        //if we are loading, load the inputs
        if (clockPulsed && this.loadPin.value == false) {
            let inputCount = parseInt(this.dataPins.map(pin => { return Number(pin.value) }).join(""), 2);
            this.currentState = inputCount;

            //else if the clock pulsed, but we're not loading - increment the state
        } else if (clockPulsed && countEnabled) {
            this.currentState = this.currentState + 1;
            let requiredBits = Math.floor(Math.log(Math.max(this.currentState - 1, 1)) * Math.LOG2E) + 1;

            if (requiredBits > this.outputPins.length) {
                this.currentState = 0;
            }

            let bitArray = leadingNullString(this.currentState.toString(2), this.outputPins.length).split("").map(bit => { return Boolean(parseInt(bit)); });
            bitArray.forEach((bit, ind) => { this.outputPins[ind].value = bit });
            //ripple carry out should mimic the value of MSB.
            this.rippleCarryOut.value = this.outputPins[0].value;
        }
        if (this.clearPin.value == false) {
            this.currentState = 0;
        }

        this.lastClockpinValue = this.clockPin.value;


    }
    assignInputPin(pin: pin | pin[], index?: number) {
        if (pin instanceof Array) {
            if (pin.length != this.outputPins.length) {
                console.log("mismatch between inputs and outputs, some internal pins will be disconnected.")
            }
            pin.forEach((pin, i) => { this.dataPins[i] = pin });
        }
        else {
            this.dataPins[index] = pin;

        }
    }

    public countAsInteger() {
        return this.currentState;
    }

}