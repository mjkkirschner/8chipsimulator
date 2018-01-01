import { pin } from "./primitives";
import { SmoothieChart, TimeSeries } from 'smoothie';


/**
 * clock is a time based oscillator which provides a binary output pin - 
 * it also has a view which draws a timeSeries chart of the clock signal over time.
 */
export class clock {

    private smoothieChart: SmoothieChart;
    private timeSeries: TimeSeries;
    private cycle;
    private state = false;
    private intervalID: NodeJS.Timer

    public outputPin: pin = new pin();

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

    /**
     * pulses the clock for the cycle time and calls the 
     * provided callback if it exists.
     * @param callback 
     */
    public increment(callback?: Function) {

        //set clock to 0  
        this.tick();
        //still zero at cycle *2
        setTimeout(() => { this.tick() }, this.cycle);
        setTimeout(() => { this.tock() }, this.cycle + 1);
        setTimeout(() => { this.tock() }, (this.cycle * 2) + 1);
        setTimeout(() => {
            this.tick();
            if (callback) {
                callback();
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


