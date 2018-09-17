module top(
    input wire CLK,             // board clock: 100 MHz on Arty & Basys 3
    input wire RST_BTN,         // reset button
    input wire STARTLOAD_SWITCH,
    input wire SERIALIN,
    output wire [0:3] DATALED,
    output wire OUTCLOCK,
    output wire DONESTATUS,
    output wire ENABLE
    );
    
     reg clock = 0;
     reg [32:0] counter = 32'b0;
     
     //our spi part deps.
     reg[0:15] control;

     always @ (STARTLOAD_SWITCH ) begin
     control[0] = STARTLOAD_SWITCH;
         end
    
         
     SPIComPart spipart (
     .i_clk(clock),
     .i_controlReg(control),
     .i_serial(SERIALIN),
     .o_dataReg(DATALED),
     .o_statReg(DONESTATUS),
     .enable(ENABLE),
     .o_clock(OUTCLOCK));
    
     
      always @ (posedge CLK) 
               begin
                  counter <= counter + 1;
                  clock <= counter[12];

               end
    endmodule