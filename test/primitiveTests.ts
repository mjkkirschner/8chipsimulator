import { clock } from "../clock";
import * as assert from 'assert';
import { nRegister, pin } from "../primitives";
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
});