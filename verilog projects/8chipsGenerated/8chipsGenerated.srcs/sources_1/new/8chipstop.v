
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
        end
        
        always@(posedge clock2) begin
          Q_2 = mem[address_2];
          end
        endmodule
    
    
(* DONT_TOUCH = "yes" *)
    module vgaSignalGenerator(
        input wire i_clk,           // base clock
        input wire i_pix_stb,       // pixel clock strobe
        input wire i_rst,
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
    
                if (v_count == SCREEN) 
                begin  // end of screen
                    v_count <= 0;
                    //h_count <= 0;
                 end
            end
        end
    endmodule

    
        //(* DONT_TOUCH = "yes" *)
        module top(input wire CLK,
         input wire [0:0] BTN,
        
            
            output reg [0:3] LED,
            output wire VGA_HS_O,       // horizontal sync output
            output wire VGA_VS_O,       // vertical sync output
            output wire [0:3] VGA_R,    // 4-bit VGA red output
            output wire [0:3] VGA_G,    // 4-bit VGA green output
            output wire [0:3] VGA_B);     // 4-bit VGA blue output);
               
            reg HIGH = 1;
            reg LOW = 0;
            reg SUBMODE = 0;
            reg UNCONNECTED = 0;

            reg [0:0]clock;
            reg [0:0]ClockFaster;
            reg pix_stb;

        
        
        wire [0:1-1] invertONff705c4f_e4f4_47d8_bd3c_e1649ded6932;
wire [0:1-1] signalBankOutputOnf0306524_16f6_4b59_869b_4b9a9c83ee77;
wire [0:1-1] invertOn9deee455_9517_4235_b551_f250ef144066;
wire [0:1-1] eepromChipEnablecee38037_4339_45e9_9a68_4d44417e34e2;
wire [0:1-1] eepromOutEnabledd66940e_f33a_4ec5_8e08_5d21b4dcce5c;
wire [0:1-1] eepromWriteDisabled380bd0f4_2917_4c8d_b8d9_e0651ab037c7;
wire [0:1-1] load_disabled5efb26a4_7d86_45dc_9481_749077e25941;
wire [0:1-1] count_enable_microcode_counter642501a5_e562_4da7_89de_37d2236ff1f3;
wire [0:1-1] invert_clock_signal_enable23820d99_0960_461e_9940_d69f9e6377ae;
wire [0:1-1] clearPCa460751f_6509_4986_9a67_20c27315396b;
wire [0:1-1] ram_chipEnablec41888da_6822_491f_bdfc_e59aa572adaf;




wire [0:1-1] invert_clock_signalab413776_bef2_459e_86a2_8904761123cc;
wire [0:3-1] microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053;
wire [0:1-1] decodeInverter6087f205_1301_4b8f_afa9_6951fa54d6c1;

wire decoder2cd216cd3_04f8_4e18_8467_1efa55bc99bf;
wire decoder246a91784_3ee2_4e2b_8750_6c29c7604ea4;
wire decoder27058ef74_3a0a_4eac_913d_e64c663b5c42;
wire decoder24cacc9fd_66a3_4af3_b39b_84130fe5c93b;
wire decoder1379fe93e_1b74_4547_ac03_e2c2eeeaa317;
wire decoder1ffdca0bd_675b_40b8_901b_63fa175a1575;
wire decoder1cf8cf983_8fc2_4b24_ad6b_1c07fb9f5570;
wire decoder1cc0f947f_2673_43b0_bf54_22354fd60214;
wire [0:16-1] Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1;
wire [0:16-1] pc_bufferc30b4d46_9bff_4597_971c_8b28db5b82f7;
wire [0:16-1] allInputsFor5226fc1b_3768_4505_b788_52b64fd1e228= {Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[0],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[1],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[2],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[3],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[4],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[5],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[6],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[7],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[8],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[9],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[10],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[11],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[12],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[13],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[14],Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1[15]};
wire [0:16-1] main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb;
wire [0:80-1] allInputsForf86f35e7_1714_4fca_8faf_d1e3e1701a22= {A_reg_buffer5264bc37_6b9f_4327_b9fd_21a9bedadd19,B_reg_buffer0629f326_da20_4262_b096_ec33a3f9b878,adder_buffer22e03839_1414_46ce_b5d1_7b875385d6c9,ram_output_bufferae5ea1b4_ea4b_4be3_870b_95399ce4aa9f,pc_bufferc30b4d46_9bff_4597_971c_8b28db5b82f7};
wire [0:5-1] allSelectsForf86f35e7_1714_4fca_8faf_d1e3e1701a22= {microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[8],microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[15],microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[9],microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[1],microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[4]};
wire [0:16-1] instruction_register4f3885b3_c2f4_47e7_9898_a6d1e83fa49f;
wire [0:16-1] allInputsForf533be56_8fff_4654_804f_9975a0beb20c= {main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[0],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[1],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[2],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[3],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[4],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[5],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[6],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[7],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[8],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[9],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[10],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[11],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[12],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[13],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[14],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[15]};
wire [0:24-1] microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563;
wire [0:8-1] allAddressInputsFor9202cf2a_b3ca_4c21_ae15_9851731c2a3a= {UNCONNECTED,instruction_register4f3885b3_c2f4_47e7_9898_a6d1e83fa49f[12],instruction_register4f3885b3_c2f4_47e7_9898_a6d1e83fa49f[13],instruction_register4f3885b3_c2f4_47e7_9898_a6d1e83fa49f[14],instruction_register4f3885b3_c2f4_47e7_9898_a6d1e83fa49f[15],microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[0],microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[1],microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[2]};
wire [0:24-1] allDataInputsFor9202cf2a_b3ca_4c21_ae15_9851731c2a3a= {UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED};
wire [0:24-1] microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d;
wire [0:24-1] allInputsFor1d5d4ec1_03b9_4308_ba77_56c35b4f9e6d= {microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[0],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[1],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[2],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[3],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[4],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[5],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[6],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[7],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[8],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[9],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[10],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[11],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[12],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[13],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[14],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[15],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[16],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[17],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[18],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[19],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[20],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[21],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[22],microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563[23]};
wire [0:1-1] countEnableInverter17f528ff_a63d_439d_a9e1_4e3d2eb9c3c0;
wire [0:1-1] ramOutInverterbc684967_75a7_4c6f_a4ba_d59542dae64f;
wire [0:1-1] ramInInverter501e3718_488d_468a_8b23_79991de2440d;
wire [0:16-1] memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76;
wire [0:16-1] allInputsFor3ff4cad4_91c1_4288_944d_7a18c036a67e= {main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[0],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[1],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[2],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[3],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[4],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[5],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[6],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[7],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[8],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[9],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[10],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[11],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[12],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[13],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[14],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[15]};
wire [0:16-1] main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc;
wire [0:16-1] main_ram474d96c5_83c2_48a2_ac1c_e98489358966;
wire [0:16-1] allAddress1InputsFor864073ce_78ca_45f9_9357_091d2b651999= {memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[0],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[1],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[2],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[3],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[4],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[5],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[6],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[7],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[8],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[9],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[10],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[11],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[12],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[13],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[14],memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76[15]};
wire [0:16-1] allAddress2InputsFor864073ce_78ca_45f9_9357_091d2b651999= {UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED};
wire [0:16-1] allDataInputsFor864073ce_78ca_45f9_9357_091d2b651999= {main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[0],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[1],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[2],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[3],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[4],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[5],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[6],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[7],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[8],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[9],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[10],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[11],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[12],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[13],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[14],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[15]};
wire [0:16-1] ram_output_bufferae5ea1b4_ea4b_4be3_870b_95399ce4aa9f;
wire [0:16-1] allInputsForcd968730_e877_4e83_9d15_274902f2f2aa= {main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[0],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[1],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[2],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[3],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[4],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[5],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[6],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[7],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[8],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[9],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[10],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[11],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[12],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[13],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[14],main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc[15]};
wire [0:16-1] OUT_register8d6e24d8_801d_4252_9209_3ec81dc74192;
wire [0:16-1] allInputsFora4ce4a16_c675_45cd_9160_69cacf5cff6a= {main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[0],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[1],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[2],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[3],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[4],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[5],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[6],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[7],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[8],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[9],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[10],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[11],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[12],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[13],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[14],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[15]};
wire [0:16-1] B_register4710ca9b_d256_4157_8b3d_f3f46c82db88;
wire [0:16-1] allInputsForf7c22e77_5084_45c9_a3d9_8ad789963c86= {main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[0],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[1],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[2],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[3],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[4],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[5],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[6],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[7],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[8],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[9],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[10],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[11],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[12],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[13],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[14],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[15]};
wire [0:16-1] B_reg_buffer0629f326_da20_4262_b096_ec33a3f9b878;
wire [0:16-1] allInputsFor3e2a05c2_a9a9_4787_9bcf_86df564a08a7= {B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[0],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[1],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[2],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[3],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[4],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[5],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[6],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[7],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[8],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[9],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[10],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[11],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[12],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[13],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[14],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[15]};
wire [0:16-1] A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619;
wire [0:16-1] allInputsForccce4171_ad68_4274_9228_66e60407db06= {main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[0],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[1],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[2],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[3],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[4],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[5],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[6],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[7],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[8],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[9],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[10],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[11],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[12],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[13],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[14],main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb[15]};
wire [0:0] A_B_Comparator82597ee8_f413_4484_8538_6828d0d64049;
wire [0:16-1] allADataInputsForef384911_cfc0_490a_af94_65df04716faf= {A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[0],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[1],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[2],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[3],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[4],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[5],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[6],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[7],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[8],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[9],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[10],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[11],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[12],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[13],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[14],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[15]};
wire [0:16-1] allBDataInputsForef384911_cfc0_490a_af94_65df04716faf= {B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[0],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[1],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[2],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[3],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[4],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[5],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[6],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[7],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[8],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[9],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[10],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[11],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[12],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[13],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[14],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[15]};
wire [0:0] A_B_Comparatorec245ccd_54c7_4cfe_89cb_ebde937724a7;
wire [0:1-1] invertALESSB61de61df_b06e_4037_9b59_5a935d5860c5;
wire [0:1-1] invertAEQUALB77dcff41_fe9a_487c_816b_3538b55d1bb2;
wire [0:1-1] AGREATERB3dd9497e_5917_4f0c_aa49_cc2e6aa733c1;
wire [0:4-1] flags_register8de4b122_243b_4a4d_a14b_7d1b026b9983;
wire [0:4-1] allInputsForfae46967_13f7_4847_8af6_d5db7e81f1d5= {AGREATERB3dd9497e_5917_4f0c_aa49_cc2e6aa733c1[0],A_B_Comparator82597ee8_f413_4484_8538_6828d0d64049[0],A_B_Comparatorec245ccd_54c7_4cfe_89cb_ebde937724a7[0],UNCONNECTED};
wire [0:1-1] ANDALESSB195b8d16_a49a_4ca7_b29b_599b35a9d3b4;
wire [0:1-1] ANDAEQUALB90f3c3f6_e987_4646_899a_784009771453;
wire [0:1-1] ANDAGB9b483ec3_df8d_48d0_b1aa_55a4f935351c;
wire [0:1-1] OR1aa5766e1_bc5a_4690_9321_34f4b56edcf7;
wire [0:1-1] OR22bb7ab8b_f9c2_4337_ab70_1d54f0026855;
wire [0:1-1] loadInvertered288173_8a9b_4848_ae3c_2b14d1340649;
wire [0:16-1] A_reg_buffer5264bc37_6b9f_4327_b9fd_21a9bedadd19;
wire [0:16-1] allInputsFor4de868ae_7541_4d61_8fd8_ea012907b9e3= {A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[0],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[1],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[2],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[3],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[4],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[5],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[6],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[7],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[8],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[9],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[10],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[11],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[12],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[13],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[14],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[15]};
wire [0:16-1] adderdcdb0798_5486_41fb_890e_bb99da1f0292;
wire adderd1a2a8a9_1801_44b8_bad4_2ebaed852277;
wire [0:16-1] allADataInputsForc40e0aee_33e3_4cd9_8172_e98c1d195e53= {A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[0],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[1],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[2],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[3],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[4],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[5],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[6],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[7],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[8],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[9],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[10],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[11],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[12],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[13],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[14],A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619[15]};
wire [0:16-1] allBDataInputsForc40e0aee_33e3_4cd9_8172_e98c1d195e53= {B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[0],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[1],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[2],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[3],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[4],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[5],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[6],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[7],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[8],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[9],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[10],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[11],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[12],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[13],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[14],B_register4710ca9b_d256_4157_8b3d_f3f46c82db88[15]};
wire [0:16-1] adder_buffer22e03839_1414_46ce_b5d1_7b875385d6c9;
wire [0:16-1] allInputsFor643574c7_4a36_4242_aacb_90745571ece9= {adderdcdb0798_5486_41fb_890e_bb99da1f0292[0],adderdcdb0798_5486_41fb_890e_bb99da1f0292[1],adderdcdb0798_5486_41fb_890e_bb99da1f0292[2],adderdcdb0798_5486_41fb_890e_bb99da1f0292[3],adderdcdb0798_5486_41fb_890e_bb99da1f0292[4],adderdcdb0798_5486_41fb_890e_bb99da1f0292[5],adderdcdb0798_5486_41fb_890e_bb99da1f0292[6],adderdcdb0798_5486_41fb_890e_bb99da1f0292[7],adderdcdb0798_5486_41fb_890e_bb99da1f0292[8],adderdcdb0798_5486_41fb_890e_bb99da1f0292[9],adderdcdb0798_5486_41fb_890e_bb99da1f0292[10],adderdcdb0798_5486_41fb_890e_bb99da1f0292[11],adderdcdb0798_5486_41fb_890e_bb99da1f0292[12],adderdcdb0798_5486_41fb_890e_bb99da1f0292[13],adderdcdb0798_5486_41fb_890e_bb99da1f0292[14],adderdcdb0798_5486_41fb_890e_bb99da1f0292[15]};

//TODO THESE HAD TO BE REVERSED....
wire [10-1:0] sigGen96907574_0527_4692_98c4_9211f88e6b3f;
wire [9-1:0] sigGen35785bef_fbda_49d7_b46d_0c2fa0495eb2;
wire sigGen85e744cd_ed39_400c_a719_e60344557ff0;
wire sigGen3719ca98_f920_4c9b_aa12_3d11f95deed6;


voltageRail invertON07468be7_22be_4049_b572_b71588fa8776 ( 
                .data(HIGH), 
                .Q(invertONff705c4f_e4f4_47d8_bd3c_e1649ded6932) );


voltageRail signalBankOutputOn96d70fc7_0370_4d44_bf1e_4e87f87b0a8a ( 
                .data(HIGH), 
                .Q(signalBankOutputOnf0306524_16f6_4b59_869b_4b9a9c83ee77) );


voltageRail invertOnee3ac050_6e7f_4e1c_8391_4f540b16de4a ( 
                .data(HIGH), 
                .Q(invertOn9deee455_9517_4235_b551_f250ef144066) );


voltageRail eepromChipEnable7af7929c_02b8_400a_9841_bf4a0c0b7bc7 ( 
                .data(LOW), 
                .Q(eepromChipEnablecee38037_4339_45e9_9a68_4d44417e34e2) );


voltageRail eepromOutEnable38e1332e_8c6d_472a_b701_5ee1b51b891e ( 
                .data(LOW), 
                .Q(eepromOutEnabledd66940e_f33a_4ec5_8e08_5d21b4dcce5c) );


voltageRail eepromWriteDisabled2e3f6c03_33c7_40a1_9dd2_ba2122190428 ( 
                .data(HIGH), 
                .Q(eepromWriteDisabled380bd0f4_2917_4c8d_b8d9_e0651ab037c7) );


voltageRail load_disabled1ecdf804_8705_4d62_8e0b_77504f48d31c ( 
                .data(HIGH), 
                .Q(load_disabled5efb26a4_7d86_45dc_9481_749077e25941) );


voltageRail count_enable_microcode_counter720f9814_9a26_4bb1_8a3b_2e7d68d206ba ( 
                .data(LOW), 
                .Q(count_enable_microcode_counter642501a5_e562_4da7_89de_37d2236ff1f3) );


voltageRail invert_clock_signal_enable60598482_461c_47ee_b8a7_abdb9f777e36 ( 
                .data(HIGH), 
                .Q(invert_clock_signal_enable23820d99_0960_461e_9940_d69f9e6377ae) );


voltageRail clearPC55ef70f3_6a43_42df_ab69_68062b116864 ( 
                .data(HIGH), 
                .Q(clearPCa460751f_6509_4986_9a67_20c27315396b) );


voltageRail ram_chipEnableff3f3300_26a7_484b_ae8b_e86292ebd890 ( 
                .data(LOW), 
                .Q(ram_chipEnablec41888da_6822_491f_bdfc_e59aa572adaf) );










inverter invert_clock_signal553e623b_91bb_4617_bff6_ce104578cb9a ( 
                .data(clock[0]), 
                .Q(invert_clock_signalab413776_bef2_459e_86a2_8904761123cc), 
                .outputEnable(invert_clock_signal_enable23820d99_0960_461e_9940_d69f9e6377ae[0]) );


binaryCounter #(.n(3)) microcode_step_counter8e5a9df6_a8df_430f_b01d_202b3215c0e5 (
                .D(UNCONNECTED),
                .clr_(invert_clock_signal_enable23820d99_0960_461e_9940_d69f9e6377ae[0]),
                .load_(load_disabled5efb26a4_7d86_45dc_9481_749077e25941[0]),
                .clock(invert_clock_signalab413776_bef2_459e_86a2_8904761123cc[0]),
                .enable1_(count_enable_microcode_counter642501a5_e562_4da7_89de_37d2236ff1f3[0]),
                .enable2_(count_enable_microcode_counter642501a5_e562_4da7_89de_37d2236ff1f3[0]),
                .Q(microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053));


inverter decodeInverterdfda2bbb_2780_49d2_9f00_42194e73adf3 ( 
                .data(microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[2]), 
                .Q(decodeInverter6087f205_1301_4b8f_afa9_6951fa54d6c1), 
                .outputEnable(invert_clock_signal_enable23820d99_0960_461e_9940_d69f9e6377ae[0]) );







twoLineToFourLineDecoder decoder2c359d5a0_cf13_40d7_908d_3132d77438dd (
                 microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[0],
                  microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[1],
                   microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[2],
                    decoder2cd216cd3_04f8_4e18_8467_1efa55bc99bf,
                    decoder246a91784_3ee2_4e2b_8750_6c29c7604ea4,
                    decoder27058ef74_3a0a_4eac_913d_e64c663b5c42,
                    decoder24cacc9fd_66a3_4af3_b39b_84130fe5c93b);





twoLineToFourLineDecoder decoder13593575c_6da8_444a_b42b_ff7a74b338d2 (
                 microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[0],
                  microcode_step_countere48812a8_a9c2_4221_b8ab_49e5f18de053[1],
                   decodeInverter6087f205_1301_4b8f_afa9_6951fa54d6c1[0],
                    decoder1379fe93e_1b74_4547_ac03_e2c2eeeaa317,
                    decoder1ffdca0bd_675b_40b8_901b_63fa175a1575,
                    decoder1cf8cf983_8fc2_4b24_ad6b_1c07fb9f5570,
                    decoder1cc0f947f_2673_43b0_bf54_22354fd60214);


binaryCounter #(.n(16)) Program_Countere3a6b72a_af56_42b1_aa54_529e9a6eaf1a (
                .D(main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb),
                .clr_(clearPCa460751f_6509_4986_9a67_20c27315396b[0]),
                .load_(loadInvertered288173_8a9b_4848_ae3c_2b14d1340649[0]),
                .clock(clock[0]),
                .enable1_(countEnableInverter17f528ff_a63d_439d_a9e1_4e3d2eb9c3c0[0]),
                .enable2_(countEnableInverter17f528ff_a63d_439d_a9e1_4e3d2eb9c3c0[0]),
                .Q(Program_Counter4be2433c_9f61_4635_926b_56789dfed9d1));



nBuffer  #(.n(16)) pc_buffer5226fc1b_3768_4505_b788_52b64fd1e228 (
                  .data(allInputsFor5226fc1b_3768_4505_b788_52b64fd1e228),
                  .Q(pc_bufferc30b4d46_9bff_4597_971c_8b28db5b82f7), 
                  .outputEnable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[4]) );




bus_mux #(.bus_count(5),.mux_width(16)) main_busf86f35e7_1714_4fca_8faf_d1e3e1701a22 (
                .selects(allSelectsForf86f35e7_1714_4fca_8faf_d1e3e1701a22),
                .data_in(allInputsForf86f35e7_1714_4fca_8faf_d1e3e1701a22),
                .data_out(main_busa4eebaf9_8906_4f61_a6a5_06eb309671cb));



nRegister #(.n(16)) instruction_registerf533be56_8fff_4654_804f_9975a0beb20c ( 
                .data(allInputsForf533be56_8fff_4654_804f_9975a0beb20c), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[2]),
                 .Q(instruction_register4f3885b3_c2f4_47e7_9898_a6d1e83fa49f) );




staticRamDiscretePorts #(.ROMFILE("microcode.mem"),.DATA_WIDTH(24),.ADDR_WIDTH(8)) microcode_rom9202cf2a_b3ca_4c21_ae15_9851731c2a3a (
                 .address(allAddressInputsFor9202cf2a_b3ca_4c21_ae15_9851731c2a3a),
                  .data(allDataInputsFor9202cf2a_b3ca_4c21_ae15_9851731c2a3a), 
                  .cs_(eepromChipEnablecee38037_4339_45e9_9a68_4d44417e34e2[0]),
                   .we_(eepromWriteDisabled380bd0f4_2917_4c8d_b8d9_e0651ab037c7[0]),
                   .oe_(eepromOutEnabledd66940e_f33a_4ec5_8e08_5d21b4dcce5c[0]),
                    .clock(ClockFaster[0]),
                   .Q(microcode_rome07021f0_5413_4b32_9e37_a32a40f5a563));



nBuffer  #(.n(24)) microCode_SIGNAL_bank1d5d4ec1_03b9_4308_ba77_56c35b4f9e6d (
                  .data(allInputsFor1d5d4ec1_03b9_4308_ba77_56c35b4f9e6d),
                  .Q(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d), 
                  .outputEnable(signalBankOutputOnf0306524_16f6_4b59_869b_4b9a9c83ee77[0]) );


inverter countEnableInvertere451c667_7ef2_4084_880e_e4baccb9c976 ( 
                .data(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[6]), 
                .Q(countEnableInverter17f528ff_a63d_439d_a9e1_4e3d2eb9c3c0), 
                .outputEnable(invertOn9deee455_9517_4235_b551_f250ef144066[0]) );


inverter ramOutInverter0bfb77e1_c528_44f1_94e1_2ba226475ace ( 
                .data(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[1]), 
                .Q(ramOutInverterbc684967_75a7_4c6f_a4ba_d59542dae64f), 
                .outputEnable(invertOn9deee455_9517_4235_b551_f250ef144066[0]) );


inverter ramInInverteref33cf3c_e277_4fd9_91ec_d254a404389e ( 
                .data(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[0]), 
                .Q(ramInInverter501e3718_488d_468a_8b23_79991de2440d), 
                .outputEnable(invertOn9deee455_9517_4235_b551_f250ef144066[0]) );



nRegister #(.n(16)) memory_address_register3ff4cad4_91c1_4288_944d_7a18c036a67e ( 
                .data(allInputsFor3ff4cad4_91c1_4288_944d_7a18c036a67e), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[18]),
                 .Q(memory_address_register168ce6ce_0d43_49a1_8e2c_0f6eae4e2b76) );






dualPortStaticRam #(.ROMFILE("staticram.mem"),.DATA_WIDTH(16),.ADDR_WIDTH(16)) main_ram864073ce_78ca_45f9_9357_091d2b651999 (
                .address_1(allAddress1InputsFor864073ce_78ca_45f9_9357_091d2b651999),
                .address_2(allAddress2InputsFor864073ce_78ca_45f9_9357_091d2b651999),
                 .data(allDataInputsFor864073ce_78ca_45f9_9357_091d2b651999), 
                 .cs_(ram_chipEnablec41888da_6822_491f_bdfc_e59aa572adaf[0]),
                  .we_(ramInInverter501e3718_488d_468a_8b23_79991de2440d[0]),
                  .oe_(ramOutInverterbc684967_75a7_4c6f_a4ba_d59542dae64f[0]),
                  .clock(ClockFaster[0]),
                  .clock2(ClockFaster[0]),
                  .Q_1(main_ramd16f706a_8438_4fbd_a00b_f6147e5067bc),
                  .Q_2(main_ram474d96c5_83c2_48a2_ac1c_e98489358966));



nBuffer  #(.n(16)) ram_output_buffercd968730_e877_4e83_9d15_274902f2f2aa (
                  .data(allInputsForcd968730_e877_4e83_9d15_274902f2f2aa),
                  .Q(ram_output_bufferae5ea1b4_ea4b_4be3_870b_95399ce4aa9f), 
                  .outputEnable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[1]) );



nRegister #(.n(16)) OUT_registera4ce4a16_c675_45cd_9160_69cacf5cff6a ( 
                .data(allInputsFora4ce4a16_c675_45cd_9160_69cacf5cff6a), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[16]),
                 .Q(OUT_register8d6e24d8_801d_4252_9209_3ec81dc74192) );



nRegister #(.n(16)) B_registerf7c22e77_5084_45c9_a3d9_8ad789963c86 ( 
                .data(allInputsForf7c22e77_5084_45c9_a3d9_8ad789963c86), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[14]),
                 .Q(B_register4710ca9b_d256_4157_8b3d_f3f46c82db88) );



nBuffer  #(.n(16)) B_reg_buffer3e2a05c2_a9a9_4787_9bcf_86df564a08a7 (
                  .data(allInputsFor3e2a05c2_a9a9_4787_9bcf_86df564a08a7),
                  .Q(B_reg_buffer0629f326_da20_4262_b096_ec33a3f9b878), 
                  .outputEnable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[15]) );



nRegister #(.n(16)) A_registerccce4171_ad68_4274_9228_66e60407db06 ( 
                .data(allInputsForccce4171_ad68_4274_9228_66e60407db06), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[7]),
                 .Q(A_registerb88dfb56_ef63_4c51_b595_0a6b9cc0d619) );





nbitComparator #(.n(16)) A_B_Comparatoref384911_cfc0_490a_af94_65df04716faf (
                .a(allADataInputsForef384911_cfc0_490a_af94_65df04716faf),
                .b(allBDataInputsForef384911_cfc0_490a_af94_65df04716faf),
                .equal(A_B_Comparator82597ee8_f413_4484_8538_6828d0d64049),
                .lower(A_B_Comparatorec245ccd_54c7_4cfe_89cb_ebde937724a7));


inverter invertALESSB935121e2_fae3_41c7_8751_58405d6f2a3c ( 
                .data(A_B_Comparatorec245ccd_54c7_4cfe_89cb_ebde937724a7[0]), 
                .Q(invertALESSB61de61df_b06e_4037_9b59_5a935d5860c5), 
                .outputEnable(invertONff705c4f_e4f4_47d8_bd3c_e1649ded6932[0]) );


inverter invertAEQUALBa7842de4_c5f1_49cd_a3c9_dbf248b65955 ( 
                .data(A_B_Comparator82597ee8_f413_4484_8538_6828d0d64049[0]), 
                .Q(invertAEQUALB77dcff41_fe9a_487c_816b_3538b55d1bb2), 
                .outputEnable(invertONff705c4f_e4f4_47d8_bd3c_e1649ded6932[0]) );


ANDGATE AGREATERB8ec55130_d28f_476a_8ac2_cfbf020fb486 ( 
                invertAEQUALB77dcff41_fe9a_487c_816b_3538b55d1bb2[0], 
                invertALESSB61de61df_b06e_4037_9b59_5a935d5860c5[0], 
                AGREATERB3dd9497e_5917_4f0c_aa49_cc2e6aa733c1 );



nRegister #(.n(4)) flags_registerfae46967_13f7_4847_8af6_d5db7e81f1d5 ( 
                .data(allInputsForfae46967_13f7_4847_8af6_d5db7e81f1d5), 
                .clock(clock[0]), 
                .enable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[22]),
                 .Q(flags_register8de4b122_243b_4a4d_a14b_7d1b026b9983) );


ANDGATE ANDALESSB011c8c98_9084_49d8_a644_36d84ecfd27a ( 
                flags_register8de4b122_243b_4a4d_a14b_7d1b026b9983[2], 
                microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[19], 
                ANDALESSB195b8d16_a49a_4ca7_b29b_599b35a9d3b4 );


ANDGATE ANDAEQUALB5c540179_2375_4b72_a505_e4382972a027 ( 
                flags_register8de4b122_243b_4a4d_a14b_7d1b026b9983[1], 
                microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[20], 
                ANDAEQUALB90f3c3f6_e987_4646_899a_784009771453 );


ANDGATE ANDAGBa179c9f9_6090_4d1e_a70f_0afd1e5ad043 ( 
                flags_register8de4b122_243b_4a4d_a14b_7d1b026b9983[0], 
                microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[21], 
                ANDAGB9b483ec3_df8d_48d0_b1aa_55a4f935351c );


ORGATE OR1b0aebd7c_5e1c_4e4a_8b79_30e153734ee1 ( 
                ANDAGB9b483ec3_df8d_48d0_b1aa_55a4f935351c[0], 
                ANDAEQUALB90f3c3f6_e987_4646_899a_784009771453[0],
                OR1aa5766e1_bc5a_4690_9321_34f4b56edcf7);


ORGATE OR223d4689c_2d63_4b5d_9fc7_242cf2b04d9b ( 
                OR1aa5766e1_bc5a_4690_9321_34f4b56edcf7[0], 
                ANDALESSB195b8d16_a49a_4ca7_b29b_599b35a9d3b4[0],
                OR22bb7ab8b_f9c2_4337_ab70_1d54f0026855);


inverter loadInverter4108bc77_7ab9_4501_b45a_9c7f063cd397 ( 
                .data(OR22bb7ab8b_f9c2_4337_ab70_1d54f0026855[0]), 
                .Q(loadInvertered288173_8a9b_4848_ae3c_2b14d1340649), 
                .outputEnable(invertONff705c4f_e4f4_47d8_bd3c_e1649ded6932[0]) );



nBuffer  #(.n(16)) A_reg_buffer4de868ae_7541_4d61_8fd8_ea012907b9e3 (
                  .data(allInputsFor4de868ae_7541_4d61_8fd8_ea012907b9e3),
                  .Q(A_reg_buffer5264bc37_6b9f_4327_b9fd_21a9bedadd19), 
                  .outputEnable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[8]) );





nbitAdder #(.n(16)) adderc40e0aee_33e3_4cd9_8172_e98c1d195e53 (
                 .sub(SUBMODE),
                .cin(UNCONNECTED),
                .x(allADataInputsForc40e0aee_33e3_4cd9_8172_e98c1d195e53),
                .y(allBDataInputsForc40e0aee_33e3_4cd9_8172_e98c1d195e53),
                .sum(adderdcdb0798_5486_41fb_890e_bb99da1f0292),
                .cout(adderd1a2a8a9_1801_44b8_bad4_2ebaed852277));



nBuffer  #(.n(16)) adder_buffer643574c7_4a36_4242_aacb_90745571ece9 (
                  .data(allInputsFor643574c7_4a36_4242_aacb_90745571ece9),
                  .Q(adder_buffer22e03839_1414_46ce_b5d1_7b875385d6c9), 
                  .outputEnable(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[9]) );





vgaSignalGenerator sigGend2928bfa_f1fd_4ac2_bfb0_47ad30f4f4ee (
                .i_clk(CLK),
                .i_pix_stb(pix_stb),
                .i_rst(~BTN[0]),
                .o_hs(VGA_HS_O),
                .o_vs(VGA_VS_O),
                .o_x(sigGen96907574_0527_4692_98c4_9211f88e6b3f),
                .o_y(sigGen35785bef_fbda_49d7_b46d_0c2fa0495eb2)
            );
       wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
       wire [8:0] y; 
       
        assign x = sigGen96907574_0527_4692_98c4_9211f88e6b3f;
        assign y = sigGen35785bef_fbda_49d7_b46d_0c2fa0495eb2;
        
         //wire sq_a, sq_b, sq_c, sq_d;
           //  assign sq_a = ((x > 120) & (y >  40) & (x < 280) & (y < 200)) ? 1 : 0;
           //  assign sq_b = ((x > 200) & (y > 120) & (x < 360) & (y < 280)) ? 1 : 0;
           //  assign sq_c = ((x > 280) & (y > 200) & (x < 440) & (y < 360)) ? 1 : 0;
           //  assign sq_d = ((x > 360) & (y > 280) & (x < 520) & (y < 440)) ? 1 : 0;
         
             assign VGA_R = OUT_register8d6e24d8_801d_4252_9209_3ec81dc74192;
             assign VGA_G = OUT_register8d6e24d8_801d_4252_9209_3ec81dc74192;
             assign VGA_B = OUT_register8d6e24d8_801d_4252_9209_3ec81dc74192;

        reg [32:0] counter = 32'b0;
        //counter for pixel clock... cant get other counter to work
        reg [15:0] cnt = {16{1'b0}};
        
         always @(posedge CLK)
               {pix_stb, cnt} <= cnt + 16'h4000; 
        
            always @ (posedge CLK) 
            begin
                LED = OUT_register8d6e24d8_801d_4252_9209_3ec81dc74192;          
                counter <= counter + 1;
                if(microCode_SIGNAL_bankdf243095_8393_4aeb_a19d_4e8cf834908d[17] == 0) begin
                clock[0] <= counter[17];
                end
                //TODO see if it works if we set strobe to counter[3 or 4];
                 //{pix_stb, counter} <= counter + 32'h40000000;  // divide by 4: (2^16)/4 = 0x4000
                 //RAM clock...
                //pix_stb <= counter[3];
                ClockFaster[0] <= counter[10];
               
            end

        endmodule
        