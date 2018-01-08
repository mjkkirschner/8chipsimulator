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

});