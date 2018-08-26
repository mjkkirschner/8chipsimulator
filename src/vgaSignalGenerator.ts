import { inputPin, outputPin } from "./pins_wires";
import { basePart, Ipart } from "./primitives";
import _ = require("underscore");

/**
 * represents
 */
export class vgaSignalGenerator extends basePart implements Ipart {

    public clockPin: inputPin = new inputPin("clock", this);
    public h_sync: outputPin = new outputPin("hsync", this);
    public v_sync: outputPin = new outputPin("vsync", this);
    public validDisplayPosition: outputPin = new outputPin("validDisplayPosition", this);
    public Xposition: outputPin[] = [];
    public YPosition: outputPin[] = [];

    private lastClockpinValue;
    private xcounter = 0;
    private ycounter = 0;

    private HA_STA = 16 + 96 + 48;
    private VA_END = 480;

    public get inputs() {
        return [this.clockPin];
    }

    public get outputs() {
        return this.Xposition.concat(this.YPosition).concat(this.h_sync).concat(this.v_sync).concat(this.validDisplayPosition);
    }


    constructor(xbits: number, ybits: number) {
        super(name);

        //generate empty data cells.
        this.Xposition = _.range(0, xbits).map((x, i) => { return new outputPin("xbit" + i, this, i) });
        this.YPosition = _.range(0, ybits).map((x, i) => { return new outputPin("ybit" + i, this, i) });

    }


    private leadingNullString(value: string | number, minSize: number): string {
        if (typeof value == "number") {
            value = "" + value;
        }
        let outString: string = '';
        let counter: number = minSize - value.length;
        if (counter > 0) {
            for (let i = 0; i < counter; i++) {
                outString += '0';
            }
        }
        return (outString + value);
    }

    update() {
        let clockPinValue = this.clockPin.value;
        let clockPulsed = clockPinValue == true && this.lastClockpinValue == false;

        if (clockPulsed) {
            //reset x pos if we max out
            if (this.xcounter == 800) {
                this.Xposition.forEach(x => x.value = false);
            }
            else {
                this.xcounter = this.xcounter + 1;
                //set output pins to match internal state.

                //keep x within the bounds of drawn pixel positions...
                let copyX = this.xcounter;
                if (copyX < this.HA_STA) {
                    copyX = 0;
                }
                else {
                    copyX = this.xcounter - this.HA_STA;
                }

                let bitArray = this.leadingNullString(copyX.toString(2), this.Xposition.length).split("").map(bit => { return Boolean(parseInt(bit)); });
                bitArray.forEach((bit, ind) => { this.Xposition[ind].value = bit });
            }

            if (this.xcounter = 0) {
                this.ycounter = this.ycounter + 1;

                //keep y within bounds of drawn pixels:
                let copyY = this.ycounter;
                if (copyY > this.VA_END) {
                    copyY = this.VA_END - 1;
                }
                else {
                    copyY = copyY;
                }

                //set output pins to match internal state.
                let bitArray = this.leadingNullString(copyY.toString(2), this.YPosition.length).split("").map(bit => { return Boolean(parseInt(bit)); });
                bitArray.forEach((bit, ind) => { this.YPosition[ind].value = bit });
            }

            if (this.xcounter > 16 && this.xcounter < (16 + 96)) {
                //in verilog invert this
                this.h_sync.value = true;
            } else {
                this.h_sync.value = false;
            }

            if (this.ycounter > 60 && this.ycounter < 420) {
                this.v_sync.value = true;
            } else {
                this.v_sync.value = false;
            }

        }
        this.lastClockpinValue = this.clockPin.value;
        super.update();
    }
}
