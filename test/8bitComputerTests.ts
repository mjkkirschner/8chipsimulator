import { Ipart, nRegister, VoltageRail, nBuffer, bus, inverter } from "../src/primitives";
import { clock } from "../src/clock";
import { wire, pin } from "../src/pins_wires";
import { nbitAdder } from "../src/ALU";
import { staticRam } from "../src/sram";
import { binaryCounter } from "../src/counter";
import { microCodeData } from "../src/8bitCPUDesign/microcode";
import _ = require("underscore");
import { grapher } from "../src/graphPart";

export function generate3Registers_Adder_Bus(): Ipart[] {

    let regA = new nRegister(8, "A register");
    let regAbuffer = new nBuffer(8, "A reg buffer");

    let outReg = new nRegister(8, "OUT register");

    let regB = new nRegister(8, " B register");
    let regBbuffer = new nBuffer(8, "B reg buffer");

    let adder = new nbitAdder(8, "adder");
    let adderBbuffer = new nBuffer(8, "adder buffer");

    let buscomponent = new bus(8, 5, "main bus");

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


    let memoryAddressREG = new nRegister(8, "memory address register");

    let ram = new staticRam(8, 256, "main ram");
    let ramBuffer = new nBuffer(8, "ram output buffer");

    //attach ram address lines to MAR outputs.
    memoryAddressREG.outputPins.forEach((outPut, index) => {
        new wire(outPut, ram.addressPins[index])
    });

    //attach ram outputs to bus via buffer.
    ram.InputOutputPins.forEach((pin, index) => { new wire(pin.internalOutput, ramBuffer.dataPins[index]) });
    ramBuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[3][index]) });


    //attach ram and intru inputs to bus.
    memoryAddressREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    ram.InputOutputPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin.internalInput) });

    return [memoryAddressREG, ram, ramBuffer, buscomponent]
}

export function generateProgramCounter(buscomponent: bus): Ipart[] {

    let pc = new binaryCounter(8, "Program Counter");
    let PCbuffer = new nBuffer(8, "pc buffer");

    pc.outputPins.forEach((pin, index) => { new wire(pin, PCbuffer.dataPins[index]) });
    PCbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[4][index]) });

    pc.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    return [pc, PCbuffer, buscomponent]
}

export function generateMicroCodeCounter_EEPROMS_INSTRUCTIONREG(clock: clock, buscomponent: bus): Ipart[] {

    let eepromLen = 256;
    let EEPROM = new staticRam(24, eepromLen, "microcode rom");

    let instructionREG = new nRegister(8, "instruction register");
    //attach instruction reg inputs to bus - we shouldn't usually care about getting data out of the instruc reg.
    instructionREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    //we need to invert the count clock signal for the microcodeCounter
    let invEnable = new VoltageRail("invert clock signal enable");
    //we need to invert the count clock signal for the microcodeCounter
    invEnable.outputPin.value = true;
    let inv = new inverter("invert clock signal");
    new wire(invEnable.outputPin, inv.outputEnablePin);


    new wire(clock.outputPin, inv.dataPin);
    //count to 8
    let microCodeCounter = new binaryCounter(3, "microcode step counter");
    //connect clock to binaryCounter through inverter
    new wire(inv.outputPin, microCodeCounter.clockPin);

    //connect to EEPROM (modeled via RAM...)
    //TODO maybe use a different memory object here with a different type of view so it's not so giant...
    EEPROM.wireUpAddressPins(instructionREG.outputPins.slice(4, 8).concat(microCodeCounter.outputPins));
    let microCode = microCodeData.getData().map(number => { return number.toString(2).padStart(24, "0").split("").map(bit => { return Boolean(Number(bit)) }) });
    while (microCode.length < eepromLen) {
        microCode.push(_.range(0, 24).map(x => { return false }))
    }
    EEPROM.data = microCode;
    //EEPROM outputs drive the rest of the computer's signals we'll need to invert some of them....
    //TODO
    //would be good to create named buffers foreach of these signals so we can easily grab them and treat them all as high when they are on
    //even if the resulting signal needs a low signal. - for this we can use indicator LED or some other component like this.
    return [EEPROM, inv, invEnable, microCodeCounter, instructionREG]
}

export function generate8bitComputerDesign(): Ipart[] {

    var parts1 = generate3Registers_Adder_Bus();
    var bus = _.last(parts1) as bus;
    var clockcomp = new clock(100);
    var parts2 = generate_MAR_RAM_DATAINPUTS(bus);
    var parts3 = generateProgramCounter(bus);
    var parts4 = generateMicroCodeCounter_EEPROMS_INSTRUCTIONREG(clockcomp, bus);


    var parts5 = [new grapher(1, "clock data view test")];
    new wire(clockcomp.outputPin, parts5[0].dataPins[0]);


    var output = parts1.concat(parts2, parts3, parts4,parts5);
    output.unshift(clockcomp);
    return _.unique(output);
}