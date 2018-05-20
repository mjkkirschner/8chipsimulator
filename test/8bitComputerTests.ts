import { Ipart, nRegister, VoltageRail, nBuffer, bus, inverter } from "../src/primitives";
import { clock } from "../src/clock";
import { wire, pin, outputPin } from "../src/pins_wires";
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

    new wire(inv.outputPin, microCodeCounter.clockPin);
    let countEnable = new VoltageRail("count enable microcode counter");

    new wire(countEnable.outputPin, microCodeCounter.outputEnablePin1);
    new wire(countEnable.outputPin, microCodeCounter.outputEnablePin2);
    //TODO should be hooked to decoder line max num of instructions.
    new wire(invEnable.outputPin,microCodeCounter.clearPin);
    

    //TODO add the decoders here.

    let loadEnable = new VoltageRail("load disabled");
    loadEnable.outputPin.value = true;
    new wire(loadEnable.outputPin, microCodeCounter.loadPin);
    let stepGraph = new grapher(3,"tstep");

    new wire(microCodeCounter.outputPins[0],stepGraph.dataPins[0]);
    new wire(microCodeCounter.outputPins[1],stepGraph.dataPins[1]);
    new wire(microCodeCounter.outputPins[2],stepGraph.dataPins[2]);


    return [EEPROM, inv, invEnable, microCodeCounter, instructionREG, countEnable,loadEnable,stepGraph]
}

function generateMicrocodeSignalBank(clock: clock,
    eeprom: staticRam,
    programCounter: binaryCounter, programCounterBuffer: nBuffer,
    ram: staticRam, ramOutBuffer: nBuffer,
    instructionReg: nRegister,
    aReg: nRegister, aRegBuffer: nBuffer,
    bReg: nRegister, bRegBuffer: nBuffer,
    outReg: nRegister,
    memoryReg: nRegister,
    adderBbuffer: nBuffer): Ipart[] {
    let signalBank = new nBuffer(24, "microCode SIGNAL bank",
        ["RAMIN",
            "RAMOUT",
            "INSTRUCTIONIN",
            "INSTROUT",
            "COUNTEROUT",
            "EMPTY BIT!",
            "COUNTERENABLE",
            "AIN",
            "AOUT",
            "SUMOUT",
            "SUBTRACT(ALUMODE?)",
            "ALUMODE",
            "ALUMODE",
            "ALUMODE",
            "BIN",
            "BOUT",
            "OUTIN",
            "HALT",
            "MEMORYREGIN",
            "JUMP A < B",
            "JUMP A = B",
            "JUMP A > B]", "", ""]);
    //invert some of the signals.
    //TODO when we build jump board and flags reg then implement this.
    //let jumpInverter = new yadayada

    //wires go from eeprom to signalBank then to inverter (if applicable) - so signal bank shows state
    //of microinstruction
    eeprom.InputOutputPins.forEach((inout, index) => {
        new wire(inout.internalOutput, signalBank.dataPins[index])
    });

    let outputOn = new VoltageRail("signalBankOutputOn");
    new wire(outputOn.outputPin, signalBank.outputEnablePin);
    outputOn.outputPin.value = true;

    //inverted signals and hookups for each signal's parts...


    //ram
    let invertSignal = new VoltageRail("invertOn");
    invertSignal.outputPin.value = true;

    let ramInInverter = new inverter("ramInInverter");
    new wire(invertSignal.outputPin, ramInInverter.outputEnablePin);
    new wire(signalBank.outputPins[0], ramInInverter.dataPin);
    new wire(ramInInverter.outputPin, ram.writeEnable);

    let ramOutInverter = new inverter("ramOutInverter");
    new wire(invertSignal.outputPin, ramOutInverter.outputEnablePin);
    new wire(signalBank.outputPins[1], ramOutInverter.dataPin);
    new wire(ramOutInverter.outputPin, ram.outputEnable);
    //we also need to turn the output buffer on but its enable is not inverted.
    new wire(signalBank.outputPins[1], ramOutBuffer.outputEnablePin);


    //instruction register
    new wire(signalBank.outputPins[2], instructionReg.enablePin);
    new wire(clock.outputPin, instructionReg.clockPin);

    //instruction out, unused currently.


    //program counter
    new wire(signalBank.outputPins[4], programCounterBuffer.outputEnablePin);

    let programCounterCountInverter = new inverter("countEnableInverter");
    new wire(invertSignal.outputPin, programCounterCountInverter.outputEnablePin);

    new wire(signalBank.outputPins[6], programCounterCountInverter.dataPin);
    new wire(programCounterCountInverter.outputPin, programCounter.outputEnablePin1);
    new wire(programCounterCountInverter.outputPin, programCounter.outputEnablePin2);

    //A register.
    new wire(clock.outputPin, aReg.clockPin);
    new wire(signalBank.outputPins[7], aReg.enablePin);
    new wire(signalBank.outputPins[8], aRegBuffer.outputEnablePin);

    //ALU //TODO ALU not fully implemented - signals unused until built.
    new wire(signalBank.outputPins[9], adderBbuffer.outputEnablePin);


    //B register
    new wire(clock.outputPin, bReg.clockPin);
    new wire(signalBank.outputPins[14], bReg.enablePin);
    new wire(signalBank.outputPins[15], bRegBuffer.outputEnablePin);

    //out register
    new wire(clock.outputPin, outReg.clockPin);
    new wire(signalBank.outputPins[16], outReg.enablePin);

    //halt - clock stuff!
    new wire(signalBank.outputPins[17], clock.enablePin);

    //memory register
    new wire(clock.outputPin, memoryReg.clockPin);
    new wire(signalBank.outputPins[18], memoryReg.enablePin);
    return [signalBank, invertSignal,
        ramInInverter,
        ramOutInverter,
        programCounterCountInverter, outputOn]
}

function generateSignalStableSignals() {

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

    var parts6 = generateMicrocodeSignalBank(
        clockcomp, parts4[0] as staticRam, parts3[0] as binaryCounter, parts3[1] as nBuffer, parts2[1] as staticRam, parts2[2] as nBuffer,
        parts4[4] as nRegister, parts1[0] as nRegister, parts1[2] as nBuffer, parts1[1] as nRegister, parts1[3] as nBuffer
        , parts1[6] as nRegister, parts2[0] as nRegister, parts1[4] as nBuffer)


    var output = parts1.concat(parts2, parts3, parts4, parts5, parts6);
    output.unshift(clockcomp);
    return _.unique(output);
}