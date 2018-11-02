import { graph } from "./engine";
import { nRegister, nBuffer, inverter, ANDGATE, ORGATE, bus, Ipart } from "./primitives";
import { inputPin } from "./pins_wires";
import { VoltageRail } from "./main";
import { nbitAdder } from "./ALU";
import { binaryCounter } from "./counter";
import { nbitComparator } from "./comparator";
import { twoLineToFourLineDecoder } from "./Decoder";
import { staticRam, dualPortStaticRam } from "./sram";
import { clockWithMode } from "./clock";
import { vgaSignalGenerator } from "./vgaSignalGenerator";
import { SPIComPart } from "./SPIpart";


/**
 * a class responsible for walking a graph and generating a verilog
 * representation of a digital circuit.
 */
export class verilogGenerator {
    private graph: graph;
    private wireMap: any = {};


    constructor(graph: graph) {
        this.graph = graph;
    }

    public generateBinaryMemoryFiles(): Array<string> {
        let rams = this.graph.nodes.filter(x => x.pointer instanceof staticRam)

        let strings = rams.map(x => {
            return (x.pointer as staticRam).data.map(data => {
                return data.map(bool => bool as any * 1).join("");
            }).join("\n");
        })
        return strings;
    }

    //TODO make a command line assembler tool.
    public generateHexArrayForArduinoFlashProgram(ram: staticRam, sliceSize: number): string {

        let data = ram.data.slice(0, sliceSize);
        let string = data.map(data => {
            return "0x" + (parseInt(data.map(bool => bool as any * 1).join(""), 2).toString(16).padStart(4, "0"));
        }).join(",\n ");
        return string;
    }

    public generateVerilog() {

        let sortedNodes = this.graph.topoSort();
        //iterate each node and instantiate parts.
        let verilog = sortedNodes.map(node => {
            //foreach node - use the constructor name to generate some verilog
            //usually this will be the instantiation of the appropriate verilog module
            // and the wiring up of upstream parts..... we may want to do this in two phases.
            let nodeType = (node.pointer.constructor as any).name;
            console.log(nodeType);
            let constructor = this.partToModule[nodeType];
            if (constructor) {
                return constructor(node.pointer);
            }
            return "";

        });

        //get all the lines which start with wire and end with ;
        //place them all at the start
        //and replace the existing ones with ""

        let wires = verilog.map(x => {
            const matches = (x as string).match(/^wire.*;$/mg);
            if (matches) {
                return matches.join("\n");
            }
            return matches;
        }).join("\n");

        //replace wires with the ""
        verilog = verilog.map(x => (x as string).replace(/^wire.*;$/mg, ""));
        //TODO replace references to [null] with [0]...?
        // verilog = verilog.map(x => (x as string).replace(/(\[null\])+/mg, "[0]"));
        // wires = wires.replace(/(\[null\])+/mg, "[0]");

        console.log("match WIRE statements", wires);

        //insert the wires string into the verilog array as the first entry.
        verilog.unshift(wires);

        let customModules = Object.keys(this.moduleMap).map(x => this.moduleMap[x]).join("\n");

        return this.generateTopModule(verilog.join("\n\n"), customModules, sortedNodes.map(x => x.pointer));

    }

    private generateTopModule(implementation: string, modules: string, parts: Ipart[]): string {

        //TODO this doesn't help me much - I want the output wires not the parts themselves...
        //maybe I can use the wire map.
        this.wireMap[]
        let microcodeSignals = parts.find(x => x.displayName == "microCode_SIGNAL_bank");
        let outreg = parts.find(x => x.displayName == "OUT_register");
        let spipart = parts.find(x => x.displayName == "spi_test");
        let comDataReg = parts.find(x => x.displayName == "comDataReg");

        return `
        ${modules}
        (* DONT_TOUCH = "yes" *)
        module top(   
                input CLK,
                input SERIALIN,
                
                output wire ENABLEOUT,
                output wire CLOCKOUT,
                output reg RGB3_Red,
                output reg [0:3] LED,
                output wire VGA_HS_O,       // horizontal sync output
                output wire VGA_VS_O,       // vertical sync output
                output wire [3:0] VGA_R,    // 4-bit VGA red output
                output wire [3:0] VGA_G,    // 4-bit VGA green output
                output wire [3:0] VGA_B,     // 4-bit VGA blue output);
                output reg  [0:7] OUT_AREG) ; //debugging
                   
                reg HIGH = 1;
                reg LOW = 0;
                reg SUBMODE = 0;
                reg UNCONNECTED = 0;
    
                reg [0:0]clock;
                reg [0:0]ClockFaster;
                reg pix_stb;

        
        
        ${implementation}

        reg [32:0] counter = 32'b0;
            always @ (posedge CLK) 
            begin
            
                LED = ${outreg.displayName}${outreg.id};
                RGB3_Red   = ${spipart.displayName}${spipart.id}[15];
                OUT_AREG = ${comDataReg.displayName}${comDataReg.id}[8:15];

                counter <= counter + 1;
                if(${microcodeSignals.displayName}${microcodeSignals.id}[17] == 0) begin
                clock[0] <= counter[9];
                end
               
                ClockFaster[0] <= counter[5];
               
            end

        endmodule
        `;
    }


    private partToModule = {

        clockWithMode: (part: clockWithMode) => {
            this.wireMap[part.outputPin.id] = "clock";
            return "";
        },

        //each of of these functions should take a part, generate input names, and output names for each port
        //and generate a wire for any outputs using the same form for generating names
        //part displayName + portID - taking the first port id if its for a vectorized port - like a multi bit data input.
        nRegister: (part: nRegister) => {

            //TODO - experiment - lets generate an assumped input name based on the pin id and part displayname (could use id too) of the node we're plugged into.
            //so this should evaluate to be the bus's first output pin + part name- and then we'll have the bus generate a wire with the same name...
            // for its output.

            const n = part.dataPins.length;
            let dataInputName = `allInputsFor${part.id}_${part.displayName}`;

            //this will generate a wire concatenation of all the input wires at the required indices. {wire1[0], wire2[0]} for example... if a part's inputs come from 2 different parts/wires.
            let concatenatedDatas = `wire [0:${n}-1] ` + dataInputName + '= {' + part.dataPins.map(x => {
                if (x.attachedWire == null) {
                    return "UNCONNECTED";
                }
                return this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`
            }).join(",") + '};';

            let enableInputName = this.wireMap[part.enablePin.attachedWire.startPin.id] + `[${part.enablePin.attachedWire.startPin.index}]`
            let clockInputName = this.wireMap[part.clockPin.attachedWire.startPin.id] + `[${part.clockPin.attachedWire.startPin.index}]`
            let outputName = part.displayName + part.outputPins[0].id;

            let func = this.moduleConstructorMap.nRegister;

            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, clockInputName, enableInputName, outputName, n, part.displayName + part.id);

            //store the wire that output pins belong to in the wire map using the output pin ids.
            part.outputPins.forEach(x => this.wireMap[x.id] = outputName);

            return [outputWireString, concatenatedDatas, moduleInstanceString].join("\n");

        },

        VoltageRail: (part: VoltageRail) => {

            let outputName = part.displayName + part.outputPin.id;
            //these point to values which the top module constructs.
            let dataInputName = part.outputPin.value == true ? "HIGH" : "LOW";

            let n = 1;
            let func = this.moduleConstructorMap.VoltageRail;
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, outputName, part.displayName + part.id);

            this.wireMap[part.outputPin.id] = outputName;

            return [outputWireString, moduleInstanceString].join("\n");

        },
        nBuffer: (part: nBuffer) => {

            const n = part.dataPins.length;
            let dataInputName = `allInputsFor${part.id}_${part.displayName}`;

            let concatenatedDatas = `wire [0:${n}-1] ` + dataInputName + '= {' + part.dataPins.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';

            let enableInputName = this.wireMap[part.outputEnablePin.attachedWire.startPin.id] + `[${part.outputEnablePin.attachedWire.startPin.index}]`
            let outputName = part.displayName + part.outputPins[0].id;

            let func = this.moduleConstructorMap.nBuffer;
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, outputName, enableInputName, n, part.displayName + part.id);

            part.outputPins.forEach(x => this.wireMap[x.id] = outputName);

            return [outputWireString, concatenatedDatas, moduleInstanceString].join("\n");

        },
        inverter: (part: inverter) => {

            let dataInputName = this.wireMap[part.dataPin.attachedWire.startPin.id] + `[${part.dataPin.attachedWire.startPin.index}]`
            let enableInputName = this.wireMap[part.outputEnablePin.attachedWire.startPin.id] + `[${part.outputEnablePin.attachedWire.startPin.index}]`
            let outputName = part.displayName + part.outputPin.id;

            let n = 1;
            let func = this.moduleConstructorMap.inverter;
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, outputName, enableInputName, part.displayName + part.id);

            this.wireMap[part.outputPin.id] = outputName;


            return [outputWireString, moduleInstanceString].join("\n");

        },
        ANDGATE: (part: ANDGATE) => {

            let dataInputName = this.wireMap[part.dataPin1.attachedWire.startPin.id] + `[${part.dataPin1.attachedWire.startPin.index}]`
            let dataInput2Name = this.wireMap[part.dataPin2.attachedWire.startPin.id] + `[${part.dataPin2.attachedWire.startPin.index}]`
            let outputName = part.displayName + part.outputPin.id;

            let n = 1;
            let func = this.moduleConstructorMap.ANDGATE;
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, dataInput2Name, outputName, part.displayName + part.id);

            this.wireMap[part.outputPin.id] = outputName;


            return [outputWireString, moduleInstanceString].join("\n");

        },
        ORGATE: (part: ORGATE) => {

            let dataInputName = this.wireMap[part.dataPin1.attachedWire.startPin.id] + `[${part.dataPin1.attachedWire.startPin.index}]`
            let dataInput2Name = this.wireMap[part.dataPin2.attachedWire.startPin.id] + `[${part.dataPin2.attachedWire.startPin.index}]`
            let outputName = part.displayName + part.outputPin.id;

            let n = 1;
            let func = this.moduleConstructorMap.ORGATE;
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, dataInput2Name, outputName, part.displayName + part.id);

            this.wireMap[part.outputPin.id] = outputName;


            return [outputWireString, moduleInstanceString].join("\n");

        },

        bus: (part: bus) => {

            //TODO this should probably use two nested maps to be a concat of each wire and each pin index... so we can build a really complex bus...
            //though it should be safe for now because all inputs come from buffers wire homogenous wires.

            //get all the dataInputs... this will be the concatenation of all the data input parts output wires...
            let dataInputName = `allInputsFor${part.id}_${part.displayName}`;

            let n = part.outputPins.length;
            let m = part.inputGroups.length;

            let concatenatedDatas = `wire [0:${n * m}-1] ` + dataInputName + '= {' + part.inputGroups.map(x => x[0].attachedWire.startPin.owner.displayName + x[0].attachedWire.startPin.id).join(",") + '};';
            let outputName = part.displayName + part.outputPins[0].id;
            //for the select signals we need to generate a concatenation of all the outputEnable signals from the inputs.
            //similar to what we did for the inputs themselves
            let selectInputName = `allSelectsFor${part.id}_${part.displayName}`;

            // TODO this is crazy.
            // this feeds the input attached to the outputenable of the buffer attached each input group into the wiremap, gets the wire, and then gets the index in that wire....
            // this mostly gets outputs from the microcode signal bank at the right index... the wires should be the same... mostly.

            let concatenatedSelects = `wire [0:${m}-1] ` + selectInputName + '= {' + part.inputGroups.map(x => (this.wireMap[(((x[0].attachedWire.startPin.owner as nBuffer).outputEnablePin as inputPin).attachedWire.startPin.id)] + `[${((x[0].attachedWire.startPin.owner as nBuffer).outputEnablePin as inputPin).attachedWire.startPin.index}]`)).join(",") + '};';


            let func = this.moduleConstructorMap.bus;
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(selectInputName, dataInputName, outputName, m, n, part.displayName + part.id);

            part.outputPins.forEach(x => this.wireMap[x.id] = outputName);


            return [outputWireString, concatenatedDatas, concatenatedSelects, moduleInstanceString].join("\n");

        },

        nbitAdder: (part: nbitAdder) => {

            let aInputName = `allADataInputsFor${part.id}_${part.displayName}`;
            let bInputName = `allBDataInputsFor${part.id}_${part.displayName}`;

            let n = part.dataPinsA.length;

            let concatenatedADatas = `wire [0:${n}-1] ` + aInputName + '= {' + part.dataPinsA.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';
            let concatenatedBDatas = `wire [0:${n}-1] ` + bInputName + '= {' + part.dataPinsB.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';

            //TODO eventually use the 4 signals for adder mode - for now it's just 0.
            //defined in top module.
            let subModeInputName = "SUBMODE";

            //I think this is left unconnected for now
            let carryInInputName = "UNCONNECTED";
            let carryOutputName = part.displayName + part.carryOut.id;
            let carryOutWire = "wire " + carryOutputName + ";";

            let outputName = part.displayName + part.sumOutPins[0].id;

            let func = this.moduleConstructorMap.nbitAdder;


            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(subModeInputName, carryInInputName, aInputName, bInputName, outputName, carryOutputName, n, part.displayName + part.id);

            part.sumOutPins.forEach(x => this.wireMap[x.id] = outputName);
            this.wireMap[part.carryOut.id] = carryOutputName;

            return [outputWireString, carryOutWire, concatenatedADatas, concatenatedBDatas, moduleInstanceString].join("\n");

        },

        SPIComPart: (part: SPIComPart) => {
            let controlRegInputName = `AllControlInputsFor${part.id}_${part.displayName}`;
            let clockInputName = this.wireMap[part.clockPin.attachedWire.startPin.id] + `[${part.clockPin.attachedWire.startPin.index}]`


            let n = part.dataoutputPins.length;

            let concatenatedRegInputs = `wire [0:${n}-1] ` + controlRegInputName + '= {' + part.controlPins.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';

            let outputDataName = part.displayName + part.dataoutputPins[0].id;
            let outputStatusName = part.displayName + part.statusPins[0].id;


            let func = this.moduleConstructorMap.SPIComPart;


            let outputWire1String = `wire [0:${n}-1] ${outputDataName};`
            let outputWire2String = `wire [0:${n}-1] ${outputStatusName};`

            // control inputs, data out, status out, n, name)
            let moduleInstanceString = func(clockInputName,
                controlRegInputName,
                outputDataName,
                outputStatusName,
                "CLOCKOUT", "SERIALIN", "ENABLEOUT",
                n, part.displayName + part.id);

            part.dataoutputPins.forEach(x => this.wireMap[x.id] = outputDataName);
            part.statusPins.forEach(x => this.wireMap[x.id] = outputStatusName);

            return [outputWire1String, outputWire2String, concatenatedRegInputs, moduleInstanceString].join("\n");

        },

        binaryCounter: (part: binaryCounter) => {

            let dataInputName = "UNCONNECTED";
            if (part.dataPins[0].attachedWire) {
                dataInputName = part.dataPins[0].attachedWire.startPin.owner.displayName + part.dataPins[0].attachedWire.startPin.id;
            }

            let enableInput1Name = this.wireMap[part.outputEnablePin1.attachedWire.startPin.id] + `[${part.outputEnablePin1.attachedWire.startPin.index}]`
            let enableInput2Name = this.wireMap[part.outputEnablePin2.attachedWire.startPin.id] + `[${part.outputEnablePin2.attachedWire.startPin.index}]`
            let clockInputName = this.wireMap[part.clockPin.attachedWire.startPin.id] + `[${part.clockPin.attachedWire.startPin.index}]`
            let clearInputName = this.wireMap[part.clearPin.attachedWire.startPin.id] + `[${part.clearPin.attachedWire.startPin.index}]`
            let loadInputName = this.wireMap[part.loadPin.attachedWire.startPin.id] + `[${part.loadPin.attachedWire.startPin.index}]`


            let outputName = part.displayName + part.outputPins[0].id;

            let n = part.dataPins.length;
            let func = this.moduleConstructorMap.binaryCounter;
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName,
                clearInputName,
                loadInputName,
                clockInputName,
                enableInput1Name,
                enableInput2Name,
                outputName,
                n,
                part.displayName + part.id);

            part.outputPins.forEach(x => this.wireMap[x.id] = outputName);

            return [outputWireString, moduleInstanceString].join("\n");

        },

        nbitComparator: (part: nbitComparator) => {

            let aInputName = `allADataInputsFor${part.id}_${part.displayName}`;
            let bInputName = `allBDataInputsFor${part.id}_${part.displayName}`;

            let n = part.dataPinsA.length;

            let concatenatedADatas = `wire [0:${n}-1] ` + aInputName + '= {' + part.dataPinsA.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';
            let concatenatedBDatas = `wire [0:${n}-1] ` + bInputName + '= {' + part.dataPinsB.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';

            let equalOutputName = part.displayName + part.AEBOUT.id;
            let lowerOutputName = part.displayName + part.ALBOUT.id;

            let func = this.moduleConstructorMap.nbitComparator;


            let equalOutputWireString = `wire [0:0] ${equalOutputName};`
            let lowerOutputWireString = `wire [0:0] ${lowerOutputName};`

            let moduleInstanceString = func(aInputName, bInputName, equalOutputName, lowerOutputName, n, part.displayName + part.id);

            this.wireMap[part.AEBOUT.id] = equalOutputName;
            this.wireMap[part.ALBOUT.id] = lowerOutputName;

            return [equalOutputWireString, concatenatedADatas, concatenatedBDatas, lowerOutputWireString, moduleInstanceString].join("\n");

        },

        twoLineToFourLineDecoder: (part: twoLineToFourLineDecoder) => {

            let aInputName = this.wireMap[part.dataPins[0].attachedWire.startPin.id] + `[${part.dataPins[0].attachedWire.startPin.index}]`
            let bInputName = this.wireMap[part.dataPins[1].attachedWire.startPin.id] + `[${part.dataPins[1].attachedWire.startPin.index}]`
            let enableInputName = this.wireMap[part.outputEnablePin.attachedWire.startPin.id] + `[${part.outputEnablePin.attachedWire.startPin.index}]`

            let yoOutputname = part.displayName + part.outputPins[0].id;
            let y1Outputname = part.displayName + part.outputPins[1].id;
            let y2Outputname = part.displayName + part.outputPins[2].id;
            let y3Outputname = part.displayName + part.outputPins[3].id;

            let yoOutputWire = "wire " + yoOutputname + ";";
            let y1OutputWire = "wire " + y1Outputname + ";";
            let y2OutputWire = "wire " + y2Outputname + ";";
            let y3OutputWire = "wire " + y3Outputname + ";";

            let func = this.moduleConstructorMap.twoLineToFourLineDecoder;


            let moduleInstanceString = func(aInputName,
                bInputName,
                enableInputName,
                yoOutputname,
                y1Outputname,
                y2Outputname,
                y3Outputname,
                part.displayName + part.id);

            this.wireMap[part.outputPins[0].id] = yoOutputname;
            this.wireMap[part.outputPins[1].id] = y1Outputname;
            this.wireMap[part.outputPins[2].id] = y2Outputname;
            this.wireMap[part.outputPins[3].id] = y3Outputname;

            return [yoOutputWire, y1OutputWire, y2OutputWire, y3OutputWire, moduleInstanceString].join("\n");

        },

        staticRam: (part: staticRam) => {

            //TODO a test. see if we can replace this in top module.
            let clockInputName = "ClockFaster[0]"


            let csInputName = this.wireMap[part.chipEnable.attachedWire.startPin.id] + `[${part.chipEnable.attachedWire.startPin.index}]`
            let weInputName = this.wireMap[part.writeEnable.attachedWire.startPin.id] + `[${part.writeEnable.attachedWire.startPin.index}]`
            let oeInputName = this.wireMap[part.outputEnable.attachedWire.startPin.id] + `[${part.outputEnable.attachedWire.startPin.index}]`

            let addressInputName = `allAddressInputsFor${part.id}_${part.displayName}`;
            let dataInputName = `allDataInputsFor${part.id}_${part.displayName}`;

            let n = part.wordSize;
            let concatenatedAddressPins = `wire [0:${part.addressPins.length}-1] ` + addressInputName + '= {' + part.addressPins.map(x => {
                if (x.attachedWire == null) {
                    return "UNCONNECTED";
                }
                return this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`
            }).join(",") + '};';

            let concatenatedDataPins = `wire [0:${n}-1] ` + dataInputName + '= {' + part.InputOutputPins.map(x => {
                if (x.internalInput.attachedWire == null) {
                    return "UNCONNECTED";
                }
                return this.wireMap[x.internalInput.attachedWire.startPin.id] + `[${x.internalInput.attachedWire.startPin.index}]`
            }).join(",") + '};';

            //this should be this part.
            let outputName = part.InputOutputPins[0].internalOutput.owner.displayName + part.InputOutputPins[0].internalOutput.id;


            let initalDataName = 'initialDataFor' + part.id;
            let totalBitLength = n * part.data.length;
            let dataString = part.data.map(data => {
                return data.map(bool => bool as any * 1).join("");
            }).join("");

            let intialDataRegString = `reg [0:${(totalBitLength - 1)}] ${initalDataName} = ${totalBitLength}'b${dataString}; `

            let func = this.moduleConstructorMap.staticRam;


            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(addressInputName,
                dataInputName,
                csInputName,
                weInputName,
                oeInputName,
                clockInputName,
                outputName,
                "ROMFILE",
                n,
                part.addressPins.length,
                part.displayName + part.id);

            part.InputOutputPins.forEach(x => this.wireMap[x.internalOutput.id] = outputName);


            return [outputWireString, concatenatedAddressPins, concatenatedDataPins, moduleInstanceString].join("\n");
        },

        dualPortStaticRam: (part: dualPortStaticRam) => {

            //TODO a test. see if we can replace this in top module.
            let clockInputName = "ClockFaster[0]";
            let clockInputName2 = "ClockFaster[0]";

            let csInputName = this.wireMap[part.chipEnable.attachedWire.startPin.id] + `[${part.chipEnable.attachedWire.startPin.index}]`
            let weInputName = this.wireMap[part.writeEnable.attachedWire.startPin.id] + `[${part.writeEnable.attachedWire.startPin.index}]`
            let oeInputName = this.wireMap[part.outputEnable.attachedWire.startPin.id] + `[${part.outputEnable.attachedWire.startPin.index}]`


            let addressInputName1 = `allAddress1InputsFor${part.id}_${part.displayName}`;
            let addressInputName2 = `allAddress2InputsFor${part.id}_${part.displayName}`;
            let dataInputName = `allDataInputsFor${part.id}_${part.displayName}`;

            let n = part.wordSize;
            let concatenatedAddress1Pins = `wire [0:${part.addressPins.length}-1] ` + addressInputName1 + '= {' + part.addressPins.map(x => {
                if (x.attachedWire == null) {
                    return "UNCONNECTED";
                }
                return this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`
            }).join(",") + '};';

            let concatenatedAddress2Pins = `wire [0:${part.addressPins2.length}-1] ` + addressInputName2 + '= {' + part.addressPins2.map(x => {
                if (x.attachedWire == null) {
                    return "UNCONNECTED";
                }
                return this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`
            }).join(",") + '};';

            let concatenatedDataPins = `wire [0:${n}-1] ` + dataInputName + '= {' + part.InputOutputPins.map(x => {
                if (x.internalInput.attachedWire == null) {
                    return "UNCONNECTED";
                }
                return this.wireMap[x.internalInput.attachedWire.startPin.id] + `[${x.internalInput.attachedWire.startPin.index}]`
            }).join(",") + '};';

            //this should be this part.
            let outputName1 = part.InputOutputPins[0].internalOutput.owner.displayName + part.InputOutputPins[0].internalOutput.id;
            let outputName2 = part.readonlyOutputPins[0].owner.displayName + part.readonlyOutputPins[0].id;


            let initalDataName = 'initialDataFor' + part.id;
            let totalBitLength = n * part.data.length;
            let dataString = part.data.map(data => {
                return data.map(bool => bool as any * 1).join("");
            }).join("");

            let intialDataRegString = `reg [0:${(totalBitLength - 1)}] ${initalDataName} = ${totalBitLength}'b${dataString}; `

            let func = this.moduleConstructorMap.dualPortStaticRam;


            let outputWireString1 = `wire [0:${n}-1] ${outputName1};`
            let outputWireString2 = `wire [0:${n}-1] ${outputName2};`
            let moduleInstanceString = func(addressInputName1, addressInputName2,
                dataInputName,
                csInputName,
                weInputName,
                oeInputName,
                //TODO attach to faster clock automatically somehow..
                //or add some post generation steps to solve this type of
                //inconsistency between the simulation of the circuit here and in verilog...
                //ie - this ram requires a different clock on the FPGA.
                clockInputName,
                clockInputName,
                outputName1, outputName2,
                "RAMFILE",
                n,
                part.addressPins.length,
                part.displayName + part.id);

            //update wiremap?
            part.InputOutputPins.forEach(x => this.wireMap[x.internalOutput.id] = outputName1);
            part.readonlyOutputPins.forEach(x => this.wireMap[x.id] = outputName2);


            return [outputWireString1, outputWireString2,

                concatenatedAddress1Pins, concatenatedAddress2Pins,
                concatenatedDataPins,
                moduleInstanceString].join("\n");
        },

        vgaSignalGenerator: (part: vgaSignalGenerator) => {

            //decide which rom file path to inject?

            let clockInputName = this.wireMap[part.clockPin.attachedWire.startPin.id] + `[${part.clockPin.attachedWire.startPin.index}]`
            let pixClockInputName = "25MHZCLOCK";

            let xlen = part.Xposition.length;
            let ylen = part.YPosition.length;

            let outputNameX = part.displayName + part.Xposition[0].id;
            let outputNameY = part.displayName + part.YPosition[0].id;
            let outputNameH = part.displayName + part.h_sync.id;
            let outputNameV = part.displayName + part.v_sync.id;

            let func = this.moduleConstructorMap.vgaSignalGenerator;


            let outputWireStringX = `wire [0:${xlen}-1] ${outputNameX};`
            let outputWireStringY = `wire [0:${ylen}-1] ${outputNameY};`

            let hOutputWire = "wire " + outputNameH + ";";
            let vOutputWire = "wire " + outputNameV + ";";

            let moduleInstanceString = func(clockInputName,
                pixClockInputName,
                outputNameH,
                outputNameV,
                outputNameX,
                outputNameY,
                part.displayName + part.id);



            //put all output names in wiremap.
            part.Xposition.forEach(x => this.wireMap[x.id] = outputNameX);
            part.YPosition.forEach(x => this.wireMap[x.id] = outputNameY);

            this.wireMap[part.h_sync.id] = outputNameH;
            this.wireMap[part.v_sync.id] = outputNameV;

            return [outputWireStringX, outputWireStringY, hOutputWire, vOutputWire, moduleInstanceString].join("\n");
        },
    }

    //TODO figure out how to get these signatures...
    private moduleConstructorMap = {
        nRegister: (data, clock, enable, Q, DATA_WIDTH, name) => {
            return `nRegister #(.n(${DATA_WIDTH})) ${name} ( 
                .data(${data}), 
                .clock(${clock}), 
                .enable(${enable}),
                 .Q(${Q}) );`
        },

        VoltageRail: (data, Q, name) => {
            return `voltageRail ${name} ( 
                .data(${data}), 
                .Q(${Q}) );`
        },

        nBuffer: (data, Q, outputEnable, DATA_WIDTH, name) => {
            return `nBuffer  #(.n(${DATA_WIDTH})) ${name} (
                  .data(${data}),
                  .Q(${Q}), 
                  .outputEnable(${outputEnable}) );`
        },

        inverter: (data, Q, outputEnable, name) => {
            return `inverter ${name} ( 
                .data(${data}), 
                .Q(${Q}), 
                .outputEnable(${outputEnable}) );`
        },

        ANDGATE: (a, b, c, name) => {
            return `ANDGATE ${name} ( 
                ${a}, 
                ${b}, 
                ${c} );`
        },

        ORGATE: (a, b, c, name) => {
            return `ORGATE ${name} ( 
                ${a}, 
                ${b},
                ${c});`
        },

        bus: (selects, data_in, data_out, BUSCOUNT, DATA_WIDTH, name) => {
            return `bus_mux #(.bus_count(${BUSCOUNT}),.mux_width(${DATA_WIDTH})) ${name} (
                .selects(${selects}),
                .data_in(${data_in}),
                .data_out(${data_out}));`
        },

        nbitAdder: (sub, cin, x, y, sum, cout, DATA_WIDTH, name) => {
            return `nbitAdder #(.n(${DATA_WIDTH})) ${name} (
                 .sub(${sub}),
                .cin(${cin}),
                .x(${x}),
                .y(${y}),
                .sum(${sum}),
                .cout(${cout}));`
        },

        //module binaryCounter(D,clr_,load_,clock,enable1_,enable2_,Q);
        binaryCounter: (D, clr_, load_, clock, enable1_, enable2_, Q, DATA_WIDTH, name) => {
            return `binaryCounter #(.n(${DATA_WIDTH})) ${name} (
                .D(${D}),
                .clr_(${clr_}),
                .load_(${load_}),
                .clock(${clock}),
                .enable1_(${enable1_}),
                .enable2_(${enable2_}),
                .Q(${Q}));`
        },

        nbitComparator: (a, b, equal, lower, DATA_WIDTH, name) => {
            return `nbitComparator #(.n(${DATA_WIDTH})) ${name} (
                .a(${a}),
                .b(${b}),
                .equal(${equal}),
                .lower(${lower}));`
        },

        twoLineToFourLineDecoder: (a, b, en_, y0, y1, y2, y3, name) => {
            return `twoLineToFourLineDecoder ${name} (
                 ${a},
                  ${b},
                   ${en_},
                    ${y0},
                    ${y1},
                    ${y2},
                    ${y3});`
        },
        /*
         module staticRamDiscretePorts (
            address     , // Address Input
            data        , // Data input
            cs_,
            we_,
            oe_,
            clock,
            Q               //output
            );
            parameter ROMFILE = "noFile";
            parameter DATA_WIDTH = 8 ;
            parameter ADDR_WIDTH = 8 ;
            parameter RAM_DEPTH = 1 << ADDR_WIDTH; 
        */
        staticRam: (address, data, cs_, we_, oe_, clock, Q, ROMFILE, DATA_WIDTH, ADDR_WIDTH, name) => {
            return `staticRamDiscretePorts #(.ROMFILE(${ROMFILE}),.DATA_WIDTH(${DATA_WIDTH}),.ADDR_WIDTH(${ADDR_WIDTH})) ${name} (
                 .address(${address}),
                  .data(${data}), 
                  .cs_(${cs_}),
                   .we_(${we_}),
                   .oe_(${oe_}),
                    .clock(${clock}),
                   .Q(${Q}));`
        },
        //TODO add clock inputs??
        dualPortStaticRam: (address, address2, data, cs_, we_, oe_, clock, clock2, Q, Q2, ROMFILE, DATA_WIDTH, ADDR_WIDTH, name) => {
            return `dualPortStaticRam #(.ROMFILE(${ROMFILE}),.DATA_WIDTH(${DATA_WIDTH}),.ADDR_WIDTH(${ADDR_WIDTH})) ${name} (
                .address_1(${address}),
                .address_2(${address2}),
                 .data(${data}), 
                 .cs_(${cs_}),
                  .we_(${we_}),
                  .oe_(${oe_}),
                  .clock(${clock}),
                  .clock2(${clock2}),
                  .Q_1(${Q}),
                  .Q_2(${Q2}));`
        },
        //TODO turn all these statements into more explicit construction calls with named parameters.
        vgaSignalGenerator: (clk, pixClock, horizontalSync, verticalSync, xpos, ypos, name) => {
            return `vgaSignalGenerator ${name} (
                .i_clk(${clk}),
                .i_pix_stb(${pixClock}),
                .o_hs(${horizontalSync}),
                .o_vs(${verticalSync}),
                .o_x(${xpos}),
                .o_y(${ypos})
            );`
        },
        SPIComPart: (clk, i_controlReg, o_dataReg, o_statusReg, o_clock, i_serial, o_enable, DATA_WIDTH, name) => {
            return `SPIComPart #(.n(${DATA_WIDTH})) ${name} (
                .i_controlReg(${i_controlReg}),
                .o_dataReg(${o_dataReg}),
                .o_statReg(${o_statusReg}),
                .i_serial(${i_serial}),
                .o_enable(${o_enable}),
                .o_clock(${o_clock}),
               .i_clk(${clk}));`
        }

    }

    //standard modules:
    private moduleMap = {
        "nRegister":
            ` (* DONT_TOUCH = "yes" *)
            module nRegister(data,clock,enable,Q);
        parameter n = 8;
        input [0:n-1] data;
        input clock,enable;
        output reg [0:n-1] Q = {n-1{1'b0}};

        always@(posedge clock)
            if(enable)
                Q<=data;
            endmodule
        `,

        //eventually these should be turned into IO pins in the FPGA
        //for now we can make them registers of 1 bit.
        "VoltageRail":
            ` (* DONT_TOUCH = "yes" *)
            module voltageRail(data,Q);
        input wire data;
        output reg Q;
        always@(data)
        Q <= data;
        endmodule
        `,

        "nBuffer":
            ` (* DONT_TOUCH = "yes" *)
            module nBuffer(data,Q,outputEnable);
        parameter n=8;
        input [0:n-1] data;
        input outputEnable;
        output reg [0:n-1] Q;
    
        always@(outputEnable,data)
        if(outputEnable)
            Q <= data;
        else
            Q <= {n{1'b0}};
    endmodule`,

        "inverter":
            ` (* DONT_TOUCH = "yes" *)
            module inverter(data,Q,outputEnable);
    input data,outputEnable;
    output reg Q;
    always@(data,outputEnable)
        if(outputEnable)
            Q <= ~data;
        else
            Q<=1'b0;
    endmodule
    `,

        "ANDGATE":
            ` (* DONT_TOUCH = "yes" *)
            module ANDGATE(a,b,c);
        input a,b;
        output c;
        and a1 (c,a,b);
        endmodule`,

        "ORGATE":
            `module ORGATE(a,b,c);
    input a,b;
    output c;
    or a1 (c,a,b);
        endmodule`,

        //http://computer-programming-forum.com/41-verilog/84ee92879b9101ee.htm
        //this bus is really a mux - and so we must also connect 
        //the select signals for all inputs - the bus component does not wire these up
        //as the select is implicit, but we'll need to wire these up for the verilog version.
        "bus":
            ` (* DONT_TOUCH = "yes" *)
            module bus_mux ( selects, data_in, data_out ); 
        parameter bus_count = 16;                   // number of input buses 
        parameter mux_width = 8;                    // bit width of data buses 
        input  [0:bus_count-1]           selects;   // one-hot select signals 
        input  [0:mux_width*bus_count-1] data_in;   // concatenated input buses 
        output reg [0:mux_width-1]                 data_out;  // output data bus 
        
        integer i=0;
        integer j=0;
        always@(selects,data_in)
        begin
        data_out = 'b0; 
    
                for (i = 0; i < bus_count; i = i + 1) 
                        for (j = 0; j < mux_width; j = j + 1) 
                                data_out[j] = data_out[j] | data_in[mux_width*i +j] &selects[i]; 
        end  // always 
        endmodule
        `,

        "nbitAdder":
            ` (* DONT_TOUCH = "yes" *)
        module nbitAdder(sub,cin,x,y,sum,cout);
        parameter n = 8;
        input sub,cin;
        input [0:n-1] x,y;
        output [0:n-1]sum;
        output cout;
        wire[0:n-1] onesComplement;

        assign onesComplement = {n{sub}}^y +sub;
        assign {cout,sum} = {1'b0,x} + {1'b0,onesComplement} + cin;
        endmodule
        `,

        "binaryCounter":
            ` (* DONT_TOUCH = "yes" *)
            module binaryCounter(D,clr_,load_,clock,enable1_,enable2_,Q);
        parameter n = 8;
        input [0:n-1] D;
        input clr_,clock,enable1_,enable2_,load_;
        output reg [0:n-1] Q = {n-1{1'b0}};

        always@(posedge clock)
        if(!clr_)
        Q <= 0;
        else if (!load_)
        Q <= D;
        else if ((!enable1_) && (!enable2_))
        Q <= Q + 1;
        endmodule
        `,

        "nbitComparator":
            ` (* DONT_TOUCH = "yes" *)
            module nbitComparator (
            input wire [0:n-1] a,
            input wire [0:n-1] b,
            output wire equal,
            output wire lower
          );
          parameter n = 8;
          assign equal = (a===b);
          assign lower = (a<b)?1'b1:1'b0;
          endmodule
          `,

        "twoLineToFourLineDecoder":
            ` (* DONT_TOUCH = "yes" *)
            module twoLineToFourLineDecoder (a,b,en_,y0,y1,y2,y3);
          input a, b, en_;
          output y0,y1,y2,y3;
          assign y0= (~a) & (~b) & (~en_);
          assign y1= (~a) & b & (~en_);
          assign y2= a & (~ b) & (~en_);
          assign y3= a & b & (~en_);
          endmodule
          `,

        "staticRam": `
        (* DONT_TOUCH = "yes" *)
        //-----------------------------------------------------
        module staticRamDiscretePorts (
            address     , // Address Input
            data        , // Data input
            cs_,
            we_,
            oe_,
            clock,
            Q               //output
            );
            parameter ROMFILE = "noFile";
            parameter DATA_WIDTH = 8 ;
            parameter ADDR_WIDTH = 8 ;
            parameter RAM_DEPTH = 1 << ADDR_WIDTH;
            
        
            //--------------Input Ports----------------------- 
            input [0:ADDR_WIDTH-1] address ;
            input [0:DATA_WIDTH-1]  data;
            input cs_;
            input we_;
            input oe_;
            input clock;
        
            //--------------Output Ports----------------------- 
            output reg [0:DATA_WIDTH-1] Q;
            integer i;
            //--------------Internal variables----------------
            reg [0:DATA_WIDTH-1] mem [0:RAM_DEPTH-1];
            
            //--------------Code Starts Here------------------ 
            initial begin
             $readmemb(ROMFILE, mem);
              for (i = 0; i < RAM_DEPTH; i = i + 1) begin
              #1 $display("%d",mem[i]);
              end
            end
            
            always @(posedge clock)
            begin
              if (!cs_ && !we_)
                mem[address] = data;
               Q = (!cs_ && !oe_) ? mem[address] : {DATA_WIDTH{1'bz}};
            end
            
            endmodule
    `,

        "dualPortStaticRam":
            `(* DONT_TOUCH = "yes" *)
    //-----------------------------------------------------
    module dualPortStaticRam (
        address_1     , // Address Input
        address_2     , // Address Input
        data        , // Data input
        cs_,
        we_,
        oe_,
        clock,
        clock2,
        Q_1,               //output
        Q_2               //output
        );
        parameter ROMFILE = "noFile";
        parameter DATA_WIDTH = 8 ;
        parameter ADDR_WIDTH = 8 ;
        parameter RAM_DEPTH = 1 << ADDR_WIDTH;
        
    
        //--------------Input Ports----------------------- 
        input [0:ADDR_WIDTH-1] address_1 ;
        input [0:ADDR_WIDTH-1] address_2 ;
        input [0:DATA_WIDTH-1]  data;
        input cs_;
        input we_;
        input oe_;
        input clock;
        input clock2;
    
        //--------------Output Ports----------------------- 
        output reg [0:DATA_WIDTH-1] Q_1;
        output reg [0:DATA_WIDTH-1] Q_2;
        integer i;
        //--------------Internal variables----------------
        reg [0:DATA_WIDTH-1] mem [0:RAM_DEPTH-1];
        
        //--------------Code Starts Here------------------ 
        initial begin
         $readmemb(ROMFILE, mem);
          for (i = 0; i < RAM_DEPTH; i = i + 1) begin
          #1 $display("%d",mem[i]);
          end
        end
        
        always @(posedge clock)
        begin
          if (!cs_ && !we_)
            mem[address_1] = data;
           Q_1 = (!cs_ && !oe_) ? mem[address_1] : {DATA_WIDTH{1'bz}};
           //Q_2 = mem[address_2];
        end

        always@(posedge clock2) begin
            Q_2 = mem[address_2];
        end
        
        endmodule
    
    `,
        //verilog adapted from:
        //https://timetoexplore.net/blog/arty-fpga-vga-verilog-01

        "vgaSignalGenerator":
            `(* DONT_TOUCH = "yes" *)
    module vgaSignalGenerator(
        input wire i_clk,           // base clock
        input wire i_pix_stb,       // pixel clock strobe
        output wire o_hs,           // horizontal sync
        output wire o_vs,           // vertical sync
        output wire o_blanking,     // high during blanking interval
        output wire o_active,       // high during active pixel drawing
        output wire o_screenend,    // high for one tick at the end of screen
        output wire o_animate,      // high for one tick at end of active drawing
        output wire [9:0] o_x,      // current pixel x position
        output wire [8:0] o_y       // current pixel y position
        );
    
        // VGA timings https://timetoexplore.net/blog/video-timings-vga-720p-1080p
        localparam HS_STA = 16;              // horizontal sync start
        localparam HS_END = 16 + 96;         // horizontal sync end
        localparam HA_STA = 16 + 96 + 48;    // horizontal active pixel start
        localparam VS_STA = 480 + 11;        // vertical sync start
        localparam VS_END = 480 + 11 + 2;    // vertical sync end
        localparam VA_END = 480;             // vertical active pixel end
        localparam LINE   = 800;             // complete line (pixels)
        localparam SCREEN = 524;             // complete screen (lines)
    
        reg [9:0] h_count = 0;  // line position
        reg [9:0] v_count = 0;  // screen position
    
        // generate sync signals (active low for 640x480)
        assign o_hs = ~((h_count >= HS_STA) & (h_count < HS_END));
        assign o_vs = ~((v_count >= VS_STA) & (v_count < VS_END));
    
        // keep x and y bound within the active pixels
        assign o_x = (h_count < HA_STA) ? 0 : (h_count - HA_STA);
        assign o_y = (v_count >= VA_END) ? (VA_END - 1) : (v_count);
    
        // blanking: high within the blanking period
        assign o_blanking = ((h_count < HA_STA) | (v_count > VA_END - 1));
    
        // active: high during active pixel drawing
        assign o_active = ~((h_count < HA_STA) | (v_count > VA_END - 1)); 
    
        // screenend: high for one tick at the end of the screen
        assign o_screenend = ((v_count == SCREEN - 1) & (h_count == LINE));
    
        // animate: high for one tick at the end of the final active pixel line
        assign o_animate = ((v_count == VA_END - 1) & (h_count == LINE));
    
        always @ (posedge i_clk)
        begin
            if (i_pix_stb)  // once per pixel
            begin
                if (h_count == LINE)  // end of line
                begin
                    h_count <= 0;
                    v_count <= v_count + 1;
                end
                else 
                    h_count <= h_count + 1;
    
                if (v_count == SCREEN)  // end of screen
                    begin
                    v_count <= 0;
                    end
            end
        end
    endmodule

    `,
        SPIComPart:
            ` 
            module SPIComPart(
                input wire i_clk,                   // base clock
                input wire [0:n-1] i_controlReg,    // control reg
                input wire  i_serial,               // serialIn
        
                output reg [0:n-1] o_dataReg = 0,       //databits to write to
                output reg [0:n-1] o_statReg = 0,       //status reg to write to
        
                output reg o_enable = 1,                 // start comms on slave
                output reg o_clock = 0           // clock out for clock
                );
        
                parameter n=16;
                
                reg [32:0]clockScaler = 0;
                //output counter
                reg [0:7]internalcounter = 0;
                reg hold = 0;
                reg slow_clock = 0;
                reg  r1_pulse = 0;
                
                //we may want to use two more registers
                //to sync this signal correctly

                //reg r2_pulse = 0;
                //reg r3_pulse = 0; 

                //when the clock goes high and start is high
                //then generate n clock pulses.
                //then drive start low.
                //and shift in data after each pulse.
                
                always @(posedge i_clk)
                begin
                clockScaler <= clockScaler + 1;
                slow_clock <= clockScaler[11];
                end
                
                always@(posedge slow_clock) begin
                
                r1_pulse <= i_controlReg[15];
               
               //start clocking out
                if((i_controlReg[15] && !r1_pulse))begin
                   hold = 1;
                   o_statReg[15] = 0;
                end
               
               //count up to 31 and reset all regs after that.
                        if(internalcounter > 31)
                        begin
                            internalcounter = 0;
                            hold = 0;
                            o_enable = 1;
                            o_statReg[15] = 1;
                            o_clock = 0;
                        end
                        
                          
                          
                        //if we have not yet reset the start flag
                        //then count on the clock - input clock / preScaler / 2 
                        if(hold == 1)begin //begin clock out 16 pulses
                            internalcounter = internalcounter + 1;
                             o_enable = 0;
                             o_clock = internalcounter[7];
                            //shift in LSB data from the serial port into the MSB
                            if(o_clock == 0) begin
                            o_dataReg <= {i_serial,o_dataReg[0:n-2]};
                            end //end shift in
                        end //end clock out
                       
                end // end always
                endmodule
    `

    }

}