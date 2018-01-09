import { Ipart, pin } from "./primitives";
import * as _ from "underscore";

/**
 * 2 to 4 line decoder - modeled after 74ls139 behavior.
 */
export class twoLineToFourLinedecoder implements Ipart {
    private dataPins: pin[] = [];
    public outputPins: pin[] = [];
    public outputEnablePin: pin;

    constructor(outputEnablePin: pin) {
        this.outputEnablePin = outputEnablePin;
        //4 outputs
        this.outputPins = _.range(0, 4).map((x, i) => { return new pin("output" + i) });
        this.dataPins = [new pin(), new pin()];
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
    }

    assignInputPin(pin: pin | pin[], index?: number) {
        if (pin instanceof Array) {
            if (pin.length != this.dataPins.length) {
                console.log("mismatch between parts and pins, some internal pins will be disconnected.")
            }
            pin.forEach((pin, i) => { this.dataPins[i] = pin });
        }
        else {
            this.dataPins[index] = pin;

        }
    }
}