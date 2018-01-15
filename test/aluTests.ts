import { clock } from "../src/clock";
import * as assert from 'assert';
import { nRegister, pin, nBuffer } from "../src/primitives";
import { fail } from "assert";
import { fullAdder, nbitAdder } from "../src/ALU";
import { outputPin, wire } from "../src/pins_wires";

describe('fullAdder', function () {
    it('should return correct truth table for all inputs', function () {
        let ci = new outputPin();
        let ad = new fullAdder();
        let a = new outputPin();
        let b = new outputPin();

        new wire(a, ad.datapins[0]);
        new wire(b, ad.datapins[1]);
        new wire(ci, ad.carryIn);

        ad.update();
        assert.equal(ad.sumPin.value, 0);
        assert.equal(ad.carryOut.value, 0);

        b.value = true;

        ad.update();
        assert.equal(ad.sumPin.value, 1);
        assert.equal(ad.carryOut.value, 0);

        a.value = true;
        b.value = true;

        ad.update();
        assert.equal(ad.sumPin.value, 0);
        assert.equal(ad.carryOut.value, 1);

        a.value = true;
        b.value = true;
        ci.value = true;

        ad.update();
        assert.equal(ad.sumPin.value, 1);
        assert.equal(ad.carryOut.value, 1);

        a.value = false;
        b.value = true;
        ci.value = true;

        ad.update();
        assert.equal(ad.sumPin.value, 0);
        assert.equal(ad.carryOut.value, 1);

        a.value = true;
        b.value = false;
        ci.value = true;

        ad.update();
        assert.equal(ad.sumPin.value, 0);
        assert.equal(ad.carryOut.value, 1);

        a.value = false;
        b.value = false;
        ci.value = true;

        ad.update();
        assert.equal(ad.sumPin.value, 1);
        assert.equal(ad.carryOut.value, 0);

    });
});

describe('8bitAdder', function () {
    it('should return correct value for simple cases', function () {
        let ci = new outputPin();
        let ad = new nbitAdder(8);
        let a = new outputPin();
        let b = new outputPin();
        let c = new outputPin();

        new wire(a, ad.dataPinsA[0]);
        new wire(b, ad.dataPinsB[0]);
        new wire(c, ad.dataPinsB[1]);
        new wire(ci, ad.carryIn);


        ad.update();
        assert.equal(ad.getDataAsInteger(), 0);
        assert.equal(ad.carryOut.value, 0);

        a.value = true;
        b.value = false;

        ad.update();
        assert.equal(ad.getDataAsInteger(), 128);
        assert.equal(ad.carryOut.value, 0);

        a.value = true;
        b.value = true;

        ad.update();
        //overflow...
        assert.equal(ad.getDataAsInteger(), 0);
        assert.equal(ad.carryOut.value, 1);

        a.value = true;
        b.value = false;
        c.value = true;

        ad.update();
        assert.equal(ad.getDataAsInteger(), 128 + 64);
        assert.equal(ad.carryOut.value, 0);
    });

    it('should return correct value for complex cases', function () {
        let ci = new outputPin();
        let ad = new nbitAdder(8);
        let a = new outputPin();
        let b = new outputPin();
        let c = new outputPin();

        new wire(a, ad.dataPinsA[0]);
        new wire(b, ad.dataPinsB[0]);
        new wire(c, ad.dataPinsB[1]);
        new wire(ci, ad.carryIn);



        ci.value = true;

        ad.update();
        assert.equal(ad.getDataAsInteger(), 1);
        assert.equal(ad.carryOut.value, 0);

        ci.value = true;
        a.value = true;
        b.value = true;
        c.value = false;

        ad.update();
        assert.equal(ad.getDataAsInteger(), 1);
        assert.equal(ad.carryOut.value, 1);


    });
});