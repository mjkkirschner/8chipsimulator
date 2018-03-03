import { clock } from "../src/clock";
import * as assert from 'assert';
import { nRegister, nBuffer, bus } from "../src/primitives";
import { fail } from "assert";
import { staticRam } from "../src/sram";
import { outputPin, wire, pinMode } from "../src/pins_wires";

describe('SRAM component', function () {
    it('ram should write when write and enable go low and out goes high', function () {
        let we = new outputPin("writeEnable");
        let ce = new outputPin();
        let oe = new outputPin();

        we.value = false;
        ce.value = false;
        oe.value = true;

        let a1 = new outputPin();
        let a2 = new outputPin();

        a1.value = false;
        a2.value = false;

        let data1 = new outputPin();
        let data2 = new outputPin();

        data1.value = true;
        data2.value = false;

        let ram = new staticRam(2, 4);

        new wire(we, ram.writeEnable);
        new wire(oe, ram.outputEnable)
        new wire(ce, ram.chipEnable)

        //TODO this is not exactly the behavior of our ram...
        //when we and ce go low, we latch address then, so we'd already have
        //latched 000000 as the adress I think.... I think we need to cycle we again...
        //need to store the state of we internally...like a clock pin.
        ram.wireUpAddressPins([a1, a2]);

        new wire(data1, ram.InputOutputPins[0].internalInput);
        new wire(data2, ram.InputOutputPins[1].internalInput)

        ram.update();
        assert.deepEqual(ram.readData(0), [true, false]);

        //assert that output pins are in input mode...
        ram.InputOutputPins.forEach(x => {
            assert.equal(x.mode == pinMode.input, true);
        })
    });

    it('ram should read when write goes high - enable and out go low', function () {
        let we = new outputPin("writeEnable");
        let ce = new outputPin();
        let oe = new outputPin();

        we.value = false;
        ce.value = false;
        oe.value = true;

        let a1 = new outputPin();
        let a2 = new outputPin();

        a1.value = false;
        a2.value = false;

        let data1 = new outputPin();
        let data2 = new outputPin();

        data1.value = true;
        data2.value = false;

        let ram = new staticRam(2, 4);

        new wire(we, ram.writeEnable);
        new wire(oe, ram.outputEnable)
        new wire(ce, ram.chipEnable)

        //TODO this is not exactly the behavior of our ram...
        //when we and ce go low, we latch address then, so we'd already have
        //latched 000000 as the adress I think.... I think we need to cycle we again...
        //need to store the state of we internally...like a clock pin.
        ram.wireUpAddressPins([a1, a2]);

        new wire(data1, ram.InputOutputPins[0].internalInput);
        new wire(data2, ram.InputOutputPins[1].internalInput)


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