import { nBuffer, VoltageRail, basePart } from "../primitives";
import { inputPin, wire } from "../pins_wires";


/**
 * This class has no inputs or outputs...
 * it has a custom view which aggregates all registers and makes
 * it easy to compare all their values.
 */
export class RegistersDebug extends basePart {
    constructor(name?: string) {
        super(name);
    }
}