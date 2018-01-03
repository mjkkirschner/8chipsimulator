import { pin, Ipart } from "./primitives";
import * as _ from "underscore";


export enum pinMode { input, output };

/**
 * This class can be used represent a pin on a part which can act as an output, but at other times
 * might need to act as an input and will need to reference other output pins.
 */
export class inputOutputPin extends pin {
    public mode: pinMode = pinMode.output;
    private inputReference: pin;
    private _value;

    constructor(name?: string, owner?: Ipart) {
        super(name, owner);
    }

    get value(): boolean {
        if (this.mode == pinMode.input) {
            return this.inputReference.value;
        }
        else {
            return this._value;
        }
    }
    set value(val: boolean) {
        if (this.mode == pinMode.input) {
            throw new Error("you cannot set the value of an input reference, set the value on the pin directly.");
        }
        else {
            this._value = val;
        }
    }

    public setPinMode(mode: pinMode, pinReference?: pin) {

        if (mode == pinMode.input) {
            this.mode = mode;
            this.inputReference = pinReference;
        }
        else {
            this.mode = mode;
            if (pinReference != null) {
                throw new Error("the mode was output but a reference was also passed...")
            }
        }
    }

}

export interface Imemory {

    addressPins: pin[];
    assignAddressPins(pins: pin[]);
    writeData(address: any, data: any)
    readData(address: any): any
}

export interface IinputOutputPart {

    assignInputOutputPin(pin: inputOutputPin | inputOutputPin[], index: number)
    update()
}

export class staticRam implements IinputOutputPart, Imemory {



    private data: Boolean[][];
    private writeEnable: pin;
    private chipEnable: pin;
    private outputEnable: pin;
    public InputOutputPins: inputOutputPin[] = [];
    public addressPins: pin[] = [];
    public wordSize: number;

    constructor(wordSize: number, length: number, writeEnable: pin, chipEnable: pin, outputEnable: pin) {
        //init data.
        this.data = _.range(0, length).map(x => { return _.range(0, wordSize).map(ind => { return false }) });
    }

    update() {
        throw new Error("Method not implemented.");
    }
    assignInputOutputPin(pin: inputOutputPin | inputOutputPin[], index: number) {

        if (pin instanceof Array) {
            if (pin.length != this.wordSize) {
                console.log("mismatch between pins and wordsize, some internal pins will be disconnected.")
            }
            pin.forEach((pin, i) => { this.InputOutputPins[i] = pin });
        }
        else {
            this.InputOutputPins[index] = pin;
        }
    }

    assignAddressPins(pins: pin[]) {
        pins.forEach((pin, index) => this.addressPins[index] = pin);
    }

    writeData(data: any) {
        //
        this.data
    }
    readData() {
        throw new Error("Method not implemented.");
    }
}


