import { Ipart, basePart } from "./primitives";
import { SmoothieChart, TimeSeries } from 'smoothie';
import * as _ from "underscore";
import { clearInterval, clearImmediate } from "timers";
import { outputPin } from "./pins_wires";
import { simulatorExecution } from "./engine";


/**
 * clock is a time based oscillator which provides a binary output pin - 
 */
export class clock extends basePart implements Ipart {

    private cycle;
    private state = false;
    private stateMode = 0;
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

    constructor(cycle: number, name?: string) {
        super(name);
        this.cycle = cycle
        this.highCallbacks = [];
        this.lowCallbacks = [];
    }

    public startClock() {
        this.intervalID = setInterval(() => {
            this.incrementTimedFullCycle();

        }, this.cycle * 4)

    }

    public stopClock() {
        clearInterval(this.intervalID);
    }

    public update(simulater: simulatorExecution) {
        //TODO - modify this function so that increment is only called
        //when the cycle time has been surpassed... 
        //ie clock may lag behind cycle time if update is called too slowly, but we'll never increment the clock
        //too quickly or before other tasks stabilize...?
        //another approach is that clock should schedule itself based on cycle time and scheduler time step...
        //we could pass the evaluator to each update call and let parts schedule themselves or return some schedule request to us.

        this.incrementState();
    }

    public assignInputPin() {
        throw new Error("Not Implemented and also would do nothing :)");
    }

    public incrementState(callbackHigh?: Function, callbackLow?: Function) {

        switch (this.stateMode) {
            case 0:
                this.tick();
                this.stateMode = 1;
                break;
            case 1:
                this.tick();
                this.stateMode = 2;
                break;
            case 2:
                this.tock();
                this.stateMode = 3;
                if (callbackHigh) {
                    callbackHigh();
                }
                this.highCallbacks.forEach(x => x());
                break;
            case 3:
                this.tick();
                this.stateMode = 0;
                this.lowCallbacks.forEach(x => x());
                if (callbackLow) {
                    callbackLow();
                }
                break;
        }
    }

    /**
     * pulses the clock for the cycle time and calls the 
     * provided callbacks if they exist.
     * @param callback 
     */
    public incrementTimedFullCycle(callbackHigh?: Function, callbackLow?: Function) {

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
                    this.incrementTimedFullCycle(undefined, () => {
                        cycleComplete = true; count = count + 1
                    });
                    cycleComplete = false;
                }
            }

        }, this.cycle * 4);

    }

    private tick() {
        this.state = false;
        this.outputPin.value = this.state;
    }
    private tock() {
        this.state = true;
        this.outputPin.value = this.state;
    }
}


