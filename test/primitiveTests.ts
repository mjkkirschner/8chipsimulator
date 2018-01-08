import { clock } from "../src/clock";
import * as assert from 'assert';
import { nRegister, pin, nBuffer, bus } from "../src/primitives";
import { fail } from "assert";

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
});

describe('bus component', function () {
    it('should return the enabled signal', function () {

        let buscomp = new bus(8);
        let buffer1enable = new pin();
        let buffer1 = new nBuffer(buffer1enable, 8);

        let buffer2enable = new pin();
        let buffer2 = new nBuffer(buffer2enable, 8);

        let b1pins = [new pin(), new pin()];
        let b2pins = [new pin(), new pin()];

        buffer1.assignInputPin(b1pins, null);
        buffer2.assignInputPin(b2pins, null);

        buscomp.assignInputPin(buffer1.outputPins, 0);
        buscomp.assignInputPin(buffer2.outputPins, 1);

        buffer1enable.value = true;
        b1pins.forEach(pin => pin.value = true);
        b2pins[1].value = true;

        buffer1.update();
        buffer2.update();
        buscomp.update();
        assert.equal(buffer1.getDataAsInteger(), 192);
        assert.equal(buscomp.getDataAsInteger(), 192);

        //switch active
        buffer1enable.value = false;
        buffer2enable.value = true;


        buffer1.update();
        buffer2.update();
        buscomp.update();
        assert.equal(buscomp.getDataAsInteger(), 64);


    });

    it('should throw if owner not assigned', function () {

    });

    it('should throw if multiple inputs enabled', function () {

    });
});

describe('register component', function () {
    it('output shoud be 0 when inputs are 0', function () {
        var clockPin = new pin();
        var enablePin = new pin();
        var reg = new nRegister(clockPin, enablePin, 8);
        var input = new pin();
        reg.assignInputPin(input, 0);

        reg.update();
        clockPin.value = true;
        enablePin.value = true;
        reg.update();

        assert.equal(reg.outputPins[0].value, 0);
    });

    it('output shoud be 0 when inputs are 1 but not enabled', function () {
        var clockPin = new pin();
        var enablePin = new pin();
        var reg = new nRegister(clockPin, enablePin, 8);
        var input = new pin();
        reg.assignInputPin(input, 0);
        input.value = true;

        reg.update();
        clockPin.value = true;
        enablePin.value = false;
        reg.update();

        assert.equal(reg.outputPins[0].value, 0);
    });

    it('output shoud be 1 when inputs are 1 and clocked and enabled', function () {
        var clockPin = new pin();
        var enablePin = new pin();
        var reg = new nRegister(clockPin, enablePin, 8);
        var input = new pin();
        reg.assignInputPin(input, 0);
        input.value = true;

        reg.update();
        clockPin.value = true;
        enablePin.value = true;
        reg.update();
        assert.equal(reg.outputPins[0].value, 1);
    });


    it('it should have the correct value after input pin values are changed', function () {
        var clockPin = new pin();
        var enablePin = new pin();
        var reg = new nRegister(clockPin, enablePin, 8);
        var input = new pin();
        var input2 = new pin();

        reg.assignInputPin(input, 0);
        reg.assignInputPin(input2, 7);
        input.value = true;
        input2.value = true;


        reg.update();
        clockPin.value = true;
        enablePin.value = true;
        reg.update();

        assert.equal(reg.getDataAsInteger(), 129);
        input2.value = false;

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

describe('buffer component', function () {
    it('output shoud be 0 when inputs are 0', function () {
        var enablePin = new pin();
        var buffer = new nBuffer(enablePin, 8);
        var input = new pin();
        buffer.assignInputPin(input, 0);

        enablePin.value = true;
        buffer.update();

        assert.equal(buffer.outputPins[0].value, 0);
    });

    it('output shoud be 0 when inputs are 1 but not enabled', function () {
        var enablePin = new pin();
        var buffer = new nBuffer(enablePin, 8);
        var input = new pin();
        buffer.assignInputPin(input, 0);
        input.value = true;

        buffer.update();
        enablePin.value = false;
        buffer.update();

        assert.equal(buffer.outputPins[0].value, 0);
    });

    it('output shoud be 1 when inputs are 1 and outenabled', function () {
        var enablePin = new pin();
        var buffer = new nBuffer(enablePin, 8);
        var input = new pin();
        buffer.assignInputPin(input, 0);
        input.value = true;

        buffer.update();
        enablePin.value = true;
        buffer.update();
        assert.equal(buffer.outputPins[0].value, 1);
    });


    it('it should have the correct value after input pin values are changed', function () {
        var enablePin = new pin();
        var buffer = new nBuffer(enablePin, 8);
        var input = new pin();
        var input2 = new pin();

        buffer.assignInputPin(input, 0);
        buffer.assignInputPin(input2, 7);
        input.value = true;
        input2.value = true;

        buffer.update();
        enablePin.value = true;
        buffer.update();

        assert.equal(buffer.getDataAsInteger(), 129);
        input2.value = false;

        buffer.update();
        assert.equal(buffer.getDataAsInteger(), 128);
    });
});