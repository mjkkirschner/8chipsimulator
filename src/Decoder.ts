import { Ipart, basePart } from "./primitives";
import * as _ from "underscore";
import { inputPin, outputPin } from "./pins_wires";

/**
 * 2 to 4 line decoder - modeled after 74ls139 behavior.
 */
export class twoLineToFourLineDecoder extends basePart implements Ipart {
    public dataPins: inputPin[] = [];
    public outputPins: outputPin[] = [];
    public outputEnablePin = new inputPin("outputEnable", this, true);;

    public get inputs() {
        return this.dataPins.concat(this.outputEnablePin)
    }

    public get outputs() {
        return this.outputPins;
    }

    constructor(name?:string) {
        super(name);
        //4 outputs
        this.outputPins = _.range(0, 4).map((x, i) => { return new outputPin("output" + i, this) });
        this.dataPins = [new inputPin("data1",this), new inputPin("data2",this)];
    }

    update() {
        //by default all pins high
        this.outputPins.forEach(pin => { pin.value = true; })
        //if enable is low then output
        if (this.outputEnablePin.value == false) {
            //get index from value
            let index = parseInt(this.dataPins.map(pin => { return Number(pin.value) }).join(""), 2);
            //use index to set one output low.
            this.outputPins[index].value = false;
        }
        super.update();
    }
}