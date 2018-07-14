import { Ipart, nRegister, VoltageRail, nBuffer, bus, inverter, ANDGATE, ORGATE } from "../src/primitives";
import { clock, clockWithMode } from "../src/clock";
import { wire, pin, outputPin } from "../src/pins_wires";
import { nbitAdder } from "../src/ALU";
import { staticRam } from "../src/sram";
import { binaryCounter } from "../src/counter";
import { microCodeData } from "../src/8bitCPUDesign/microcode";
import _ = require("underscore");
import { grapher } from "../src/graphPart";
import { twoLineToFourLineDecoder } from "../src/Decoder";
import { toggleButton } from "../src/buttons";
import { nbitComparator } from "../src/comparator";

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

    //attach register inputs to the bus.
    regA.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    regB.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    outReg.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });


    //attach all outputs to bus.
    regAbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[0][index]) });
    regBbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[1][index]) });
    adderBbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[2][index]) });

    //attach inputs to bus.
    //regAbuffer.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    //regBbuffer.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    //outReg.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });


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

export function generateProgramCounter(clockComp: clock, buscomponent: bus): Ipart[] {

    let pc = new binaryCounter(8, "Program Counter");
    let PCbuffer = new nBuffer(8, "pc buffer");


    //TODO This will get replaced with reset computer signal
    let resetPC = new VoltageRail("clearPC");
    resetPC.outputPin.value = true;

    new wire(clockComp.outputPin, pc.clockPin);
    new wire(resetPC.outputPin, pc.clearPin);


    pc.outputPins.forEach((pin, index) => { new wire(pin, PCbuffer.dataPins[index]) });
    PCbuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[4][index]) });

    pc.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    return [pc, PCbuffer, buscomponent, resetPC]
}

export function generateMicroCodeCounter_EEPROMS_INSTRUCTIONREG(clock: clock, buscomponent: bus): Ipart[] {

    let eepromLen = 256;
    let EEPROM = new staticRam(24, eepromLen, "microcode rom");

    let eepromWriteDisabled = new VoltageRail("eepromWriteDisabled");
    eepromWriteDisabled.outputPin.value = true;

    let eepromOutEnable = new VoltageRail("eepromOutEnable");
    eepromOutEnable.outputPin.value = false;

    let eepromChipEnable = new VoltageRail("eepromChipEnable");
    eepromChipEnable.outputPin.value = false;

    new wire(eepromWriteDisabled.outputPin, EEPROM.writeEnable);
    new wire(eepromOutEnable.outputPin, EEPROM.outputEnable);
    new wire(eepromChipEnable.outputPin, EEPROM.chipEnable);


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
    //EEPROM.wireUpAddressPins(instructionREG.outputPins.slice(4, 8).concat(microCodeCounter.outputPins));

    new wire(instructionREG.outputPins[4], EEPROM.addressPins[1]);
    new wire(instructionREG.outputPins[5], EEPROM.addressPins[2]);
    new wire(instructionREG.outputPins[6], EEPROM.addressPins[3]);
    new wire(instructionREG.outputPins[7], EEPROM.addressPins[4]);

    new wire(microCodeCounter.outputPins[0], EEPROM.addressPins[5]);
    new wire(microCodeCounter.outputPins[1], EEPROM.addressPins[6]);
    new wire(microCodeCounter.outputPins[2], EEPROM.addressPins[7]);

    let microCode = microCodeData.getData().map(number => { return number.toString(2).padStart(24, "0").split("").map(bit => { return Boolean(Number(bit)) }) });
    while (microCode.length < eepromLen) {
        microCode.push(_.range(0, 24).map(x => { return false }))
    }
    EEPROM.data = microCode;
    //EEPROM outputs drive the rest of the computer's signals we'll need to invert some of them....

    new wire(inv.outputPin, microCodeCounter.clockPin);
    let countEnable = new VoltageRail("count enable microcode counter");

    new wire(countEnable.outputPin, microCodeCounter.outputEnablePin1);
    new wire(countEnable.outputPin, microCodeCounter.outputEnablePin2);
    //TODO should be hooked to decoder line max num of instructions.
    new wire(invEnable.outputPin, microCodeCounter.clearPin);

    let decoder1 = new twoLineToFourLineDecoder("decoder1");
    let decoder2 = new twoLineToFourLineDecoder("decoder2");
    let decodeInverter = new inverter("decodeInverter");
    new wire(invEnable.outputPin, decodeInverter.outputEnablePin);

    new wire(microCodeCounter.outputPins[0], decoder1.dataPins[0])
    new wire(microCodeCounter.outputPins[0], decoder2.dataPins[0])
    new wire(microCodeCounter.outputPins[1], decoder1.dataPins[1])
    new wire(microCodeCounter.outputPins[1], decoder2.dataPins[1])

    //third pin is tied to the enable lines of the decoders, but one is inverted.
    new wire(microCodeCounter.outputPins[2], decodeInverter.dataPin);
    new wire(decodeInverter.outputPin, decoder1.outputEnablePin);

    new wire(microCodeCounter.outputPins[2], decoder2.outputEnablePin);

    //TODO!!!!! Something is wrong here I think because we have 1 output going to 2
    //inputs not sure this is handled in the graph search...?

    let loadEnable = new VoltageRail("load disabled");
    loadEnable.outputPin.value = true;
    new wire(loadEnable.outputPin, microCodeCounter.loadPin);
    let stepGraph = new grapher(3, "tstep");

    new wire(microCodeCounter.outputPins[0], stepGraph.dataPins[0]);
    new wire(microCodeCounter.outputPins[1], stepGraph.dataPins[1]);
    new wire(microCodeCounter.outputPins[2], stepGraph.dataPins[2]);


    return [EEPROM, inv, invEnable,
        microCodeCounter, instructionREG,
        countEnable, loadEnable, stepGraph, decoder1, decoder2, decodeInverter,
        eepromWriteDisabled, eepromOutEnable, eepromChipEnable]
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
            "JUMP A > B]", "FLAGIN", ""]);
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

    //jump and flags circuits

    let flagsRegister = new nRegister(4, "flags register");

    new wire(clock.outputPin, flagsRegister.clockPin);
    new wire(signalBank.outputPins[22], flagsRegister.enablePin);


    //comparators for a and b.
    let comparatorComp = new nbitComparator(8, "A_B Comparator");
    let invertON = new VoltageRail("invertON");
    invertON.outputPin.value = true;

    let invert1 = new inverter("invertA=B");
    let invert2 = new inverter("invertA<B");
    new wire(invertON.outputPin, invert1.outputEnablePin);
    new wire(invertON.outputPin, invert2.outputEnablePin);


    let AGTB = new ANDGATE("A>B");


    //wire comparator outputs to inverters
    new wire(comparatorComp.AEBOUT, invert1.dataPin);
    new wire(comparatorComp.AEBOUT, invert2.dataPin);

    //AND the inverted signals to calculate our A > B signal
    new wire(invert1.outputPin, AGTB.dataPin1);
    new wire(invert2.outputPin, AGTB.dataPin2);

    //hookup signals to the flags register itself.

    new wire(AGTB.outputPin, flagsRegister.dataPins[0]);
    new wire(comparatorComp.AEBOUT, flagsRegister.dataPins[1]);
    new wire(comparatorComp.ALBOUT, flagsRegister.dataPins[2]);

    //jump signal calculation//

    let JE = signalBank.outputPins[20];
    let JG = signalBank.outputPins[21];
    let JL = signalBank.outputPins[19];

    //to actually calculate the jump we use the incoming microcode signals
    //and the flags register outputs - if any set are true we jump.

    let ANDAGB = new ANDGATE("ANDAGB");
    let ANDALB = new ANDGATE("ANDALESSB");
    let ANDEB = new ANDGATE("ANDA=B");


    new wire(flagsRegister.outputPins[0], ANDAGB.dataPin1);
    new wire(JG, ANDAGB.dataPin2);

    new wire(flagsRegister.outputPins[1], ANDEB.dataPin1);
    new wire(JE, ANDEB.dataPin2);

    new wire(flagsRegister.outputPins[2], ANDALB.dataPin1);
    new wire(JL, ANDALB.dataPin2);

    let OR1 = new ORGATE("OR1");
    let OR2 = new ORGATE("OR2");

    new wire(ANDAGB.outputPin, OR1.dataPin1);
    new wire(ANDEB.outputPin, OR1.dataPin2);

    //feed first or gate into second or gate.
    new wire(OR1.outputPin, OR2.dataPin1);
    new wire(ANDALB.outputPin, OR2.dataPin2);

    //output of final OR is hooked to program counter jump/load signal.
    //actually an inverter first.

    let loadInverter = new inverter();
    new wire(invertON.outputPin, loadInverter.outputEnablePin);
    new wire(OR2.outputPin, loadInverter.dataPin);
    //finally wire up the load pin...
    new wire(loadInverter.outputPin, programCounter.loadPin);

    new wire(signalBank.outputPins[18], memoryReg.enablePin);



    return [signalBank, invertSignal,
        ramInInverter,
        ramOutInverter,
        programCounterCountInverter, outputOn,invertON,comparatorComp,invert1,invert2,loadInverter,flagsRegister,ANDAGB,ANDALB,ANDEB,OR1,OR2,AGTB]
}

export function generate8bitComputerDesign(): Ipart[] {

    var parts1 = generate3Registers_Adder_Bus();
    var bus = _.last(parts1) as bus;
    var clockcomp = new clockWithMode(50);
    let modeButton = new toggleButton("clockMode");
    let stepButton = new toggleButton("stepButton");

    new wire(modeButton.outputPin, clockcomp.modePin);
    new wire(stepButton.outputPin, clockcomp.stepPin);

    var parts2 = generate_MAR_RAM_DATAINPUTS(bus);
    var parts3 = generateProgramCounter(clockcomp, bus);
    var parts4 = generateMicroCodeCounter_EEPROMS_INSTRUCTIONREG(clockcomp, bus);


    var parts5 = [new grapher(1, "clock data view test")];
    new wire(clockcomp.outputPin, parts5[0].dataPins[0]);

    var parts6 = generateMicrocodeSignalBank(
        clockcomp, parts4[0] as staticRam, parts3[0] as binaryCounter, parts3[1] as nBuffer, parts2[1] as staticRam, parts2[2] as nBuffer,
        parts4[4] as nRegister, parts1[0] as nRegister, parts1[2] as nBuffer, parts1[1] as nRegister, parts1[3] as nBuffer
        , parts1[6] as nRegister, parts2[0] as nRegister, parts1[4] as nBuffer)


    var output = parts1.concat(parts2, parts3, parts4, parts5, parts6);
    output.unshift(clockcomp, modeButton, stepButton);
    return _.unique(output);
}