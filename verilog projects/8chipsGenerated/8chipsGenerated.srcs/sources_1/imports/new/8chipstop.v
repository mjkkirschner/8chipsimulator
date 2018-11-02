
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
                reg pix_stb = 0;

        
        
        wire [0:1-1] COMenableOna6ce3d3e_2799_42fd_b62c_941ebd3c3bc5;
wire [0:1-1] invertONd4dc9909_beb3_4517_bab6_b305ba85f881;
wire [0:1-1] signalBankOutputOn6390dfb5_c218_4453_b020_1adb140034d8;
wire [0:1-1] invertOn2ad9ae95_2552_4efb_89fb_3a3229f30394;
wire [0:1-1] eepromChipEnable3a7be011_4eeb_4357_bbee_2263e2edd2f2;
wire [0:1-1] eepromOutEnable48142b48_6297_4a61_8cd4_8b601e96412b;
wire [0:1-1] eepromWriteDisablede9b0c820_c4ca_4c2b_8f44_d2b42988bb58;
wire [0:1-1] load_disabledfca3419a_405b_47ba_ae74_397f8861f45c;
wire [0:1-1] count_enable_microcode_counter64270aad_7e56_4cf1_b13f_8786d462b7f4;
wire [0:1-1] invert_clock_signal_enabled5939afa_e831_467d_bc99_8ca02c85a595;
wire [0:1-1] clearPC9187ee38_7fa0_4534_949f_4f06021a5d1b;
wire [0:1-1] ram_chipEnable1a694d58_b217_46e0_b8e3_4e3659cfbf3a;



wire [0:16-1] comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9;
wire [0:16-1] allInputsFor4d8de3c1_c630_4839_91fb_e6edce08ef11_comDataReg= {spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[0],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[1],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[2],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[3],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[4],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[5],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[6],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[7],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[8],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[9],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[10],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[11],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[12],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[13],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[14],spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b[15]};
wire [0:16-1] comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759;
wire [0:16-1] allInputsFord9ab60e9_f786_421d_9383_fd8df6bc92d0_comStatusReg= {spi_testb3413355_1dce_42de_92f1_95ba91a08248[0],spi_testb3413355_1dce_42de_92f1_95ba91a08248[1],spi_testb3413355_1dce_42de_92f1_95ba91a08248[2],spi_testb3413355_1dce_42de_92f1_95ba91a08248[3],spi_testb3413355_1dce_42de_92f1_95ba91a08248[4],spi_testb3413355_1dce_42de_92f1_95ba91a08248[5],spi_testb3413355_1dce_42de_92f1_95ba91a08248[6],spi_testb3413355_1dce_42de_92f1_95ba91a08248[7],spi_testb3413355_1dce_42de_92f1_95ba91a08248[8],spi_testb3413355_1dce_42de_92f1_95ba91a08248[9],spi_testb3413355_1dce_42de_92f1_95ba91a08248[10],spi_testb3413355_1dce_42de_92f1_95ba91a08248[11],spi_testb3413355_1dce_42de_92f1_95ba91a08248[12],spi_testb3413355_1dce_42de_92f1_95ba91a08248[13],spi_testb3413355_1dce_42de_92f1_95ba91a08248[14],spi_testb3413355_1dce_42de_92f1_95ba91a08248[15]};

wire [0:1-1] invert_clock_signale7f23b2f_5905_4e19_ae45_0d40ded814b5;
wire [0:3-1] microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca;
wire [0:1-1] decodeInverterefa5749b_763d_42d5_a0fd_cae627dceac6;

wire decoder29a0bb26a_e858_4667_93c0_c0b4a5d2f07a;
wire decoder2cf4b4c70_6152_46c0_81d9_08575ba2dc78;
wire decoder298abaf74_87a2_441d_87b1_adb023db0706;
wire decoder25d2f6765_8e95_44dd_ba20_2d8079a1f81d;
wire decoder1f2b0fff7_2203_4c10_841d_63e0f9e6f639;
wire decoder1637298ab_dc89_4b89_8328_dc6337eb95e7;
wire decoder1db254d4c_2d97_4afa_8dd4_ed6debdda9fc;
wire decoder1188f3d0a_83a1_4a0a_a595_ba8c7a832dd3;
wire [0:16-1] Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc;
wire [0:16-1] pc_buffer56ae585a_7c60_4db5_aaf8_f503af608735;
wire [0:16-1] allInputsFor75c1064c_c0bb_46a2_84e3_9e4711358e9b_pc_buffer= {Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[0],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[1],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[2],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[3],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[4],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[5],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[6],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[7],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[8],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[9],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[10],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[11],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[12],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[13],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[14],Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc[15]};
wire [0:16-1] main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928;
wire [0:112-1] allInputsFord678947b_53c5_4d22_8722_bdf0e0f1783b_main_bus= {A_reg_bufferce95afe0_a007_4119_96d6_5e07d45124f6,B_reg_bufferae7cac2f_fcef_4397_a830_c400e5fe8b4b,adder_buffer76d54fe1_6c23_4ccd_b43c_b297a762963d,ram_output_buffer7f4e104d_0124_4dec_85d2_e843d2843366,pc_buffer56ae585a_7c60_4db5_aaf8_f503af608735,comDataRegBuffer6255fd38_cafe_4243_8c84_0c463cc5d552,comStatusRegBuffer3b66b407_2d91_4178_9c6b_0562e87d5cad};
wire [0:7-1] allSelectsFord678947b_53c5_4d22_8722_bdf0e0f1783b_main_bus= {microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[8],microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[15],microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[9],microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[1],microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[4],microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[25],microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[23]};
wire [0:16-1] instruction_registeref263682_c3c9_4070_8d84_84ab80338c8c;
wire [0:16-1] allInputsForde079a87_4200_4fd9_be8f_77620cb330d0_instruction_register= {main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[0],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[1],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[2],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[3],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[4],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[5],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[6],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[7],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[8],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[9],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[10],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[11],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[12],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[13],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[14],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[15]};
wire [0:32-1] microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825;
wire [0:8-1] allAddressInputsFor558fc34e_cb4f_4477_a6ce_3611c2137b04_microcode_rom= {instruction_registeref263682_c3c9_4070_8d84_84ab80338c8c[11],instruction_registeref263682_c3c9_4070_8d84_84ab80338c8c[12],instruction_registeref263682_c3c9_4070_8d84_84ab80338c8c[13],instruction_registeref263682_c3c9_4070_8d84_84ab80338c8c[14],instruction_registeref263682_c3c9_4070_8d84_84ab80338c8c[15],microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[0],microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[1],microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[2]};
wire [0:32-1] allDataInputsFor558fc34e_cb4f_4477_a6ce_3611c2137b04_microcode_rom= {UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED};
wire [0:32-1] microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73;
wire [0:32-1] allInputsFor42a7e49c_5b4a_4979_ab9d_6b4ffd802b04_microCode_SIGNAL_bank= {microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[0],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[1],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[2],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[3],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[4],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[5],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[6],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[7],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[8],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[9],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[10],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[11],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[12],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[13],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[14],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[15],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[16],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[17],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[18],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[19],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[20],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[21],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[22],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[23],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[24],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[25],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[26],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[27],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[28],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[29],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[30],microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825[31]};
wire [0:16-1] comDataRegBuffer6255fd38_cafe_4243_8c84_0c463cc5d552;
wire [0:16-1] allInputsForf0ad7468_0d74_409f_83d6_f91902afb7eb_comDataRegBuffer= {comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[0],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[1],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[2],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[3],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[4],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[5],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[6],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[7],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[8],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[9],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[10],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[11],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[12],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[13],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[14],comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[15]};
wire [0:16-1] comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf;
wire [0:16-1] allInputsForb56b4867_2ad5_4579_8909_580394c8ed16_comControlReg= {main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[0],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[1],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[2],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[3],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[4],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[5],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[6],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[7],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[8],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[9],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[10],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[11],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[12],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[13],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[14],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[15]};
wire [0:16-1] spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b;
wire [0:16-1] spi_testb3413355_1dce_42de_92f1_95ba91a08248;
wire [0:16-1] AllControlInputsFor59e32e52_f2fa_41d5_8595_63c5b93ae17a_spi_test= {comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[0],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[1],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[2],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[3],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[4],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[5],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[6],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[7],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[8],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[9],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[10],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[11],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[12],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[13],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[14],comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf[15]};
wire [0:16-1] comStatusRegBuffer3b66b407_2d91_4178_9c6b_0562e87d5cad;
wire [0:16-1] allInputsFor80be5f4c_c843_420d_b691_d747ab8b7c7c_comStatusRegBuffer= {comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[0],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[1],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[2],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[3],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[4],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[5],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[6],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[7],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[8],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[9],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[10],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[11],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[12],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[13],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[14],comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759[15]};
wire [0:1-1] countEnableInverterc657340d_09fb_40a8_9bb1_cff0a11805ff;
wire [0:1-1] ramOutInverter0980be50_239a_4cab_adbc_00e5c68f108c;
wire [0:1-1] ramInInverterf6e82919_c6f3_4ae5_a2bd_f4cce10a86bf;
wire [0:16-1] memory_address_register32e58028_e945_45bc_b2be_c34ba619063d;
wire [0:16-1] allInputsFor70382e12_73ff_4189_9b16_62bdecf528df_memory_address_register= {main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[0],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[1],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[2],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[3],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[4],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[5],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[6],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[7],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[8],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[9],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[10],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[11],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[12],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[13],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[14],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[15]};
wire [0:16-1] main_rama9781169_e25b_4053_87b7_81c917387ad5;
wire [0:16-1] main_rama79bcb85_fbf1_4744_9d2e_72e5e1a151c7;
wire [0:16-1] allAddress1InputsFor46401ae1_cdc0_4c5d_b2cb_3401abb0c018_main_ram= {memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[0],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[1],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[2],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[3],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[4],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[5],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[6],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[7],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[8],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[9],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[10],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[11],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[12],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[13],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[14],memory_address_register32e58028_e945_45bc_b2be_c34ba619063d[15]};
wire [0:16-1] allAddress2InputsFor46401ae1_cdc0_4c5d_b2cb_3401abb0c018_main_ram= {sigGen99308565_dedb_4212_82bc_6ed8eef6cb62[0:5],sigGen3905f924_d585_4385_83e1_0f6dc61906ff};
wire [0:16-1] allDataInputsFor46401ae1_cdc0_4c5d_b2cb_3401abb0c018_main_ram= {main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[0],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[1],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[2],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[3],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[4],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[5],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[6],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[7],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[8],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[9],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[10],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[11],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[12],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[13],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[14],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[15]};
wire [0:16-1] ram_output_buffer7f4e104d_0124_4dec_85d2_e843d2843366;
wire [0:16-1] allInputsForb537dbe8_5eb8_4bda_8afc_6e8e11081fc2_ram_output_buffer= {main_rama9781169_e25b_4053_87b7_81c917387ad5[0],main_rama9781169_e25b_4053_87b7_81c917387ad5[1],main_rama9781169_e25b_4053_87b7_81c917387ad5[2],main_rama9781169_e25b_4053_87b7_81c917387ad5[3],main_rama9781169_e25b_4053_87b7_81c917387ad5[4],main_rama9781169_e25b_4053_87b7_81c917387ad5[5],main_rama9781169_e25b_4053_87b7_81c917387ad5[6],main_rama9781169_e25b_4053_87b7_81c917387ad5[7],main_rama9781169_e25b_4053_87b7_81c917387ad5[8],main_rama9781169_e25b_4053_87b7_81c917387ad5[9],main_rama9781169_e25b_4053_87b7_81c917387ad5[10],main_rama9781169_e25b_4053_87b7_81c917387ad5[11],main_rama9781169_e25b_4053_87b7_81c917387ad5[12],main_rama9781169_e25b_4053_87b7_81c917387ad5[13],main_rama9781169_e25b_4053_87b7_81c917387ad5[14],main_rama9781169_e25b_4053_87b7_81c917387ad5[15]};
wire [0:16-1] OUT_registercada2531_4081_41e2_8c5f_8ce024d2c282;
wire [0:16-1] allInputsForb23150f3_85b2_479b_9f7b_abe20d7431cc_OUT_register= {main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[0],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[1],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[2],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[3],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[4],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[5],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[6],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[7],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[8],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[9],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[10],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[11],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[12],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[13],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[14],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[15]};
wire [0:16-1] B_registerae893324_23f0_4e4c_8849_42ce5b23373a;
wire [0:16-1] allInputsForb84f7fea_dbf6_4145_8db3_8bce2dde1ce1_B_register= {main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[0],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[1],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[2],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[3],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[4],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[5],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[6],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[7],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[8],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[9],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[10],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[11],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[12],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[13],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[14],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[15]};
wire [0:16-1] B_reg_bufferae7cac2f_fcef_4397_a830_c400e5fe8b4b;
wire [0:16-1] allInputsForfd5653c3_5395_4f49_9ef6_0a245a15d63e_B_reg_buffer= {B_registerae893324_23f0_4e4c_8849_42ce5b23373a[0],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[1],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[2],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[3],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[4],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[5],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[6],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[7],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[8],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[9],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[10],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[11],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[12],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[13],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[14],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[15]};
wire [0:16-1] A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60;
wire [0:16-1] allInputsFor91962c85_0244_4528_9d36_ae82fd552e9e_A_register= {main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[0],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[1],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[2],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[3],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[4],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[5],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[6],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[7],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[8],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[9],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[10],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[11],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[12],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[13],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[14],main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928[15]};
wire [0:0] A_B_Comparator95a9c70b_c0e7_432a_b0fe_c16124e3b0e0;
wire [0:16-1] allADataInputsForba7d753e_78c0_408c_a2bb_9528a64dfd8f_A_B_Comparator= {A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[0],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[1],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[2],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[3],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[4],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[5],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[6],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[7],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[8],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[9],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[10],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[11],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[12],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[13],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[14],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[15]};
wire [0:16-1] allBDataInputsForba7d753e_78c0_408c_a2bb_9528a64dfd8f_A_B_Comparator= {B_registerae893324_23f0_4e4c_8849_42ce5b23373a[0],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[1],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[2],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[3],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[4],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[5],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[6],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[7],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[8],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[9],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[10],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[11],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[12],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[13],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[14],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[15]};
wire [0:0] A_B_Comparator075b8e98_6b90_4a03_b997_41166450d8e1;
wire [0:1-1] invertALESSB797075a8_c1e9_4367_88d8_dfc628eaea79;
wire [0:1-1] invertAEQUALB6eca266d_9151_433a_b523_d0d96b46a86e;
wire [0:1-1] AGREATERBa6cf7035_0a0c_42a7_a3eb_57f27df1bd78;
wire [0:4-1] flags_register30fded88_1e6b_42d1_845a_76f7b332eba8;
wire [0:4-1] allInputsFor5c66143d_621e_4cfa_bc7c_d25c1117baed_flags_register= {AGREATERBa6cf7035_0a0c_42a7_a3eb_57f27df1bd78[0],A_B_Comparator95a9c70b_c0e7_432a_b0fe_c16124e3b0e0[0],A_B_Comparator075b8e98_6b90_4a03_b997_41166450d8e1[0],UNCONNECTED};
wire [0:1-1] ANDALESSBf4ef4104_6dfb_4dfd_bf36_d2d523f4e5ef;
wire [0:1-1] ANDAEQUALB21cc6361_65d1_45ae_8f25_c60fb2b82a10;
wire [0:1-1] ANDAGB9e610485_92b5_4184_9f0a_4edcbcb48652;
wire [0:1-1] OR12ffd1432_b7b2_4aa9_907b_8cd14946c938;
wire [0:1-1] OR231666e7c_6b9c_4eb7_8a28_e45419a329dc;
wire [0:1-1] loadInverter710986e6_3336_4b16_84fe_b767ef4ec548;
wire [0:16-1] A_reg_bufferce95afe0_a007_4119_96d6_5e07d45124f6;
wire [0:16-1] allInputsForea97df4c_3162_4ac4_87e3_93476beb9c2d_A_reg_buffer= {A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[0],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[1],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[2],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[3],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[4],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[5],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[6],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[7],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[8],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[9],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[10],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[11],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[12],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[13],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[14],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[15]};
wire [0:16-1] adder7abc65cd_1ac0_4824_a20e_1113780edd92;
wire adder05f17e67_7785_4ad1_98d7_e528c893e15d;
wire [0:16-1] allADataInputsFor79c2bc75_f760_4f9a_a79f_e125953379b7_adder= {A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[0],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[1],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[2],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[3],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[4],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[5],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[6],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[7],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[8],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[9],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[10],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[11],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[12],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[13],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[14],A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60[15]};
wire [0:16-1] allBDataInputsFor79c2bc75_f760_4f9a_a79f_e125953379b7_adder= {B_registerae893324_23f0_4e4c_8849_42ce5b23373a[0],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[1],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[2],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[3],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[4],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[5],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[6],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[7],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[8],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[9],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[10],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[11],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[12],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[13],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[14],B_registerae893324_23f0_4e4c_8849_42ce5b23373a[15]};
wire [0:16-1] adder_buffer76d54fe1_6c23_4ccd_b43c_b297a762963d;
wire [0:16-1] allInputsFor91e8fae8_cd81_4e89_a979_53d7d16ab13f_adder_buffer= {adder7abc65cd_1ac0_4824_a20e_1113780edd92[0],adder7abc65cd_1ac0_4824_a20e_1113780edd92[1],adder7abc65cd_1ac0_4824_a20e_1113780edd92[2],adder7abc65cd_1ac0_4824_a20e_1113780edd92[3],adder7abc65cd_1ac0_4824_a20e_1113780edd92[4],adder7abc65cd_1ac0_4824_a20e_1113780edd92[5],adder7abc65cd_1ac0_4824_a20e_1113780edd92[6],adder7abc65cd_1ac0_4824_a20e_1113780edd92[7],adder7abc65cd_1ac0_4824_a20e_1113780edd92[8],adder7abc65cd_1ac0_4824_a20e_1113780edd92[9],adder7abc65cd_1ac0_4824_a20e_1113780edd92[10],adder7abc65cd_1ac0_4824_a20e_1113780edd92[11],adder7abc65cd_1ac0_4824_a20e_1113780edd92[12],adder7abc65cd_1ac0_4824_a20e_1113780edd92[13],adder7abc65cd_1ac0_4824_a20e_1113780edd92[14],adder7abc65cd_1ac0_4824_a20e_1113780edd92[15]};
wire [0:10-1] sigGen3905f924_d585_4385_83e1_0f6dc61906ff;
wire [0:9-1] sigGen99308565_dedb_4212_82bc_6ed8eef6cb62;
wire sigGen535bef02_465d_40b1_a3ae_a1d4745f6b7d;
wire sigGencb62e8b5_684b_4e67_a8b0_f01f0e89de95;


voltageRail COMenableOn897b3c11_8c68_41fd_84f2_e7bd844f0a70 ( 
                .data(HIGH), 
                .Q(COMenableOna6ce3d3e_2799_42fd_b62c_941ebd3c3bc5) );


voltageRail invertON747c8201_9b31_479e_b62a_e2529d3e91ed ( 
                .data(HIGH), 
                .Q(invertONd4dc9909_beb3_4517_bab6_b305ba85f881) );


voltageRail signalBankOutputOnac175a32_740c_4f55_80ad_5c3ab8a7f153 ( 
                .data(HIGH), 
                .Q(signalBankOutputOn6390dfb5_c218_4453_b020_1adb140034d8) );


voltageRail invertOna01f287f_20dd_44b5_ad89_bc480c6337f4 ( 
                .data(HIGH), 
                .Q(invertOn2ad9ae95_2552_4efb_89fb_3a3229f30394) );


voltageRail eepromChipEnabled1298cd5_02cd_4618_adb5_866655e053db ( 
                .data(LOW), 
                .Q(eepromChipEnable3a7be011_4eeb_4357_bbee_2263e2edd2f2) );


voltageRail eepromOutEnable0341acef_eda1_48b3_a5c5_c281abfb9b29 ( 
                .data(LOW), 
                .Q(eepromOutEnable48142b48_6297_4a61_8cd4_8b601e96412b) );


voltageRail eepromWriteDisabledb7bd8463_066d_473a_8021_b659969efe4a ( 
                .data(HIGH), 
                .Q(eepromWriteDisablede9b0c820_c4ca_4c2b_8f44_d2b42988bb58) );


voltageRail load_disabled77b28bd6_c560_4711_b571_87b6baf8359e ( 
                .data(HIGH), 
                .Q(load_disabledfca3419a_405b_47ba_ae74_397f8861f45c) );


voltageRail count_enable_microcode_counter22666e8e_10fc_432c_8e8f_dfc1f6766f05 ( 
                .data(LOW), 
                .Q(count_enable_microcode_counter64270aad_7e56_4cf1_b13f_8786d462b7f4) );


voltageRail invert_clock_signal_enabled5b21e98_1fd4_44d4_95ee_44c3eb3fd19e ( 
                .data(HIGH), 
                .Q(invert_clock_signal_enabled5939afa_e831_467d_bc99_8ca02c85a595) );


voltageRail clearPC9c160c16_b4fe_498c_9072_82fc813b78ec ( 
                .data(HIGH), 
                .Q(clearPC9187ee38_7fa0_4534_949f_4f06021a5d1b) );


voltageRail ram_chipEnablea9dd6bfc_3fcc_40a8_a38b_452a2609685a ( 
                .data(LOW), 
                .Q(ram_chipEnable1a694d58_b217_46e0_b8e3_4e3659cfbf3a) );









nRegister #(.n(16)) comDataReg4d8de3c1_c630_4839_91fb_e6edce08ef11 ( 
                .data(allInputsFor4d8de3c1_c630_4839_91fb_e6edce08ef11_comDataReg), 
                .clock(clock[0]), 
                .enable(COMenableOna6ce3d3e_2799_42fd_b62c_941ebd3c3bc5[0]),
                 .Q(comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9) );



nRegister #(.n(16)) comStatusRegd9ab60e9_f786_421d_9383_fd8df6bc92d0 ( 
                .data(allInputsFord9ab60e9_f786_421d_9383_fd8df6bc92d0_comStatusReg), 
                .clock(clock[0]), 
                .enable(COMenableOna6ce3d3e_2799_42fd_b62c_941ebd3c3bc5[0]),
                 .Q(comStatusReg9ec25660_332c_4f6c_9f1f_b96f4b901759) );




inverter invert_clock_signale555f1b0_2389_4b56_8cea_22b9bb76af67 ( 
                .data(clock[0]), 
                .Q(invert_clock_signale7f23b2f_5905_4e19_ae45_0d40ded814b5), 
                .outputEnable(invert_clock_signal_enabled5939afa_e831_467d_bc99_8ca02c85a595[0]) );


binaryCounter #(.n(3)) microcode_step_counter22c6618a_e5cf_4b4f_9b92_178492c608fd (
                .D(UNCONNECTED),
                .clr_(invert_clock_signal_enabled5939afa_e831_467d_bc99_8ca02c85a595[0]),
                .load_(load_disabledfca3419a_405b_47ba_ae74_397f8861f45c[0]),
                .clock(invert_clock_signale7f23b2f_5905_4e19_ae45_0d40ded814b5[0]),
                .enable1_(count_enable_microcode_counter64270aad_7e56_4cf1_b13f_8786d462b7f4[0]),
                .enable2_(count_enable_microcode_counter64270aad_7e56_4cf1_b13f_8786d462b7f4[0]),
                .Q(microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca));


inverter decodeInverterc86f48cb_6f51_4bbc_9bff_91e041c8712c ( 
                .data(microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[2]), 
                .Q(decodeInverterefa5749b_763d_42d5_a0fd_cae627dceac6), 
                .outputEnable(invert_clock_signal_enabled5939afa_e831_467d_bc99_8ca02c85a595[0]) );







twoLineToFourLineDecoder decoder2cabc5332_9181_4387_bfdd_61e86b089b05 (
                 microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[0],
                  microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[1],
                   microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[2],
                    decoder29a0bb26a_e858_4667_93c0_c0b4a5d2f07a,
                    decoder2cf4b4c70_6152_46c0_81d9_08575ba2dc78,
                    decoder298abaf74_87a2_441d_87b1_adb023db0706,
                    decoder25d2f6765_8e95_44dd_ba20_2d8079a1f81d);





twoLineToFourLineDecoder decoder1927cb490_576c_408e_8f3f_685b967eaf32 (
                 microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[0],
                  microcode_step_counter22856748_8cc1_42c0_b081_e2a797fb83ca[1],
                   decodeInverterefa5749b_763d_42d5_a0fd_cae627dceac6[0],
                    decoder1f2b0fff7_2203_4c10_841d_63e0f9e6f639,
                    decoder1637298ab_dc89_4b89_8328_dc6337eb95e7,
                    decoder1db254d4c_2d97_4afa_8dd4_ed6debdda9fc,
                    decoder1188f3d0a_83a1_4a0a_a595_ba8c7a832dd3);


binaryCounter #(.n(16)) Program_Counter758ca93b_bb4e_42a6_9f88_5301aed9d53e (
                .D(main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928),
                .clr_(clearPC9187ee38_7fa0_4534_949f_4f06021a5d1b[0]),
                .load_(loadInverter710986e6_3336_4b16_84fe_b767ef4ec548[0]),
                .clock(clock[0]),
                .enable1_(countEnableInverterc657340d_09fb_40a8_9bb1_cff0a11805ff[0]),
                .enable2_(countEnableInverterc657340d_09fb_40a8_9bb1_cff0a11805ff[0]),
                .Q(Program_Counterf7d5952d_736d_4916_94b9_c84a48576fcc));



nBuffer  #(.n(16)) pc_buffer75c1064c_c0bb_46a2_84e3_9e4711358e9b (
                  .data(allInputsFor75c1064c_c0bb_46a2_84e3_9e4711358e9b_pc_buffer),
                  .Q(pc_buffer56ae585a_7c60_4db5_aaf8_f503af608735), 
                  .outputEnable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[4]) );




bus_mux #(.bus_count(7),.mux_width(16)) main_busd678947b_53c5_4d22_8722_bdf0e0f1783b (
                .selects(allSelectsFord678947b_53c5_4d22_8722_bdf0e0f1783b_main_bus),
                .data_in(allInputsFord678947b_53c5_4d22_8722_bdf0e0f1783b_main_bus),
                .data_out(main_bus500cefa6_0b9c_4eb7_90b5_f9dd9407e928));



nRegister #(.n(16)) instruction_registerde079a87_4200_4fd9_be8f_77620cb330d0 ( 
                .data(allInputsForde079a87_4200_4fd9_be8f_77620cb330d0_instruction_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[2]),
                 .Q(instruction_registeref263682_c3c9_4070_8d84_84ab80338c8c) );




staticRamDiscretePorts #(.ROMFILE("microcode.mem"),.DATA_WIDTH(32),.ADDR_WIDTH(8)) microcode_rom558fc34e_cb4f_4477_a6ce_3611c2137b04 (
                 .address(allAddressInputsFor558fc34e_cb4f_4477_a6ce_3611c2137b04_microcode_rom),
                  .data(allDataInputsFor558fc34e_cb4f_4477_a6ce_3611c2137b04_microcode_rom), 
                  .cs_(eepromChipEnable3a7be011_4eeb_4357_bbee_2263e2edd2f2[0]),
                   .we_(eepromWriteDisablede9b0c820_c4ca_4c2b_8f44_d2b42988bb58[0]),
                   .oe_(eepromOutEnable48142b48_6297_4a61_8cd4_8b601e96412b[0]),
                    .clock(ClockFaster[0]),
                   .Q(microcode_rom86f4dab6_1b83_4bda_b4cf_9327425da825));



nBuffer  #(.n(32)) microCode_SIGNAL_bank42a7e49c_5b4a_4979_ab9d_6b4ffd802b04 (
                  .data(allInputsFor42a7e49c_5b4a_4979_ab9d_6b4ffd802b04_microCode_SIGNAL_bank),
                  .Q(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73), 
                  .outputEnable(signalBankOutputOn6390dfb5_c218_4453_b020_1adb140034d8[0]) );



nBuffer  #(.n(16)) comDataRegBufferf0ad7468_0d74_409f_83d6_f91902afb7eb (
                  .data(allInputsForf0ad7468_0d74_409f_83d6_f91902afb7eb_comDataRegBuffer),
                  .Q(comDataRegBuffer6255fd38_cafe_4243_8c84_0c463cc5d552), 
                  .outputEnable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[25]) );



nRegister #(.n(16)) comControlRegb56b4867_2ad5_4579_8909_580394c8ed16 ( 
                .data(allInputsForb56b4867_2ad5_4579_8909_580394c8ed16_comControlReg), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[24]),
                 .Q(comControlRegaab69a2f_f9b5_4d1a_aa30_b827d85364bf) );




SPIComPart #(.n(16)) spi_test59e32e52_f2fa_41d5_8595_63c5b93ae17a (
                .i_controlReg(AllControlInputsFor59e32e52_f2fa_41d5_8595_63c5b93ae17a_spi_test),
                .o_dataReg(spi_test7d5c204c_5be6_4cf8_8573_8cae3425365b),
                .o_statReg(spi_testb3413355_1dce_42de_92f1_95ba91a08248),
                .i_serial(SERIALIN),
                .o_enable(ENABLEOUT),
                .o_clock(CLOCKOUT),
               .i_clk(CLK));



nBuffer  #(.n(16)) comStatusRegBuffer80be5f4c_c843_420d_b691_d747ab8b7c7c (
                  .data(allInputsFor80be5f4c_c843_420d_b691_d747ab8b7c7c_comStatusRegBuffer),
                  .Q(comStatusRegBuffer3b66b407_2d91_4178_9c6b_0562e87d5cad), 
                  .outputEnable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[23]) );


inverter countEnableInverterfed341c8_9cbf_4376_8b43_82f7c41e7ae5 ( 
                .data(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[6]), 
                .Q(countEnableInverterc657340d_09fb_40a8_9bb1_cff0a11805ff), 
                .outputEnable(invertOn2ad9ae95_2552_4efb_89fb_3a3229f30394[0]) );


inverter ramOutInverter5b9c68c8_9809_486e_bca8_48556e83c063 ( 
                .data(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[1]), 
                .Q(ramOutInverter0980be50_239a_4cab_adbc_00e5c68f108c), 
                .outputEnable(invertOn2ad9ae95_2552_4efb_89fb_3a3229f30394[0]) );


inverter ramInInverter15e236aa_be5d_4af1_acbd_1a7906d190d2 ( 
                .data(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[0]), 
                .Q(ramInInverterf6e82919_c6f3_4ae5_a2bd_f4cce10a86bf), 
                .outputEnable(invertOn2ad9ae95_2552_4efb_89fb_3a3229f30394[0]) );



nRegister #(.n(16)) memory_address_register70382e12_73ff_4189_9b16_62bdecf528df ( 
                .data(allInputsFor70382e12_73ff_4189_9b16_62bdecf528df_memory_address_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[18]),
                 .Q(memory_address_register32e58028_e945_45bc_b2be_c34ba619063d) );






dualPortStaticRam #(.ROMFILE("staticram.mem"),.DATA_WIDTH(16),.ADDR_WIDTH(16)) main_ram46401ae1_cdc0_4c5d_b2cb_3401abb0c018 (
                .address_1(allAddress1InputsFor46401ae1_cdc0_4c5d_b2cb_3401abb0c018_main_ram),
                .address_2(allAddress2InputsFor46401ae1_cdc0_4c5d_b2cb_3401abb0c018_main_ram),
                 .data(allDataInputsFor46401ae1_cdc0_4c5d_b2cb_3401abb0c018_main_ram), 
                 .cs_(ram_chipEnable1a694d58_b217_46e0_b8e3_4e3659cfbf3a[0]),
                  .we_(ramInInverterf6e82919_c6f3_4ae5_a2bd_f4cce10a86bf[0]),
                  .oe_(ramOutInverter0980be50_239a_4cab_adbc_00e5c68f108c[0]),
                  .clock(ClockFaster[0]),
                  .clock2(ClockFaster[0]),
                  .Q_1(main_rama9781169_e25b_4053_87b7_81c917387ad5),
                  .Q_2(main_rama79bcb85_fbf1_4744_9d2e_72e5e1a151c7));



nBuffer  #(.n(16)) ram_output_bufferb537dbe8_5eb8_4bda_8afc_6e8e11081fc2 (
                  .data(allInputsForb537dbe8_5eb8_4bda_8afc_6e8e11081fc2_ram_output_buffer),
                  .Q(ram_output_buffer7f4e104d_0124_4dec_85d2_e843d2843366), 
                  .outputEnable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[1]) );



nRegister #(.n(16)) OUT_registerb23150f3_85b2_479b_9f7b_abe20d7431cc ( 
                .data(allInputsForb23150f3_85b2_479b_9f7b_abe20d7431cc_OUT_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[16]),
                 .Q(OUT_registercada2531_4081_41e2_8c5f_8ce024d2c282) );



nRegister #(.n(16)) B_registerb84f7fea_dbf6_4145_8db3_8bce2dde1ce1 ( 
                .data(allInputsForb84f7fea_dbf6_4145_8db3_8bce2dde1ce1_B_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[14]),
                 .Q(B_registerae893324_23f0_4e4c_8849_42ce5b23373a) );



nBuffer  #(.n(16)) B_reg_bufferfd5653c3_5395_4f49_9ef6_0a245a15d63e (
                  .data(allInputsForfd5653c3_5395_4f49_9ef6_0a245a15d63e_B_reg_buffer),
                  .Q(B_reg_bufferae7cac2f_fcef_4397_a830_c400e5fe8b4b), 
                  .outputEnable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[15]) );



nRegister #(.n(16)) A_register91962c85_0244_4528_9d36_ae82fd552e9e ( 
                .data(allInputsFor91962c85_0244_4528_9d36_ae82fd552e9e_A_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[7]),
                 .Q(A_registerc9802523_a9d1_4181_bb88_f57aa3e9ef60) );





nbitComparator #(.n(16)) A_B_Comparatorba7d753e_78c0_408c_a2bb_9528a64dfd8f (
                .a(allADataInputsForba7d753e_78c0_408c_a2bb_9528a64dfd8f_A_B_Comparator),
                .b(allBDataInputsForba7d753e_78c0_408c_a2bb_9528a64dfd8f_A_B_Comparator),
                .equal(A_B_Comparator95a9c70b_c0e7_432a_b0fe_c16124e3b0e0),
                .lower(A_B_Comparator075b8e98_6b90_4a03_b997_41166450d8e1));


inverter invertALESSB6ce6bae7_c818_425e_b20c_b683eb016cc6 ( 
                .data(A_B_Comparator075b8e98_6b90_4a03_b997_41166450d8e1[0]), 
                .Q(invertALESSB797075a8_c1e9_4367_88d8_dfc628eaea79), 
                .outputEnable(invertONd4dc9909_beb3_4517_bab6_b305ba85f881[0]) );


inverter invertAEQUALB163b1a43_0821_4634_ade0_7cc48efe5197 ( 
                .data(A_B_Comparator95a9c70b_c0e7_432a_b0fe_c16124e3b0e0[0]), 
                .Q(invertAEQUALB6eca266d_9151_433a_b523_d0d96b46a86e), 
                .outputEnable(invertONd4dc9909_beb3_4517_bab6_b305ba85f881[0]) );


ANDGATE AGREATERBa0df0a4a_ee10_445c_9061_b91dd76e1620 ( 
                invertAEQUALB6eca266d_9151_433a_b523_d0d96b46a86e[0], 
                invertALESSB797075a8_c1e9_4367_88d8_dfc628eaea79[0], 
                AGREATERBa6cf7035_0a0c_42a7_a3eb_57f27df1bd78 );



nRegister #(.n(4)) flags_register5c66143d_621e_4cfa_bc7c_d25c1117baed ( 
                .data(allInputsFor5c66143d_621e_4cfa_bc7c_d25c1117baed_flags_register), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[22]),
                 .Q(flags_register30fded88_1e6b_42d1_845a_76f7b332eba8) );


ANDGATE ANDALESSBd84142c9_e36e_4520_a275_0da3a7e7bad7 ( 
                flags_register30fded88_1e6b_42d1_845a_76f7b332eba8[2], 
                microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[19], 
                ANDALESSBf4ef4104_6dfb_4dfd_bf36_d2d523f4e5ef );


ANDGATE ANDAEQUALBa5fb33ef_6ea4_4545_8f9b_be78feb41a92 ( 
                flags_register30fded88_1e6b_42d1_845a_76f7b332eba8[1], 
                microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[20], 
                ANDAEQUALB21cc6361_65d1_45ae_8f25_c60fb2b82a10 );


ANDGATE ANDAGB85f32e04_ea50_40c0_9486_18ffad89d7d3 ( 
                flags_register30fded88_1e6b_42d1_845a_76f7b332eba8[0], 
                microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[21], 
                ANDAGB9e610485_92b5_4184_9f0a_4edcbcb48652 );


ORGATE OR19385dfd2_4bc9_4e6c_b125_fd068a31fdfb ( 
                ANDAGB9e610485_92b5_4184_9f0a_4edcbcb48652[0], 
                ANDAEQUALB21cc6361_65d1_45ae_8f25_c60fb2b82a10[0],
                OR12ffd1432_b7b2_4aa9_907b_8cd14946c938);


ORGATE OR29f9a5dd4_5c18_4f17_8db4_1a51606aa344 ( 
                OR12ffd1432_b7b2_4aa9_907b_8cd14946c938[0], 
                ANDALESSBf4ef4104_6dfb_4dfd_bf36_d2d523f4e5ef[0],
                OR231666e7c_6b9c_4eb7_8a28_e45419a329dc);


inverter loadInverter9df66340_fcdd_4869_a9a5_671fbd7f4217 ( 
                .data(OR231666e7c_6b9c_4eb7_8a28_e45419a329dc[0]), 
                .Q(loadInverter710986e6_3336_4b16_84fe_b767ef4ec548), 
                .outputEnable(invertONd4dc9909_beb3_4517_bab6_b305ba85f881[0]) );



nBuffer  #(.n(16)) A_reg_bufferea97df4c_3162_4ac4_87e3_93476beb9c2d (
                  .data(allInputsForea97df4c_3162_4ac4_87e3_93476beb9c2d_A_reg_buffer),
                  .Q(A_reg_bufferce95afe0_a007_4119_96d6_5e07d45124f6), 
                  .outputEnable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[8]) );





nbitAdder #(.n(16)) adder79c2bc75_f760_4f9a_a79f_e125953379b7 (
                 .sub(SUBMODE),
                .cin(UNCONNECTED),
                .x(allADataInputsFor79c2bc75_f760_4f9a_a79f_e125953379b7_adder),
                .y(allBDataInputsFor79c2bc75_f760_4f9a_a79f_e125953379b7_adder),
                .sum(adder7abc65cd_1ac0_4824_a20e_1113780edd92),
                .cout(adder05f17e67_7785_4ad1_98d7_e528c893e15d));



nBuffer  #(.n(16)) adder_buffer91e8fae8_cd81_4e89_a979_53d7d16ab13f (
                  .data(allInputsFor91e8fae8_cd81_4e89_a979_53d7d16ab13f_adder_buffer),
                  .Q(adder_buffer76d54fe1_6c23_4ccd_b43c_b297a762963d), 
                  .outputEnable(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[9]) );




vgaSignalGenerator sigGen1ef2ddc2_efb0_44c6_b17b_873063e5c645 (
                .i_clk(CLK),
                .i_pix_stb(pix_stb),
                .o_hs(sigGen535bef02_465d_40b1_a3ae_a1d4745f6b7d),
                .o_vs(sigGencb62e8b5_684b_4e67_a8b0_f01f0e89de95),
                .o_x(sigGen3905f924_d585_4385_83e1_0f6dc61906ff),
                .o_y(sigGen99308565_dedb_4212_82bc_6ed8eef6cb62)
            );
            
            assign VGA_HS_O = sigGen535bef02_465d_40b1_a3ae_a1d4745f6b7d;
            assign VGA_VS_O = sigGencb62e8b5_684b_4e67_a8b0_f01f0e89de95;
            assign VGA_R = main_rama79bcb85_fbf1_4744_9d2e_72e5e1a151c7[0:3];
            assign VGA_G = main_rama79bcb85_fbf1_4744_9d2e_72e5e1a151c7[4:7];
            assign VGA_B = main_rama79bcb85_fbf1_4744_9d2e_72e5e1a151c7[8:11];

        reg [32:0] counter = 32'b0;
        reg [15:0] cnt;
            always @ (posedge CLK) 
            begin
                LED =OUT_registercada2531_4081_41e2_8c5f_8ce024d2c282;
                RGB3_Red   = spi_testb3413355_1dce_42de_92f1_95ba91a08248[15];
                OUT_AREG = comDataRegd4e590e2_a4d5_4c29_a305_f4c75b8763e9[8:15];

                counter <= counter + 1;
                {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

                if(microCode_SIGNAL_bank7dff668b_8383_494d_9114_717e114dca73[17] == 0) begin
                clock[0] <= counter[8];
                end
               
                ClockFaster[0] <= counter[0];
               
            end

        endmodule
        