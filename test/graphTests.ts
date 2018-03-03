import { Ipart, nRegister, nBuffer, VoltageRail } from "../src/primitives";
import { clock } from "../src/clock";
import { wire, outputPin } from "../src/pins_wires";
import * as assert from 'assert';
import { graph } from "../src/engine";
import { generateRegisterAndBuffer } from "./graphTestHelpers";

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
        console.log(currentGraph.topoSort().map(x => x.constructor));

    });
});
