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
        
          (* DONT_TOUCH = "yes" *)
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
        module top(input CLK, input [0:0]BTN, output  reg ck_io40, output reg ck_io41, output reg [0:3] LED, output reg [0:7] ja);
        reg HIGH = 1;
        reg LOW = 0;
        reg SUBMODE = 0;
        reg UNCONNECTED = 0;
        reg [0:0]clock;
        reg [0:0]clockFaster;
        
        
        wire [0:1-1] invertON2f29cc42_2b8b_4075_95c3_b9e23518217d;
wire [0:1-1] signalBankOutputOna60175cb_e215_4fd0_8606_3d843e4fd445;
wire [0:1-1] invertOn463a5db0_a7d2_4106_8288_fdf935ac816a;
wire [0:1-1] eepromChipEnablefa04874e_9ed9_4da7_aedd_cbb7af4ef92f;
wire [0:1-1] eepromOutEnable21e298c6_223e_467e_82e5_bf54353ecb30;
wire [0:1-1] eepromWriteDisabled0030ea24_6855_4143_b4ad_6316e66bcfa5;
wire [0:1-1] load_disabled26be31e6_1279_47f3_98c4_b998882f71ef;
wire [0:1-1] count_enable_microcode_countere60cb285_282c_4af4_b8ab_d776d610fe75;
wire [0:1-1] invert_clock_signal_enable2cd88d27_3417_493a_be95_1e4cdab78bdb;
wire [0:1-1] clearPC04cd6f27_03e9_483d_98ec_d2776cfefa45;
wire [0:1-1] ram_chipEnable19f22829_b6df_4228_80a6_efe7295b2351;




wire [0:1-1] invert_clock_signale4215683_a56a_4837_9894_65acfeeac185;
wire [0:3-1] microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867;
wire [0:1-1] decodeInverter77dba274_29cd_4003_bfe4_ac9f276e7bc9;

wire decoder25c3107d7_cba4_46ec_8742_f670d4e73ecf;
wire decoder2a1636fba_ace3_4f3d_9102_8d38c57ba8c1;
wire decoder2f25bfd2b_3fcd_4b17_bb82_e52f62f1293c;
wire decoder2c48def82_8f53_47b8_bd6a_3c967a40ad43;
wire decoder13df14a40_2daa_4d92_bb7e_be17a8f6741d;
wire decoder1d59c2f25_7841_456a_a741_8e9d280da149;
wire decoder1a1f0f261_2aba_4434_be78_755ffa129b75;
wire decoder12db666d4_b8c0_4dfb_8741_aace729d059e;
wire [0:8-1] Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791;
wire [0:8-1] pc_buffer2be9d096_1a68_4707_be8f_8f594a785cf3;
wire [0:8-1] allInputsForab17648b_fdd9_4308_b146_b5509f453bac= {Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[0],Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[1],Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[2],Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[3],Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[4],Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[5],Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[6],Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791[7]};
wire [0:8-1] main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d;

wire [0:8-1] instruction_register9cf21404_4514_41e1_a233_f7d5c5411526;
wire [0:8-1] allInputsFor9e5dabe8_e0a0_42c4_b393_6af36048eb59= {main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]};
wire [0:24-1] microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d;
wire [0:8-1] allAddressInputsFor196a21c8_55be_4cef_aca1_0dcc542d7eb2= {UNCONNECTED,instruction_register9cf21404_4514_41e1_a233_f7d5c5411526[4],instruction_register9cf21404_4514_41e1_a233_f7d5c5411526[5],instruction_register9cf21404_4514_41e1_a233_f7d5c5411526[6],instruction_register9cf21404_4514_41e1_a233_f7d5c5411526[7],microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0],microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1],microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]};
wire [0:24-1] allDataInputsFor196a21c8_55be_4cef_aca1_0dcc542d7eb2= {UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED,UNCONNECTED};
wire [0:24-1] microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf;
wire [0:24-1] allInputsFora29e44c5_d6ee_42ae_b9be_d8ee6e3c7508= {microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[0],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[2],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[3],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[5],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[6],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[7],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[10],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[11],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[12],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[13],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[14],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[15],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[16],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[17],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[18],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[19],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[20],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[21],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[22],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[23]};
wire [0:1-1] countEnableInvertere46852f4_22c0_48d5_a1ec_a064ec9e336c;
wire [0:1-1] ramOutInverter41f84cdb_d153_4210_a27a_1761ff04bfcf;
wire [0:1-1] ramInInvertercff29776_ebcf_4cdd_a69e_1483e30855c2;
wire [0:8-1] memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6;
wire [0:8-1] allInputsFor04bc32f9_9690_4e31_8392_6fb6950c4c9d= {main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]};
wire [0:8-1] main_ram118b3127_9ac9_438d_b207_2884b5d16b15;
wire [0:8-1] allAddressInputsFor058f23a5_f365_4220_8e38_da596e15e48f= {memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[0],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[1],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[2],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[3],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[4],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[5],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[6],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[7]};
wire [0:8-1] allDataInputsFor058f23a5_f365_4220_8e38_da596e15e48f= {main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]};
wire [0:8-1] ram_output_bufferc81700b4_0321_498f_925d_c10ca30cc232;
wire [0:8-1] allInputsForcbc2a54b_aace_44fa_b35c_8f1bbda139af= {main_ram118b3127_9ac9_438d_b207_2884b5d16b15[0],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[1],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[2],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[3],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[4],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[5],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[6],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[7]};
wire [0:8-1] OUT_register326d4b27_c9d6_4892_91f1_255a5fc9fb08;
wire [0:8-1] allInputsForb6bda39a_f152_436e_a45e_e386c475386c= {main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]};
wire [0:8-1] B_registera9d402a3_f423_474d_a57a_03f266088e78;
wire [0:8-1] allInputsFor6a6161ba_30b5_46f4_b70b_5d08d83841f2= {main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]};
wire [0:8-1] B_reg_buffer03bdd088_1cdc_4325_b940_4dba4ade4520;
wire [0:8-1] allInputsForc921f68c_903c_4852_b0d5_5512e7dfd00c= {B_registera9d402a3_f423_474d_a57a_03f266088e78[0],B_registera9d402a3_f423_474d_a57a_03f266088e78[1],B_registera9d402a3_f423_474d_a57a_03f266088e78[2],B_registera9d402a3_f423_474d_a57a_03f266088e78[3],B_registera9d402a3_f423_474d_a57a_03f266088e78[4],B_registera9d402a3_f423_474d_a57a_03f266088e78[5],B_registera9d402a3_f423_474d_a57a_03f266088e78[6],B_registera9d402a3_f423_474d_a57a_03f266088e78[7]};
wire [0:8-1] A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa;
wire [0:8-1] allInputsFor7f6259ba_4079_4214_8482_3b7541d380bc= {main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]};
wire [0:0] A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7;
wire [0:8-1] allADataInputsFor2a1c439a_c9bd_4101_94e0_ddbf4974c53c= {A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[0],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[1],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[2],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[3],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[4],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[5],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[6],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[7]};
wire [0:8-1] allBDataInputsFor2a1c439a_c9bd_4101_94e0_ddbf4974c53c= {B_registera9d402a3_f423_474d_a57a_03f266088e78[0],B_registera9d402a3_f423_474d_a57a_03f266088e78[1],B_registera9d402a3_f423_474d_a57a_03f266088e78[2],B_registera9d402a3_f423_474d_a57a_03f266088e78[3],B_registera9d402a3_f423_474d_a57a_03f266088e78[4],B_registera9d402a3_f423_474d_a57a_03f266088e78[5],B_registera9d402a3_f423_474d_a57a_03f266088e78[6],B_registera9d402a3_f423_474d_a57a_03f266088e78[7]};
wire [0:0] A_B_Comparatoree489946_8ec0_4155_b5ba_aa3198a2d8e2;
wire [0:1-1] invertALESSB4e7ac467_a9c3_480f_8b69_9a7822cb94c4;
wire [0:1-1] invertAEQUALBe2577cce_e286_43d9_9fbe_b87fbc6aabac;
wire [0:1-1] AGREATERB512014c4_4144_41ed_b4c4_f824975136a4;
wire [0:4-1] flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0;
wire [0:4-1] allInputsFor7767ffe9_fc7b_465a_994c_5b37fa114233= {AGREATERB512014c4_4144_41ed_b4c4_f824975136a4[0],A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7[0],A_B_Comparatoree489946_8ec0_4155_b5ba_aa3198a2d8e2[0],UNCONNECTED};
wire [0:1-1] ANDALESSBf42d180d_9a51_46e4_9ebf_d70f6707c4fe;
wire [0:1-1] ANDAEQUALBedf57453_64f4_4620_baf9_9782f8645346;
wire [0:1-1] ANDAGBf8f962d7_7ca6_4239_b875_5ef2dd2f13c5;
wire [0:1-1] OR177f45f69_b75a_4be3_901d_2880357f1de4;
wire [0:1-1] OR2001f27f7_929e_4c0c_93a1_70cf85c04169;
wire [0:1-1] loadInverterdfffd2f0_0359_43f5_9759_916105456181;
wire [0:8-1] A_reg_buffer49a20085_746e_433b_8ae5_2129daba083e;
wire [0:8-1] allInputsFor6c77fa5e_eed9_4eb4_b395_22571967cdf7= {A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[0],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[1],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[2],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[3],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[4],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[5],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[6],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[7]};
wire [0:8-1] addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f;
wire adderf56a100e_eae5_4b32_9c3e_6d8ec369d38c;
wire [0:8-1] allADataInputsFor4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed= {A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[0],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[1],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[2],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[3],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[4],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[5],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[6],A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa[7]};
wire [0:8-1] allBDataInputsFor4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed= {B_registera9d402a3_f423_474d_a57a_03f266088e78[0],B_registera9d402a3_f423_474d_a57a_03f266088e78[1],B_registera9d402a3_f423_474d_a57a_03f266088e78[2],B_registera9d402a3_f423_474d_a57a_03f266088e78[3],B_registera9d402a3_f423_474d_a57a_03f266088e78[4],B_registera9d402a3_f423_474d_a57a_03f266088e78[5],B_registera9d402a3_f423_474d_a57a_03f266088e78[6],B_registera9d402a3_f423_474d_a57a_03f266088e78[7]};
wire [0:8-1] adder_bufferb9bfffd9_71d5_4200_86e7_281b26ab1bb0;
wire [0:8-1] allInputsFor367f9b23_b9c9_4e7a_be78_da0039d22dae= {addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[0],addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[1],addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[2],addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[3],addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[4],addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[5],addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[6],addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f[7]};
wire [0:40-1] allInputsForea6e3600_5feb_43e3_856c_9ab9aa7665eb= {A_reg_buffer49a20085_746e_433b_8ae5_2129daba083e,B_reg_buffer03bdd088_1cdc_4325_b940_4dba4ade4520,adder_bufferb9bfffd9_71d5_4200_86e7_281b26ab1bb0,ram_output_bufferc81700b4_0321_498f_925d_c10ca30cc232,pc_buffer2be9d096_1a68_4707_be8f_8f594a785cf3};
wire [0:5-1] allSelectsForea6e3600_5feb_43e3_856c_9ab9aa7665eb= {microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[8],microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[15],microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[9],microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[1],microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[4]};

voltageRail invertONbc0746dc_ab62_4712_b2f1_f5dd137359a1 ( HIGH, invertON2f29cc42_2b8b_4075_95c3_b9e23518217d );


voltageRail signalBankOutputOn69a8c057_1105_47fd_a815_a2a514aa0826 ( HIGH, signalBankOutputOna60175cb_e215_4fd0_8606_3d843e4fd445 );


voltageRail invertOnbd1cb875_2eeb_43a8_913f_1dc564b94bf2 ( HIGH, invertOn463a5db0_a7d2_4106_8288_fdf935ac816a );


voltageRail eepromChipEnable0e3997be_f309_4e71_81db_5ba52d9addda ( LOW, eepromChipEnablefa04874e_9ed9_4da7_aedd_cbb7af4ef92f );


voltageRail eepromOutEnable94e8ad10_095e_4772_b748_3535be944002 ( LOW, eepromOutEnable21e298c6_223e_467e_82e5_bf54353ecb30 );


voltageRail eepromWriteDisabled20a253e9_a5ca_4950_9b22_e13f287ef657 ( HIGH, eepromWriteDisabled0030ea24_6855_4143_b4ad_6316e66bcfa5 );


voltageRail load_disabled59497c56_d228_4b12_927e_a5c9ab9ad810 ( HIGH, load_disabled26be31e6_1279_47f3_98c4_b998882f71ef );


voltageRail count_enable_microcode_counterfc58f480_6c3d_4e18_926d_32092ea744e3 ( LOW, count_enable_microcode_countere60cb285_282c_4af4_b8ab_d776d610fe75 );


voltageRail invert_clock_signal_enable8a4a87ed_2f0e_49f3_9afa_1ab1b82a4e39 ( HIGH, invert_clock_signal_enable2cd88d27_3417_493a_be95_1e4cdab78bdb );

//TODO added button instead of HIGH to reset the program counter...
voltageRail clearPC5d073ad4_4fd6_40a7_a8b8_ab4cd5946e0c ( ~BTN[0], clearPC04cd6f27_03e9_483d_98ec_d2776cfefa45 );


voltageRail ram_chipEnableb2dfd491_cdc4_4ab0_82e6_dbeb6def4528 ( LOW, ram_chipEnable19f22829_b6df_4228_80a6_efe7295b2351 );










inverter invert_clock_signale2c11c96_487a_459d_827c_e49ab66a4801 ( clock[0], invert_clock_signale4215683_a56a_4837_9894_65acfeeac185 , invert_clock_signal_enable2cd88d27_3417_493a_be95_1e4cdab78bdb[0] );


binaryCounter microcode_step_counterdade7a7c_6f4d_4d87_97e4_e6ad97bc619f ( UNCONNECTED, invert_clock_signal_enable2cd88d27_3417_493a_be95_1e4cdab78bdb[0] , load_disabled26be31e6_1279_47f3_98c4_b998882f71ef[0], invert_clock_signale4215683_a56a_4837_9894_65acfeeac185[0], count_enable_microcode_countere60cb285_282c_4af4_b8ab_d776d610fe75[0], count_enable_microcode_countere60cb285_282c_4af4_b8ab_d776d610fe75[0], microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867  );


inverter decodeInverter050744c7_5801_470f_9499_216fe428d79c ( microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2], decodeInverter77dba274_29cd_4003_bfe4_ac9f276e7bc9 , invert_clock_signal_enable2cd88d27_3417_493a_be95_1e4cdab78bdb[0] );







twoLineToFourLineDecoder decoder2fd954b6a_36df_4fde_8909_20001e287d62 ( microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0], microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1] , microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2], decoder25c3107d7_cba4_46ec_8742_f670d4e73ecf,decoder2a1636fba_ace3_4f3d_9102_8d38c57ba8c1,decoder2f25bfd2b_3fcd_4b17_bb82_e52f62f1293c,decoder2c48def82_8f53_47b8_bd6a_3c967a40ad43);





twoLineToFourLineDecoder decoder14f1ec580_fb26_447a_96f2_8d9d48c6a5ca ( microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0], microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1] , decodeInverter77dba274_29cd_4003_bfe4_ac9f276e7bc9[0], decoder13df14a40_2daa_4d92_bb7e_be17a8f6741d,decoder1d59c2f25_7841_456a_a741_8e9d280da149,decoder1a1f0f261_2aba_4434_be78_755ffa129b75,decoder12db666d4_b8c0_4dfb_8741_aace729d059e);


binaryCounter Program_Counterc36da09d_cc52_43a9_a1d9_c841131cb066 ( main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d, clearPC04cd6f27_03e9_483d_98ec_d2776cfefa45[0] , loadInverterdfffd2f0_0359_43f5_9759_916105456181[0], clock[0], countEnableInvertere46852f4_22c0_48d5_a1ec_a064ec9e336c[0], countEnableInvertere46852f4_22c0_48d5_a1ec_a064ec9e336c[0], Program_Counter79f2cbbe_4c21_49d6_9925_9c24412cf791  );



nBuffer  #(8) pc_bufferab17648b_fdd9_4308_b146_b5509f453bac ( allInputsForab17648b_fdd9_4308_b146_b5509f453bac, pc_buffer2be9d096_1a68_4707_be8f_8f594a785cf3 , microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[4] );




bus_mux #(5,8) main_busea6e3600_5feb_43e3_856c_9ab9aa7665eb ( allSelectsForea6e3600_5feb_43e3_856c_9ab9aa7665eb, allInputsForea6e3600_5feb_43e3_856c_9ab9aa7665eb , main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d );



nRegister instruction_register9e5dabe8_e0a0_42c4_b393_6af36048eb59 ( allInputsFor9e5dabe8_e0a0_42c4_b393_6af36048eb59, clock[0], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[2], instruction_register9cf21404_4514_41e1_a233_f7d5c5411526 );



staticRamDiscretePorts #("microcode.mem",24,8) microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2 ( allAddressInputsFor196a21c8_55be_4cef_aca1_0dcc542d7eb2, allDataInputsFor196a21c8_55be_4cef_aca1_0dcc542d7eb2, eepromChipEnablefa04874e_9ed9_4da7_aedd_cbb7af4ef92f[0], eepromWriteDisabled0030ea24_6855_4143_b4ad_6316e66bcfa5[0],eepromOutEnable21e298c6_223e_467e_82e5_bf54353ecb30[0],clockFaster[0],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d);



nBuffer  #(24) microCode_SIGNAL_banka29e44c5_d6ee_42ae_b9be_d8ee6e3c7508 ( allInputsFora29e44c5_d6ee_42ae_b9be_d8ee6e3c7508, microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf , signalBankOutputOna60175cb_e215_4fd0_8606_3d843e4fd445[0] );


inverter countEnableInverterc86811f8_28c6_41a7_bf63_5992422ed3a9 ( microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[6], countEnableInvertere46852f4_22c0_48d5_a1ec_a064ec9e336c , invertOn463a5db0_a7d2_4106_8288_fdf935ac816a[0] );


inverter ramOutInverteree0e0b73_36c7_4c59_91d5_cd5587fd2b0c ( microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[1], ramOutInverter41f84cdb_d153_4210_a27a_1761ff04bfcf , invertOn463a5db0_a7d2_4106_8288_fdf935ac816a[0] );


inverter ramInInverteraeec2b6c_d7fb_4d49_a8b8_06fcd32bd9fe ( microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[0], ramInInvertercff29776_ebcf_4cdd_a69e_1483e30855c2 , invertOn463a5db0_a7d2_4106_8288_fdf935ac816a[0] );



nRegister memory_address_register04bc32f9_9690_4e31_8392_6fb6950c4c9d ( allInputsFor04bc32f9_9690_4e31_8392_6fb6950c4c9d, clock[0], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[18], memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6 );



staticRamDiscretePorts #("staticram.mem",8,8) main_ram058f23a5_f365_4220_8e38_da596e15e48f ( allAddressInputsFor058f23a5_f365_4220_8e38_da596e15e48f, allDataInputsFor058f23a5_f365_4220_8e38_da596e15e48f, ram_chipEnable19f22829_b6df_4228_80a6_efe7295b2351[0], ramInInvertercff29776_ebcf_4cdd_a69e_1483e30855c2[0],ramOutInverter41f84cdb_d153_4210_a27a_1761ff04bfcf[0],clockFaster[0],main_ram118b3127_9ac9_438d_b207_2884b5d16b15);



nBuffer  #(8) ram_output_buffercbc2a54b_aace_44fa_b35c_8f1bbda139af ( allInputsForcbc2a54b_aace_44fa_b35c_8f1bbda139af, ram_output_bufferc81700b4_0321_498f_925d_c10ca30cc232 , microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[1] );



nRegister OUT_registerb6bda39a_f152_436e_a45e_e386c475386c ( allInputsForb6bda39a_f152_436e_a45e_e386c475386c, clock[0], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[16], OUT_register326d4b27_c9d6_4892_91f1_255a5fc9fb08 );



nRegister B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2 ( allInputsFor6a6161ba_30b5_46f4_b70b_5d08d83841f2, clock[0], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[14], B_registera9d402a3_f423_474d_a57a_03f266088e78 );



nBuffer  #(8) B_reg_bufferc921f68c_903c_4852_b0d5_5512e7dfd00c ( allInputsForc921f68c_903c_4852_b0d5_5512e7dfd00c, B_reg_buffer03bdd088_1cdc_4325_b940_4dba4ade4520 , microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[15] );



nRegister A_register7f6259ba_4079_4214_8482_3b7541d380bc ( allInputsFor7f6259ba_4079_4214_8482_3b7541d380bc, clock[0], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[7], A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa );





nbitComparator A_B_Comparator2a1c439a_c9bd_4101_94e0_ddbf4974c53c ( allADataInputsFor2a1c439a_c9bd_4101_94e0_ddbf4974c53c, allBDataInputsFor2a1c439a_c9bd_4101_94e0_ddbf4974c53c , A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7, A_B_Comparatoree489946_8ec0_4155_b5ba_aa3198a2d8e2);


inverter invertALESSB57a1b1c6_2b08_4f35_8240_68773b47ec50 ( A_B_Comparatoree489946_8ec0_4155_b5ba_aa3198a2d8e2[0], invertALESSB4e7ac467_a9c3_480f_8b69_9a7822cb94c4 , invertON2f29cc42_2b8b_4075_95c3_b9e23518217d[0] );


inverter invertAEQUALBd6adc99f_d43d_42b9_babd_57fc360388ae ( A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7[0], invertAEQUALBe2577cce_e286_43d9_9fbe_b87fbc6aabac , invertON2f29cc42_2b8b_4075_95c3_b9e23518217d[0] );


ANDGATE AGREATERB4b44b68b_d9a7_421f_ad2a_32c496e6e60a ( invertAEQUALBe2577cce_e286_43d9_9fbe_b87fbc6aabac[0], invertALESSB4e7ac467_a9c3_480f_8b69_9a7822cb94c4[0] , AGREATERB512014c4_4144_41ed_b4c4_f824975136a4 );



nRegister flags_register7767ffe9_fc7b_465a_994c_5b37fa114233 ( allInputsFor7767ffe9_fc7b_465a_994c_5b37fa114233, clock[0], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[22], flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0 );


ANDGATE ANDALESSBf284eada_d2d1_4a34_9d15_4c0a3a179295 ( flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[2], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[19] , ANDALESSBf42d180d_9a51_46e4_9ebf_d70f6707c4fe );


ANDGATE ANDAEQUALB62d42f40_c62d_4725_a6d8_a5c17e67fd18 ( flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[1], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[20] , ANDAEQUALBedf57453_64f4_4620_baf9_9782f8645346 );


ANDGATE ANDAGB273c43ac_6a4c_489c_9887_87587786a5cf ( flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[0], microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[21] , ANDAGBf8f962d7_7ca6_4239_b875_5ef2dd2f13c5 );


ORGATE OR123abe0a5_d31b_4ce2_b17f_1bb26d641ba6 ( ANDAGBf8f962d7_7ca6_4239_b875_5ef2dd2f13c5[0], ANDAEQUALBedf57453_64f4_4620_baf9_9782f8645346[0] , OR177f45f69_b75a_4be3_901d_2880357f1de4 );


ORGATE OR230cd6685_5b17_496b_ab1e_d5a31c7593e7 ( OR177f45f69_b75a_4be3_901d_2880357f1de4[0], ANDALESSBf42d180d_9a51_46e4_9ebf_d70f6707c4fe[0] , OR2001f27f7_929e_4c0c_93a1_70cf85c04169 );


inverter loadInverter5f94730a_641d_476e_ad61_79ee8bba1f52 ( OR2001f27f7_929e_4c0c_93a1_70cf85c04169[0], loadInverterdfffd2f0_0359_43f5_9759_916105456181 , invertON2f29cc42_2b8b_4075_95c3_b9e23518217d[0] );



nBuffer  #(8) A_reg_buffer6c77fa5e_eed9_4eb4_b395_22571967cdf7 ( allInputsFor6c77fa5e_eed9_4eb4_b395_22571967cdf7, A_reg_buffer49a20085_746e_433b_8ae5_2129daba083e , microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[8] );





nbitAdder adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed ( SUBMODE, UNCONNECTED , allADataInputsFor4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed, allBDataInputsFor4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed, addere5d94d33_3e6f_45a1_9fd2_e8450c1d165f, adderf56a100e_eae5_4b32_9c3e_6d8ec369d38c  );



nBuffer  #(8) adder_buffer367f9b23_b9c9_4e7a_be78_da0039d22dae ( allInputsFor367f9b23_b9c9_4e7a_be78_da0039d22dae, adder_bufferb9bfffd9_71d5_4200_86e7_281b26ab1bb0 , microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[9] );
        //lets reduce clock to a 1.5hzish clock:
        reg [0:32] counter = 32'b0;
        
            always @ (posedge CLK) 
            begin
                 LED <= OUT_register326d4b27_c9d6_4892_91f1_255a5fc9fb08;
                 ja <= A_register7f963932_f9ef_4859_82af_1f10c6e9d0fa;
                counter <= counter + 1;
                //halt
                if(microCode_SIGNAL_banka0d7526c_fd6d_4103_90f3_fa1a10f2f7bf[17] == 0) begin
                    clock[0] <= counter[9];
                    end
                clockFaster[0] <= counter[12];
            
                ck_io40 <= clock[0];
                ck_io41 <= clockFaster[0];
            end

        endmodule
        