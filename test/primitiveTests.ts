import { clock } from "../src/clock";
import * as assert from 'assert';
import { nRegister, nBuffer, bus, inverter } from "../src/primitives";
import { fail } from "assert";
import { outputPin, wire, inputPin } from "../src/pins_wires";

describe('clock component', function () {
    it('should pulse and call callback when incremented', function (done) {
        var clockComp = new clock(100);
        clockComp.increment(() => { done() });
    });

    it('value should be 0 after pulsing', function (done) {
        var clockComp = new clock(100);
        clockComp.increment(undefined, () => {
            assert.equal(clockComp.outputPin.value, 0);
            done()
        });
    });

    it('should have produced some values after pulsing for a while', function (done) {
        this.timeout(15000);
        var clockComp = new clock(100);
        var data = [];
        clockComp.registerHighCallback(() => { data.push(clockComp.outputPin.value) });
        clockComp.startClock();
        setTimeout(() => {
            assert(data.length > 0);
            console.log(data);
            clockComp.stopClock();
            done();
        }, 10000);

    });
});

describe('bus component', function () {
    it('should return the enabled signal', function () {

        let buscomp = new bus(8, 2);
        let buffer1enable = new outputPin();
        let buffer1 = new nBuffer(8);

        let buffer2enable = new outputPin();
        let buffer2 = new nBuffer(8);


        var wire1 = new wire(buffer1enable, buffer1.outputEnablePin);
        var wire2 = new wire(buffer2enable, buffer2.outputEnablePin);

        var b1pins = buffer1.dataPins.map(pin => { return new outputPin() });
        var b2pins = buffer2.dataPins.map(pin => { return new outputPin() });
        //TODO this should probably be a helper method...
        //connect all datapins to output pins created above
        b1pins.forEach((pin, index) => { new wire(pin, buffer1.dataPins[index]) });
        b2pins.forEach((pin, index) => { new wire(pin, buffer2.dataPins[index]) });

        var buswires1 = buffer1.outputPins.map((pin, index) => { return new wire(pin, buscomp.inputGroups[0][index]) });
        var buswires2 = buffer2.outputPins.map((pin, index) => { return new wire(pin, buscomp.inputGroups[1][index]) });

        buffer1enable.value = true;
        b1pins.forEach(pin => pin.value = true);
        b2pins[1].value = true;

        buffer1.update();
        buffer2.update();
        buscomp.update();
        assert.equal(buffer1.getDataAsInteger(), 255);
        assert.equal(buscomp.getDataAsInteger(), 255);

        //switch active
        buffer1enable.value = false;
        buffer2enable.value = true;


        buffer1.update();
        buffer2.update();
        buscomp.update();
        assert.equal(buffer2.getDataAsInteger(), 64);
        assert.equal(buscomp.getDataAsInteger(), 64);


    });

    it('should throw if owner not assigned', function () {

    });

    it('should throw if multiple inputs enabled', function () {

    });
});

describe('register component', function () {
    it('output shoud be 0 when inputs are 0', function () {
        var clockPin = new outputPin("clock");;
        var enablePin = new outputPin("enable");
        var reg = new nRegister(8);
        var data = new outputPin("data");

        let dataWire = new wire(data, reg.dataPins[0]);
        let clockwire = new wire(clockPin, reg.clockPin);
        let enableWire = new wire(enablePin, reg.enablePin);

        reg.update();
        clockPin.value = true;
        enablePin.value = true;
        reg.update();

        assert.equal(reg.outputPins[0].value, 0);
    });

    it('output shoud be 0 when inputs are 1 but not enabled', function () {
        var clockPin = new outputPin("clock");;
        var enablePin = new outputPin("enable");
        var reg = new nRegister(8);
        var data = new outputPin("data");

        let dataWire = new wire(data, reg.dataPins[0]);
        let clockwire = new wire(clockPin, reg.clockPin);
        let enableWire = new wire(enablePin, reg.enablePin);

        data.value = true;

        reg.update();
        clockPin.value = true;
        enablePin.value = false;
        reg.update();

        assert.equal(reg.outputPins[0].value, 0);
    });

    it('output shoud be 1 when inputs are 1 and clocked and enabled', function () {
        var clockPin = new outputPin("clock");;
        var enablePin = new outputPin("enable");
        var reg = new nRegister(8);
        var data = new outputPin("data");

        let dataWire = new wire(data, reg.dataPins[0]);
        let clockwire = new wire(clockPin, reg.clockPin);
        let enableWire = new wire(enablePin, reg.enablePin);

        data.value = true;

        reg.update();
        clockPin.value = true;
        enablePin.value = true;
        reg.update();
        assert.equal(reg.outputPins[0].value, 1);
    });


    it('it should have the correct value after input pin values are changed', function () {


        var clockPin = new outputPin("clock");;
        var enablePin = new outputPin("enable");
        var reg = new nRegister(8);
        var data = new outputPin("data");
        var data2 = new outputPin("data2");


        let dataWire = new wire(data, reg.dataPins[0]);
        let dataWire2 = new wire(data2, reg.dataPins[7]);

        let clockwire = new wire(clockPin, reg.clockPin);
        let enableWire = new wire(enablePin, reg.enablePin);

        data.value = true;
        data2.value = true;

        reg.update();
        clockPin.value = true;
        enablePin.value = true;
        reg.update();

        assert.equal(reg.getDataAsInteger(), 129);
        data2.value = false;

        //to load new data we need to reset the clock-
        //as we'll only load when the clock transitions.
        clockPin.value = false;

        reg.update();
        clockPin.value = true;
        //this update actually causes new data to be loaded.
        reg.update();
        assert.equal(reg.getDataAsInteger(), 128);
    });
});

describe('inverter component', function () {
    it('output shoud be 0 when inputs are 1', function () {
        var enablePin = new outputPin("enable");
        var inv = new inverter();
        var data = new outputPin("data");
        let dataWire = new wire(data, inv.dataPin);
        let enableWire = new wire(enablePin, inv.outputEnablePin);


        data.value = true;

        enablePin.value = true;
        inv.update();

        assert.equal(inv.outputPin.value, 0);
    });
});


describe('buffer component', function () {
    it('output shoud be 0 when inputs are 0', function () {
        var enablePin = new outputPin("enable");
        var buffer = new nBuffer(8);

        var data = new outputPin();

        let dataWire = new wire(data, buffer.dataPins[0]);
        let enableWire = new wire(enablePin, buffer.outputEnablePin);

        enablePin.value = true;
        buffer.update();

        assert.equal(buffer.outputPins[0].value, 0);
    });

    it('output shoud be 0 when inputs are 1 but not enabled', function () {
        var enablePin = new outputPin("enable");
        var buffer = new nBuffer(8);

        var data = new outputPin();
        let dataWire = new wire(data, buffer.dataPins[0]);
        let enableWire = new wire(enablePin, buffer.outputEnablePin);

        data.value = true;

        buffer.update();
        enablePin.value = false;
        buffer.update();

        assert.equal(buffer.outputPins[0].value, 0);
    });

    it('output shoud be 1 when inputs are 1 and outenabled', function () {
        var enablePin = new outputPin("enable");
        var buffer = new nBuffer(8);
        var data = new outputPin();
        let dataWire = new wire(data, buffer.dataPins[0]);
        let enableWire = new wire(enablePin, buffer.outputEnablePin);
        data.value = true;

        buffer.update();
        enablePin.value = true;
        buffer.update();
        assert.equal(buffer.outputPins[0].value, 1);
    });


    it('it should have the correct value after input pin values are changed', function () {
        var enablePin = new outputPin("enable");
        var buffer = new nBuffer(8);

        var data = new outputPin();
        var data2 = new outputPin();

        let dataWire = new wire(data, buffer.dataPins[0]);
        let dataWire2 = new wire(data2, buffer.dataPins[7]);

        let enableWire = new wire(enablePin, buffer.outputEnablePin);

        data.value = true;
        data2.value = true;

        buffer.update();
        enablePin.value = true;
        buffer.update();

        assert.equal(buffer.getDataAsInteger(), 129);
        data2.value = false;

        buffer.update();
        assert.equal(buffer.getDataAsInteger(), 128);
    });
});