import { clock } from "../src/clock";
import * as assert from 'assert';
import { nRegister, pin, nBuffer, bus } from "../src/primitives";
import { fail } from "assert";
import { staticRam, inputOutputPin, pinMode } from "../src/sram";
import { binaryCounter } from "../src/counter";

describe('Binary counter component', function () {
    it('counter should count when clocked and enabled', function (done) {
        let enp = new pin();
        let ent = new pin();
        let clear = new pin();
        let load = new pin();
        let clockcomp = new clock(100);

        let counter = new binaryCounter(enp, ent, clear, clockcomp.outputPin, load, 8, );
        enp.value = true;
        ent.value = true;
        //active lows.
        clear.value = true;
        load.value = true;

        counter.update();
        clockcomp.increment(() => {
            counter.update();
            assert.equal(counter.countAsInteger(), 1);
            done();
        });
    });

    it('counter should overflow to 0 when clocked too many times', function (done) {
        let enp = new pin();
        let ent = new pin();
        let clear = new pin();
        let load = new pin();
        let clockcomp = new clock(50);

        let counter = new binaryCounter(enp, ent, clear, clockcomp.outputPin, load, 2, );
        enp.value = true;
        ent.value = true;
        //active lows.
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
                done();
            });
        });
    });

    it('counter should clear when clear goes low', function (done) {
        let enp = new pin();
        let ent = new pin();
        let clear = new pin();
        let load = new pin();
        let clockcomp = new clock(50);

        let counter = new binaryCounter(enp, ent, clear, clockcomp.outputPin, load, 2, );
        enp.value = true;
        ent.value = true;
        //active lows.
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
            done();
        });
    });

    it('counter should load when load goes low', function (done) {
        let enp = new pin();
        let ent = new pin();
        let clear = new pin();
        let load = new pin();
        let clockcomp = new clock(50);

        let counter = new binaryCounter(enp, ent, clear, clockcomp.outputPin, load, 2, );
        enp.value = true;
        ent.value = true;
        //active lows.
        clear.value = true;
        load.value = true;

        let data1 = new pin();
        let data2 = new pin();

        counter.assignInputPin([data1,data2]);
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
                done();
            });
        });
    });

});
