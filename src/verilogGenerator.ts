import { graph } from "./engine";
import { nRegister, nBuffer, inverter, ANDGATE, ORGATE, bus, Ipart } from "./primitives";
import { inputPin } from "./pins_wires";
import { VoltageRail } from "./main";
import { nbitAdder } from "./ALU";
import { binaryCounter } from "./counter";
import { nbitComparator } from "./comparator";
import { twoLineToFourLineDecoder } from "./Decoder";
import { staticRam } from "./sram";
import { clockWithMode } from "./clock";


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

        return this.generateTopModule(verilog.join("\n\n"), customModules);

    }

    private generateTopModule(implementation: string, modules: string): string {
        return `
        ${modules}
        module top(input CLK,output reg [0:3] LED);
        reg HIGH = 1;
        reg LOW = 0;
        reg SUBMODE = 0;
        reg UNCONNECTED = 0;
        reg [0:0]clock;
        
        
        ${implementation}
        //lets reduce clock to a 1.5hzish clock:
        reg [0:32] counter = 32'b0;
        
            always @ (posedge CLK) 
            begin
                counter <= counter + 1;
                clock[0] <= counter[25];
                LED = OUTREGISTER;
            end

        endmodule;
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
            let dataInputName = 'allInputsFor' + part.id;

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

            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, clockInputName, enableInputName, outputName, part.displayName + part.id);

            //store the wire that output pins belong to in the wire map using the output pin ids.
            part.outputPins.forEach(x => this.wireMap[x.id] = outputName);

            return [outputWireString, concatenatedDatas, moduleInstanceString].join("\n");

        },

        VoltageRail: (part: VoltageRail) => {

            let outputName = part.displayName + part.outputPin.id;
            //these point to values which the top module constructs.
            let dataInputName = part.outputPin.value == true ? "HIGH" : "LOW";

            let n = 1;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, outputName, part.displayName + part.id);

            this.wireMap[part.outputPin.id] = outputName;

            return [outputWireString, moduleInstanceString].join("\n");

        },
        nBuffer: (part: nBuffer) => {

            const n = part.dataPins.length;
            let dataInputName = 'allInputsFor' + part.id;

            let concatenatedDatas = `wire [0:${n}-1] ` + dataInputName + '= {' + part.dataPins.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';

            let enableInputName = this.wireMap[part.outputEnablePin.attachedWire.startPin.id] + `[${part.outputEnablePin.attachedWire.startPin.index}]`
            let outputName = part.displayName + part.outputPins[0].id;

            let func = this.moduleConstructorMap[part.constructor.name];
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
            let func = this.moduleConstructorMap[part.constructor.name];
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
            let func = this.moduleConstructorMap[part.constructor.name];
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
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName, dataInput2Name, outputName, part.displayName + part.id);

            this.wireMap[part.outputPin.id] = outputName;


            return [outputWireString, moduleInstanceString].join("\n");

        },

        bus: (part: bus) => {

            //TODO this should probably use two nested maps to be a concat of each wire and each pin index... so we can build a really complex bus...
            //though it should be safe for now because all inputs come from buffers wire homogenous wires.

            //get all the dataInputs... this will be the concatenation of all the data input parts output wires...
            let dataInputName = 'allInputsFor' + part.id;

            let n = part.outputPins.length;
            let m = part.inputGroups.length;

            let concatenatedDatas = `wire [0:${n * m}-1] ` + dataInputName + '= {' + part.inputGroups.map(x => x[0].attachedWire.startPin.owner.displayName + x[0].attachedWire.startPin.id).join(",") + '};';
            let outputName = part.displayName + part.outputPins[0].id;
            //for the select signals we need to generate a concatenation of all the outputEnable signals from the inputs.
            //similar to what we did for the inputs themselves
            let selectInputName = 'allSelectsFor' + part.id;
            // TODO this is crazy.
            // this feeds the input attached to the outputenable of the buffer attached each input group into the wiremap, gets the wire, and then gets the index in that wire....
            // this mostly gets outputs from the microcode signal bang at the right index... the wires should be the same... mostly.

            let concatenatedSelects = `wire [0:${m}-1] ` + selectInputName + '= {' + part.inputGroups.map(x => (this.wireMap[(((x[0].attachedWire.startPin.owner as nBuffer).outputEnablePin as inputPin).attachedWire.startPin.id)] + `[${((x[0].attachedWire.startPin.owner as nBuffer).outputEnablePin as inputPin).attachedWire.startPin.index}]`)).join(",") + '};';


            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(selectInputName, dataInputName, outputName, m, n, part.displayName + part.id);

            part.outputPins.forEach(x => this.wireMap[x.id] = outputName);


            return [outputWireString, concatenatedDatas, concatenatedSelects, moduleInstanceString].join("\n");

        },

        nbitAdder: (part: nbitAdder) => {

            let aInputName = 'allADataInputsFor' + part.id;
            let bInputName = 'allBDataInputsFor' + part.id;

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

            let func = this.moduleConstructorMap[part.constructor.name];


            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(subModeInputName, carryInInputName, aInputName, bInputName, outputName, carryOutputName, part.displayName + part.id);

            part.sumOutPins.forEach(x => this.wireMap[x.id] = outputName);
            this.wireMap[part.carryOut.id] = carryOutputName;

            return [outputWireString, carryOutWire, concatenatedADatas, concatenatedBDatas, moduleInstanceString].join("\n");

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
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(dataInputName,
                clearInputName,
                loadInputName,
                clockInputName,
                enableInput1Name,
                enableInput2Name,
                outputName,
                part.displayName + part.id);

            part.outputPins.forEach(x => this.wireMap[x.id] = outputName);

            return [outputWireString, moduleInstanceString].join("\n");

        },

        nbitComparator: (part: nbitComparator) => {

            let aInputName = 'allADataInputsFor' + part.id;
            let bInputName = 'allBDataInputsFor' + part.id;

            let n = part.dataPinsA.length;

            let concatenatedADatas = `wire [0:${n}-1] ` + aInputName + '= {' + part.dataPinsA.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';
            let concatenatedBDatas = `wire [0:${n}-1] ` + bInputName + '= {' + part.dataPinsB.map(x => this.wireMap[x.attachedWire.startPin.id] + `[${x.attachedWire.startPin.index}]`).join(",") + '};';

            let equalOutputName = part.displayName + part.AEBOUT.id;
            let lowerOutputName = part.displayName + part.ALBOUT.id;

            let func = this.moduleConstructorMap[part.constructor.name];


            let equalOutputWireString = `wire [0:0] ${equalOutputName};`
            let lowerOutputWireString = `wire [0:0] ${lowerOutputName};`

            let moduleInstanceString = func(aInputName, bInputName, equalOutputName, lowerOutputName, part.displayName + part.id);

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

            let func = this.moduleConstructorMap[part.constructor.name];


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

            //decide which rom file path to inject?

            let csInputName = this.wireMap[part.chipEnable.attachedWire.startPin.id] + `[${part.chipEnable.attachedWire.startPin.index}]`
            let weInputName = this.wireMap[part.writeEnable.attachedWire.startPin.id] + `[${part.writeEnable.attachedWire.startPin.index}]`
            let oeInputName = this.wireMap[part.outputEnable.attachedWire.startPin.id] + `[${part.outputEnable.attachedWire.startPin.index}]`


            let addressInputName = 'allAddressInputsFor' + part.id;
            let dataInputName = "allDataInputsFor" + part.id;

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

            let func = this.moduleConstructorMap[part.constructor.name];


            let outputWireString = `wire [0:${n}-1] ${outputName};`
            let moduleInstanceString = func(addressInputName,
                dataInputName,
                initalDataName,
                csInputName,
                weInputName,
                oeInputName,
                outputName,
                n,
                part.addressPins.length,
                part.displayName + part.id, );

            part.InputOutputPins.forEach(x => this.wireMap[x.internalOutput.id] = outputName);


            return [outputWireString, intialDataRegString, concatenatedAddressPins, concatenatedDataPins, moduleInstanceString].join("\n");
        }
    }

    //TODO figure out how to get these signatures...
    private moduleConstructorMap = {
        nRegister: (data, clock, enable, Q, name) => {
            return `nRegister ${name} ( ${data}, ${clock}, ${enable}, ${Q} );`
        },

        VoltageRail: (data, Q, name) => {
            return `voltageRail ${name} ( ${data}, ${Q} );`
        },

        nBuffer: (data, Q, outputEnable, DATA_WIDTH, name) => {
            return `nBuffer  #(${DATA_WIDTH}) ${name} ( ${data}, ${Q} , ${outputEnable} );`
        },

        inverter: (data, Q, outputEnable, name) => {
            return `inverter ${name} ( ${data}, ${Q} , ${outputEnable} );`
        },

        ANDGATE: (a, b, c, name) => {
            return `ANDGATE ${name} ( ${a}, ${b} , ${c} );`
        },

        ORGATE: (a, b, c, name) => {
            return `ORGATE ${name} ( ${a}, ${b} , ${c} );`
        },

        bus: (selects, data_in, data_out, BUSCOUNT, DATA_WIDTH, name) => {
            return `bus_mux #(${BUSCOUNT},${DATA_WIDTH}) ${name} ( ${selects}, ${data_in} , ${data_out} );`
        },

        nbitAdder: (sub, cin, x, y, sum, cout, name) => {
            return `nbitAdder ${name} ( ${sub}, ${cin} , ${x}, ${y}, ${sum}, ${cout}  );`
        },

        binaryCounter: (D, clr_, load_, clock, enable1_, enable2_, Q, name) => {
            return `binaryCounter ${name} ( ${D}, ${clr_} , ${load_}, ${clock}, ${enable1_}, ${enable2_}, ${Q}  );`
        },

        nbitComparator: (a, b, equal, lower, name) => {
            return `nbitComparator ${name} ( ${a}, ${b} , ${equal}, ${lower});`
        },

        twoLineToFourLineDecoder: (a, b, en_, y0, y1, y2, y3, name) => {
            return `twoLineToFourLineDecoder ${name} ( ${a}, ${b} , ${en_}, ${y0},${y1},${y2},${y3});`
        },
        staticRam: (address, data, initialData, cs_, we_, oe_, Q, DATA_WIDTH, ADDR_WIDTH, name) => {
            return `staticRamDiscretePorts #(${DATA_WIDTH},${ADDR_WIDTH}) ${name} ( ${address}, ${data} , ${initialData}, ${cs_}, ${we_},${oe_},${Q});`
        },
    }

    //standard modules:
    private moduleMap = {
        "nRegister":
            `module nRegister(data,clock,enable,Q);
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
            `module voltageRail(data,Q);
        input wire data;
        output reg Q;
        always@(data)
        Q <= data;
        endmodule
        `,

        "nBuffer":
            `module nBuffer(data,Q,outputEnable);
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
            `module inverter(data,Q,outputEnable);
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
            `module ANDGATE(a,b,c);
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
            `module bus_mux ( selects, data_in, data_out ); 
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
            `
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
            `module binaryCounter(D,clr_,load_,clock,enable1_,enable2_,Q);
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
            `module nbitComparator (
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
            `module twoLineToFourLineDecoder (a,b,en_,y0,y1,y2,y3);
          input a, b, en_;
          output y0,y1,y2,y3;
          assign y0= (~a) & (~b) & (~en_);
          assign y1= (~a) & b & (~en_);
          assign y2= a & (~ b) & (~en_);
          assign y3= a & b & (~en_);
          endmodule
          `,

        "staticRam": `

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
    `

    }

}