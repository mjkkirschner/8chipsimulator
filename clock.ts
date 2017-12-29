import { pin } from "./primitives";
import {SmoothieChart,TimeSeries} from 'smoothie';


/**
 * clock is a time based oscillator which provides a binary output pin - 
 * it also has a view which draws a timeSeries chart of the clock signal over time.
 */
export class clock {

    private smoothieChart;
    private timeSeries;
    private cycle;
    private state = false;

    public outputPin: pin = new pin();

    constructor(canvas: HTMLCanvasElement, cycle: number) {
        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        this.smoothieChart.streamTo(canvas);
        this.timeSeries = new TimeSeries();
        this.cycle = cycle
        this.smoothieChart.addTimeSeries(this.timeSeries);
    }

    public startClock() {
        setInterval(() => {
            //set 0  
            this.tick()
            //still zero at cycle *2
            setTimeout(() => { this.tick() }, this.cycle);
            setTimeout(() => { this.tock() }, this.cycle + 1);
            setTimeout(() => { this.tock() }, (this.cycle * 2) + 1);
            setTimeout(() => { this.tick() }, this.cycle * 3);

        }, this.cycle * 4)

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


