import { clock } from "../src/clock";
import * as assert from 'assert';
import { nRegister, pin, nBuffer, bus } from "../src/primitives";
import { fail } from "assert";
import { staticRam, inputOutputPin, pinMode } from "../src/sram";

describe('SRAM component', function () {
    it('ram should write when write and enable go low and out goes high', function () {
        let we = new pin();
        let ce = new pin();
        let oe = new pin();

        we.value = false;
        ce.value = false;
        oe.value = true;

        let a1 = new pin();
        let a2 = new pin();

        a1.value = false;
        a2.value = false;

        let data1 = new pin();
        let data2 = new pin();

        data1.value = true;
        data2.value = false;

        let ram = new staticRam(2, 4, we, ce, oe);

        ram.assignAddressPins([a1, a2]);
        ram.assignInputPin([data1, data2]);
        ram.update();
        assert.deepEqual(ram.readData(0), [true, false]);

        //assert that output pins are in input mode - and value returns undefined...
        ram.InputOutputPins.forEach(x => {
            assert.equal(x.value == undefined, true);
            assert.equal(x.mode == pinMode.input, true);
        })
    });

    it('ram should read when write goes high - enable and out go low', function () {
        let we = new pin();
        let ce = new pin();
        let oe = new pin();

        we.value = false;
        ce.value = false;
        oe.value = true;

        let a1 = new pin();
        let a2 = new pin();

        a1.value = false;
        a2.value = false;

        let data1 = new pin();
        let data2 = new pin();

        data1.value = true;
        data2.value = false;

        let ram = new staticRam(2, 4, we, ce, oe);

        ram.assignAddressPins([a1, a2]);
        ram.assignInputPin([data1, data2]);
        ram.update();

        //now we have written some data, lets read it back and check output pins.

        we.value = true;
        ce.value = false;
        oe.value = false;
        ram.update();

        ram.InputOutputPins.forEach(x => {
            assert.equal(x.mode == pinMode.output, true);
        });

        assert.deepEqual(ram.InputOutputPins.map(pin => { return pin.value }), [true, false]);

    });



});