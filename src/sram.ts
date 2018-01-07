import { pin, Ipart } from "./primitives";
import * as _ from "underscore";
import { error } from "util";


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

            //TODO...not sure about this - if we're in input mode
            //it makes sense that this pin is in HIGHZ and has no value.
            return undefined;
            //return this.inputReference.value;
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

    get inputValue(): boolean {
        if (this.inputReference && this.mode == pinMode.input) {
            return this.inputReference.value;
        }
        else {
            throw new Error("the mode was not input or the input reference was invalid, cannot get an input value");
        }
    }

    public setPinMode(mode: pinMode, pinReference?: pin) {

        if (mode == pinMode.input) {
            this.mode = mode;
            //if a reference is passed, update it.
            if (pinReference) {
                this.inputReference = pinReference;

            }
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

/**
 * represents an SRAM chip with I/O pins-
 * the chip has chip, write, and output enable modes
 * modeled after something like the:
 * CY7C199 32kx8 RAM module.
 */
export class staticRam implements Ipart, Imemory {

    private data: boolean[][];
    private writeEnable: pin;
    private chipEnable: pin;
    private outputEnable: pin;
    public InputOutputPins: inputOutputPin[] = [];
    public addressPins: pin[] = [];
    public wordSize: number;

    /**
     * 
     * @param wordSize size of the words this chip holds (usually 8bits).
     * @param length total number of words this chip can hold.
     * @param writeEnable active low write enable
     * @param chipEnable active low chip enable
     * @param outputEnable active low output enable
     */
    constructor(wordSize: number, length: number, writeEnable: pin, chipEnable: pin, outputEnable: pin) {
        //init data.
        this.wordSize = wordSize;
        this.chipEnable = chipEnable;
        this.writeEnable = writeEnable;
        this.outputEnable = outputEnable;

        //generate empty data cells.
        this.data = _.range(0, length).map(x => { return _.range(0, wordSize).map(ind => { return false }) });
        //generate the input output pins.
        this.InputOutputPins = _.range(0, wordSize).map(ind => { return new inputOutputPin("in/out:" + ind) });
    }

    update() {
        //case 1 - read. ChipEnable low, output low, write high, get data on address lines and read value to outputs.
        //put pins in output mode.
        if (this.chipEnable.value == false && this.outputEnable.value == false && this.writeEnable.value == true) {

            let addressToRead = parseInt(this.addressPins.map(pin => { return Number(pin.value) }).join(""), 2);
            let dataToOutput = this.data[addressToRead];

            //TODO required?
            this.InputOutputPins.forEach(pin => { pin.setPinMode(pinMode.output) });
            this.InputOutputPins.forEach((pin, index) => { pin.value = dataToOutput[index] });
        }
        //case 2 - write chip low, output high, write low.
        else if (this.chipEnable.value == false && this.outputEnable.value == true && this.writeEnable.value == false) {
            //get address to write
            let addressToWrite = parseInt(this.addressPins.map(pin => { return Number(pin.value) }).join(""), 2);
            //TODO look at this again... what does it do?
            let dataToWrite = this.InputOutputPins.map(pin => { pin.setPinMode(pinMode.input); return pin.inputValue });
            this.data[addressToWrite] = dataToWrite;
        }
    }

    assignInputPin(pin: pin | pin[], index?: number) {

        if (pin instanceof Array) {
            if (pin.length != this.wordSize) {
                console.log("mismatch between pins and wordsize, some internal pins will be disconnected.");
            }
            pin.forEach((pin, i) => { this.InputOutputPins[i].setPinMode(pinMode.input, pin) });
        }
        else {
            this.InputOutputPins[index].setPinMode(pinMode.input, pin);
        }
    }

    assignAddressPins(pins: pin[]) {
        //check that we have enough address pins
        let requiredBits = Math.floor(Math.log(this.data.length - 1) * Math.LOG2E) + 1;
        if (requiredBits > pins.length) {
            console.log("not enough address pins to access all cells in memory");
        }
        pins.forEach((pin, index) => this.addressPins[index] = pin);
    }

    /**
     * This is a convenience method for writing data to a memory chip - usually used for 
     * initializing it as it was programmed already.
     * @param address address to write data to
     * @param data data to write
     */
    writeData(address: number, data: boolean[]) {
        this.data[address] = data;
    }

    /**
     * this is a convenience method for accessing the data at a specific cell in memory
     * @param address address to read from
     */
    readData(address: number): boolean[] {
        return this.data[address];
    }
}


