
/**
 * clock is a time based oscillator which provides a binary output pin - 
 * it also has a view which draws a timeSeries chart of the clock signal over time.
 */
class clock {

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

/**
 * pin holds a value and enables connecting components together.
 */
class pin {

    value = false;
    constructor() {

    }

}

/**
 * a component represented by an HTML button which sets it's output pin value
 * to its state. The state is inverted when the button is clicked.
 */
class toggleSwitch {

    private state = false;
    private el: HTMLElement;
    private num
    public outputPin: pin = new pin();

    constructor(displayContainer: HTMLElement, uniqueID: string) {
        this.outputPin.value = this.state;

        $(displayContainer).append($('<p>' + uniqueID + '</p>'));

        let button = $('<input type="button" value="test">');
        button.click(() => {
            this.state = !this.state;
            this.outputPin.value = this.state;
        })
        $(displayContainer).append(button);
    }
}

/**
 * a flipFlop - this component has a single bit of memory, 3 inputs, and an output.
 * It loads the input bit to the output if enable is true and if the clock moves from low to high.
 */
class binaryCell {

    public clockPin: pin;
    public dataPin: pin;
    public outputPin: pin = new pin();
    public enablePin: pin;

    private state: boolean = false;
    private lastClockpinValue;
    private smoothieChart;
    private timeSeries;


    constructor(signalDrawing: HTMLCanvasElement) {
        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        this.smoothieChart.streamTo(signalDrawing);
        this.timeSeries = new TimeSeries();
        this.smoothieChart.addTimeSeries(this.timeSeries);
    }


    //this update method is called on all components - and their pins are evaluated to 
    // determine their state.
    public update() {

        let clockPinValue = this.clockPin.value;

        //when the clock pin goes from false to true, and the enable pin is true:
        //set the current input to the output and update the state to that value.

        if ((clockPinValue == true && this.lastClockpinValue == false) && this.enablePin.value == true) {
            this.state = this.dataPin.value;
        }
        //TODO is this correct?
        this.outputPin.value = this.state;
        this.timeSeries.append(new Date().getTime(), this.outputPin.value);
        console.log("register state is", this.state);
        this.lastClockpinValue = this.clockPin.value;

    }

}
class byteRegister {

    public clockPin: pin;
    public dataPins: pin[] = [];
    public outputPins: pin[] = _.range(0, 8).map(x => { return new pin() });
    public enablePin: pin;

    private state: boolean[] = _.range(0, 8).map(x => { return false });
    private lastClockpinValue;
    private smoothieChart;
    private timeSeries;


    constructor(signalDrawing: HTMLCanvasElement) {
        this.smoothieChart = new SmoothieChart({ maxValueScale: 1.5, interpolation: 'step' });
        this.smoothieChart.streamTo(signalDrawing);
        this.timeSeries = new TimeSeries();
        this.smoothieChart.addTimeSeries(this.timeSeries);
    }

    public update() {

        let clockPinValue = this.clockPin.value;

        //when the clock pin goes from false to true, and the enable pin is true:
        //set the current input to the output and update the state to that value.

        if ((clockPinValue == true && this.lastClockpinValue == false) && this.enablePin.value == true) {
            //set each state to the input pin value.
            this.dataPins.forEach((pin, index) => { this.state[index] = pin.value });
        }
        this.outputPins.forEach((pin, index) => { pin.value = this.state[index] });

        var outputAsInt = parseInt(this.outputPins.map(pin => { return Number(pin.value) }).join(""), 2);
        this.timeSeries.append(new Date().getTime(), outputAsInt);

        console.log("register state is", outputAsInt);
        this.lastClockpinValue = this.clockPin.value;

    }

}
