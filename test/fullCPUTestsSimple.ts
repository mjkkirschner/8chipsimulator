

import * as utils from "../test/8bitComputerTests";
import { staticRam } from "../src/sram";
import { clock } from "../src/clock";
import { graph, simulatorExecution } from "../src/engine";
import * as assert from "assert";





describe("testing a full cpu/computer integreation", () => {

    it("can add A and B - and send result to Out Reg, then halt ", (done) => {
        let parts = utils.generate8bitComputerDesign();
        let ram = parts.filter(x => x.displayName == "main ram")[0] as staticRam;
        ram.writeData(0, [0, 0, 0, 0, 0, 1, 1, 0].map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
        ram.writeData(1, [0, 0, 0, 1, 0, 1, 0, 0].map(x => Boolean(x))); //20 - after this A should contain 20.
        ram.writeData(2, [0, 0, 0, 0, 0, 0, 1, 1].map(x => Boolean(x))); // Put whatever follows at memory address 100 into B // then add to A.
        ram.writeData(3, [0, 1, 1, 0, 0, 1, 0, 0].map(x => Boolean(x))); // 100
        ram.writeData(4, [0, 0, 0, 0, 0, 0, 1, 0].map(x => Boolean(x))); // A transfer to Out reg.
        ram.writeData(5, [0, 0, 0, 0, 1, 1, 1, 1].map(x => Boolean(x)));

        ram.writeData(100, [0, 0, 0, 0, 0, 1, 0, 1].map(x => Boolean(x))); //5 at memory location 100


        let gra = new graph(parts);
        const orderedParts = gra.topoSort();

        //get all parts into correct initial state.
        orderedParts.forEach((x) => {
            if (!(x.pointer instanceof clock)) {
                x.pointer.update();
            }
        });

        let evaluator = new simulatorExecution(parts);
        
        evaluator.Evaluate();

        //let the simulation run for a bit.
        setTimeout(() => {
            const outReg = orderedParts.filter((x) => { return x.pointer.displayName == "OUT register" })[0].pointer;
            assert.equal(outReg.toOutputString(), "25");
            done();
        }, 30000);

    }).timeout(60000);

});

