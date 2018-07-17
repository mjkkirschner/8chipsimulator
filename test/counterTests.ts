import { clock } from "../src/clock";
import * as assert from 'assert';
import { nBuffer, bus } from "../src/primitives";
import { fail } from "assert";
import { staticRam } from "../src/sram";
import { binaryCounter } from "../src/counter";
import { outputPin, wire } from "../src/pins_wires";

describe('Binary counter component', function () {
    it('counter should count when clocked and enabled', function (done) {
        let enp = new outputPin();
        let ent = new outputPin();
        let clear = new outputPin();
        let load = new outputPin();
        let clockcomp = new clock(100);

        let counter = new binaryCounter(8);

        new wire(enp, counter.outputEnablePin1);
        new wire(ent, counter.outputEnablePin2);
        new wire(clear, counter.clearPin);
        new wire(load, counter.loadPin);
        new wire(clockcomp.outputPin, counter.clockPin);


        //active lows.
        enp.value = false;
        ent.value = false;
        clear.value = true;
        load.value = true;

        counter.update();
        clockcomp.incrementTimedFullCycle(() => {
            counter.update();
            assert.equal(counter.countAsInteger(), 1);
            assert.equal(counter.outputPins[0].value, 0);
            assert.equal(counter.outputPins[1].value, 0);
            assert.equal(counter.outputPins[2].value, 0);
            assert.equal(counter.outputPins[3].value, 0);
            assert.equal(counter.outputPins[4].value, 0);
            assert.equal(counter.outputPins[5].value, 0);
            assert.equal(counter.outputPins[6].value, 0);
            assert.equal(counter.outputPins[7].value, 1);

            done();
        });
    });

    it('counter should overflow to 0 when clocked too many times', function (done) {
        let enp = new outputPin();
        let ent = new outputPin();
        let clear = new outputPin();
        let load = new outputPin();
        let clockcomp = new clock(50);

        let counter = new binaryCounter(2);

        new wire(enp, counter.outputEnablePin1);
        new wire(ent, counter.outputEnablePin2);
        new wire(clear, counter.clearPin);
        new wire(load, counter.loadPin);
        new wire(clockcomp.outputPin, counter.clockPin);


        //active lows.
        enp.value = false;
        ent.value = false;
        clear.value = true;
        load.value = true;

        //TODO.... this test works but is awful
        //how can we better run the clock a certain number of times
        //and assert a value... actually executing a circuit will
        //need more design later.
        counter.update();
        clockcomp.registerHighCallback(() => {
            counter.update()
        });
        clockcomp.registerLowCallback(() => {
            counter.update()
        });

        clockcomp.pulseNumberOfTimes(2, () => {
            assert.equal(counter.countAsInteger(), 2);
            clockcomp.pulseNumberOfTimes(2, () => {
                assert.equal(counter.countAsInteger(), 0);
                assert.equal(counter.outputPins[0].value, 0);
                assert.equal(counter.outputPins[1].value, 0);

                done();
            });
        });
    });

    it('counter should clear when clear goes low', function (done) {
        let enp = new outputPin();
        let ent = new outputPin();
        let clear = new outputPin();
        let load = new outputPin();
        let clockcomp = new clock(50);

        let counter = new binaryCounter(2);

        new wire(enp, counter.outputEnablePin1);
        new wire(ent, counter.outputEnablePin2);
        new wire(clear, counter.clearPin);
        new wire(load, counter.loadPin);
        new wire(clockcomp.outputPin, counter.clockPin);


        //active lows.
        enp.value = false;
        ent.value = false;
        clear.value = true;
        load.value = true;

        //TODO.... this test works but is awful
        //how can we better run the clock a certain number of times
        //and assert a value... actually executing a circuit will
        //need more design later.
        counter.update();
        clockcomp.registerHighCallback(() => {
            counter.update()
        });
        clockcomp.registerLowCallback(() => {
            counter.update()
        });

        clockcomp.pulseNumberOfTimes(2, () => {
            assert.equal(counter.countAsInteger(), 2);
            clear.value = false;
            counter.update();
            assert.equal(counter.countAsInteger(), 0);
            assert.equal(counter.outputPins[0].value, 0);
            assert.equal(counter.outputPins[1].value, 0);

            done();
        });
    });

    it('counter should load when load goes low', function (done) {
        let enp = new outputPin();
        let ent = new outputPin();
        let clear = new outputPin();
        let load = new outputPin();
        let clockcomp = new clock(50);

        let counter = new binaryCounter(2);

        new wire(enp, counter.outputEnablePin1);
        new wire(ent, counter.outputEnablePin2);
        new wire(clear, counter.clearPin);
        new wire(load, counter.loadPin);
        new wire(clockcomp.outputPin, counter.clockPin);


        //active lows.
        enp.value = false;
        ent.value = false;
        clear.value = true;
        load.value = true;

        let data1 = new outputPin();
        let data2 = new outputPin();

        new wire(data1, counter.dataPins[0]);
        new wire(data2, counter.dataPins[1]);

        data1.value = true;
        data2.value = true;

        //TODO.... this test works but is awful
        //how can we better run the clock a certain number of times
        //and assert a value... actually executing a circuit will
        //need more design later.
        counter.update();
        clockcomp.registerHighCallback(() => {
            counter.update()
        });
        clockcomp.registerLowCallback(() => {
            counter.update()
        });

        clockcomp.pulseNumberOfTimes(2, () => {
            assert.equal(counter.countAsInteger(), 2);
            load.value = false;
            clockcomp.pulseNumberOfTimes(2, () => {
                assert.equal(counter.countAsInteger(), 3);
                assert.equal(counter.outputPins[0].value, 1);
                assert.equal(counter.outputPins[1].value, 1);

                done();
            });
        });
    });

});
