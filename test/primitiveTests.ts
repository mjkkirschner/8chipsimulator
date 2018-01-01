import { clock } from "../clock";
import * as assert from 'assert';
import { nRegister, pin, nBuffer } from "../primitives";
import { fail } from "assert";

describe('clock component', function () {
    it('should pulse and call callback when incremented', function (done) {
        var clockComp = new clock(100);
        clockComp.increment(() => { done() });
    });

    it('value should be 0 after pulsing', function (done) {
        var clockComp = new clock(100);
        clockComp.increment(() => {
            assert.equal(clockComp.outputPin.value, 0);
            done()
        });
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
        var loadPin = new pin();
        var enablePin = new pin();
        var buffer = new nBuffer(loadPin, enablePin, 8);
        var input = new pin();
        buffer.assignInputPin(input, 0);

        loadPin.value = true;
        enablePin.value = true;
        buffer.update();

        assert.equal(buffer.outputPins[0].value, 0);
    });

    it('output shoud be 0 when inputs are 1 but not enabled', function () {
        var loadPin = new pin();
        var enablePin = new pin();
        var buffer = new nBuffer(loadPin, enablePin, 8);
        var input = new pin();
        buffer.assignInputPin(input, 0);
        input.value = true;

        buffer.update();
        loadPin.value = true;
        enablePin.value = false;
        buffer.update();

        assert.equal(buffer.outputPins[0].value, 0);
    });

    it('output shoud be 1 when inputs are 1 and load and outenabled', function () {
        var loadPin = new pin();
        var enablePin = new pin();
        var buffer = new nBuffer(loadPin, enablePin, 8);
        var input = new pin();
        buffer.assignInputPin(input, 0);
        input.value = true;

        buffer.update();
        loadPin.value = true;
        enablePin.value = true;
        buffer.update();
        assert.equal(buffer.outputPins[0].value, 1);
    });


    it('it should have the correct value after input pin values are changed', function () {
        var loadPin = new pin();
        var enablePin = new pin();
        var buffer = new nBuffer(loadPin, enablePin, 8);
        var input = new pin();
        var input2 = new pin();

        buffer.assignInputPin(input, 0);
        buffer.assignInputPin(input2, 7);
        input.value = true;
        input2.value = true;

        buffer.update();
        loadPin.value = true;
        enablePin.value = true;
        buffer.update();

        assert.equal(buffer.getDataAsInteger(), 129);
        input2.value = false;

        buffer.update();
        assert.equal(buffer.getDataAsInteger(), 128);
    });
});