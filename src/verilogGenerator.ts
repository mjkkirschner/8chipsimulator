import { graph } from "./engine";
import { nRegister, nBuffer, inverter, ANDGATE, ORGATE, bus } from "./primitives";
import { inputPin } from "./pins_wires";
import { VoltageRail } from "./main";
import { nbitAdder } from "./ALU";
import { binaryCounter } from "./counter";
import { nbitComparator } from "./comparator";
import { twoLineToFourLineDecoder } from "./Decoder";
import { staticRam } from "./sram";


function verilogRegister(register: nRegister): string {
    register

}

/**
 * a class responsible for walking a graph and generating a verilog
 * representation of a digital circuit.
 */
export class verilogGenerator {
    private graph: graph;


    constructor(graph: graph) {
        this.graph = graph;
    }

    public generateVerilog() {

        let sortedNodes = this.graph.topoSort();
        //iterate each node and instantiate parts.
        sortedNodes.forEach(node => {
            //foreach node - use the constructor name to generate some verilog
            //usually this will be the instantiation of the appropriate verilog module
            // and the wiring up of upstream parts..... we may want to do this in two phases.
            let nodeType = (node.pointer.constructor as any).name;
            let constructor = this.moduleConstructorMap[nodeType];
            let instantiatedString = 
        })



    }

    private generateTopModule(implementation: string): string {
        return
        `module top(input clock);
        reg HIGH = 1;
        reg LOW = 0;
        reg SUBMODE = 0;
        reg UNCONNECTED = 0;
        ${implementation}
        endmodule;
        `;
    }


    private partToModule = {

        //each of of these functions should take a part, generate input names, and output names for each port
        //and generate a wire for any outputs using the same form for generating names
        //part displayName + portID - taking the first port id if its for a vectorized port - like a multi bit data input.
        nRegister: (part: nRegister) => {

            //TODO - experiment - lets generate an assumped input name based on the pin id and part displayname (could use id too) of the node we're plugged into.
            //so this should evaluate to be the bus's first output pin + part name- and then we'll have the bus generate a wire with the same name...
            // for its output.

            let dataInputName = part.dataPins[0].attachedWire.startPin.owner.displayName + part.dataPins[0].attachedWire.startPin.id;
            let enableInputName = part.enablePin.attachedWire.startPin.owner.displayName + part.enablePin.attachedWire.startPin.id;
            let clockInputName = part.clockPin.attachedWire.startPin.owner.displayName + part.clockPin.attachedWire.startPin.id;

            let outputName = part.displayName + part.outputPins[0].id;

            let n = part.dataPins.length;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(dataInputName, clockInputName, enableInputName, outputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },

        VoltageRail: (part: VoltageRail) => {

            let outputName = part.displayName + part.outputPin.id;
            //these point to values which the top module constructs.
            let dataInputName = part.outputPin.value == true ? "HIGH" : "LOW";

            let n = 1;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(dataInputName, outputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },
        nBuffer: (part: nBuffer) => {

            let dataInputName = part.dataPins[0].attachedWire.startPin.owner.displayName + part.dataPins[0].attachedWire.startPin.id;
            let enableInputName = part.outputEnablePin.attachedWire.startPin.owner.displayName + part.outputEnablePin.attachedWire.startPin.id;

            let outputName = part.displayName + part.outputPins[0].id;

            let n = part.dataPins.length;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(dataInputName, outputName, enableInputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },
        inverter: (part: inverter) => {

            let dataInputName = part.dataPin.attachedWire.startPin.owner.displayName + part.dataPin.attachedWire.startPin.id;
            let enableInputName = part.outputEnablePin.attachedWire.startPin.owner.displayName + part.outputEnablePin.attachedWire.startPin.id;

            let outputName = part.displayName + part.outputPin.id;

            let n = 1;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(dataInputName, outputName, enableInputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },
        ANDGATE: (part: ANDGATE) => {

            let dataInputName = part.dataPin1.attachedWire.startPin.owner.displayName + part.dataPin1.attachedWire.startPin.id;
            let dataInput2Name = part.dataPin2.attachedWire.startPin.owner.displayName + part.dataPin2.attachedWire.startPin.id;

            let outputName = part.displayName + part.outputPin.id;

            let n = 1;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(dataInputName, dataInput2Name, outputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },
        ORGATE: (part: ORGATE) => {

            let dataInputName = part.dataPin1.attachedWire.startPin.owner.displayName + part.dataPin1.attachedWire.startPin.id;
            let dataInput2Name = part.dataPin2.attachedWire.startPin.owner.displayName + part.dataPin2.attachedWire.startPin.id;

            let outputName = part.displayName + part.outputPin.id;

            let n = 1;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(dataInputName, dataInput2Name, outputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },

        bus: (part: bus) => {


            //get all the dataInputs... this will be the concatenation of all the data input parts output wires...


            let dataInputName = 'allInputsFor' + part.id;

            let n = part.outputPins.length;
            let m = part.inputGroups[0].length;

            let concatenatedDatas = 'wire [${n*m}-1:0] ' + dataInputName + '= {' + part.inputGroups.map(x => x[0].owner.displayName + x[0].id).join(",") + '};';
            let outputName = part.displayName + part.outputPins[0].id;
            //for the select signals we need to generate a concatenation of all the outputEnable signals from the inputs.
            //similar to what we did for the inputs themselves
            let selectInputName = 'allSelectsFor' + part.id;
            let concatenatedSelects = 'wire [${n*m}-1:0] ' + selectInputName + '= {' + part.inputGroups.map(x => x[0].owner.displayName + (x[0].owner as nBuffer).outputEnablePin.id).join(",") + '};';


            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(selectInputName, dataInputName, outputName, part.displayName + part.id);

            return [outputWireString, concatenatedDatas, concatenatedSelects, moduleInstanceString].join("\n");

        },

        nbitAdder: (part: nbitAdder) => {

            let aInputName = part.dataPinsA[0].attachedWire.startPin.owner.displayName + part.dataPinsA[0].attachedWire.startPin.id;
            let bInputName = part.dataPinsB[0].attachedWire.startPin.owner.displayName + part.dataPinsB[0].attachedWire.startPin.id;
            //TODO eventually use the 4 signals for adder mode - for now it's just 0.
            //defined in top module.
            let subModeInputName = "SUBMODE";

            //I think this is left unconnected for now
            let carryInInputName = "UNCONNECTED";
            let carryOutputName = part.displayName + part.carryOut[0].id;
            let carryOutWire = "wire " + carryOutputName;

            let outputName = part.displayName + part.sumOutPins[0].id;

            let n = part.dataPinsA.length;
            let func = this.moduleConstructorMap[part.constructor.name];


            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(subModeInputName, carryInInputName, aInputName, bInputName, outputName, carryOutputName, part.displayName + part.id);

            return [outputWireString, carryOutWire, moduleInstanceString].join("\n");

        },

        binaryCounter: (part: binaryCounter) => {


            let dataInputName = part.dataPins[0].attachedWire.startPin.owner.displayName + part.dataPins[0].attachedWire.startPin.id;
            let enableInput1Name = part.outputEnablePin1.attachedWire.startPin.owner.displayName + part.outputEnablePin1.attachedWire.startPin.id;
            let enableInput2Name = part.outputEnablePin2.attachedWire.startPin.owner.displayName + part.outputEnablePin2.attachedWire.startPin.id;
            let clockInputName = part.clockPin.attachedWire.startPin.owner.displayName + part.clockPin.attachedWire.startPin.id;
            let clearInputName = part.clearPin.attachedWire.startPin.owner.displayName + part.clearPin.attachedWire.startPin.id;
            let loadInputName = part.loadPin.attachedWire.startPin.owner.displayName + part.loadPin.attachedWire.startPin.id;


            let outputName = part.displayName + part.outputPins[0].id;

            let n = part.dataPins.length;
            let func = this.moduleConstructorMap[part.constructor.name];
            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(dataInputName,
                clearInputName,
                loadInputName,
                clockInputName,
                enableInput1Name,
                enableInput2Name,
                outputName,
                part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },

        nbitComparator: (part: nbitComparator) => {

            let aInputName = part.dataPinsA[0].attachedWire.startPin.owner.displayName + part.dataPinsA[0].attachedWire.startPin.id;
            let bInputName = part.dataPinsB[0].attachedWire.startPin.owner.displayName + part.dataPinsB[0].attachedWire.startPin.id;

            let equalOutputName = part.displayName + part.AEBOUT[0].id;
            let lowerOutputName = part.displayName + part.ALBOUT[0].id;

            let n = part.dataPinsA.length;
            let func = this.moduleConstructorMap[part.constructor.name];


            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(aInputName, bInputName, equalOutputName, lowerOutputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");

        },

        twoLineToFourLineDecoder: (part: twoLineToFourLineDecoder) => {

            let aInputName = part.dataPins[0].attachedWire.startPin.owner.displayName + part.dataPins[0].attachedWire.startPin.id;
            let bInputName = part.dataPins[1].attachedWire.startPin.owner.displayName + part.dataPins[1].attachedWire.startPin.id;
            let enableInputName = part.outputEnablePin.attachedWire.startPin.owner.displayName + part.outputEnablePin.attachedWire.startPin.id;

            let yoOutputname = part.displayName + part.outputPins[0].id;
            let y1Outputname = part.displayName + part.outputPins[1].id;
            let y2Outputname = part.displayName + part.outputPins[2].id;
            let y3Outputname = part.displayName + part.outputPins[3].id;

            let yoOutputWire = "wire " + yoOutputname;
            let y1OutputWire = "wire " + y1Outputname;
            let y2OutputWire = "wire " + y2Outputname;
            let y3OutputWire = "wire " + y3Outputname;

            let func = this.moduleConstructorMap[part.constructor.name];


            let moduleInstanceString = func(aInputName,
                bInputName,
                enableInputName,
                yoOutputname,
                y1Outputname,
                y2Outputname,
                y3Outputname,
                part.displayName + part.id);

            return [yoOutputWire, y1OutputWire, y2OutputWire, y3OutputWire, moduleInstanceString].join("\n");

        },

        staticRam:(part:staticRam)=>{

            //decide which rom file path to inject?

            let addressInputs = part.addressPins[0].attachedWire.startPin.owner.displayName + part.addressPins[0].attachedWire.startPin.id;
            //this is the bus output wire.
            let dataInputName = part.InputOutputPins[0].internalInput.attachedWire.startPin.owner.displayName + part.InputOutputPins[0].internalInput.attachedWire.startPin.id;



            let bInputName = part.dataPinsB[0].attachedWire.startPin.owner.displayName + part.dataPinsB[0].attachedWire.startPin.id;

            let equalOutputName = part.displayName + part.AEBOUT[0].id;
            let lowerOutputName = part.displayName + part.ALBOUT[0].id;

            let n = part.dataPinsA.length;
            let func = this.moduleConstructorMap[part.constructor.name];


            let outputWireString = 'wire [${n}-1:0] ${outputName};'
            let moduleInstanceString = func(aInputName, bInputName, equalOutputName, lowerOutputName, part.displayName + part.id);

            return [outputWireString, moduleInstanceString].join("\n");
        }

        staticRam: (address, data, cs_, we_, oe_, ROMFILE, DATA_WIDTH, ADDR_WIDTH, name) => {



        }

    //TODO figure out how to get these signatures...
    private moduleConstructorMap = {
            nRegister: (data, clock, enable, Q, name) => {
                return 'nRegister ${name} ( ${data}, ${clock}, ${enable}, ${Q} );'
            },

            VoltageRail: (data, Q, name) => {
                return 'voltageRail ${name} ( ${data}, ${Q} );'
            },

            nBuffer: (data, Q, outputEnable, name) => {
                return 'nBuffer ${name} ( ${data}, ${Q} , ${outputEnable} );'
            },

            inverter: (data, Q, outputEnable, name) => {
                return 'inverter ${name} ( ${data}, ${Q} , ${outputEnable} );'
            },

            ANDGATE: (a, b, c, name) => {
                return 'ANDGATE ${name} ( ${a}, ${b} , ${c} );'
            },

            ORGATE: (a, b, c, name) => {
                return 'ORGATE ${name} ( ${a}, ${b} , ${c} );'
            },

            bus: (selects, data_in, data_out, name) => {
                return 'bus_mux ${name} ( ${selects}, ${data_in} , ${data_out} );'
            },

            nbitAdder: (sub, cin, x, y, sum, cout, name) => {
                return 'nbitAdder ${name} ( ${sub}, ${cin} , ${x}, ${y}, ${sum}, ${cout}  );'
            },

            binaryCounter: (D, clr_, load_, clock, enable1_, enable2_, Q, name) => {
                return 'nbitbinaryCounterdder ${name} ( ${D}, ${clr_} , ${load_}, ${clock}, ${enable1_}, ${enable2_}, ${Q}  );'
            },

            nbitComparator: (a, b, equal, lower, name) => {
                return 'nbitComparator ${name} ( ${a}, ${b} , ${equal}, ${lower});'
            },

            twoLineToFourLineDecoder: (a, b, en_, y0, y1, y2, y3, name) => {
                return 'twoLineToFourLineDecoder ${name} ( ${a}, ${b} , ${en_}, ${y0},${y1},${y2},${y3});'
            },
            staticRam: (address, data, cs_, we_, oe_, ROMFILE, DATA_WIDTH, ADDR_WIDTH, name) => {
                return 'ram_sp_ar_aw #(${ROMFILE},${DATA_WIDTH},${ADDR_WIDTH} ${name} ( ${address}, ${data} , ${cs_}, ${we_},${oe_});'
            },
        }

    //standard modules:
    private moduleMap = {
            "nRegister":
                `module nRegister(data,clock,enable,Q);
        parameter n = 8;
        input [n-1:0] data;
        input clock,enable;
        output reg [n-1:0] Q;

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
        Q = data;
        endmodule
        `,

            "nBuffer":
                `module nBuffer(data,Q,outputEnable);
        parameter n=8;
        input [n-1:0] data;
        input outputEnable;
        output reg [n-1:0] Q;
    
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
        input  [bus_count-1:0]           selects;   // one-hot select signals 
        input  [mux_width*bus_count-1:0] data_in;   // concatenated input buses 
        output reg [mux_width-1:0]                 data_out;  // output data bus 
        
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
        input [n-1:0] x,y;
        output [n-1:0]sum;
        output cout;
        wire[n-1:0] onesComplement;

        assign onesComplement = {n{sub}}^y +sub;
        assign {cout,sum} = {1'b0,x} + {1'b0,onesComplement} + cin;
        endmodule
        `,

            "binaryCounter":
                `module binaryCounter(D,clr_,load_,clock,enable1_,enable2_,Q);
        parameter n = 8;
        input [n-1:0] D;
        input clr_,clock,enable1_,enable2_,load_;
        output reg [n-1:0] Q;

        always@(negedge clr_,negedge load_,posedge clock)
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
            input wire [n-1:0] a,
            input wire [n-1:0] b,
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
          input a, b, en;
          output y0,y1,y2,y3;
          assign y0= (~a) & (~b) & (~en_);
          assign y1= (~a) & b & (~en_);
          assign y2= a & (~ b) & (~en_);
          assign y3= a & b & (~en_);
          end module
          `,
            //http://www.asic-world.com/examples/verilog/ram_sp_ar_aw.html
            //I have inverted the contorl signals
            //and modified the highz size.
            //as well as reading rom file in initial block...
            "staticRam":
                `
          //-----------------------------------------------------
// Design Name : ram_sp_ar_aw
// File Name   : ram_sp_ar_aw.v
// Function    : Asynchronous read write RAM 
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module ram_sp_ar_aw (
    address     , // Address Input
    data        , // Data bi-directional
    cs_          , // Chip Select
    we_          , // Write Enable/Read Enable
    oe_            // Output Enable
    );
    parameter ROMFILE="nofile";  
    parameter DATA_WIDTH = 8 ;
    parameter ADDR_WIDTH = 8 ;
    parameter RAM_DEPTH = 1 << ADDR_WIDTH;
    
    //--------------Input Ports----------------------- 
    input [ADDR_WIDTH-1:0] address ;
    input                                     cs_           ;
    input                                     we_          ;
    input                                     oe_           ; 
    
    //--------------Inout Ports----------------------- 
    inout [DATA_WIDTH-1:0]  data       ;
    
    //--------------Internal variables----------------
    reg [DATA_WIDTH-1:0]   data_out ;
    reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
    
    //--------------Code Starts Here------------------ 
    initial begin
        $display("Loading rom.");
        $readmemh(ROMFILE, mem);
    end
    // Tri-State Buffer control 
    // output : When we = 1, oe = 0, cs = 0
    assign data = (!cs_ && !oe_ && we_) ? data_out : {DATA_WIDTH{1'bz}};
    
    // Memory Write Block 
    // Write Operation : When we = 0, cs = 0
    always @ (address or data or cs_ or we_)
    begin : MEM_WRITE
       if ( !cs_ && !we_ ) begin
           mem[address] = data;
       end
    end
    
    // Memory Read Block 
    // Read Operation : When we = 1, oe = 0, cs = 0
    always @ (address or cs_ or we_ or oe_)
    begin : MEM_READ
        if (!cs_ && we_ && !oe_)  begin
             data_out = mem[address];
        end
    end
    
    endmodule // End of Module ram_sp_ar_aw
    `

        }

    }