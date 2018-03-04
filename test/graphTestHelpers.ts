import { Ipart, nRegister, VoltageRail, nBuffer, bus, inverter } from "../src/primitives";
import { clock } from "../src/clock";
import { wire, pin } from "../src/pins_wires";
import { nbitAdder } from "../src/ALU";
import { staticRam } from "../src/sram";
import { binaryCounter } from "../src/counter";
import { microCodeData } from "../src/8bitCPUDesign/microcode";
import _ = require("underscore");

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


export function generate3Registers_Adder_Bus(): Ipart[] {

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


    return [regA, regB, regAbuffer, regBbuffer, adderBbuffer, adder, outReg, buscomponent];
}

export function generate_MAR_RAM_DATAINPUTS(buscomponent: bus): Ipart[] {


    let memoryAddressREG = new nRegister(8);

    let ram = new staticRam(8, 256);

    //attach ram address lines to MAR outputs.
    memoryAddressREG.outputPins.forEach((outPut, index) => {
        new wire(outPut, ram.addressPins[index])
    });

    //attach ram outputs to bus.
    ram.InputOutputPins.forEach((pin, index) => { new wire(pin.internalOutput, buscomponent.inputGroups[3][index]) });


    //attach ram and intru inputs to bus.
    memoryAddressREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    ram.InputOutputPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin.internalInput) });

    return [memoryAddressREG, ram, buscomponent]
}

export function generateProgramCounter(buscomponent: bus): Ipart[] {

    let pc = new binaryCounter(8);
    let PCbuffer = new nBuffer(8);

    pc.outputPins.forEach((pin, index) => { new wire(pin, PCbuffer.dataPins[index]) });
    PCbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[5][index]) });

    pc.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    return [pc, PCbuffer, buscomponent]
}

export function generateMicroCodeCounter_EEPROMS_INSTRUCTIONREG(clock: clock, buscomponent: bus): Ipart[] {


    let EEPROM = new staticRam(24, 4096);

    let instructionREG = new nRegister(8);
    //attach instruction reg inputs to bus - we shouldn't usually care about getting data out of the instruc reg.
    instructionREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    //we need to invert the count clock signal for the microcodeCounter
    let inv = new inverter();
    new wire(clock.outputPin, inv.dataPin);
    //count to 8
    let microCodeCounter = new binaryCounter(3);
    //connect clock to binaryCounter through inverter
    new wire(inv.outputPin, microCodeCounter.clockPin);

    //connect to EEPROM (modeled via RAM...)
    //TODO maybe use a different memory object here with a different type of view so it's not so giant...
    EEPROM.wireUpAddressPins(instructionREG.outputPins.concat(microCodeCounter.outputPins));
    let microCode = microCodeData.getData().map(number => { return number.toString(2).padStart(24, "0").split("").map(bit => { return Boolean(Number(bit)) }) });
    EEPROM.data = microCode;
    //EEPROM outputs drive the rest of the computer's signals we'll need to invert some of them....
    //TODO
    //would be good to create named buffers foreach of these signals so we can easily grab them and treat them all as high when they are on
    //even if the resulting signal needs a low signal. - for this we can use indicator LED or some other component like this.
    return [EEPROM, inv, microCodeCounter, instructionREG]
}

export function generate8bitComputerDesign(): Ipart[] {

    var parts1 = generate3Registers_Adder_Bus();
    var bus = _.last(parts1) as bus;
    var clockcomp = new clock(100);
    var parts2 = generate_MAR_RAM_DATAINPUTS(bus);
    var parts3 = generateProgramCounter(bus);
    var parts4 = generateMicroCodeCounter_EEPROMS_INSTRUCTIONREG(clockcomp, bus);

    var output = parts1.concat(parts2, parts3, parts4);
    output.unshift(clockcomp);
    return _.unique(output);
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