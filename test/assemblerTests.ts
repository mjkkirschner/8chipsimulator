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


        ].map(x=>x.toLowerCase()))
    });

});
