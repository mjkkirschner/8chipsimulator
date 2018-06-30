import { outputPin, wire } from "../src/pins_wires";
import { nbitComparator } from "../src/comparator";
import * as assert from 'assert';

describe('comparator component', function () {
    it('comparator should return correct signal when A = B', function () {
        let A0 = new outputPin("A0");
        let A1 = new outputPin("A1");

        let B0 = new outputPin("B0");
        let B1 = new outputPin("B1");

        let comp = new nbitComparator(2, "testComp");
        new wire(A0, comp.dataPinsA[0]);
        new wire(A1, comp.dataPinsA[1]);

        new wire(B0, comp.dataPinsB[0]);
        new wire(B1, comp.dataPinsB[1]);

        comp.update();
        assert.equal(comp.AEBOUT.value, true);
        assert.equal(comp.ALBOUT.value, false);

        A1.value = true;
        B1.value = true;

        comp.update();
        assert.equal(comp.AEBOUT.value, true);
        assert.equal(comp.ALBOUT.value, false);

    });

    it('comparator should return correct signal when A < B', function () {
        let A0 = new outputPin("A0");
        let A1 = new outputPin("A1");

        let B0 = new outputPin("B0");
        let B1 = new outputPin("B1");

        B0.value = true;
        B1.value = true;

        let comp = new nbitComparator(2, "testComp");
        new wire(A0, comp.dataPinsA[0]);
        new wire(A1, comp.dataPinsA[1]);

        new wire(B0, comp.dataPinsB[0]);
        new wire(B1, comp.dataPinsB[1]);

        comp.update();
        assert.equal(comp.AEBOUT.value, false);
        assert.equal(comp.ALBOUT.value, true);

    });

    it('comparator should return correct signal when A > B', function () {
        let A0 = new outputPin("A0");
        let A1 = new outputPin("A1");

        let B0 = new outputPin("B0");
        let B1 = new outputPin("B1");

        A0.value = true;
        A1.value = true;

        let comp = new nbitComparator(2, "testComp");
        new wire(A0, comp.dataPinsA[0]);
        new wire(A1, comp.dataPinsA[1]);

        new wire(B0, comp.dataPinsB[0]);
        new wire(B1, comp.dataPinsB[1]);

        comp.update();
        assert.equal(comp.AEBOUT.value, false);
        assert.equal(comp.ALBOUT.value, false);

    });
});
