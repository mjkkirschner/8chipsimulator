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

    //a bootloader!

    ram.writeData(0, hex2BinArray("0x0010").map(x => Boolean(x))); //Load SPI control reg.
    ram.writeData(1, hex2BinArray("0x0001").map(x => Boolean(x))); //put a 1 in LSB... this is start coms.

    ram.writeData(2, hex2BinArray("0x0010").map(x => Boolean(x))); //Load SPI control reg.
    ram.writeData(3, hex2BinArray("0x0000").map(x => Boolean(x))); //reset coms control.

    ram.writeData(4, hex2BinArray("0x0011").map(x => Boolean(x))); //check the status reg to see if we're done getting data.
    ram.writeData(5, hex2BinArray("0x0022").map(x => Boolean(x))); //store status result in FF (34)

    ram.writeData(6, hex2BinArray("0x0001").map(x => Boolean(x))); //load the status into A and then compare to b.
    ram.writeData(7, hex2BinArray("0x0022").map(x => Boolean(x))); //load from 34.


    ram.writeData(8, hex2BinArray("0x000C").map(x => Boolean(x))); //loadBimmediate. - load what follows into B.
    ram.writeData(9, hex2BinArray("0x0001").map(x => Boolean(x))); //1 - after this B should contain 1.

    ram.writeData(10, hex2BinArray("0x000E").map(x => Boolean(x))); //update flag reg for jump

    ram.writeData(11, hex2BinArray("0x0008").map(x => Boolean(x))); //jump to reading data if A == B:
    ram.writeData(12, hex2BinArray("0x000F").map(x => Boolean(x))); //address 15

    ram.writeData(13, hex2BinArray("0x0007").map(x => Boolean(x))); //not equal, so jump up to 4 - we need to keep waiting for data
    ram.writeData(14, hex2BinArray("0x0004").map(x => Boolean(x))); //address 4

    //calculate index and offset by doing an increment on top of our constant offset.
    //we'll store our offset+index at location 35.
    ram.writeData(15, hex2BinArray("0x0001").map(x => Boolean(x))); //load memory location 35 into A
    ram.writeData(16, hex2BinArray("0x0023").map(x => Boolean(x))); //load from 35.
    ram.writeData(17, hex2BinArray("0x0003").map(x => Boolean(x))); // Put whatever follows at memory address 36 into B // then add to A.
    ram.writeData(18, hex2BinArray("0x0024").map(x => Boolean(x))); // 36

    //store A in 35 (this is our offset + 1)
    ram.writeData(19, hex2BinArray("0x0005").map(x => Boolean(x))); //store A
    ram.writeData(20, hex2BinArray("0x0023").map(x => Boolean(x))); //at 35

    //check if our new index is > to 1255 - if so - we're done.
    //jump to index 255 and start running the program.

    ram.writeData(21, hex2BinArray("0x000C").map(x => Boolean(x))); //loadBimmediate. - load what follows into B.
    ram.writeData(22, hex2BinArray("0x04E7").map(x => Boolean(x))); //1255 - after this B should contain 1255.
    ram.writeData(23, hex2BinArray("0x000E").map(x => Boolean(x))); //update flag reg for jump

    //conditionally jump to 255 if we've copied all data from 255 to 1255.
    ram.writeData(24, hex2BinArray("0x000A").map(x => Boolean(x))); //jump to line if A > B:
    ram.writeData(25, hex2BinArray("0x00FF").map(x => Boolean(x))); //address 255

    //we still need to copy - keep reading from the data reg to A, and then store that to pointer
    ram.writeData(26, hex2BinArray("0x0012").map(x => Boolean(x))); // store com data
    ram.writeData(27, hex2BinArray("0x0025").map(x => Boolean(x))); // at a temp location 37
    ram.writeData(28, hex2BinArray("0x0001").map(x => Boolean(x))); // load A with the data we just stored
    ram.writeData(29, hex2BinArray("0x0025").map(x => Boolean(x))); // temp data address
    ram.writeData(30, hex2BinArray("0x0013").map(x => Boolean(x))); // store A at pointer which is at address 35
    ram.writeData(31, hex2BinArray("0x0023").map(x => Boolean(x))); // 35

    //jump back to 0, get the next 16 bits of flash memory.
    ram.writeData(32, hex2BinArray("0x0007").map(x => Boolean(x))); // we're not up to 1255 yet, keep asking for data.
    ram.writeData(33, hex2BinArray("0x0000").map(x => Boolean(x))); //address 0

    //////////////////
    //our working data...
    ram.writeData(34, hex2BinArray("0x0000").map(x => Boolean(x))); //0 at memory location 34
    ram.writeData(35, hex2BinArray("0x00FE").map(x => Boolean(x))); //255 at memory location 35 - ...all memory locations in our programs need 255 added to them... important!!!!
    ram.writeData(36, hex2BinArray("0x0001").map(x => Boolean(x))); //1 at memory location 36
    ram.writeData(37, hex2BinArray("0x0000").map(x => Boolean(x))); //temp loc for new data

    //end prog - TODO THIS IS ONLY FOR DEBUGGING
    ram.writeData(255, hex2BinArray("0x0006").map(x => Boolean(x))); //aloadimm
    ram.writeData(256, hex2BinArray("0x000F").map(x => Boolean(x))); //15
    ram.writeData(257, hex2BinArray("0x0002").map(x => Boolean(x))); //aout
    ram.writeData(258, hex2BinArray("0x000F").map(x => Boolean(x))); //address 255

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

    let mockRam = new staticRam(16, 2000, "userProgram");
    //the real program we want to run.
    //TODO this should be an assembly file which we point to on disk.
    mockRam.writeData(0, hex2BinArray("0x0006").map(x => Boolean(x))); //loadAimmediate. - load what follows into A.
    mockRam.writeData(1, hex2BinArray("0x0000").map(x => Boolean(x))); //0 - after this A should contain 0.

    mockRam.writeData(2, hex2BinArray("0x0003").map(x => Boolean(x))); // Put whatever follows at memory address 100 into B // then add to A.
    mockRam.writeData(3, hex2BinArray("0x0163").map(x => Boolean(x))); // 100 + offset of 255
    mockRam.writeData(4, hex2BinArray("0x0002").map(x => Boolean(x))); // A transfer to Out reg.


    mockRam.writeData(5, hex2BinArray("0x000C").map(x => Boolean(x))); //loadBimmediate. - load what follows into B.
    mockRam.writeData(6, hex2BinArray("0x0010").map(x => Boolean(x))); //16 - after this B should contain 16.

    mockRam.writeData(7, hex2BinArray("0x000E").map(x => Boolean(x))); //update flag reg for jump

    //conditionally jump to 2 if A < B... if A < 16 keep looping 
    mockRam.writeData(8, hex2BinArray("0x0009").map(x => Boolean(x))); //jump to line:
    mockRam.writeData(9, hex2BinArray("0x0101").map(x => Boolean(x))); //address 2

    mockRam.writeData(10, hex2BinArray("0x0008").map(x => Boolean(x))); //jump to line:
    mockRam.writeData(11, hex2BinArray("0x00FF").map(x => Boolean(x))); //address 0
    //this is going to be offset to 355 (100 + 255)...
    mockRam.writeData(100, hex2BinArray("0x0001").map(x => Boolean(x))); //1 at memory location 100

    let memoryFiles = generator.generateBinaryMemoryFiles().concat(generator.generateHexArrayForArduinoFlashProgram(mockRam, 1000));
    console.log(memoryFiles);
    memoryFiles.forEach((x, i) => fs.writeFileSync("./memoryFile" + i, x));


};

generateVerilog();
/*
//no symbols

LOADAIMMEDIATE
0
ADD
355
OUTA
LOADBIMMEDIATE
16
UPDATEFLAGS
JUMPIFLESS
257
JUMP
255
100 = 1 // this is an assembly only instruction -
// put some data at a memory address directly.//these should go at end of program



increment = 1
//version with symbols:
(START)
LOADAIMMEDIATE
0
(ADD_1)
ADD
increment
OUTA
LOADBIMMEDIATE
16
UPDATEFLAGS
JUMPIFLESS
ADD_1
JUMP
START

*/