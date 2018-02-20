import { Ipart, basePart } from "./primitives";
import * as _ from "underscore";
import { error } from "util";
import { inputPin, inputOutputPin, pinMode, outputPin, wire } from "./pins_wires";




export interface Imemory {

    addressPins: inputPin[];
    wireUpAddressPins(pins: outputPin[]);
    writeData(address: any, data: any)
    readData(address: any): any
    data: boolean[][];
}

/**
 * represents an SRAM chip with I/O pins-
 * the chip has chip, write, and output enable modes
 * modeled after something like the:
 * CY7C199 32kx8 RAM module.
 */
export class staticRam extends basePart implements Ipart, Imemory {

    public data: boolean[][];
    public writeEnable = new inputPin("writeEnable", this, true);
    public chipEnable = new inputPin("chipEnable", this, true);
    public outputEnable = new inputPin("outEnable", this, true);
    public InputOutputPins: inputOutputPin[] = [];
    public addressPins: inputPin[] = [];
    public wordSize: number;
    private lastWEstate: boolean = true;


    public get inputs() {
        let step1 = this.addressPins.concat(this.writeEnable, this.chipEnable,
            this.outputEnable);
        let step2 = step1.concat(this.InputOutputPins.map(x => { return x.internalInput }));
        return step2;
    }

    public get outputs() {
        return this.InputOutputPins.map(x => { return x.internalOutput });
    }


    /**
     * 
     * @param wordSize size of the words this chip holds (usually 8bits).
     * @param length total number of words this chip can hold.
     */
    constructor(wordSize: number, length: number) {
        super();
        //init data.
        this.wordSize = wordSize;

        //generate empty data cells.
        this.data = _.range(0, length).map(x => { return _.range(0, wordSize).map(ind => { return false }) });
        //generate the input output pins.
        this.InputOutputPins = _.range(0, wordSize).map(ind => { return new inputOutputPin("in/out:" + ind, this) });
        //generate address pins
        let requiredBits = Math.floor(Math.log(this.data.length - 1) /Math.log(2)) + 1;
        this.addressPins = _.range(0, requiredBits).map(x => { return new inputPin("address" + x, this) });
    }

    update() {
        //case 1 - read. ChipEnable low, output low, write high, get data on address lines and read value to outputs.
        //put pins in output mode.
        if (this.chipEnable.value == false && this.outputEnable.value == false && this.writeEnable.value == true) {

            let addressToRead = parseInt(this.addressPins.map(pin => { return Number(pin.value) }).join(""), 2);
            let dataToOutput = this.data[addressToRead];

            //TODO required?
            this.InputOutputPins.forEach(pin => { pin.mode = pinMode.output });
            this.InputOutputPins.forEach((pin, index) => { pin.value = dataToOutput[index] });
        }
        //case 2 - write chip low, output high, write low. - and WE just went low.
        else if (this.chipEnable.value == false && this.outputEnable.value == true && this.writeEnable.value == false && this.lastWEstate == true) {
            //get address to write
            let addressToWrite = parseInt(this.addressPins.map(pin => { return Number(pin.value) }).join(""), 2);
            //TODO look at this again... what does it do?
            let dataToWrite = this.InputOutputPins.map(pin => { pin.mode = pinMode.input; return pin.value });
            this.data[addressToWrite] = dataToWrite;
        }

        this.lastWEstate = this.writeEnable.value;
    }


    /**
     * a helper method to wire up multiple output pins to the address lines
     * returns an array of wires created.
     * @param pins output pins for driving the address lines
     */
    wireUpAddressPins(pins: outputPin[]): wire[] {
        //check that we have enough address pins
        let requiredBits = Math.floor(Math.log(this.data.length) / Math.log(2)) + 1;
        if (requiredBits > pins.length) {
            console.log("not enough address pins to access all cells in memory");
        }
        return pins.map((pin, index) => { return new wire(pin, this.addressPins[index]) });
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


