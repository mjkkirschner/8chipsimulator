import { basePart, Ipart } from "./primitives";
import { inputPin, outputPin } from "./pins_wires";
import _ = require("underscore");



//comparator modeled after 74LS682. (except outputs are active high.)
export class nbitComparator extends basePart implements Ipart {

    public dataPinsA: inputPin[] = [];
    public dataPinsB: inputPin[] = [];
    public AEBOUT: outputPin = new outputPin("A==B", this);
    public ALBOUT: outputPin = new outputPin("A<B", this);

    public get inputs() {
        return this.dataPinsA.concat(this.dataPinsB);
    }

    public get outputs() {
        return [this.AEBOUT, this.ALBOUT];
    }

    constructor(n: number, name?: string) {
        super(name);

        this.dataPinsA = _.range(0, n).map((x, i) => { return new inputPin("inputA" + x, this, false, i) });
        this.dataPinsB = _.range(0, n).map((x, i) => { return new inputPin("inputB" + x, this, false, i) });

    }

    public update() {

        const A = parseInt(this.dataPinsA.map(pin => { return Number(pin.value) }).join(""), 2);
        const B = parseInt(this.dataPinsB.map(pin => { return Number(pin.value) }).join(""), 2);


        if (A == B) {
            this.AEBOUT.value = true;
            this.ALBOUT.value = false;
        }
        else if (A < B) {
            this.AEBOUT.value = false;
            this.ALBOUT.value = true;
        }
        else if (A > B) {
            this.AEBOUT.value = false;
            this.ALBOUT.value = false;
        }

    }

    public toOutputString(): string {
        return `A==B:${this.AEBOUT} | A<B:${this.ALBOUT}`
    }

} 