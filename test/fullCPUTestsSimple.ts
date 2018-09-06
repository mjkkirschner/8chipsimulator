
import * as utils from "./8bitComputerTests";
import { staticRam } from "../src/sram";
import { clock } from "../src/clock";
import { graph, simulatorExecution } from "../src/engine";
import * as assert from "assert";
import { verilogGenerator } from "../src/verilogGenerator";
import *  as fs from 'fs';

//TODO MOVE THESE TO UTILS
function hex2BinArray(hexString: string) {
    let binString = convertNumber(hexString, 16, 2);
    return binString.padStart(16, "0").split('').map(x => { return parseInt(x) });
  }

  function convertNumber(n: string, fromBase: number, toBase: number): string {
    if (fromBase === void 0) {
      fromBase = 10;
    }
    if (toBase === void 0) {
      toBase = 10;
    }
    return (parseInt(n, fromBase)).toString(toBase);
  }


xdescribe("testing a full cpu/computer integreation", () => {

    it("can halt ", (done) => {
        let parts = utils.generate8bitComputerDesign();
        let ram = parts.filter(x => x.displayName == "main_ram")[0] as staticRam;

        ram.writeData(0, [0, 0, 0, 0, 1, 1, 1, 1].map(x => Boolean(x)));

        //these should not be run.
        ram.writeData(1, [0, 0, 0, 0, 0, 1, 1, 0].map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
        ram.writeData(2, [0, 0, 0, 1, 0, 1, 0, 0].map(x => Boolean(x))); //20 - after this A should contain 20.


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
            const aReg = orderedParts.filter((x) => { return x.pointer.displayName == "OUT_register" })[0].pointer;
            assert.equal(aReg.toOutputString(), "0");
            done();
        }, 10000);

    }).timeout(60000);

    it("can add A and B - and send result to Out Reg, then halt ", (done) => {
        let parts = utils.generate8bitComputerDesign();
        let ram = parts.filter(x => x.displayName == "main_ram")[0] as staticRam;
        ram.writeData(0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0].map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
        ram.writeData(1, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0].map(x => Boolean(x))); //20 - after this A should contain 20.
        ram.writeData(2, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1].map(x => Boolean(x))); // Put whatever follows at memory address 100 into B // then add to A.
        ram.writeData(3, [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0].map(x => Boolean(x))); // 100
        ram.writeData(4, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0].map(x => Boolean(x))); // A transfer to Out reg.
        ram.writeData(5, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1].map(x => Boolean(x)));

        //these should not be run.
        ram.writeData(6, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0].map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
        ram.writeData(7, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0].map(x => Boolean(x))); //20 - after this A should contain 20.

        ram.writeData(100, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1].map(x => Boolean(x))); //5 at memory location 100


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
            const aReg = orderedParts.filter((x) => { return x.pointer.displayName == "OUT_register" })[0].pointer;
            assert.equal(aReg.toOutputString(), "25");
            const outReg = orderedParts.filter((x) => { return x.pointer.displayName == "A_register" })[0].pointer;
            assert.equal(outReg.toOutputString(), "25");
            done();
        }, 10000);

    }).timeout(60000);

    it("can jump unconditionally ", (done) => {
        let parts = utils.generate8bitComputerDesign();
        let ram = parts.filter(x => x.displayName == "main_ram")[0] as staticRam;
        ram.writeData(0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0].map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
        ram.writeData(1, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0].map(x => Boolean(x))); //20 - after this A should contain 20.
        ram.writeData(2, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0].map(x => Boolean(x))); //update flagsreg for jump
        ram.writeData(3, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1].map(x => Boolean(x))); //jump to line:
        ram.writeData(4, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0].map(x => Boolean(x))); //address 0
        //we should never execute this line
        ram.writeData(5, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0].map(x => Boolean(x))); // A transfer to Out reg.
        ram.writeData(6, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1].map(x => Boolean(x)));


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
            const outReg = orderedParts.filter((x) => { return x.pointer.displayName == "OUT_register" })[0].pointer;
            assert.equal(outReg.toOutputString(), "0");
            const aReg = orderedParts.filter((x) => { return x.pointer.displayName == "A_register" })[0].pointer;
            assert.equal(aReg.toOutputString(), "20");
            done();
        }, 10000);

    }).timeout(60000);

    it("can jump conditionally ", (done) => {
        let parts = utils.generate8bitComputerDesign();
        let ram = parts.filter(x => x.displayName == "main_ram")[0] as staticRam;
        ram.writeData(0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0].map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
        ram.writeData(1, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0].map(x => Boolean(x))); //20 - after this A should contain 20.
        ram.writeData(2, [0, 0, 0, 0, 0, 0, 1, 1].map(x => Boolean(x))); // Put whatever follows at memory address 100 into B // then add to A.
        ram.writeData(3, [0, 1, 1, 0, 0, 1, 0, 0].map(x => Boolean(x))); // 100

        ram.writeData(4, [0, 0, 0, 0, 1, 1, 0, 0].map(x => Boolean(x))); //loadBimmediate. - load what follows into B.
        ram.writeData(5, [0, 0, 0, 1, 1, 0, 0, 1].map(x => Boolean(x))); //25 - after this B should contain 25.

        ram.writeData(6, [0, 0, 0, 0, 1, 1, 1, 0].map(x => Boolean(x))); //update flag reg for jump

        //conditionally jump to 2 if A < B... if A < 25 keep looping 
        ram.writeData(7, [0, 0, 0, 0, 1, 0, 0, 1].map(x => Boolean(x))); //jump to line:
        ram.writeData(8, [0, 0, 0, 0, 0, 0, 1, 0].map(x => Boolean(x))); //address 2
        //25 to out
        ram.writeData(9, [0, 0, 0, 0, 0, 0, 1, 0].map(x => Boolean(x))); // A transfer to Out reg.
        //halt
        ram.writeData(10, [0, 0, 0, 0, 1, 1, 1, 1].map(x => Boolean(x)));

        ram.writeData(100, [0, 0, 0, 0, 0, 0, 0, 1].map(x => Boolean(x))); //1 at memory location 100



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
            const aReg = orderedParts.filter((x) => { return x.pointer.displayName == "A_register" })[0].pointer;
            assert.equal(aReg.toOutputString(), "25");
            const bReg = orderedParts.filter((x) => { return x.pointer.displayName == "B_register" })[0].pointer;
            assert.equal(bReg.toOutputString(), "25");
            const outReg = orderedParts.filter((x) => { return x.pointer.displayName == "OUT_register" })[0].pointer;
            assert.equal(outReg.toOutputString(), "25");

            done();
        }, 10000);

    }).timeout(60000);

});


describe("testing a full cpu/computer verilog generation", () => {

    it("can generate something ", (done) => {
        let parts = utils.generate8bitComputerDesign();
        let ram = parts.filter(x => x.displayName == "main_ram")[0] as staticRam;

        ram.writeData(0, hex2BinArray("0x0006").map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
        ram.writeData(1, hex2BinArray("0x0000").map(x => Boolean(x))); //0 - after this A should contain 0.
        
        ram.writeData(2, hex2BinArray("0x0003").map(x => Boolean(x))); // Put whatever follows at memory address 100 into B // then add to A.
        ram.writeData(3, hex2BinArray("0x0064").map(x => Boolean(x))); // 100
        ram.writeData(4, hex2BinArray("0x0002").map(x => Boolean(x))); // A transfer to Out reg.
    
    
        ram.writeData(5, hex2BinArray("0x000C").map(x => Boolean(x))); //loadBimmediate. - load what follows into B.
        ram.writeData(6, hex2BinArray("0x0010").map(x => Boolean(x))); //16 - after this B should contain 16.
    
        ram.writeData(7, hex2BinArray("0x000E").map(x => Boolean(x))); //update flag reg for jump
    
        //conditionally jump to 2 if A < B... if A < 16 keep looping 
        ram.writeData(8, hex2BinArray("0x0009").map(x => Boolean(x))); //jump to line:
        ram.writeData(9, hex2BinArray("0x0002").map(x => Boolean(x))); //address 2
        
        ram.writeData(10, hex2BinArray("0x0008").map(x => Boolean(x))); //jump to line:
        ram.writeData(11, hex2BinArray("0x0000").map(x => Boolean(x))); //address 2
    
        ram.writeData(100, hex2BinArray("0x0001").map(x => Boolean(x))); //1 at memory location 100



        let gra = new graph(parts);
        const orderedParts = gra.topoSort();

        //get all parts into correct initial state.
        orderedParts.forEach((x) => {
            if (!(x.pointer instanceof clock)) {
                x.pointer.update();
            }
        });

        let generator = new verilogGenerator(gra);
        let generatedVerilog = generator.generateVerilog();
        generatedVerilog = generator.generateVerilog();

        console.log(generatedVerilog);
        fs.writeFileSync("./generatedVerilog", generatedVerilog);

        let memoryFiles = generator.generateBinaryMemoryFiles();
        console.log(memoryFiles);
        memoryFiles.forEach((x, i) => fs.writeFileSync("./memoryFile" + i, x));

    });
});

