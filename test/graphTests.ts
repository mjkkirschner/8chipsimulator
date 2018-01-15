import { Ipart, nRegister, nBuffer, VoltageRail } from "../src/primitives";
import { clock } from "../src/clock";
import { wire, outputPin } from "../src/pins_wires";
import * as assert from 'assert';
import { graph } from "../src/engine";

describe('graph functions', function () {
    it('graph should be created', function (done) {
        assert.doesNotThrow(() => {
            let parts = generateRegisterAndBuffer();
            let currentGraph = new graph(parts);

            assert.equal(parts.length, currentGraph.nodes.length);
            currentGraph.printNodes();
        });
        //TODO check some connections are correct... or number of edegs or something...
        done();
    });

    it('graph should be created', function () {

        let parts = generateRegisterAndBuffer();
        let currentGraph = new graph(parts);
        console.log(currentGraph.topoSort().map(x=>x.constructor));

    });


    function generateRegisterAndBuffer(): Ipart[] {

        let clockcomp = new clock(20);
        let reg = new nRegister(8);

        let data1 = new VoltageRail("data");
        let enable = new VoltageRail("enablereg");
        let bufEnable = new VoltageRail("enablebuffer");


        new wire(clockcomp.outputPin, reg.clockPin);
        new wire(data1.outputPin, reg.dataPins[0]);
        new wire(enable.outputPin, reg.enablePin);

        let buffer = new nBuffer(8);

        new wire(reg.outputPins[0], buffer.dataPins[0]);
        new wire(bufEnable.outputPin, buffer.outputEnablePin);

        return [clockcomp, reg, data1, enable, bufEnable, buffer];
    }