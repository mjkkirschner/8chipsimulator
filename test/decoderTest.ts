import { outputPin, wire } from "../src/pins_wires";
import { twoLineToFourLineDecoder } from "../src/Decoder";
import * as assert from 'assert';
import { fail } from "assert";


describe('decoder component', function () {
    it('decoder should output high when not enabled', function () {
        let outPin = new outputPin("outPutEnable");
        let decod = new twoLineToFourLineDecoder();
        new wire(outPin, decod.outputEnablePin);
        outPin.value = true;
        decod.update();
        decod.outputPins.forEach(x => { assert.equal(x.value, true) });

    });

    it('decoder should output 0 when enabled with no inputs', function () {
        let outPin = new outputPin("outPutEnable");
        let decod = new twoLineToFourLineDecoder();
        new wire(outPin, decod.outputEnablePin);
        outPin.value = false;
        decod.update();
        assert.deepEqual(decod.outputPins.map(x => { return x.value }), [false, true, true, true]);


    });

    it('decoder should output 2 when enabled with inputs in that state', function () {
        let outPin = new outputPin("outPutEnable");
        let decod = new twoLineToFourLineDecoder();

        let data1 = new outputPin();
        let data2 = new outputPin();

        new wire(outPin, decod.outputEnablePin);
        new wire(data1, decod.dataPins[0]);
        new wire(data2, decod.dataPins[1]);


        outPin.value = false;
        data1.value = true;
        data2.value = false;

        decod.update();
        assert.deepEqual(decod.outputPins.map(x => { return x.value }), [true, true, false, true]);

    });
});
