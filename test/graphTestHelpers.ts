import { Ipart, nRegister, VoltageRail, nBuffer, bus } from "../src/primitives";
import { clock } from "../src/clock";
import { wire, pin } from "../src/pins_wires";
import { nbitAdder } from "../src/ALU";
import { staticRam } from "../src/sram";
import { binaryCounter } from "../src/counter";

export function generateRegisterAndBuffer(): Ipart[] {

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


export function generate2RegistersAndAdder(): Ipart[] {

    let regA = new nRegister(8);
    let regAbuffer = new nBuffer(8);

    let outReg = new nRegister(8);

    let regB = new nRegister(8);
    let regBbuffer = new nBuffer(8);

    let adder = new nbitAdder(8);
    let adderBbuffer = new nBuffer(8);

    let buscomponent = new bus(8, 12);

    //hook up registers to adders
    regA.outputPins.forEach((pin, index) => { new wire(pin, adder.dataPinsA[index]) });
    regB.outputPins.forEach((pin, index) => { new wire(pin, adder.dataPinsB[index]) });

    //registers to buffers.
    regA.outputPins.forEach((pin, index) => { new wire(pin, regAbuffer.dataPins[index]) });
    regB.outputPins.forEach((pin, index) => { new wire(pin, regBbuffer.dataPins[index]) });

    //sum pins to buffers
    adder.sumOutPins.forEach((pin, index) => { new wire(pin, adderBbuffer.dataPins[index]) });

    //attach all outputs to bus.
    regAbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[0][index]) });
    regBbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[1][index]) });
    adderBbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[2][index]) });

    //attach inputs to bus.
    regAbuffer.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    regBbuffer.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    outReg.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });


    return [regA, regB, adder, outReg, buscomponent];
}

export function generate_MAR_RAM_DATAINPUTS_INSTRUCTION_REG(buscomponent: bus): Ipart[] {

    let instructionREG = new nRegister(8);

    let memoryAddressREG = new nRegister(8);

    let ram = new staticRam(8, 255);

    //attach ram address lines to MAR outputs.
    memoryAddressREG.outputPins.forEach((outPut, index) => {
        new wire(outPut, ram.addressPins[index])
    });

    //attach ram and instr outputs to bus.
    ram.InputOutputPins.forEach((pin, index) => { new wire(pin.internalOutput, buscomponent.inputGroups[3][index]) });
    instructionREG.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[4][index]) });


    //attach ram and intru inputs to bus.
    memoryAddressREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    ram.InputOutputPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin.internalInput) });
    instructionREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    return [memoryAddressREG, ram, instructionREG, buscomponent]
}

export function generateProgramCounter(buscomponent: bus): Ipart[] {

    let pc = new binaryCounter(8);
    pc.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[5][index]) });
    pc.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    return [pc, buscomponent]
}




export function generate2RegistersAdderAndStaticRam(): Ipart[] {

    let clockcomp = new clock(50);
    let regA = new nRegister(8);
    let regB = new nRegister(8);

    let data1 = new VoltageRail("data");
    let enable = new VoltageRail("enablereg");
    enable.outputPin.value = true;
    data1.outputPin.value = true;


    new wire(clockcomp.outputPin, regA.clockPin);
    new wire(clockcomp.outputPin, regB.clockPin);

    new wire(data1.outputPin, regB.dataPins[7]);

    new wire(enable.outputPin, regA.enablePin);
    new wire(enable.outputPin, regB.enablePin);

    let adder = new nbitAdder(8);

    regA.outputPins.forEach((pin, index) => { new wire(pin, adder.dataPinsA[index]) });
    regB.outputPins.forEach((pin, index) => { new wire(pin, adder.dataPinsB[index]) });

    adder.sumOutPins.forEach((pin, index) => { new wire(pin, regA.dataPins[index]) });


    let we = new VoltageRail("writeEnable");
    let oe = new VoltageRail("outEnable");
    let ce = new VoltageRail("chipEnable");
    let ram = new staticRam(8, 255);

    we.outputPin.value = true;
    oe.outputPin.value = true;
    ce.outputPin.value = false;


    regA.outputPins.forEach((outPut, index) => {
        new wire(outPut, ram.addressPins[index])
    });
    regA.outputPins.forEach((outPut, index) => {
        new wire(outPut, ram.InputOutputPins[index].internalInput)
    });

    new wire(clockcomp.outputPin, ram.writeEnable);
    new wire(oe.outputPin, ram.outputEnable);
    new wire(ce.outputPin, ram.chipEnable);



    return [clockcomp, regA, regB, data1, enable, adder, ram, we, oe, ce];
} 