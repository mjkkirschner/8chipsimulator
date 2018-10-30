import { Ipart, nRegister, VoltageRail, nBuffer, inverter, ANDGATE, ORGATE, bus } from "../src/primitives";
import { clock, clockWithMode } from "../src/clock";
import { wire, pin, outputPin } from "../src/pins_wires";
import { nbitAdder } from "../src/ALU";
import { staticRam, dualPortStaticRam } from "../src/sram";
import { binaryCounter } from "../src/counter";
import { microCodeData } from "../src/8bitCPUDesign/microcode";
import _ = require("underscore");
import { grapher } from "../src/graphPart";
import { twoLineToFourLineDecoder } from "../src/Decoder";
import { toggleButton } from "../src/buttons";
import { nbitComparator } from "../src/comparator";
import { vgaSignalGenerator } from "../src/vgaSignalGenerator";
import { vgaMonitorPart } from "../src/debugParts/vgaMonitor";
import { SPIComPart } from "../src/SPIpart";

export function generate3Registers_Adder_Bus(): Ipart[] {

    let regA = new nRegister(16, "A_register");
    let regAbuffer = new nBuffer(16, "A_reg_buffer");

    let outReg = new nRegister(16, "OUT_register");

    let regB = new nRegister(16, "B_register");
    let regBbuffer = new nBuffer(16, "B_reg_buffer");

    let adder = new nbitAdder(16, "adder");
    let adderBbuffer = new nBuffer(16, "adder_buffer");

    let buscomponent = new bus(16, 7, "main_bus");

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

    return [regA, regB, regAbuffer, regBbuffer, adderBbuffer, adder, outReg, buscomponent];
}

export function generate_MAR_RAM_DATAINPUTS(buscomponent: bus, clock: clockWithMode): Ipart[] {


    let memoryAddressREG = new nRegister(16, "memory_address_register");


    let ce = new VoltageRail("ram_chipEnable");
    ce.outputPin.value = false;

    let ram = new dualPortStaticRam(16, 65536, "main_ram");
    new wire(ce.outputPin, ram.chipEnable);
    let ramBuffer = new nBuffer(16, "ram_output_buffer");

    //attach ram address lines to MAR outputs.
    memoryAddressREG.outputPins.forEach((outPut, index) => {
        new wire(outPut, ram.addressPins[index])
    });

    //attach ram outputs to bus via buffer.
    ram.InputOutputPins.forEach((pin, index) => { new wire(pin.internalOutput, ramBuffer.dataPins[index]) });
    ramBuffer.outputPins.forEach((pin, index) => { new wire(pin, buscomponent.inputGroups[3][index]) });


    //attach ram and address inputs to bus.
    memoryAddressREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });
    ram.InputOutputPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin.internalInput) });

    //add our vga signal generator
    //640 x 480 - but we'll discard a bunch of x and y positions...
    let vgaSignalGen = new vgaSignalGenerator(10, 9, "sigGen");

    new wire(clock.outputPin, vgaSignalGen.clockPin);


    /*

    //on the FPGA the monitor part are output pins
    //on the FPGA chip or TOP module.

    let vgaMonitor = new vgaMonitorPart(640, 480, "monitor");
    new wire(vgaSignalGen.h_sync, vgaMonitor.hsync);
    new wire(vgaSignalGen.v_sync, vgaMonitor.vsync);
    new wire(clock.outputPin, vgaMonitor.clock);

    new wire(ram.readonlyOutputPins[0], vgaMonitor.red[0]);
    new wire(ram.readonlyOutputPins[1], vgaMonitor.red[1]);
    new wire(ram.readonlyOutputPins[2], vgaMonitor.red[2]);
    new wire(ram.readonlyOutputPins[3], vgaMonitor.red[3]);

    new wire(ram.readonlyOutputPins[4], vgaMonitor.green[0]);
    new wire(ram.readonlyOutputPins[5], vgaMonitor.green[1]);
    new wire(ram.readonlyOutputPins[6], vgaMonitor.green[2]);
    new wire(ram.readonlyOutputPins[7], vgaMonitor.green[3]);

    new wire(ram.readonlyOutputPins[8], vgaMonitor.blue[0]);
    new wire(ram.readonlyOutputPins[9], vgaMonitor.blue[1]);
    new wire(ram.readonlyOutputPins[10], vgaMonitor.blue[2]);
    new wire(ram.readonlyOutputPins[11], vgaMonitor.blue[3]);
*/

    return [memoryAddressREG, ram, ramBuffer, buscomponent, ce, vgaSignalGen]
}

export function generateProgramCounter(clockComp: clock, buscomponent: bus): Ipart[] {

    let pc = new binaryCounter(16, "Program_Counter");
    let PCbuffer = new nBuffer(16, "pc_buffer");


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
    let EEPROM = new staticRam(32, eepromLen, "microcode_rom");

    let eepromWriteDisabled = new VoltageRail("eepromWriteDisabled");
    eepromWriteDisabled.outputPin.value = true;

    let eepromOutEnable = new VoltageRail("eepromOutEnable");
    eepromOutEnable.outputPin.value = false;

    let eepromChipEnable = new VoltageRail("eepromChipEnable");
    eepromChipEnable.outputPin.value = false;

    new wire(eepromWriteDisabled.outputPin, EEPROM.writeEnable);
    new wire(eepromOutEnable.outputPin, EEPROM.outputEnable);
    new wire(eepromChipEnable.outputPin, EEPROM.chipEnable);


    let instructionREG = new nRegister(16, "instruction_register");
    //attach instruction reg inputs to bus - we shouldn't usually care about getting data out of the instruc reg.
    instructionREG.dataPins.forEach((pin, index) => { new wire(buscomponent.outputPins[index], pin) });

    //we need to invert the count clock signal for the microcodeCounter
    let invEnable = new VoltageRail("invert_clock_signal_enable");
    //we need to invert the count clock signal for the microcodeCounter
    invEnable.outputPin.value = true;
    let inv = new inverter("invert_clock_signal");
    new wire(invEnable.outputPin, inv.outputEnablePin);


    new wire(clock.outputPin, inv.dataPin);
    //count to 8
    let microCodeCounter = new binaryCounter(3, "microcode_step_counter");
    //connect clock to binaryCounter through inverter
    new wire(inv.outputPin, microCodeCounter.clockPin);

    let instructionPinsLen = instructionREG.outputPins.length;
    new wire(instructionREG.outputPins[instructionPinsLen - 5], EEPROM.addressPins[0]);
    new wire(instructionREG.outputPins[instructionPinsLen - 4], EEPROM.addressPins[1]);
    new wire(instructionREG.outputPins[instructionPinsLen - 3], EEPROM.addressPins[2]);
    new wire(instructionREG.outputPins[instructionPinsLen - 2], EEPROM.addressPins[3]);
    new wire(instructionREG.outputPins[instructionPinsLen - 1], EEPROM.addressPins[4]);

    new wire(microCodeCounter.outputPins[0], EEPROM.addressPins[5]);
    new wire(microCodeCounter.outputPins[1], EEPROM.addressPins[6]);
    new wire(microCodeCounter.outputPins[2], EEPROM.addressPins[7]);

    let microCode = microCodeData.getData().map(number => { return number.toString(2).padStart(32, "0").split("").map(bit => { return Boolean(Number(bit)) }) });
    while (microCode.length < eepromLen) {
        microCode.push(_.range(0, 32).map(x => { return false }));
    }
    EEPROM.data = microCode;
    //EEPROM outputs drive the rest of the computer's signals we'll need to invert some of them....

    new wire(inv.outputPin, microCodeCounter.clockPin);
    let countEnable = new VoltageRail("count_enable_microcode_counter");

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

    let loadEnable = new VoltageRail("load_disabled");
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
    adderBbuffer: nBuffer, bus: bus): Ipart[] {
    let signalBank = new nBuffer(32, "microCode_SIGNAL_bank",
        [
            "RAMIN",
            "RAMOUT",
            "INSTRUCTIONIN",
            "INSTROUT",
            "COUNTEROUT",
            "EMPTY_BIT",
            "COUNTERENABLE",
            "AIN",
            "AOUT",
            "SUMOUT",
            "SUBTRACT_ALUMODE_",
            "ALUMODE",
            "ALUMODE",
            "ALUMODE",
            "BIN",
            "BOUT",
            "OUTIN",
            "HALT",
            "MEMORYREGIN",
            "JUMP_A_LESS_B",
            "JUMP_A_EQUAL_B",
            "JUMP_A_GREATER_ B]",
            "FLAGIN",
            "COM_STATUS_OUT",
            "COM_CONTROL_IN",
            "COM_DATA_IN",
            "26", "27", "28", "29", "30", "31"
        ]);

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


    //com regs
    //TODO general GPIO?
    let comDataReg = new nRegister(16, "comDataReg");
    let comDataRegBuffer = new nBuffer(16, "comDataRegBuffer");
    let comControlReg = new nRegister(16, "comControlReg");
    let comStatusReg = new nRegister(16, "comStatusReg");
    let comStatusRegBuffer = new nBuffer(16, "comStatusRegBuffer");
    let spi = new SPIComPart(16, "spi_test");
    //connect spi part pins to the related registers
    spi.dataoutputPins.forEach((x, i) => { new wire(x, comDataReg.dataPins[i]) });
    spi.statusPins.forEach((x, i) => { new wire(x, comStatusReg.dataPins[i]) });
    new wire(clock.outputPin,spi.clockPin);
    
    comControlReg.outputPins.forEach((x, i) => { new wire(x, spi.controlPins[i]) });

    //attach the com registers to the bus....
    //attach register inputs to the bus.
    comControlReg.dataPins.forEach((pin, index) => { new wire(bus.outputPins[index], pin) });


    //attach all outputs to bus.
    comDataRegBuffer.outputPins.forEach((pin, index) => { new wire(pin, bus.inputGroups[5][index]) });
    comStatusRegBuffer.outputPins.forEach((pin, index) => { new wire(pin, bus.inputGroups[6][index]) });

    //attach register outputs to buffer inputs.
    comDataReg.outputPins.forEach((x, i) => new wire(x, comDataRegBuffer.dataPins[i]));
    comStatusReg.outputPins.forEach((x, i) => new wire(x, comStatusRegBuffer.dataPins[i]));


    //comControlReg never outputs to the bus, only reads from the bus.
    new wire(clock.outputPin, comControlReg.clockPin);
    new wire(signalBank.outputPins[24], comControlReg.enablePin);

    // comDataReg and comStatusReg enable are always off. - it never reads from the bus.
    //TODO - I think this should be always on!.
    let comEnableOn = new VoltageRail("COMenableOn");
    comEnableOn.outputPin.value = true;

    new wire(clock.outputPin, comStatusReg.clockPin);
    new wire(comEnableOn.outputPin, comStatusReg.enablePin);
    new wire(signalBank.outputPins[23], comStatusRegBuffer.outputEnablePin);

    new wire(clock.outputPin, comDataReg.clockPin);
    new wire(comEnableOn.outputPin, comDataReg.enablePin);
    new wire(signalBank.outputPins[25], comDataRegBuffer.outputEnablePin);

    //out register
    new wire(clock.outputPin, outReg.clockPin);
    new wire(signalBank.outputPins[16], outReg.enablePin);

    //halt - clock stuff!
    new wire(signalBank.outputPins[17], clock.enablePin);

    //memory register
    new wire(clock.outputPin, memoryReg.clockPin);
    new wire(signalBank.outputPins[18], memoryReg.enablePin);

    //jump and flags circuits

    let flagsRegister = new nRegister(4, "flags_register");

    new wire(clock.outputPin, flagsRegister.clockPin);
    new wire(signalBank.outputPins[22], flagsRegister.enablePin);


    //comparators for a and b.
    let comparatorComp = new nbitComparator(16, "A_B_Comparator");

    aReg.outputPins.forEach((x, i) => { new wire(x, comparatorComp.dataPinsA[i]) })
    bReg.outputPins.forEach((x, i) => { new wire(x, comparatorComp.dataPinsB[i]) })


    let invertON = new VoltageRail("invertON");
    invertON.outputPin.value = true;

    let invert1 = new inverter("invertAEQUALB");
    let invert2 = new inverter("invertALESSB");
    new wire(invertON.outputPin, invert1.outputEnablePin);
    new wire(invertON.outputPin, invert2.outputEnablePin);


    let AGTB = new ANDGATE("AGREATERB");


    //wire comparator outputs to inverters
    new wire(comparatorComp.AEBOUT, invert1.dataPin);
    new wire(comparatorComp.ALBOUT, invert2.dataPin);

    //AND the inverted signals to calculate our A > B signal
    new wire(invert1.outputPin, AGTB.dataPin1);
    new wire(invert2.outputPin, AGTB.dataPin2);

    //hookup signals to the flags register itself.

    new wire(AGTB.outputPin, flagsRegister.dataPins[0]);
    new wire(comparatorComp.AEBOUT, flagsRegister.dataPins[1]);
    new wire(comparatorComp.ALBOUT, flagsRegister.dataPins[2]);

    //jump signal calculation//
    let JL = signalBank.outputPins[19];
    let JE = signalBank.outputPins[20];
    let JG = signalBank.outputPins[21];

    //to actually calculate the jump we use the incoming microcode signals
    //and the flags register outputs - if any set are true we jump.

    let ANDAGB = new ANDGATE("ANDAGB");
    let ANDALB = new ANDGATE("ANDALESSB");
    let ANDEB = new ANDGATE("ANDAEQUALB");


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

    let loadInverter = new inverter("loadInverter");
    new wire(invertON.outputPin, loadInverter.outputEnablePin);
    new wire(OR2.outputPin, loadInverter.dataPin);
    //finally wire up the load pin...
    new wire(loadInverter.outputPin, programCounter.loadPin);

    new wire(signalBank.outputPins[18], memoryReg.enablePin);



    return [signalBank, invertSignal,
        ramInInverter,
        ramOutInverter,
        programCounterCountInverter, outputOn, invertON, comparatorComp, invert1, invert2, loadInverter,
        flagsRegister, ANDAGB, ANDALB, ANDEB, OR1, OR2, AGTB,
        comEnableOn, comControlReg, comStatusReg, comStatusRegBuffer, comDataReg, comDataRegBuffer, spi]
}

export function generate8bitComputerDesign(): Ipart[] {

    var parts1 = generate3Registers_Adder_Bus();
    var bus = _.last(parts1) as bus;
    var clockcomp = new clockWithMode(50, "mainClock");
    let modeButton = new toggleButton("clockMode");
    let stepButton = new toggleButton("stepButton");

    new wire(modeButton.outputPin, clockcomp.modePin);
    new wire(stepButton.outputPin, clockcomp.stepPin);

    var parts2 = generate_MAR_RAM_DATAINPUTS(bus, clockcomp);
    var parts3 = generateProgramCounter(clockcomp, bus);
    var parts4 = generateMicroCodeCounter_EEPROMS_INSTRUCTIONREG(clockcomp, bus);


    var parts5 = [new grapher(1, "clock_data_view_test")];
    new wire(clockcomp.outputPin, parts5[0].dataPins[0]);

    var parts6 = generateMicrocodeSignalBank(
        clockcomp, parts4[0] as staticRam, parts3[0] as binaryCounter, parts3[1] as nBuffer, parts2[1] as staticRam, parts2[2] as nBuffer,
        parts4[4] as nRegister, parts1[0] as nRegister, parts1[2] as nBuffer, parts1[1] as nRegister, parts1[3] as nBuffer
        , parts1[6] as nRegister, parts2[0] as nRegister, parts1[4] as nBuffer, bus)


    var output = parts1.concat(parts2, parts3, parts4, parts5, parts6);
    output.unshift(clockcomp, modeButton, stepButton);
    return _.unique(output);
}