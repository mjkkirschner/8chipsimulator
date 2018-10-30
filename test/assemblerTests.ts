import { assembler } from "../tools/assembler";
import * as fs from 'fs';
import * as assert from 'assert';

let testCountProgram =
    `increment = 1
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
START`

let testVGAOutputProgram = 
`increment = 1
(START)
LOADAIMMEDIATE
40000
(ADD_1)
ADD
increment
OUTA
STOREA
pixelindex
LOADAATPOINTER
pixelindex
LOADBIMMEDIATE
0
UPDATEFLAGS
JUMPIFEQUAL
COLORWHITE

(COLORBLACK)
LOADAIMMEDIATE
0
STOREAATPOINTER
pixelindex
JUMP
DONECHECK

(COLORWHITE)
LOADAIMMEDIATE
65000
STOREAATPOINTER
pixelindex

//a comment

(DONECHECK)
LOADBIMMEDIATE
62000
UPDATEFLAGS
JUMPIFLESS
ADD_1
JUMP
START`

describe('assembler', function () {
    it('assembler should convert counter with macro and symbols correctly', function () {
        let path = "./TempTestFileAssem.asm";
        fs.writeFileSync(path, testCountProgram);
        let assem = new assembler(path);
        let result = assem.convertToBinary();
        assert.deepEqual(result, [
            "0x0006", //loadAimmediate
            "0x0001",//1
            "0x0005", //Store A
            "0x02F3",//next location in variable space
            "0x0006",//loadAImmediate
            "0x0000",//0
            "0x0003",//add
            "0x02F3",//increment memory location
            "0x0002",// outA
            "0x000C",//loadBImmediate
            "0x0010", //16
            "0x000E", //update flags for jump
            "0x0009", //jump if less (A<B)
            "0x0105", //ADD_1 label location in hex
            "0x0007", //JUMP
            "0x0103", //START label location


        ].map(x => x.toLowerCase()))
    });

    it('assembler should convert vga draw program with no symbols (direct memory hex locations)', function () {
        let path = "./TempTestFileAssem.asm";
        fs.writeFileSync(path, testVGAOutputProgram);
        let assem = new assembler(path);
        let result = assem.convertToBinary();
        assert.deepEqual(result, [
            "0x0006", //loadAimmediate
            "0x0001",//1
            "0x0005", //Store A
            "0x02F3",//next location in variable space,
            "0x0006",//loadAImmediate
            "0x9C40",//40000
            "0x0003",//add
            "0x02F3",//increment memory location,
            "0x0002",// outA
            "0x0005", //Store A,
            "0x02F4", // pixel index next var space
            "0x0014", //load A from pointer
            "0x02F4", // pixel index next var space
            "0x000C",//loadBImmediate
            "0x0000", //0
            "0x000E", //update flags for jump
            "0x0008", //jump if equal
            "0x0117", //address 24 color white
            "0x0006",//loadAImmediate
            "0x0000",//0
            "0x0013", //store a at pointer,
            "0x02F4", // pixel index next var space
            "0x0007", //JUMP
            "0x011B", //done check (28)
            "0x0006",//loadAImmediate
            "0xFDE8",//65000
            "0x0013", //store a at pointer,
            "0x02F4", // pixel index next var space,
            "0x000C", //loadbimm
            "0xF230", //62000,
            "0x000E", //update flags for jump
            "0x0009", //jump if less (A<B)
            "0x0105", //add 1 (6)
            "0x0007", //JUMP
            "0x0103" // START (4)

           
        ].map(x => x.toLowerCase()))
    });

});
