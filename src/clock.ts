import {  Ipart, basePart } from "./primitives";
import { SmoothieChart, TimeSeries } from 'smoothie';
import * as _ from "underscore";
import { clearInterval, clearImmediate } from "timers";
import { outputPin } from "./pins_wires";


/**
 * clock is a time based oscillator which provides a binary output pin - 
 * it also has a view which draws a timeSeries chart of the clock signal over time.
 */
export class clock extends  basePart implements Ipart {

    private smoothieChart: SmoothieChart;
    private timeSeries: TimeSeries;
    private cycle;
    private state = false;
    private intervalID: NodeJS.Timer

    private highCallbacks: Function[];
    private lowCallbacks: Function[];


    public outputPin: outputPin = new outputPin("clock", this);

    public get inputs() {
        return [];
    }

    public get outputs() {
        return [this.outputPin];
    }

    constructor(cycle: number, canvas?: HTMLCanvasElement) {
        super();
        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        if (canvas) {
            this.smoothieChart.streamTo(canvas);
        }
        this.timeSeries = new TimeSeries();
        this.cycle = cycle
        this.smoothieChart.addTimeSeries(this.timeSeries);
        this.highCallbacks = [];
        this.lowCallbacks = [];
    }

    public startClock() {
        this.intervalID = setInterval(() => {
            this.increment();

        }, this.cycle * 4)

    }

    public stopClock() {
        clearInterval(this.intervalID);
    }

    public update() {
        this.increment();
    }

    public assignInputPin() {
        throw new Error("Not Implemented and also would do nothing :)");
    }

    /**
     * pulses the clock for the cycle time and calls the 
     * provided callbacks if they exist.
     * @param callback 
     */
    public increment(callbackHigh?: Function, callbackLow?: Function) {

        //set clock to 0  
        this.tick();
        //still zero at cycle *2
        setTimeout(() => { this.tick(); }, this.cycle);
        setTimeout(() => {
            this.tock();
            if (callbackHigh) {
                callbackHigh();
            }
            this.highCallbacks.forEach(x => x());
        }, this.cycle + 1);

        setTimeout(() => { this.tock() }, (this.cycle * 2) + 1);
        setTimeout(() => {
            this.tick();
            this.lowCallbacks.forEach(x => x());
            if (callbackLow) {
                callbackLow();
            }
        }, this.cycle * 3);
    }

    public registerHighCallback(cb: Function) {
        this.highCallbacks.push(cb);
    }

    public registerLowCallback(cb: Function) {
        this.lowCallbacks.push(cb);
    }

    //not sure if this method is actually working correctly...
    public pulseNumberOfTimes(n: number, done?: Function) {
        let count = 0;
        let cycleComplete = true;

        this.intervalID = setInterval(() => {
            if (cycleComplete) {
                //it's time to get out of here...
                if (count > n - 1) {
                    clearInterval(this.intervalID);
                    done();
                }
                else {
                    this.increment(undefined, () => {
                        cycleComplete = true; count = count + 1
                    });
                    cycleComplete = false;
                }
            }

        }, this.cycle * 4);

    }

    private tick() {
        this.timeSeries.append(new Date().getTime(), 0);
        this.state = false;
        this.outputPin.value = this.state;
    }
    private tock() {
        this.timeSeries.append(new Date().getTime(), 1);
        this.state = true;
        this.outputPin.value = this.state;
    }
}


