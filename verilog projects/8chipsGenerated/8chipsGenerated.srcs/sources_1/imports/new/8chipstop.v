
         (* DONT_TOUCH = "yes" *)
            module nRegister(data,clock,enable,Q);
        parameter n = 8;
        input [0:n-1] data;
        input clock,enable;
        output reg [0:n-1] Q = {n-1{1'b0}};

        always@(posedge clock)
            if(enable)
                Q<=data;
            endmodule
        
 (* DONT_TOUCH = "yes" *)
            module voltageRail(data,Q);
        input wire data;
        output reg Q;
        always@(data)
        Q <= data;
        endmodule
        
 (* DONT_TOUCH = "yes" *)
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
    endmodule
 (* DONT_TOUCH = "yes" *)
            module inverter(data,Q,outputEnable);
    input data,outputEnable;
    output reg Q;
    always@(data,outputEnable)
        if(outputEnable)
            Q <= ~data;
        else
            Q<=1'b0;
    endmodule
    
 (* DONT_TOUCH = "yes" *)
            module ANDGATE(a,b,c);
        input a,b;
        output c;
        and a1 (c,a,b);
        endmodule
module ORGATE(a,b,c);
    input a,b;
    output c;
    or a1 (c,a,b);
        endmodule
 (* DONT_TOUCH = "yes" *)
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
        
 (* DONT_TOUCH = "yes" *)
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
        
 (* DONT_TOUCH = "yes" *)
    module nbitALU(mode,x,y,out,cout);
    parameter n = 8;
    input [0:3] mode;
    input [0:n-1] x,y;
    output [0:n-1]out;
    output cout;

    reg  [0:n-1] ALU_Result = 0 ;
    assign out = ALU_Result[0:n-1];
    assign cout =0;

    always @(*)
    begin
        case(mode)
        4'b1001: // Addition
           ALU_Result = x + y ; 
        4'b0110: // Subtraction
          ALU_Result = x - y ;
        4'b1000: // Multiplication
           ALU_Result = x * y;
        4'b0100: // Division
           ALU_Result = x/y;
        4'b1100: // MOD
           ALU_Result = x%y;
          default: ALU_Result = x + y ; 
        endcase
    end
    endmodule
    
 (* DONT_TOUCH = "yes" *)
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
        
 (* DONT_TOUCH = "yes" *)
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
          
 (* DONT_TOUCH = "yes" *)
            module twoLineToFourLineDecoder (a,b,en_,y0,y1,y2,y3);
          input a, b, en_;
          output y0,y1,y2,y3;
          assign y0= (~a) & (~b) & (~en_);
          assign y1= (~a) & b & (~en_);
          assign y2= a & (~ b) & (~en_);
          assign y3= a & b & (~en_);
          endmodule
          

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
    
(* DONT_TOUCH = "yes" *)
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
    
    
(* DONT_TOUCH = "yes" *)
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
                reg  r2_pulse = 0;
                reg  r3_pulse = 0;
                reg [0:7] stretch_counter = 0;
                wire stretched;

                assign stretched = stretch_counter > 0 ? 1:0;

                //when the clock goes high and start is high
                //then generate n clock pulses.
                //then drive start low.
                //and shift in data after each pulse.
                
                always @(posedge i_clk)
                begin
                    clockScaler <= clockScaler + 1;
                    slow_clock <= clockScaler[11];

                    if(i_controlReg[15] == 1)begin
                        stretch_counter <= 4096;
                     end
                    else if (stretch_counter > 0) begin
                        stretch_counter <= stretch_counter - 1;
                     end

                end
                
            always@(posedge slow_clock) begin
               
               r1_pulse <= stretched;
               r2_pulse <= r1_pulse;
               r3_pulse <= r2_pulse;
               //start clocking out -
               //r2 is current, r3 is old...
                if((r3_pulse == 1) && (r2_pulse == 0))begin
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
                output reg  [0:7] OUT_AREG, //debugging
                output wire PIX_STRB);
                   
                reg HIGH = 1;
                reg LOW = 0;
                reg SUBMODE = 0;
                reg UNCONNECTED = 0;
    
                reg [0:0]clock;
                reg [0:0]ClockFaster;
                reg pix_stb;

        
        
        wire [0:1-1] COMenableOn93e5ad32_e20d_458c_b27b_064e10e6ce9a;
wire [0:1-1] invertON54ebb284_ab40_4830_8e98_94eae224c9c9;
wire [0:1-1] signalBankOutputOn5ac24d9e_c152_49fe_b6d2_c5bc8090fdec;
wire [0:1-1] invertOn19e7aa60_d875_4b7e_a1be_69832c1069dd;
wire [0:1-1] eepromChipEnablea930e9f4_4938_4f91_a44b_167413eee42c;
wire [0:1-1] eepromOutEnable0062137e_6d0f_4476_81fc_855fa66662b3;
wire [0:1-1] eepromWriteDisableda6cc829e_fefc_4df6_8f28_1b47f4d3f3f4;
wire [0:1-1] load_disabled769243e5_244e_4583_8925_efc9cee2141b;
wire [0:1-1] count_enable_microcode_counter62d90467_1a91_48a3_985a_68734a14cb85;
wire [0:1-1] invert_clock_signal_enable27ca165a_2bcc_4048_83cd_22e177db00dd;
wire [0:1-1] clearPC7ebaea00_400c_4004_b77c_ea7db63326e3;
wire [0:1-1] ram_chipEnable43d7cabe_4b0c_4478_b243_98b6d0bae8d5;



wire [0:16-1] comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913;
wire [0:16-1] allInputsFor412c4a58_04b7_401f_aabf_ab157536ac99_comDataReg= {spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[0],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[1],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[2],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[3],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[4],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[5],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[6],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[7],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[8],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[9],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[10],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[11],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[12],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[13],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[14],spi_testc2cfff6f_0da1_46fa_aab8_75084e122133[15]};
wire [0:16-1] comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c;
wire [0:16-1] allInputsFor9b02a0fc_05fb_4c82_b4fb_290a3cf6017e_comStatusReg= {spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[0],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[1],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[2],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[3],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[4],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[5],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[6],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[7],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[8],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[9],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[10],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[11],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[12],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[13],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[14],spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[15]};

wire [0:1-1] invert_clock_signal4e9c149b_9bd8_4ff2_aa48_41b84bd491f4;
wire [0:3-1] microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c;
wire [0:1-1] decodeInverter28beb87a_b7e8_47d1_8482_eb2beba6c61f;

wire decoder259751554_9371_4837_a4bd_74a67b492d53;
wire decoder275f58661_9a8a_48fe_a356_474bba284bb4;
wire decoder28dcca1d1_434d_41b6_94bb_667ace851be8;
wire decoder2cd59b37c_edec_4033_a98a_cccd74f09a57;
wire decoder11b433644_ff3c_4221_ac58_d527aef57277;
wire decoder1e82116da_4230_4397_a137_2398c47f6963;
wire decoder11f749edf_ce8e_4087_9d43_d6bfc6e025a1;
wire decoder176a4d8dc_9a56_419f_802c_52c92b8f5883;
wire [0:16-1] Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5;
wire [0:16-1] pc_buffer92c6ddaf_f374_4eac_aec1_c429d94d2402;
wire [0:16-1] allInputsForee01ae1f_d5f8_4280_8b01_b0b092a14fa6_pc_buffer= {Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[0],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[1],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[2],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[3],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[4],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[5],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[6],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[7],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[8],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[9],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[10],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[11],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[12],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[13],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[14],Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5[15]};
wire [0:16-1] main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f;
wire [0:112-1] allInputsForbd178d74_f423_43ab_be76_04ffb5cded6f_main_bus= {A_reg_buffer9c092306_9829_4776_809f_63d5a36c6181,B_reg_bufferd36a8dab_b0ff_487b_b672_a031add40457,adder_buffer97f73335_d941_4b60_9b1c_e3f30002c42a,ram_output_buffer1992aa6d_b3d6_4bcb_bc23_60e1fc5721b2,pc_buffer92c6ddaf_f374_4eac_aec1_c429d94d2402,comDataRegBuffer21ea835a_63b9_4574_98fb_a4be52cd1ac5,comStatusRegBufferebe516de_8a9a_4e8f_a1ad_905e441e79c2};
wire [0:7-1] allSelectsForbd178d74_f423_43ab_be76_04ffb5cded6f_main_bus= {microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[8],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[15],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[9],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[1],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[4],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[25],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[23]};
wire [0:16-1] instruction_register3ab4c5a7_e4b4_4421_8b8c_f2f7a56f37a2;
wire [0:16-1] allInputsFor014c93c2_5c15_4f64_9bfc_3bf926daf322_instruction_register= {main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[0],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[1],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[2],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[3],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[4],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[5],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[6],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[7],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[8],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[9],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[10],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[11],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[12],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[13],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[14],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[15]};
wire [0:32-1] microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594;
wire [0:8-1] allAddressInputsFora5772c60_7eaf_4921_b8c9_eb59de74a47e_microcode_rom= {instruction_register3ab4c5a7_e4b4_4421_8b8c_f2f7a56f37a2[11],instruction_register3ab4c5a7_e4b4_4421_8b8c_f2f7a56f37a2[12],instruction_register3ab4c5a7_e4b4_4421_8b8c_f2f7a56f37a2[13],instruction_register3ab4c5a7_e4b4_4421_8b8c_f2f7a56f37a2[14],instruction_register3ab4c5a7_e4b4_4421_8b8c_f2f7a56f37a2[15],microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[0],microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[1],microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[2]};
wire [0:32-1] allDataInputsFora5772c60_7eaf_4921_b8c9_eb59de74a47e_microcode_rom= {UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED};
wire [0:32-1] microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406;
wire [0:32-1] allInputsFordad9a175_6292_4ca2_818a_1c9d542c9ab6_microCode_SIGNAL_bank= {microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[0],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[1],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[2],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[3],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[4],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[5],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[6],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[7],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[8],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[9],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[10],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[11],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[12],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[13],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[14],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[15],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[16],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[17],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[18],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[19],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[20],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[21],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[22],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[23],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[24],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[25],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[26],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[27],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[28],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[29],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[30],microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594[31]};
wire [0:16-1] comDataRegBuffer21ea835a_63b9_4574_98fb_a4be52cd1ac5;
wire [0:16-1] allInputsFor55a0e51e_84c2_4863_9f9d_6cccb13a5177_comDataRegBuffer= {comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[0],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[1],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[2],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[3],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[4],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[5],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[6],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[7],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[8],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[9],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[10],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[11],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[12],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[13],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[14],comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[15]};
wire [0:16-1] comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18;
wire [0:16-1] allInputsFor94e9285f_17d0_49e4_bf2e_a90c6824f615_comControlReg= {main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[0],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[1],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[2],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[3],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[4],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[5],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[6],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[7],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[8],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[9],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[10],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[11],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[12],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[13],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[14],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[15]};
wire [0:16-1] spi_testc2cfff6f_0da1_46fa_aab8_75084e122133;
wire [0:16-1] spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799;
wire [0:16-1] AllControlInputsFor69b922cf_3a0f_4e18_b2b8_27c92ef872e2_spi_test= {comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[0],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[1],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[2],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[3],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[4],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[5],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[6],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[7],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[8],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[9],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[10],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[11],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[12],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[13],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[14],comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18[15]};
wire [0:16-1] comStatusRegBufferebe516de_8a9a_4e8f_a1ad_905e441e79c2;
wire [0:16-1] allInputsFor66dd9ed3_f32c_4a55_a51f_b703c910f212_comStatusRegBuffer= {comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[0],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[1],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[2],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[3],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[4],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[5],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[6],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[7],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[8],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[9],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[10],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[11],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[12],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[13],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[14],comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c[15]};
wire [0:1-1] countEnableInverter6460f522_088d_4350_8f14_437b2cfd13bb;
wire [0:1-1] ramOutInverter6702f03d_ff50_4f9e_9b53_8669861592f7;
wire [0:1-1] ramInInverter7db13039_fe8f_4d11_9b2d_0197b2548a9b;
wire [0:16-1] memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991;
wire [0:16-1] allInputsFor069d9a3f_d99a_4ac5_bbe8_cf7dd246efb7_memory_address_register= {main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[0],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[1],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[2],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[3],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[4],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[5],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[6],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[7],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[8],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[9],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[10],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[11],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[12],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[13],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[14],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[15]};
wire [0:16-1] main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61;
wire [0:16-1] main_ram853ef005_a0ed_483e_82f5_58840b92f31d;
wire [0:16-1] allAddress1InputsFor3dd2c77a_5ecd_4a00_8c2a_d303178e59ea_main_ram= {memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[0],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[1],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[2],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[3],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[4],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[5],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[6],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[7],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[8],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[9],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[10],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[11],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[12],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[13],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[14],memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991[15]};
wire [0:16-1] allAddress2InputsFor3dd2c77a_5ecd_4a00_8c2a_d303178e59ea_main_ram= {sigGen4e62b71e_a806_42c2_a4cf_a5a4ac230863[3:8],sigGen5e06e10b_db18_4804_933c_00d2501780a9};
wire [0:16-1] allDataInputsFor3dd2c77a_5ecd_4a00_8c2a_d303178e59ea_main_ram= {main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[0],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[1],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[2],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[3],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[4],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[5],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[6],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[7],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[8],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[9],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[10],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[11],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[12],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[13],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[14],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[15]};
wire [0:16-1] ram_output_buffer1992aa6d_b3d6_4bcb_bc23_60e1fc5721b2;
wire [0:16-1] allInputsFor36b0b893_f5e5_4558_aaa4_9eff276ffb81_ram_output_buffer= {main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[0],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[1],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[2],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[3],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[4],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[5],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[6],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[7],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[8],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[9],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[10],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[11],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[12],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[13],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[14],main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61[15]};
wire [0:16-1] OUT_registercc60b3a9_54ff_42c1_9019_03c4a115ca7c;
wire [0:16-1] allInputsForbf4f5ce0_55aa_4c9a_87be_12c510cef0d1_OUT_register= {main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[0],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[1],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[2],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[3],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[4],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[5],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[6],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[7],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[8],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[9],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[10],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[11],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[12],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[13],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[14],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[15]};
wire [0:16-1] B_register0840e4cd_9d81_496b_8162_5a4881cbaa31;
wire [0:16-1] allInputsFor12daeb20_d118_478b_9401_acab32f3ec08_B_register= {main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[0],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[1],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[2],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[3],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[4],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[5],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[6],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[7],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[8],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[9],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[10],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[11],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[12],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[13],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[14],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[15]};
wire [0:16-1] B_reg_bufferd36a8dab_b0ff_487b_b672_a031add40457;
wire [0:16-1] allInputsFor04f7e35d_2489_415e_a489_273c3a3c416f_B_reg_buffer= {B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[0],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[1],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[2],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[3],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[4],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[5],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[6],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[7],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[8],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[9],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[10],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[11],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[12],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[13],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[14],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[15]};
wire [0:16-1] A_register3800747a_213b_4d90_8ac3_69c57425d437;
wire [0:16-1] allInputsFor0995da8d_3e84_40ee_a304_e9a24eabc4ce_A_register= {main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[0],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[1],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[2],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[3],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[4],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[5],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[6],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[7],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[8],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[9],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[10],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[11],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[12],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[13],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[14],main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f[15]};
wire [0:0] A_B_Comparatorc056cd2e_208a_4a97_be45_8c095d4f011d;
wire [0:16-1] allADataInputsForf864afdb_f350_4fa9_8dd3_3392317dc80e_A_B_Comparator= {A_register3800747a_213b_4d90_8ac3_69c57425d437[0],A_register3800747a_213b_4d90_8ac3_69c57425d437[1],A_register3800747a_213b_4d90_8ac3_69c57425d437[2],A_register3800747a_213b_4d90_8ac3_69c57425d437[3],A_register3800747a_213b_4d90_8ac3_69c57425d437[4],A_register3800747a_213b_4d90_8ac3_69c57425d437[5],A_register3800747a_213b_4d90_8ac3_69c57425d437[6],A_register3800747a_213b_4d90_8ac3_69c57425d437[7],A_register3800747a_213b_4d90_8ac3_69c57425d437[8],A_register3800747a_213b_4d90_8ac3_69c57425d437[9],A_register3800747a_213b_4d90_8ac3_69c57425d437[10],A_register3800747a_213b_4d90_8ac3_69c57425d437[11],A_register3800747a_213b_4d90_8ac3_69c57425d437[12],A_register3800747a_213b_4d90_8ac3_69c57425d437[13],A_register3800747a_213b_4d90_8ac3_69c57425d437[14],A_register3800747a_213b_4d90_8ac3_69c57425d437[15]};
wire [0:16-1] allBDataInputsForf864afdb_f350_4fa9_8dd3_3392317dc80e_A_B_Comparator= {B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[0],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[1],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[2],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[3],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[4],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[5],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[6],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[7],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[8],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[9],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[10],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[11],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[12],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[13],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[14],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[15]};
wire [0:0] A_B_Comparator9efc3425_d274_4523_8d58_94efe347f335;
wire [0:1-1] invertALESSB6fd24131_0d1b_4238_8a42_3de605fe852d;
wire [0:1-1] invertAEQUALB3b8d3052_62ae_4497_b22f_4e5aec16a038;
wire [0:1-1] AGREATERBaa9dc33c_9a06_4ae1_bc55_b3b5c78caa01;
wire [0:4-1] flags_registerdbdcf886_6b09_4210_bc6b_d465542a4de6;
wire [0:4-1] allInputsFor14a3e01e_f4c5_4989_9603_d0cdb9148917_flags_register= {AGREATERBaa9dc33c_9a06_4ae1_bc55_b3b5c78caa01[0],A_B_Comparatorc056cd2e_208a_4a97_be45_8c095d4f011d[0],A_B_Comparator9efc3425_d274_4523_8d58_94efe347f335[0],UNCONNECTED};
wire [0:1-1] ANDALESSBd1d79197_a2fa_49f6_b608_0b15bf63e6e1;
wire [0:1-1] ANDAEQUALBf73549e9_d3ce_4bac_8928_bf005199b226;
wire [0:1-1] ANDAGBf01bd6b5_805d_4ff9_a16b_45991aa7545a;
wire [0:1-1] OR16d52a9b1_245a_4238_8c59_33756deb13ef;
wire [0:1-1] OR2c016bf6c_901b_4d0c_8818_c45a92395e98;
wire [0:1-1] loadInverterfd984bdc_1781_48f8_ab76_48a67c718d4d;
wire [0:16-1] A_reg_buffer9c092306_9829_4776_809f_63d5a36c6181;
wire [0:16-1] allInputsFor55550418_c754_4c48_82f9_ab1f49fe39e5_A_reg_buffer= {A_register3800747a_213b_4d90_8ac3_69c57425d437[0],A_register3800747a_213b_4d90_8ac3_69c57425d437[1],A_register3800747a_213b_4d90_8ac3_69c57425d437[2],A_register3800747a_213b_4d90_8ac3_69c57425d437[3],A_register3800747a_213b_4d90_8ac3_69c57425d437[4],A_register3800747a_213b_4d90_8ac3_69c57425d437[5],A_register3800747a_213b_4d90_8ac3_69c57425d437[6],A_register3800747a_213b_4d90_8ac3_69c57425d437[7],A_register3800747a_213b_4d90_8ac3_69c57425d437[8],A_register3800747a_213b_4d90_8ac3_69c57425d437[9],A_register3800747a_213b_4d90_8ac3_69c57425d437[10],A_register3800747a_213b_4d90_8ac3_69c57425d437[11],A_register3800747a_213b_4d90_8ac3_69c57425d437[12],A_register3800747a_213b_4d90_8ac3_69c57425d437[13],A_register3800747a_213b_4d90_8ac3_69c57425d437[14],A_register3800747a_213b_4d90_8ac3_69c57425d437[15]};
wire [0:16-1] adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5;
wire adder3a143945_31f7_4610_ae35_0f9393574f6e;
wire [0:3] allDataForMode587e1c6a_68b8_4cc4_b11d_b945f329dfc4_adder= {microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[10],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[11],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[12],microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[13]};
wire [0:16-1] allADataInputsFor587e1c6a_68b8_4cc4_b11d_b945f329dfc4_adder= {A_register3800747a_213b_4d90_8ac3_69c57425d437[0],A_register3800747a_213b_4d90_8ac3_69c57425d437[1],A_register3800747a_213b_4d90_8ac3_69c57425d437[2],A_register3800747a_213b_4d90_8ac3_69c57425d437[3],A_register3800747a_213b_4d90_8ac3_69c57425d437[4],A_register3800747a_213b_4d90_8ac3_69c57425d437[5],A_register3800747a_213b_4d90_8ac3_69c57425d437[6],A_register3800747a_213b_4d90_8ac3_69c57425d437[7],A_register3800747a_213b_4d90_8ac3_69c57425d437[8],A_register3800747a_213b_4d90_8ac3_69c57425d437[9],A_register3800747a_213b_4d90_8ac3_69c57425d437[10],A_register3800747a_213b_4d90_8ac3_69c57425d437[11],A_register3800747a_213b_4d90_8ac3_69c57425d437[12],A_register3800747a_213b_4d90_8ac3_69c57425d437[13],A_register3800747a_213b_4d90_8ac3_69c57425d437[14],A_register3800747a_213b_4d90_8ac3_69c57425d437[15]};
wire [0:16-1] allBDataInputsFor587e1c6a_68b8_4cc4_b11d_b945f329dfc4_adder= {B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[0],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[1],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[2],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[3],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[4],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[5],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[6],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[7],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[8],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[9],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[10],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[11],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[12],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[13],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[14],B_register0840e4cd_9d81_496b_8162_5a4881cbaa31[15]};
wire [0:16-1] adder_buffer97f73335_d941_4b60_9b1c_e3f30002c42a;
wire [0:16-1] allInputsFor7b825143_a913_4504_99c3_aab5033403b3_adder_buffer= {adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[0],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[1],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[2],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[3],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[4],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[5],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[6],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[7],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[8],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[9],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[10],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[11],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[12],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[13],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[14],adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5[15]};
wire [0:10-1] sigGen5e06e10b_db18_4804_933c_00d2501780a9;
wire [0:9-1] sigGen4e62b71e_a806_42c2_a4cf_a5a4ac230863;
wire sigGen227ec629_2c89_47c1_8b8a_2f48c6c8cc69;
wire sigGen58628296_9704_4a0e_894c_e563501704b8;


voltageRail COMenableOn592cfdf6_2e6e_4645_882d_b9af52801218 ( 
                .data(HIGH), 
                .Q(COMenableOn93e5ad32_e20d_458c_b27b_064e10e6ce9a) );


voltageRail invertONeb5ff0d7_112b_4544_9a15_e62eff26860b ( 
                .data(HIGH), 
                .Q(invertON54ebb284_ab40_4830_8e98_94eae224c9c9) );


voltageRail signalBankOutputOn35a521e3_525c_4f24_b347_a8520ed1a2d8 ( 
                .data(HIGH), 
                .Q(signalBankOutputOn5ac24d9e_c152_49fe_b6d2_c5bc8090fdec) );


voltageRail invertOn3713dc6a_263c_413c_87cf_0a1a3d23b2fb ( 
                .data(HIGH), 
                .Q(invertOn19e7aa60_d875_4b7e_a1be_69832c1069dd) );


voltageRail eepromChipEnable84b70228_0ba3_44a7_aa3f_c9c6274698af ( 
                .data(LOW), 
                .Q(eepromChipEnablea930e9f4_4938_4f91_a44b_167413eee42c) );


voltageRail eepromOutEnableba097d73_1a59_4af8_9d13_4eba23a80bf2 ( 
                .data(LOW), 
                .Q(eepromOutEnable0062137e_6d0f_4476_81fc_855fa66662b3) );


voltageRail eepromWriteDisabled864b3d00_0a78_4d44_9f1e_89ada2fd9f1b ( 
                .data(HIGH), 
                .Q(eepromWriteDisableda6cc829e_fefc_4df6_8f28_1b47f4d3f3f4) );


voltageRail load_disabled2e2fe005_daa8_45d3_9ea2_79fbeb4680ca ( 
                .data(HIGH), 
                .Q(load_disabled769243e5_244e_4583_8925_efc9cee2141b) );


voltageRail count_enable_microcode_counterc070976e_2197_45aa_8774_6615ce62e376 ( 
                .data(LOW), 
                .Q(count_enable_microcode_counter62d90467_1a91_48a3_985a_68734a14cb85) );


voltageRail invert_clock_signal_enabledbc8b495_e758_44b6_ab44_7293f4bf8b59 ( 
                .data(HIGH), 
                .Q(invert_clock_signal_enable27ca165a_2bcc_4048_83cd_22e177db00dd) );


voltageRail clearPCe5234c5d_7f45_4731_ace2_ab9aefa06682 ( 
                .data(HIGH), 
                .Q(clearPC7ebaea00_400c_4004_b77c_ea7db63326e3) );


voltageRail ram_chipEnable2ee6b19b_0c4f_472a_8939_591bea7a6b7e ( 
                .data(LOW), 
                .Q(ram_chipEnable43d7cabe_4b0c_4478_b243_98b6d0bae8d5) );









nRegister #(.n(16)) comDataReg412c4a58_04b7_401f_aabf_ab157536ac99 ( 
                .data(allInputsFor412c4a58_04b7_401f_aabf_ab157536ac99_comDataReg), 
                .clock(clock[0]), 
                .enable(COMenableOn93e5ad32_e20d_458c_b27b_064e10e6ce9a[0]),
                 .Q(comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913) );



nRegister #(.n(16)) comStatusReg9b02a0fc_05fb_4c82_b4fb_290a3cf6017e ( 
                .data(allInputsFor9b02a0fc_05fb_4c82_b4fb_290a3cf6017e_comStatusReg), 
                .clock(clock[0]), 
                .enable(COMenableOn93e5ad32_e20d_458c_b27b_064e10e6ce9a[0]),
                 .Q(comStatusRega99faafb_72c4_4bf1_b5d5_30c38e57b20c) );




inverter invert_clock_signaldf8499ff_e727_48c6_963f_0a10e2003ffd ( 
                .data(clock[0]), 
                .Q(invert_clock_signal4e9c149b_9bd8_4ff2_aa48_41b84bd491f4), 
                .outputEnable(invert_clock_signal_enable27ca165a_2bcc_4048_83cd_22e177db00dd[0]) );


binaryCounter #(.n(3)) microcode_step_counterb30f91a2_7b30_44ab_91b5_753aae7d4816 (
                .D(UNCONNECTED),
                .clr_(invert_clock_signal_enable27ca165a_2bcc_4048_83cd_22e177db00dd[0]),
                .load_(load_disabled769243e5_244e_4583_8925_efc9cee2141b[0]),
                .clock(invert_clock_signal4e9c149b_9bd8_4ff2_aa48_41b84bd491f4[0]),
                .enable1_(count_enable_microcode_counter62d90467_1a91_48a3_985a_68734a14cb85[0]),
                .enable2_(count_enable_microcode_counter62d90467_1a91_48a3_985a_68734a14cb85[0]),
                .Q(microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c));


inverter decodeInverterad1f743d_7aa6_4714_adaf_118d8fbda0c8 ( 
                .data(microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[2]), 
                .Q(decodeInverter28beb87a_b7e8_47d1_8482_eb2beba6c61f), 
                .outputEnable(invert_clock_signal_enable27ca165a_2bcc_4048_83cd_22e177db00dd[0]) );







twoLineToFourLineDecoder decoder209106207_7335_4938_ba28_2069fa0105f3 (
                 microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[0],
                  microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[1],
                   microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[2],
                    decoder259751554_9371_4837_a4bd_74a67b492d53,
                    decoder275f58661_9a8a_48fe_a356_474bba284bb4,
                    decoder28dcca1d1_434d_41b6_94bb_667ace851be8,
                    decoder2cd59b37c_edec_4033_a98a_cccd74f09a57);





twoLineToFourLineDecoder decoder11c2522c3_3318_47dc_a610_93fab1a1ec58 (
                 microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[0],
                  microcode_step_counterc48042f9_25b2_4575_b94d_8a9965eb044c[1],
                   decodeInverter28beb87a_b7e8_47d1_8482_eb2beba6c61f[0],
                    decoder11b433644_ff3c_4221_ac58_d527aef57277,
                    decoder1e82116da_4230_4397_a137_2398c47f6963,
                    decoder11f749edf_ce8e_4087_9d43_d6bfc6e025a1,
                    decoder176a4d8dc_9a56_419f_802c_52c92b8f5883);


binaryCounter #(.n(16)) Program_Countercc531777_b6ba_42a0_88fb_5723be05140a (
                .D(main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f),
                .clr_(clearPC7ebaea00_400c_4004_b77c_ea7db63326e3[0]),
                .load_(loadInverterfd984bdc_1781_48f8_ab76_48a67c718d4d[0]),
                .clock(clock[0]),
                .enable1_(countEnableInverter6460f522_088d_4350_8f14_437b2cfd13bb[0]),
                .enable2_(countEnableInverter6460f522_088d_4350_8f14_437b2cfd13bb[0]),
                .Q(Program_Counter7ed6dce4_0718_46c0_89d2_a70136b5f6d5));



nBuffer  #(.n(16)) pc_bufferee01ae1f_d5f8_4280_8b01_b0b092a14fa6 (
                  .data(allInputsForee01ae1f_d5f8_4280_8b01_b0b092a14fa6_pc_buffer),
                  .Q(pc_buffer92c6ddaf_f374_4eac_aec1_c429d94d2402), 
                  .outputEnable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[4]) );




bus_mux #(.bus_count(7),.mux_width(16)) main_busbd178d74_f423_43ab_be76_04ffb5cded6f (
                .selects(allSelectsForbd178d74_f423_43ab_be76_04ffb5cded6f_main_bus),
                .data_in(allInputsForbd178d74_f423_43ab_be76_04ffb5cded6f_main_bus),
                .data_out(main_bus0cf65478_5900_4fc6_aa9d_b902a761c87f));



nRegister #(.n(16)) instruction_register014c93c2_5c15_4f64_9bfc_3bf926daf322 ( 
                .data(allInputsFor014c93c2_5c15_4f64_9bfc_3bf926daf322_instruction_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[2]),
                 .Q(instruction_register3ab4c5a7_e4b4_4421_8b8c_f2f7a56f37a2) );




staticRamDiscretePorts #(.ROMFILE("microcode.mem"),.DATA_WIDTH(32),.ADDR_WIDTH(8)) microcode_roma5772c60_7eaf_4921_b8c9_eb59de74a47e (
                 .address(allAddressInputsFora5772c60_7eaf_4921_b8c9_eb59de74a47e_microcode_rom),
                  .data(allDataInputsFora5772c60_7eaf_4921_b8c9_eb59de74a47e_microcode_rom), 
                  .cs_(eepromChipEnablea930e9f4_4938_4f91_a44b_167413eee42c[0]),
                   .we_(eepromWriteDisableda6cc829e_fefc_4df6_8f28_1b47f4d3f3f4[0]),
                   .oe_(eepromOutEnable0062137e_6d0f_4476_81fc_855fa66662b3[0]),
                    .clock(ClockFaster[0]),
                   .Q(microcode_rom2a319154_0758_49a4_a6d6_5bb0d9d38594));



nBuffer  #(.n(32)) microCode_SIGNAL_bankdad9a175_6292_4ca2_818a_1c9d542c9ab6 (
                  .data(allInputsFordad9a175_6292_4ca2_818a_1c9d542c9ab6_microCode_SIGNAL_bank),
                  .Q(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406), 
                  .outputEnable(signalBankOutputOn5ac24d9e_c152_49fe_b6d2_c5bc8090fdec[0]) );



nBuffer  #(.n(16)) comDataRegBuffer55a0e51e_84c2_4863_9f9d_6cccb13a5177 (
                  .data(allInputsFor55a0e51e_84c2_4863_9f9d_6cccb13a5177_comDataRegBuffer),
                  .Q(comDataRegBuffer21ea835a_63b9_4574_98fb_a4be52cd1ac5), 
                  .outputEnable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[25]) );



nRegister #(.n(16)) comControlReg94e9285f_17d0_49e4_bf2e_a90c6824f615 ( 
                .data(allInputsFor94e9285f_17d0_49e4_bf2e_a90c6824f615_comControlReg), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[24]),
                 .Q(comControlRegbf6bc3e4_70a7_4969_9da3_b7c3fcdb3f18) );




SPIComPart #(.n(16)) spi_test69b922cf_3a0f_4e18_b2b8_27c92ef872e2 (
                .i_controlReg(AllControlInputsFor69b922cf_3a0f_4e18_b2b8_27c92ef872e2_spi_test),
                .o_dataReg(spi_testc2cfff6f_0da1_46fa_aab8_75084e122133),
                .o_statReg(spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799),
                .i_serial(SERIALIN),
                .o_enable(ENABLEOUT),
                .o_clock(CLOCKOUT),
               .i_clk(CLK));



nBuffer  #(.n(16)) comStatusRegBuffer66dd9ed3_f32c_4a55_a51f_b703c910f212 (
                  .data(allInputsFor66dd9ed3_f32c_4a55_a51f_b703c910f212_comStatusRegBuffer),
                  .Q(comStatusRegBufferebe516de_8a9a_4e8f_a1ad_905e441e79c2), 
                  .outputEnable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[23]) );


inverter countEnableInverter9e12c000_aad2_493d_ae49_8f810eb18ab3 ( 
                .data(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[6]), 
                .Q(countEnableInverter6460f522_088d_4350_8f14_437b2cfd13bb), 
                .outputEnable(invertOn19e7aa60_d875_4b7e_a1be_69832c1069dd[0]) );


inverter ramOutInverter57d5c73b_6d61_4128_a4fb_631e34e45621 ( 
                .data(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[1]), 
                .Q(ramOutInverter6702f03d_ff50_4f9e_9b53_8669861592f7), 
                .outputEnable(invertOn19e7aa60_d875_4b7e_a1be_69832c1069dd[0]) );


inverter ramInInvertere76668ac_e412_445d_9151_42c4bb66302f ( 
                .data(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[0]), 
                .Q(ramInInverter7db13039_fe8f_4d11_9b2d_0197b2548a9b), 
                .outputEnable(invertOn19e7aa60_d875_4b7e_a1be_69832c1069dd[0]) );



nRegister #(.n(16)) memory_address_register069d9a3f_d99a_4ac5_bbe8_cf7dd246efb7 ( 
                .data(allInputsFor069d9a3f_d99a_4ac5_bbe8_cf7dd246efb7_memory_address_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[18]),
                 .Q(memory_address_registerb96856fa_ecdd_478a_92e9_d64da17e0991) );






dualPortStaticRam #(.ROMFILE("staticram.mem"),.DATA_WIDTH(16),.ADDR_WIDTH(16)) main_ram3dd2c77a_5ecd_4a00_8c2a_d303178e59ea (
                .address_1(allAddress1InputsFor3dd2c77a_5ecd_4a00_8c2a_d303178e59ea_main_ram),
                .address_2(allAddress2InputsFor3dd2c77a_5ecd_4a00_8c2a_d303178e59ea_main_ram),
                 .data(allDataInputsFor3dd2c77a_5ecd_4a00_8c2a_d303178e59ea_main_ram), 
                 .cs_(ram_chipEnable43d7cabe_4b0c_4478_b243_98b6d0bae8d5[0]),
                  .we_(ramInInverter7db13039_fe8f_4d11_9b2d_0197b2548a9b[0]),
                  .oe_(ramOutInverter6702f03d_ff50_4f9e_9b53_8669861592f7[0]),
                  .clock(ClockFaster[0]),
                  .clock2(ClockFaster[0]),
                  .Q_1(main_rama8f06042_bc1f_4f6a_bce0_bd4cb3a98f61),
                  .Q_2(main_ram853ef005_a0ed_483e_82f5_58840b92f31d));



nBuffer  #(.n(16)) ram_output_buffer36b0b893_f5e5_4558_aaa4_9eff276ffb81 (
                  .data(allInputsFor36b0b893_f5e5_4558_aaa4_9eff276ffb81_ram_output_buffer),
                  .Q(ram_output_buffer1992aa6d_b3d6_4bcb_bc23_60e1fc5721b2), 
                  .outputEnable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[1]) );



nRegister #(.n(16)) OUT_registerbf4f5ce0_55aa_4c9a_87be_12c510cef0d1 ( 
                .data(allInputsForbf4f5ce0_55aa_4c9a_87be_12c510cef0d1_OUT_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[16]),
                 .Q(OUT_registercc60b3a9_54ff_42c1_9019_03c4a115ca7c) );



nRegister #(.n(16)) B_register12daeb20_d118_478b_9401_acab32f3ec08 ( 
                .data(allInputsFor12daeb20_d118_478b_9401_acab32f3ec08_B_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[14]),
                 .Q(B_register0840e4cd_9d81_496b_8162_5a4881cbaa31) );



nBuffer  #(.n(16)) B_reg_buffer04f7e35d_2489_415e_a489_273c3a3c416f (
                  .data(allInputsFor04f7e35d_2489_415e_a489_273c3a3c416f_B_reg_buffer),
                  .Q(B_reg_bufferd36a8dab_b0ff_487b_b672_a031add40457), 
                  .outputEnable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[15]) );



nRegister #(.n(16)) A_register0995da8d_3e84_40ee_a304_e9a24eabc4ce ( 
                .data(allInputsFor0995da8d_3e84_40ee_a304_e9a24eabc4ce_A_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[7]),
                 .Q(A_register3800747a_213b_4d90_8ac3_69c57425d437) );





nbitComparator #(.n(16)) A_B_Comparatorf864afdb_f350_4fa9_8dd3_3392317dc80e (
                .a(allADataInputsForf864afdb_f350_4fa9_8dd3_3392317dc80e_A_B_Comparator),
                .b(allBDataInputsForf864afdb_f350_4fa9_8dd3_3392317dc80e_A_B_Comparator),
                .equal(A_B_Comparatorc056cd2e_208a_4a97_be45_8c095d4f011d),
                .lower(A_B_Comparator9efc3425_d274_4523_8d58_94efe347f335));


inverter invertALESSBcaf3b603_d561_47a6_a8ca_5122cf3fcaa4 ( 
                .data(A_B_Comparator9efc3425_d274_4523_8d58_94efe347f335[0]), 
                .Q(invertALESSB6fd24131_0d1b_4238_8a42_3de605fe852d), 
                .outputEnable(invertON54ebb284_ab40_4830_8e98_94eae224c9c9[0]) );


inverter invertAEQUALB359bf547_6760_473d_8745_0f178d4367d2 ( 
                .data(A_B_Comparatorc056cd2e_208a_4a97_be45_8c095d4f011d[0]), 
                .Q(invertAEQUALB3b8d3052_62ae_4497_b22f_4e5aec16a038), 
                .outputEnable(invertON54ebb284_ab40_4830_8e98_94eae224c9c9[0]) );


ANDGATE AGREATERB9799c31a_f373_46f6_8967_bb2777650cee ( 
                invertAEQUALB3b8d3052_62ae_4497_b22f_4e5aec16a038[0], 
                invertALESSB6fd24131_0d1b_4238_8a42_3de605fe852d[0], 
                AGREATERBaa9dc33c_9a06_4ae1_bc55_b3b5c78caa01 );



nRegister #(.n(4)) flags_register14a3e01e_f4c5_4989_9603_d0cdb9148917 ( 
                .data(allInputsFor14a3e01e_f4c5_4989_9603_d0cdb9148917_flags_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[22]),
                 .Q(flags_registerdbdcf886_6b09_4210_bc6b_d465542a4de6) );


ANDGATE ANDALESSB9b3640f3_15d5_4f54_9287_d5313313c26d ( 
                flags_registerdbdcf886_6b09_4210_bc6b_d465542a4de6[2], 
                microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[19], 
                ANDALESSBd1d79197_a2fa_49f6_b608_0b15bf63e6e1 );


ANDGATE ANDAEQUALBbf1e1bc7_9a83_4b47_a646_6a811eb3600f ( 
                flags_registerdbdcf886_6b09_4210_bc6b_d465542a4de6[1], 
                microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[20], 
                ANDAEQUALBf73549e9_d3ce_4bac_8928_bf005199b226 );


ANDGATE ANDAGB2a752c30_b696_49f4_b534_bbe20962863c ( 
                flags_registerdbdcf886_6b09_4210_bc6b_d465542a4de6[0], 
                microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[21], 
                ANDAGBf01bd6b5_805d_4ff9_a16b_45991aa7545a );


ORGATE OR167051297_ff7d_4965_9f2a_cc089a19e253 ( 
                ANDAGBf01bd6b5_805d_4ff9_a16b_45991aa7545a[0], 
                ANDAEQUALBf73549e9_d3ce_4bac_8928_bf005199b226[0],
                OR16d52a9b1_245a_4238_8c59_33756deb13ef);


ORGATE OR2ca5473e2_05c6_47bb_9490_3653d1c80d0d ( 
                OR16d52a9b1_245a_4238_8c59_33756deb13ef[0], 
                ANDALESSBd1d79197_a2fa_49f6_b608_0b15bf63e6e1[0],
                OR2c016bf6c_901b_4d0c_8818_c45a92395e98);


inverter loadInvertera49692af_11be_4298_b88a_05829af9ac56 ( 
                .data(OR2c016bf6c_901b_4d0c_8818_c45a92395e98[0]), 
                .Q(loadInverterfd984bdc_1781_48f8_ab76_48a67c718d4d), 
                .outputEnable(invertON54ebb284_ab40_4830_8e98_94eae224c9c9[0]) );



nBuffer  #(.n(16)) A_reg_buffer55550418_c754_4c48_82f9_ab1f49fe39e5 (
                  .data(allInputsFor55550418_c754_4c48_82f9_ab1f49fe39e5_A_reg_buffer),
                  .Q(A_reg_buffer9c092306_9829_4776_809f_63d5a36c6181), 
                  .outputEnable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[8]) );






nbitALU #(.n(16)) adder587e1c6a_68b8_4cc4_b11d_b945f329dfc4 (
                .mode(allDataForMode587e1c6a_68b8_4cc4_b11d_b945f329dfc4_adder),
                .x(allADataInputsFor587e1c6a_68b8_4cc4_b11d_b945f329dfc4_adder),
                .y(allBDataInputsFor587e1c6a_68b8_4cc4_b11d_b945f329dfc4_adder),
                .out(adderdd09da2c_9e81_4e42_b38c_25d01bba4ec5),
                .cout(adder3a143945_31f7_4610_ae35_0f9393574f6e));



nBuffer  #(.n(16)) adder_buffer7b825143_a913_4504_99c3_aab5033403b3 (
                  .data(allInputsFor7b825143_a913_4504_99c3_aab5033403b3_adder_buffer),
                  .Q(adder_buffer97f73335_d941_4b60_9b1c_e3f30002c42a), 
                  .outputEnable(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[9]) );





vgaSignalGenerator sigGenaf5f0cb8_1872_4de2_8cd7_1a186a23e66e (
                .i_clk(CLK),
                .i_pix_stb(pix_stb),
                .o_hs(sigGen227ec629_2c89_47c1_8b8a_2f48c6c8cc69),
                .o_vs(sigGen58628296_9704_4a0e_894c_e563501704b8),
                .o_x(sigGen5e06e10b_db18_4804_933c_00d2501780a9),
                .o_y(sigGen4e62b71e_a806_42c2_a4cf_a5a4ac230863)
            );
            
         assign VGA_HS_O = sigGen227ec629_2c89_47c1_8b8a_2f48c6c8cc69;
                      assign VGA_VS_O = sigGen58628296_9704_4a0e_894c_e563501704b8;
                      assign VGA_R = main_ram853ef005_a0ed_483e_82f5_58840b92f31d[0:3];
                      assign VGA_G = main_ram853ef005_a0ed_483e_82f5_58840b92f31d[4:7];
                      assign VGA_B = main_ram853ef005_a0ed_483e_82f5_58840b92f31d[8:11];
                      assign PIX_STRB = pix_stb;
                      

        reg [32:0] counter = 32'b0;
        reg [15:0] cnt;

            always @ (posedge CLK) 
            begin
            
                LED = OUT_registercc60b3a9_54ff_42c1_9019_03c4a115ca7c;
                RGB3_Red   = spi_testb30e98c2_3771_4b0c_a19d_ba35517ba799[15];
                OUT_AREG = comDataRegb62144ea_0203_4f34_a7b4_3584eabeb913[8:15];

                counter <= counter + 1;
                {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
                if(microCode_SIGNAL_bank569f267e_5f69_43a2_aa01_b10fbb04f406[17] == 0) begin
                clock[0] <= counter[8];
                end
               
                ClockFaster[0] <= counter[0];
               
            end

        endmodule
        