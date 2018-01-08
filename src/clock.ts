import { pin, Ipart } from "./primitives";
import { SmoothieChart, TimeSeries } from 'smoothie';


/**
 * clock is a time based oscillator which provides a binary output pin - 
 * it also has a view which draws a timeSeries chart of the clock signal over time.
 */
export class clock implements Ipart {

    private smoothieChart: SmoothieChart;
    private timeSeries: TimeSeries;
    private cycle;
    private state = false;
    private intervalID: NodeJS.Timer

    public outputPin: pin = new pin("clock", this);

    constructor(cycle: number, canvas?: HTMLCanvasElement) {
        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        if (canvas) {
            this.smoothieChart.streamTo(canvas);
        }
        this.timeSeries = new TimeSeries();
        this.cycle = cycle
        this.smoothieChart.addTimeSeries(this.timeSeries);
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
        }, this.cycle + 1);

        setTimeout(() => { this.tock() }, (this.cycle * 2) + 1);
        setTimeout(() => {
            this.tick();
            if (callbackLow) {
                callbackLow();
            }
        }, this.cycle * 3);
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

