import { basePart } from "../primitives";
import _ = require("underscore");
import { inputPin } from "../pins_wires";
import { Color } from "csstype";


/**
 * a simplified binary vga monitor...
 * collects all RGB signals in 3 buffers until it sees
 * a horizontal sync pulse, then starts next line.
 * real implementation is time dependent and would require 3 DACs.
 */
export class vgaMonitorPart extends basePart {

    private RGBLineBuffer: number[] = [];
    public screen: number[][];

    public clock: inputPin = new inputPin("clock", this);
    public hsync: inputPin = new inputPin("hsync", this);
    public vsync: inputPin = new inputPin("vsync", this);

    private lasthsyncValue;
    private lastvsyncValue;
    private lastclockValue;


    public red: inputPin[];
    public green: inputPin[];
    public blue: inputPin[];

    public width;
    public height;

    constructor(x: number, y: number, name: string) {
        super(name);
        this.screen = [];
        this.red = _.range(0, 4).map(i => new inputPin("red" + i, this, false, i));
        this.green = _.range(0, 4).map(i => new inputPin("green" + i, this, false, i));
        this.blue = _.range(0, 4).map(i => new inputPin("blue" + i, this, false, i));
        this.width = x;
        this.height = y;
    }

    update() {
        //collect any changing colors between pulses
        if (this.hsync.value == true && this.lasthsyncValue == false) {
            this.screen.push(this.RGBLineBuffer);
            this.RGBLineBuffer = [];
        }
        //start screen over.
        if (this.vsync.value == true && this.lastvsyncValue == false) {
            this.screen = [];
        }

        let red = parseInt(this.red.map(pin => { return Number(pin.value) }).join(""), 2);
        let green = parseInt(this.red.map(pin => { return Number(pin.value) }).join(""), 2);
        let blue = parseInt(this.red.map(pin => { return Number(pin.value) }).join(""), 2);

        if (this.clock.value == true && this.lastclockValue == false) {
            this.RGBLineBuffer.push(red, green, blue, 255);
        }

        this.lasthsyncValue = this.hsync.value;
        this.lastvsyncValue = this.vsync.value;
        this.lastclockValue = this.clock.value;
        super.update();

    }

}