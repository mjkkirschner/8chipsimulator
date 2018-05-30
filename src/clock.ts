import { Ipart, basePart } from "./primitives";
import * as _ from "underscore";
import { outputPin, inputPin } from "./pins_wires";
import { simulatorExecution, Task } from "./engine";



/**
 * clock is a time based oscillator which provides a binary output pin - 
 */
export class clock extends basePart implements Ipart {

    protected cycle;
    protected state = false;
    protected stateMode = 0;
    protected intervalID: number

    private highCallbacks: Function[];
    private lowCallbacks: Function[];

    public enablePin: inputPin = new inputPin("enable", this, true);
    public outputPin: outputPin = new outputPin("clock", this);

    public get inputs() {
        return [this.enablePin];
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

        if (this.enablePin.value == false) {
            //each run of the clock will increment the clock state 1/4 state of a full cycle
            //and then schedule the next task.
            this.incrementState();
        }

        //TODO this is wrong... duty cycle fix it.
        let clocktTask = simulater.generateTaskAndDownstreamTasks(simulater.rootOfAllTasks, this, simulater.time + this.cycle / 4);
        simulater.insertTask(clocktTask);
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

    public resetInternalState() {
        this.stateMode = 0;
        this.tick();
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

export class clockWithMode extends clock {

    //0 = auto, 1 = manual
    public modePin: inputPin = new inputPin("enable", this);
    //step pulse high to step clock
    public stepPin: inputPin = new inputPin("step", this);
    private lastStepSignal: boolean = true;
    private lastTimeIncrmented: number;

    constructor(cycle: number, name?: string) {
        super(cycle, name);

    }

    public get inputs() {
        return [this.enablePin, this.stepPin, this.modePin];
    }

    public update(simulater: simulatorExecution) {

        if (this.lastTimeIncrmented == simulater.time) {
            throw new Error("clock tried to run twice on same timestep...")
        }
        if (this.enablePin.value == false) {
            if (this.modePin.value == false) {
                //each run of the clock will increment the clock state 1/4 state of a full cycle
                //and then schedule the next task.
                this.incrementState();
                this.lastTimeIncrmented = simulater.time;
            }
            //mode is manual
            else {
                if (this.lastStepSignal == false && this.stepPin.value == true) {

                    //we're already high so we need to drop low.
                    if (this.stateMode == 3) {
                        this.incrementState();
                        this.lastTimeIncrmented = simulater.time;
                    }

                    //we're in some other low state, we should reset to 0 and increment all the way high.
                    else {

                        //we don't want to increment state, but instead restart our state.
                        this.resetInternalState();
                        this.incrementState();
                        this.incrementState();
                        this.incrementState();
                        this.lastTimeIncrmented = simulater.time;
                    }
                }
            }
            this.lastStepSignal = this.stepPin.value;

            //TODO this is wrong... duty cycle fix it.
            let clocktTask = simulater.generateTaskAndDownstreamTasks(simulater.rootOfAllTasks, this, simulater.time + Math.floor(this.cycle / 4));
            simulater.insertTask(clocktTask);
        }
    }
}