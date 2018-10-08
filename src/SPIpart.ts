import { basePart, Ipart } from "./primitives";
import { inputPin, outputPin } from "./pins_wires";
import _ = require("underscore");

export class SPIComPart extends basePart implements Ipart {

    public statusPins: outputPin[] = [];
    public controlPins: inputPin[] = [];
    public dataoutputPins: outputPin[] = [];
    public clockPin: inputPin = new inputPin("clockpin", this);

    public clockout: outputPin = new outputPin("clockOut", this);
    public serialin: inputPin = new inputPin("serialin", this);
    public enable: outputPin = new outputPin("enable", this);



    constructor(n, name?: string) {
        super(name);
        //make pin ranges
        this.statusPins = _.range(0, n).map(x => new outputPin("status" + x, this, x))
        this.controlPins = _.range(0, n).map(x => new inputPin("control" + x, this))
        this.dataoutputPins = _.range(0, n).map(x => new outputPin("dataoutput" + x, this, x))

    }



}