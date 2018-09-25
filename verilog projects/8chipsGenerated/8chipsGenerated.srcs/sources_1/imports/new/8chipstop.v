
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
          if (!cs_ && !we_) begin
               #1 $display("writing");
                       #1 $display("%d",address_1);
                      #1 $display("%d",data);
            mem[address_1] = data;
            end
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
                r2_pulse <= r1_pulse;
                r3_pulse <= r2_pulse;
               
               //start clocking out
                if((r2_pulse && !r3_pulse))begin
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
            output reg  [0:7] OUT_AREG) ; //debugging
               
            reg HIGH = 1;
            reg LOW = 0;
            reg SUBMODE = 0;
            reg UNCONNECTED = 0;

            reg [0:0]clock;
            reg [0:0]ClockFaster;
            reg pix_stb;
        
        
        wire [0:1-1] COMenableOnc3a85782_e2e0_4639_ac8a_9ce5bca64494;
wire [0:1-1] invertONdef2138c_5bdb_4a1f_b83b_0105d64a6713;
wire [0:1-1] signalBankOutputOn1a14a4da_840c_4e79_a85b_56d211fa6ff5;
wire [0:1-1] invertOn940cd0df_9440_441d_9ade_e002e62176bc;
wire [0:1-1] eepromChipEnableee2a7fc2_e908_4bf4_9e70_246d2c0aa8d3;
wire [0:1-1] eepromOutEnable84354f6f_aabe_4a16_a175_3c1a06391ee8;
wire [0:1-1] eepromWriteDisabled0d6fab58_aac8_4a39_9715_4059440820ae;
wire [0:1-1] load_disableda8be4d0a_e738_4280_9ecb_2dccfe072047;
wire [0:1-1] count_enable_microcode_counter2bf2cb35_b6ad_4a73_b4ff_461cafc32e71;
wire [0:1-1] invert_clock_signal_enablea83332fd_9d04_42c1_8608_0ab519e05e9e;
wire [0:1-1] clearPC80e12f3a_b0e3_4a07_b82a_a0028b0b638c;
wire [0:1-1] ram_chipEnablec606de19_5448_432f_bb4a_9524c7ad9c49;



wire [0:16-1] comDataRegd07c63fd_faea_4234_860a_56d17308e8d5;
wire [0:16-1] allInputsFord599ab72_75ab_45e9_a781_ab19010092e5= {spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[0],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[1],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[2],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[3],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[4],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[5],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[6],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[7],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[8],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[9],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[10],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[11],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[12],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[13],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[14],spi_testb2b3a930_fc5f_47b8_b45b_efeade294464[15]};
wire [0:16-1] comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d;
wire [0:16-1] allInputsFor831d6bd2_4f35_424e_834e_f51252d27ff0= {spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[0],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[1],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[2],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[3],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[4],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[5],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[6],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[7],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[8],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[9],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[10],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[11],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[12],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[13],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[14],spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[15]};

wire [0:1-1] invert_clock_signalb236601f_97ca_46ac_8417_e73c533fa21c;
wire [0:3-1] microcode_step_countere45279e6_3731_4073_8c48_3bb833485882;
wire [0:1-1] decodeInverterde002a2e_7251_488e_b3c2_ea6f4791603c;

wire decoder289d6f8db_a433_4119_8718_18cabb38b201;
wire decoder217253679_598b_45cd_8173_acd1cb38fd57;
wire decoder261a13d37_3bce_4d7b_8432_9ef2725b44e3;
wire decoder2a6ed30ee_fad2_40ea_8a18_e262ad4adb8c;
wire decoder1a3de65b0_c076_411d_8551_80946281b2de;
wire decoder150477a52_4743_4ee0_b689_5a37c3e02778;
wire decoder17235598b_b198_480f_a68a_b0b90c6c9444;
wire decoder1696580cd_cec7_4431_a264_c62a03e07289;
wire [0:16-1] Program_Counter1c341a13_6da5_44a9_b028_72be756161af;
wire [0:16-1] pc_buffer48bcfc7d_abef_43b0_8986_22232dffdffa;
wire [0:16-1] allInputsFor49723356_773a_40d7_b901_711c91add572= {Program_Counter1c341a13_6da5_44a9_b028_72be756161af[0],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[1],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[2],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[3],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[4],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[5],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[6],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[7],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[8],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[9],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[10],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[11],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[12],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[13],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[14],Program_Counter1c341a13_6da5_44a9_b028_72be756161af[15]};
wire [0:16-1] main_bus21eacba7_a403_4826_ad41_70185f7dc7a7;
wire [0:112-1] allInputsForbd72946f_bbdb_476d_bcd8_0916cfba57bd= {A_reg_buffer5d8f0526_6738_4d27_a515_087c610d4647,B_reg_buffer591c187f_37b8_4a1c_b28c_58e00009d245,adder_buffer332d6aea_f4f9_41dd_9c38_9c1fc2310755,ram_output_buffer8ea2b86a_486b_4320_8dac_cf964cb9c43d,pc_buffer48bcfc7d_abef_43b0_8986_22232dffdffa,comDataRegBufferf8f9dac3_f267_4f0c_9c1c_cd533f62eed4,comStatusRegBuffer18fd87f7_289e_4be0_a0ec_917d0b040e64};
wire [0:7-1] allSelectsForbd72946f_bbdb_476d_bcd8_0916cfba57bd= {microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[8],microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[15],microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[9],microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[1],microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[4],microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[25],microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[23]};
wire [0:16-1] instruction_register65677589_db75_4de8_a007_cbe7a34e0db6;
wire [0:16-1] allInputsFor945af85a_2d78_4093_be8b_e1cb3f43d6b0= {main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[0],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[1],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[2],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[3],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[4],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[5],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[6],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[7],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[8],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[9],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[10],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[11],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[12],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[13],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[14],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[15]};
wire [0:32-1] microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858;
wire [0:8-1] allAddressInputsFor501d374a_9172_497f_96a3_7d11b982fa92= {instruction_register65677589_db75_4de8_a007_cbe7a34e0db6[11],instruction_register65677589_db75_4de8_a007_cbe7a34e0db6[12],instruction_register65677589_db75_4de8_a007_cbe7a34e0db6[13],instruction_register65677589_db75_4de8_a007_cbe7a34e0db6[14],instruction_register65677589_db75_4de8_a007_cbe7a34e0db6[15],microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[0],microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[1],microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[2]};
wire [0:32-1] allDataInputsFor501d374a_9172_497f_96a3_7d11b982fa92= {UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED};
wire [0:32-1] microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691;
wire [0:32-1] allInputsFor90109ee4_4a46_4c7e_888e_669dfd173fbd= {microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[0],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[1],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[2],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[3],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[4],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[5],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[6],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[7],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[8],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[9],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[10],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[11],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[12],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[13],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[14],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[15],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[16],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[17],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[18],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[19],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[20],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[21],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[22],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[23],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[24],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[25],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[26],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[27],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[28],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[29],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[30],microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858[31]};
wire [0:16-1] comDataRegBufferf8f9dac3_f267_4f0c_9c1c_cd533f62eed4;
wire [0:16-1] allInputsFor0c2983d4_f1d8_4817_acf5_b1d99aa3747f= {comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[0],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[1],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[2],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[3],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[4],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[5],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[6],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[7],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[8],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[9],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[10],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[11],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[12],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[13],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[14],comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[15]};
wire [0:16-1] comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4;
wire [0:16-1] allInputsFor30345804_e089_409f_9881_14e3f5e3dce2= {main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[0],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[1],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[2],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[3],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[4],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[5],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[6],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[7],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[8],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[9],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[10],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[11],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[12],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[13],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[14],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[15]};
wire [0:16-1] spi_testb2b3a930_fc5f_47b8_b45b_efeade294464;
wire [0:16-1] spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae;
wire [0:16-1] AllControlInputsFordc728842_03ae_4852_a4e9_876efe18753a= {comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[0],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[1],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[2],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[3],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[4],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[5],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[6],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[7],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[8],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[9],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[10],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[11],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[12],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[13],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[14],comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4[15]};
wire [0:16-1] comStatusRegBuffer18fd87f7_289e_4be0_a0ec_917d0b040e64;
wire [0:16-1] allInputsForfd1ff0fd_41d9_4a20_8256_2bbd88129b64= {comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[0],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[1],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[2],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[3],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[4],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[5],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[6],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[7],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[8],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[9],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[10],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[11],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[12],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[13],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[14],comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d[15]};
wire [0:1-1] countEnableInverter9235f07f_22e4_443c_861a_d435b2e6074e;
wire [0:1-1] ramOutInverter46f6784d_9768_4d7b_99b8_3c2eb57e6b13;
wire [0:1-1] ramInInverter9dc5a0ef_0abb_4526_bc0c_ca500aae0311;
wire [0:16-1] memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8;
wire [0:16-1] allInputsForee43d09e_e8ae_4eba_9cc9_c8eb5db712b6= {main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[0],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[1],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[2],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[3],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[4],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[5],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[6],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[7],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[8],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[9],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[10],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[11],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[12],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[13],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[14],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[15]};
wire [0:16-1] main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd;
wire [0:16-1] main_ram1f517116_4526_48df_ac19_1d8c75147dd4;
wire [0:16-1] allAddress1InputsForad144c31_5eab_45d0_93f7_15625fc502f8= {memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[0],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[1],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[2],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[3],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[4],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[5],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[6],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[7],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[8],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[9],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[10],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[11],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[12],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[13],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[14],memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8[15]};
wire [0:16-1] allAddress2InputsForad144c31_5eab_45d0_93f7_15625fc502f8= {UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED};
wire [0:16-1] allDataInputsForad144c31_5eab_45d0_93f7_15625fc502f8= {main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[0],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[1],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[2],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[3],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[4],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[5],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[6],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[7],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[8],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[9],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[10],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[11],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[12],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[13],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[14],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[15]};
wire [0:16-1] ram_output_buffer8ea2b86a_486b_4320_8dac_cf964cb9c43d;
wire [0:16-1] allInputsFor65bc6be6_f2ce_49d7_a3d4_4fe6d53aab33= {main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[0],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[1],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[2],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[3],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[4],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[5],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[6],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[7],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[8],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[9],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[10],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[11],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[12],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[13],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[14],main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd[15]};
wire [0:16-1] OUT_register0ae9533e_37a1_4cf7_b5d3_ee3e51eae0a4;
wire [0:16-1] allInputsFor450cfe1a_084a_4337_8446_6a1c8377a57b= {main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[0],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[1],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[2],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[3],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[4],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[5],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[6],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[7],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[8],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[9],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[10],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[11],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[12],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[13],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[14],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[15]};
wire [0:16-1] B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272;
wire [0:16-1] allInputsForabbfa68e_bc26_4f96_aa3d_767b3679170d= {main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[0],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[1],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[2],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[3],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[4],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[5],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[6],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[7],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[8],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[9],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[10],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[11],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[12],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[13],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[14],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[15]};
wire [0:16-1] B_reg_buffer591c187f_37b8_4a1c_b28c_58e00009d245;
wire [0:16-1] allInputsFor627b30dc_8429_4c41_837b_96330d47524c= {B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[0],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[1],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[2],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[3],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[4],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[5],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[6],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[7],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[8],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[9],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[10],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[11],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[12],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[13],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[14],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[15]};
wire [0:16-1] A_register2c04495b_d5ca_448a_9673_2e0ad353f509;
wire [0:16-1] allInputsFor72ee5950_1355_4ac0_9a56_d2d4fb2d6827= {main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[0],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[1],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[2],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[3],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[4],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[5],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[6],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[7],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[8],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[9],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[10],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[11],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[12],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[13],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[14],main_bus21eacba7_a403_4826_ad41_70185f7dc7a7[15]};
wire [0:0] A_B_Comparator92c9603a_8695_4901_92a5_61ae28886dab;
wire [0:16-1] allADataInputsFor5ed275b9_a827_4965_9b1b_342413460c6a= {A_register2c04495b_d5ca_448a_9673_2e0ad353f509[0],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[1],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[2],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[3],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[4],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[5],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[6],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[7],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[8],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[9],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[10],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[11],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[12],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[13],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[14],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[15]};
wire [0:16-1] allBDataInputsFor5ed275b9_a827_4965_9b1b_342413460c6a= {B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[0],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[1],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[2],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[3],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[4],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[5],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[6],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[7],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[8],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[9],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[10],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[11],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[12],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[13],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[14],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[15]};
wire [0:0] A_B_Comparator3f7f8a35_15cd_4a23_8f82_5ee1b0c13278;
wire [0:1-1] invertALESSB6642ecfb_095a_4504_b80e_65ea77ab0deb;
wire [0:1-1] invertAEQUALB6aec92d6_e96d_4082_9e9f_d3f8660df7e1;
wire [0:1-1] AGREATERB69084d4f_872b_4bd3_99e6_0ff8e97c9f68;
wire [0:4-1] flags_register31d51a31_fb68_4b6b_a011_c119149bf7bb;
wire [0:4-1] allInputsFor1e7e95fa_5b0a_482d_8f38_ee209a1a0f43= {AGREATERB69084d4f_872b_4bd3_99e6_0ff8e97c9f68[0],A_B_Comparator92c9603a_8695_4901_92a5_61ae28886dab[0],A_B_Comparator3f7f8a35_15cd_4a23_8f82_5ee1b0c13278[0],UNCONNECTED};
wire [0:1-1] ANDALESSB2a968654_5a96_40ff_b090_ce24535a6c39;
wire [0:1-1] ANDAEQUALB4d8c7a77_206f_46c0_a59a_7c4a62744d0f;
wire [0:1-1] ANDAGBd42780bb_52ee_46ab_9da1_5c5210599119;
wire [0:1-1] OR1eb7afeb0_f683_4b5e_ac00_f1a1215b4956;
wire [0:1-1] OR237a0ef81_a43e_4674_9fc9_d5aa6ff294d8;
wire [0:1-1] loadInverter506f3558_d72a_4e1f_a22b_5c5adb70e8b1;
wire [0:16-1] A_reg_buffer5d8f0526_6738_4d27_a515_087c610d4647;
wire [0:16-1] allInputsFor9face0ff_b07a_40cc_beb3_03e9c083f9a3= {A_register2c04495b_d5ca_448a_9673_2e0ad353f509[0],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[1],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[2],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[3],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[4],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[5],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[6],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[7],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[8],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[9],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[10],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[11],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[12],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[13],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[14],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[15]};
wire [0:16-1] adder5f681b73_8a1c_426e_bd44_583b3eeb2939;
wire adderff06cf60_1a40_4699_b825_e475f8399297;
wire [0:16-1] allADataInputsFordb5c05b3_3a6d_4a9b_8e0d_86f1013a348e= {A_register2c04495b_d5ca_448a_9673_2e0ad353f509[0],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[1],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[2],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[3],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[4],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[5],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[6],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[7],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[8],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[9],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[10],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[11],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[12],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[13],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[14],A_register2c04495b_d5ca_448a_9673_2e0ad353f509[15]};
wire [0:16-1] allBDataInputsFordb5c05b3_3a6d_4a9b_8e0d_86f1013a348e= {B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[0],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[1],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[2],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[3],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[4],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[5],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[6],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[7],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[8],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[9],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[10],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[11],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[12],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[13],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[14],B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272[15]};
wire [0:16-1] adder_buffer332d6aea_f4f9_41dd_9c38_9c1fc2310755;
wire [0:16-1] allInputsFor8dba51fd_129d_4412_819f_c315fe5f014a= {adder5f681b73_8a1c_426e_bd44_583b3eeb2939[0],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[1],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[2],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[3],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[4],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[5],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[6],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[7],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[8],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[9],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[10],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[11],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[12],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[13],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[14],adder5f681b73_8a1c_426e_bd44_583b3eeb2939[15]};
wire [0:10-1] sigGen7f0a4f9a_c4b3_4a7a_9311_c0f1ad8ae9c5;
wire [0:9-1] sigGenbd78ac15_d51a_47ff_a2e7_227f0acb9fdd;
wire sigGen47203e0a_5c3a_42a3_8caa_ea473a75ee52;
wire sigGen4a36c076_0de5_40bc_b28a_d1d029b05610;


voltageRail COMenableOne0a267f7_48b8_446d_8087_94720353fd07 ( 
                .data(HIGH), 
                .Q(COMenableOnc3a85782_e2e0_4639_ac8a_9ce5bca64494) );


voltageRail invertON26d00e84_dbf5_492e_b345_14e571abfb11 ( 
                .data(HIGH), 
                .Q(invertONdef2138c_5bdb_4a1f_b83b_0105d64a6713) );


voltageRail signalBankOutputOnd6b9ddb0_91c9_4b53_9846_30eaaad97a3b ( 
                .data(HIGH), 
                .Q(signalBankOutputOn1a14a4da_840c_4e79_a85b_56d211fa6ff5) );


voltageRail invertOnb997cb02_05d9_47eb_846a_4759586206ac ( 
                .data(HIGH), 
                .Q(invertOn940cd0df_9440_441d_9ade_e002e62176bc) );


voltageRail eepromChipEnableb18f16eb_bb23_4b83_94e7_bfefa9bc5d1a ( 
                .data(LOW), 
                .Q(eepromChipEnableee2a7fc2_e908_4bf4_9e70_246d2c0aa8d3) );


voltageRail eepromOutEnable8c497d97_c9cc_4a45_9af5_d51fdbbd6e6f ( 
                .data(LOW), 
                .Q(eepromOutEnable84354f6f_aabe_4a16_a175_3c1a06391ee8) );


voltageRail eepromWriteDisabled73334163_faa4_4a41_a9ac_8fcf2b93d97f ( 
                .data(HIGH), 
                .Q(eepromWriteDisabled0d6fab58_aac8_4a39_9715_4059440820ae) );


voltageRail load_disabled8b976b83_1ed2_4aab_bbdd_525b8526a88b ( 
                .data(HIGH), 
                .Q(load_disableda8be4d0a_e738_4280_9ecb_2dccfe072047) );


voltageRail count_enable_microcode_counter844451cd_d042_4ad5_a081_5d13f6b0b89c ( 
                .data(LOW), 
                .Q(count_enable_microcode_counter2bf2cb35_b6ad_4a73_b4ff_461cafc32e71) );


voltageRail invert_clock_signal_enable4e282fbf_19e6_44b9_ae17_ae9b49d1148b ( 
                .data(HIGH), 
                .Q(invert_clock_signal_enablea83332fd_9d04_42c1_8608_0ab519e05e9e) );


voltageRail clearPC97c59049_7b5d_4589_a6c6_d733c17c8e27 ( 
                .data(HIGH), 
                .Q(clearPC80e12f3a_b0e3_4a07_b82a_a0028b0b638c) );


voltageRail ram_chipEnable0f986f83_26e6_466d_b081_5b8bc365a001 ( 
                .data(LOW), 
                .Q(ram_chipEnablec606de19_5448_432f_bb4a_9524c7ad9c49) );









nRegister #(.n(16)) comDataRegd599ab72_75ab_45e9_a781_ab19010092e5 ( 
                .data(allInputsFord599ab72_75ab_45e9_a781_ab19010092e5), 
                .clock(clock[0]), 
                .enable(COMenableOnc3a85782_e2e0_4639_ac8a_9ce5bca64494[0]),
                 .Q(comDataRegd07c63fd_faea_4234_860a_56d17308e8d5) );



nRegister #(.n(16)) comStatusReg831d6bd2_4f35_424e_834e_f51252d27ff0 ( 
                .data(allInputsFor831d6bd2_4f35_424e_834e_f51252d27ff0), 
                .clock(clock[0]), 
                .enable(COMenableOnc3a85782_e2e0_4639_ac8a_9ce5bca64494[0]),
                 .Q(comStatusReg641d0b6b_46eb_4a3e_aaa7_2b841f7cbd6d) );




inverter invert_clock_signal40952150_db24_417c_a3d0_b092b4b4a5f4 ( 
                .data(clock[0]), 
                .Q(invert_clock_signalb236601f_97ca_46ac_8417_e73c533fa21c), 
                .outputEnable(invert_clock_signal_enablea83332fd_9d04_42c1_8608_0ab519e05e9e[0]) );


binaryCounter #(.n(3)) microcode_step_counterc33991a1_b929_4872_b815_7eaab37e1042 (
                .D(UNCONNECTED),
                .clr_(invert_clock_signal_enablea83332fd_9d04_42c1_8608_0ab519e05e9e[0]),
                .load_(load_disableda8be4d0a_e738_4280_9ecb_2dccfe072047[0]),
                .clock(invert_clock_signalb236601f_97ca_46ac_8417_e73c533fa21c[0]),
                .enable1_(count_enable_microcode_counter2bf2cb35_b6ad_4a73_b4ff_461cafc32e71[0]),
                .enable2_(count_enable_microcode_counter2bf2cb35_b6ad_4a73_b4ff_461cafc32e71[0]),
                .Q(microcode_step_countere45279e6_3731_4073_8c48_3bb833485882));


inverter decodeInverter9a4a44c6_a219_4666_9f0d_d1c7c580987f ( 
                .data(microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[2]), 
                .Q(decodeInverterde002a2e_7251_488e_b3c2_ea6f4791603c), 
                .outputEnable(invert_clock_signal_enablea83332fd_9d04_42c1_8608_0ab519e05e9e[0]) );







twoLineToFourLineDecoder decoder2beb564a6_bfc2_49a0_a9ca_710e150ea0a9 (
                 microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[0],
                  microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[1],
                   microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[2],
                    decoder289d6f8db_a433_4119_8718_18cabb38b201,
                    decoder217253679_598b_45cd_8173_acd1cb38fd57,
                    decoder261a13d37_3bce_4d7b_8432_9ef2725b44e3,
                    decoder2a6ed30ee_fad2_40ea_8a18_e262ad4adb8c);





twoLineToFourLineDecoder decoder158030c4e_31b9_440d_95e7_0f5042fe39d5 (
                 microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[0],
                  microcode_step_countere45279e6_3731_4073_8c48_3bb833485882[1],
                   decodeInverterde002a2e_7251_488e_b3c2_ea6f4791603c[0],
                    decoder1a3de65b0_c076_411d_8551_80946281b2de,
                    decoder150477a52_4743_4ee0_b689_5a37c3e02778,
                    decoder17235598b_b198_480f_a68a_b0b90c6c9444,
                    decoder1696580cd_cec7_4431_a264_c62a03e07289);


binaryCounter #(.n(16)) Program_Counter4f71d7ee_07a5_42db_9998_93fecc29ecc2 (
                .D(main_bus21eacba7_a403_4826_ad41_70185f7dc7a7),
                .clr_(clearPC80e12f3a_b0e3_4a07_b82a_a0028b0b638c[0]),
                .load_(loadInverter506f3558_d72a_4e1f_a22b_5c5adb70e8b1[0]),
                .clock(clock[0]),
                .enable1_(countEnableInverter9235f07f_22e4_443c_861a_d435b2e6074e[0]),
                .enable2_(countEnableInverter9235f07f_22e4_443c_861a_d435b2e6074e[0]),
                .Q(Program_Counter1c341a13_6da5_44a9_b028_72be756161af));



nBuffer  #(.n(16)) pc_buffer49723356_773a_40d7_b901_711c91add572 (
                  .data(allInputsFor49723356_773a_40d7_b901_711c91add572),
                  .Q(pc_buffer48bcfc7d_abef_43b0_8986_22232dffdffa), 
                  .outputEnable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[4]) );




bus_mux #(.bus_count(7),.mux_width(16)) main_busbd72946f_bbdb_476d_bcd8_0916cfba57bd (
                .selects(allSelectsForbd72946f_bbdb_476d_bcd8_0916cfba57bd),
                .data_in(allInputsForbd72946f_bbdb_476d_bcd8_0916cfba57bd),
                .data_out(main_bus21eacba7_a403_4826_ad41_70185f7dc7a7));



nRegister #(.n(16)) instruction_register945af85a_2d78_4093_be8b_e1cb3f43d6b0 ( 
                .data(allInputsFor945af85a_2d78_4093_be8b_e1cb3f43d6b0), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[2]),
                 .Q(instruction_register65677589_db75_4de8_a007_cbe7a34e0db6) );




staticRamDiscretePorts #(.ROMFILE("microcode.mem"),.DATA_WIDTH(32),.ADDR_WIDTH(8)) microcode_rom501d374a_9172_497f_96a3_7d11b982fa92 (
                 .address(allAddressInputsFor501d374a_9172_497f_96a3_7d11b982fa92),
                  .data(allDataInputsFor501d374a_9172_497f_96a3_7d11b982fa92), 
                  .cs_(eepromChipEnableee2a7fc2_e908_4bf4_9e70_246d2c0aa8d3[0]),
                   .we_(eepromWriteDisabled0d6fab58_aac8_4a39_9715_4059440820ae[0]),
                   .oe_(eepromOutEnable84354f6f_aabe_4a16_a175_3c1a06391ee8[0]),
                    .clock(ClockFaster[0]),
                   .Q(microcode_rom60998e5c_abe1_47c0_b628_2f81b7288858));



nBuffer  #(.n(32)) microCode_SIGNAL_bank90109ee4_4a46_4c7e_888e_669dfd173fbd (
                  .data(allInputsFor90109ee4_4a46_4c7e_888e_669dfd173fbd),
                  .Q(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691), 
                  .outputEnable(signalBankOutputOn1a14a4da_840c_4e79_a85b_56d211fa6ff5[0]) );



nBuffer  #(.n(16)) comDataRegBuffer0c2983d4_f1d8_4817_acf5_b1d99aa3747f (
                  .data(allInputsFor0c2983d4_f1d8_4817_acf5_b1d99aa3747f),
                  .Q(comDataRegBufferf8f9dac3_f267_4f0c_9c1c_cd533f62eed4), 
                  .outputEnable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[25]) );



nRegister #(.n(16)) comControlReg30345804_e089_409f_9881_14e3f5e3dce2 ( 
                .data(allInputsFor30345804_e089_409f_9881_14e3f5e3dce2), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[24]),
                 .Q(comControlReg3adc0e05_a9cb_474a_85f5_7d4e985abcd4) );




SPIComPart #(.n(16)) spi_testdc728842_03ae_4852_a4e9_876efe18753a (
                .i_controlReg(AllControlInputsFordc728842_03ae_4852_a4e9_876efe18753a),
                .o_dataReg(spi_testb2b3a930_fc5f_47b8_b45b_efeade294464),
                .o_statReg(spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae),
                .i_serial(SERIALIN),
                .o_enable(ENABLEOUT),
                .o_clock(CLOCKOUT),
               .i_clk(CLK));



nBuffer  #(.n(16)) comStatusRegBufferfd1ff0fd_41d9_4a20_8256_2bbd88129b64 (
                  .data(allInputsForfd1ff0fd_41d9_4a20_8256_2bbd88129b64),
                  .Q(comStatusRegBuffer18fd87f7_289e_4be0_a0ec_917d0b040e64), 
                  .outputEnable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[23]) );


inverter countEnableInverterf55dcb72_5e5f_48b3_94f6_901d6fa112c8 ( 
                .data(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[6]), 
                .Q(countEnableInverter9235f07f_22e4_443c_861a_d435b2e6074e), 
                .outputEnable(invertOn940cd0df_9440_441d_9ade_e002e62176bc[0]) );


inverter ramOutInvertera3ac5298_16dd_4a7f_b629_61514480ebbb ( 
                .data(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[1]), 
                .Q(ramOutInverter46f6784d_9768_4d7b_99b8_3c2eb57e6b13), 
                .outputEnable(invertOn940cd0df_9440_441d_9ade_e002e62176bc[0]) );


inverter ramInInverterd8131701_c47b_4e14_95bb_3e6c86a53f06 ( 
                .data(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[0]), 
                .Q(ramInInverter9dc5a0ef_0abb_4526_bc0c_ca500aae0311), 
                .outputEnable(invertOn940cd0df_9440_441d_9ade_e002e62176bc[0]) );



nRegister #(.n(16)) memory_address_registeree43d09e_e8ae_4eba_9cc9_c8eb5db712b6 ( 
                .data(allInputsForee43d09e_e8ae_4eba_9cc9_c8eb5db712b6), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[18]),
                 .Q(memory_address_register585f6d07_9d90_4ed1_812e_48d997c618a8) );






dualPortStaticRam #(.ROMFILE("staticram.mem"),.DATA_WIDTH(16),.ADDR_WIDTH(16)) main_ramad144c31_5eab_45d0_93f7_15625fc502f8 (
                .address_1(allAddress1InputsForad144c31_5eab_45d0_93f7_15625fc502f8),
                .address_2(allAddress2InputsForad144c31_5eab_45d0_93f7_15625fc502f8),
                 .data(allDataInputsForad144c31_5eab_45d0_93f7_15625fc502f8), 
                 .cs_(ram_chipEnablec606de19_5448_432f_bb4a_9524c7ad9c49[0]),
                  .we_(ramInInverter9dc5a0ef_0abb_4526_bc0c_ca500aae0311[0]),
                  .oe_(ramOutInverter46f6784d_9768_4d7b_99b8_3c2eb57e6b13[0]),
                  .clock(ClockFaster[0]),
                  .clock2(ClockFaster[0]),
                  .Q_1(main_ramdd2142a4_e9eb_479a_8996_910acf61fcbd),
                  .Q_2(main_ram1f517116_4526_48df_ac19_1d8c75147dd4));



nBuffer  #(.n(16)) ram_output_buffer65bc6be6_f2ce_49d7_a3d4_4fe6d53aab33 (
                  .data(allInputsFor65bc6be6_f2ce_49d7_a3d4_4fe6d53aab33),
                  .Q(ram_output_buffer8ea2b86a_486b_4320_8dac_cf964cb9c43d), 
                  .outputEnable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[1]) );



nRegister #(.n(16)) OUT_register450cfe1a_084a_4337_8446_6a1c8377a57b ( 
                .data(allInputsFor450cfe1a_084a_4337_8446_6a1c8377a57b), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[16]),
                 .Q(OUT_register0ae9533e_37a1_4cf7_b5d3_ee3e51eae0a4) );



nRegister #(.n(16)) B_registerabbfa68e_bc26_4f96_aa3d_767b3679170d ( 
                .data(allInputsForabbfa68e_bc26_4f96_aa3d_767b3679170d), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[14]),
                 .Q(B_registerfe884a39_9e8f_47f6_b404_ee0a936ed272) );



nBuffer  #(.n(16)) B_reg_buffer627b30dc_8429_4c41_837b_96330d47524c (
                  .data(allInputsFor627b30dc_8429_4c41_837b_96330d47524c),
                  .Q(B_reg_buffer591c187f_37b8_4a1c_b28c_58e00009d245), 
                  .outputEnable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[15]) );



nRegister #(.n(16)) A_register72ee5950_1355_4ac0_9a56_d2d4fb2d6827 ( 
                .data(allInputsFor72ee5950_1355_4ac0_9a56_d2d4fb2d6827), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[7]),
                 .Q(A_register2c04495b_d5ca_448a_9673_2e0ad353f509) );





nbitComparator #(.n(16)) A_B_Comparator5ed275b9_a827_4965_9b1b_342413460c6a (
                .a(allADataInputsFor5ed275b9_a827_4965_9b1b_342413460c6a),
                .b(allBDataInputsFor5ed275b9_a827_4965_9b1b_342413460c6a),
                .equal(A_B_Comparator92c9603a_8695_4901_92a5_61ae28886dab),
                .lower(A_B_Comparator3f7f8a35_15cd_4a23_8f82_5ee1b0c13278));


inverter invertALESSB2c8bf031_8f23_4d8a_abfa_186326927020 ( 
                .data(A_B_Comparator3f7f8a35_15cd_4a23_8f82_5ee1b0c13278[0]), 
                .Q(invertALESSB6642ecfb_095a_4504_b80e_65ea77ab0deb), 
                .outputEnable(invertONdef2138c_5bdb_4a1f_b83b_0105d64a6713[0]) );


inverter invertAEQUALB90c1338f_2add_41da_9ada_102b6b1447ba ( 
                .data(A_B_Comparator92c9603a_8695_4901_92a5_61ae28886dab[0]), 
                .Q(invertAEQUALB6aec92d6_e96d_4082_9e9f_d3f8660df7e1), 
                .outputEnable(invertONdef2138c_5bdb_4a1f_b83b_0105d64a6713[0]) );


ANDGATE AGREATERB50a58d0f_c5f8_4e13_beba_0c60c07b00f4 ( 
                invertAEQUALB6aec92d6_e96d_4082_9e9f_d3f8660df7e1[0], 
                invertALESSB6642ecfb_095a_4504_b80e_65ea77ab0deb[0], 
                AGREATERB69084d4f_872b_4bd3_99e6_0ff8e97c9f68 );



nRegister #(.n(4)) flags_register1e7e95fa_5b0a_482d_8f38_ee209a1a0f43 ( 
                .data(allInputsFor1e7e95fa_5b0a_482d_8f38_ee209a1a0f43), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[22]),
                 .Q(flags_register31d51a31_fb68_4b6b_a011_c119149bf7bb) );


ANDGATE ANDALESSB3215d35b_f3dd_40f7_8c26_31991e584387 ( 
                flags_register31d51a31_fb68_4b6b_a011_c119149bf7bb[2], 
                microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[19], 
                ANDALESSB2a968654_5a96_40ff_b090_ce24535a6c39 );


ANDGATE ANDAEQUALBa4c7210c_abaa_43d8_8415_15395ec3cfb7 ( 
                flags_register31d51a31_fb68_4b6b_a011_c119149bf7bb[1], 
                microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[20], 
                ANDAEQUALB4d8c7a77_206f_46c0_a59a_7c4a62744d0f );


ANDGATE ANDAGB1ab3bf93_3b1d_4541_8b86_1ebe9e8bbb81 ( 
                flags_register31d51a31_fb68_4b6b_a011_c119149bf7bb[0], 
                microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[21], 
                ANDAGBd42780bb_52ee_46ab_9da1_5c5210599119 );


ORGATE OR14b02fe43_7287_4e08_a911_4fc42ac20de6 ( 
                ANDAGBd42780bb_52ee_46ab_9da1_5c5210599119[0], 
                ANDAEQUALB4d8c7a77_206f_46c0_a59a_7c4a62744d0f[0],
                OR1eb7afeb0_f683_4b5e_ac00_f1a1215b4956);


ORGATE OR27f8fb59f_4b57_4286_a64b_e69b3f1ddc92 ( 
                OR1eb7afeb0_f683_4b5e_ac00_f1a1215b4956[0], 
                ANDALESSB2a968654_5a96_40ff_b090_ce24535a6c39[0],
                OR237a0ef81_a43e_4674_9fc9_d5aa6ff294d8);


inverter loadInverterec0e4160_3492_40e0_b107_de0e314ab68b ( 
                .data(OR237a0ef81_a43e_4674_9fc9_d5aa6ff294d8[0]), 
                .Q(loadInverter506f3558_d72a_4e1f_a22b_5c5adb70e8b1), 
                .outputEnable(invertONdef2138c_5bdb_4a1f_b83b_0105d64a6713[0]) );



nBuffer  #(.n(16)) A_reg_buffer9face0ff_b07a_40cc_beb3_03e9c083f9a3 (
                  .data(allInputsFor9face0ff_b07a_40cc_beb3_03e9c083f9a3),
                  .Q(A_reg_buffer5d8f0526_6738_4d27_a515_087c610d4647), 
                  .outputEnable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[8]) );





nbitAdder #(.n(16)) adderdb5c05b3_3a6d_4a9b_8e0d_86f1013a348e (
                 .sub(SUBMODE),
                .cin(UNCONNECTED),
                .x(allADataInputsFordb5c05b3_3a6d_4a9b_8e0d_86f1013a348e),
                .y(allBDataInputsFordb5c05b3_3a6d_4a9b_8e0d_86f1013a348e),
                .sum(adder5f681b73_8a1c_426e_bd44_583b3eeb2939),
                .cout(adderff06cf60_1a40_4699_b825_e475f8399297));



nBuffer  #(.n(16)) adder_buffer8dba51fd_129d_4412_819f_c315fe5f014a (
                  .data(allInputsFor8dba51fd_129d_4412_819f_c315fe5f014a),
                  .Q(adder_buffer332d6aea_f4f9_41dd_9c38_9c1fc2310755), 
                  .outputEnable(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[9]) );



/*

vgaSignalGenerator sigGenbd21f964_f65d_44fa_b709_5dd900129dc1 (
                .i_clk(clock[0]),
                .i_pix_stb(25MHZCLOCK),
                .o_hs(sigGen47203e0a_5c3a_42a3_8caa_ea473a75ee52),
                .o_vs(sigGen4a36c076_0de5_40bc_b28a_d1d029b05610),
                .o_x(sigGen7f0a4f9a_c4b3_4a7a_9311_c0f1ad8ae9c5),
                .o_y(sigGenbd78ac15_d51a_47ff_a2e7_227f0acb9fdd)
            );
*/
        reg [32:0] counter = 32'b0;
            always @ (posedge CLK) 
            begin

                   LED = OUT_register0ae9533e_37a1_4cf7_b5d3_ee3e51eae0a4;
                   RGB3_Red   = spi_testfced2bc9_a603_4bb2_ab78_17d1b97a11ae[15];
                   OUT_AREG = comDataRegd07c63fd_faea_4234_860a_56d17308e8d5[8:15];

                counter <= counter + 1;
                if(microCode_SIGNAL_bankf02248bf_b13e_4a2a_8d6c_1db5fc363691[17] == 0) begin
                clock[0] <= counter[14];
                end
                ClockFaster[0] <= counter[3];
               
            end

        endmodule
        