import { hex2BinArray } from "../src/utils";
import * as testUtils from "../test/8bitComputerTests";
import { staticRam } from "../src/sram";
import { graph } from "../src/engine";
import { clock } from "../src/clock";
import { verilogGenerator } from "../src/verilogGenerator";
import * as fs from 'fs';

export function generateVerilog() {
    let parts = testUtils.generate8bitComputerDesign();
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

};

generateVerilog();