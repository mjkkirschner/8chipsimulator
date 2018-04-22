import { nBuffer, VoltageRail } from "./primitives";
import { inputPin, wire } from "./pins_wires";

/**
 * this class is just like a buffer, but 
 * it has a custom view which graphs its input data.
 */
export class grapher extends nBuffer {
    constructor(n = 8, name?: string) {
        super(n, name);
        let on = new VoltageRail("on");
        on.outputPin.value = true;
        new wire(on.outputPin, this.outputEnablePin);
    }
}