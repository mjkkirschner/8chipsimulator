  module SPIComPart(
                input wire i_clk,                   // base clock
                input wire [0:n-1] i_controlReg,    // control reg
                input wire  i_serial,               // serialIn
        
                output reg [0:n-1] o_dataReg = 0,       //databits to write to
                output reg [0:n-1] o_statReg = 0,       //status reg to write to
        
                output reg enable = 1,                 // start comms on slave
                output reg o_clock = 0           // clock out for clock
                );
        
                parameter n=16;
        
                //for now lets just count to 16.
                reg [0:7]internalcounter = 0;
                reg  startcoms = 0;
                reg  startcomsRisingEdge = 0;
                reg hold = 0;
               
                //when the clock goes high and start is high
                //then generate n clock pulses.
                //then drive start low.
                //and shift in data after each pulse.
                
                always @(posedge i_clk)
                begin
                
                 startcomsRisingEdge = i_controlReg[0] & !startcoms;              
                 startcoms = i_controlReg[0];
               
                if((startcomsRisingEdge))begin
                   hold = 1;
                end
               
                        if(internalcounter > 31)
                        begin
                            internalcounter = 0;
                            hold = 0;
                            enable = 1;
                            o_statReg[0] = 1;
                            o_clock = 0;
                        end
                        
                          
                          
                        //if we have not yet reset the start flag
                        //then count on the clock
                        if(hold == 1)begin
                            internalcounter = internalcounter + 1;
                             enable = 0;
                             o_clock = internalcounter[7];
                            //shift in data from the serial port
                            o_dataReg <= {o_dataReg[1:n-1] ,i_serial};
        
                        end
                       
                
                end
        
                endmodule