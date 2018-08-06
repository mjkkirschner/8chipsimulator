// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Sun Aug  5 22:43:35 2018
// Host        : MICHAELKIRSE6E4 running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               C:/Users/michaelkirschner/8chipsGenerated/8chipsGenerated.sim/sim_1/impl/func/xsim/top_func_impl.v
// Design      : top
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module binaryCounter
   (Q,
    D,
    \Q_retimed_reg[9] ,
    \Q_reg[6]_0 ,
    SR,
    E,
    clock_BUFG);
  output [7:0]Q;
  input [0:0]D;
  input [6:0]\Q_retimed_reg[9] ;
  input \Q_reg[6]_0 ;
  input [0:0]SR;
  input [0:0]E;
  input clock_BUFG;

  wire [0:0]D;
  wire [0:0]E;
  wire [7:0]Q;
  wire \Q[0]_i_4_n_0 ;
  wire \Q[2]_i_2_n_0 ;
  wire \Q_reg[6]_0 ;
  wire [6:0]\Q_retimed_reg[9] ;
  wire [0:0]SR;
  wire clock_BUFG;
  wire [7:1]p_0_in__0;

  LUT5 #(
    .INIT(32'h8BB8B8B8)) 
    \Q[0]_i_2 
       (.I0(\Q_retimed_reg[9] [6]),
        .I1(\Q_reg[6]_0 ),
        .I2(Q[7]),
        .I3(\Q[0]_i_4_n_0 ),
        .I4(Q[6]),
        .O(p_0_in__0[7]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \Q[0]_i_4 
       (.I0(Q[5]),
        .I1(Q[3]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(Q[2]),
        .I5(Q[4]),
        .O(\Q[0]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h8BB8)) 
    \Q[1]_i_1 
       (.I0(\Q_retimed_reg[9] [5]),
        .I1(\Q_reg[6]_0 ),
        .I2(Q[6]),
        .I3(\Q[0]_i_4_n_0 ),
        .O(p_0_in__0[6]));
  LUT6 #(
    .INIT(64'h8BB8B8B8B8B8B8B8)) 
    \Q[2]_i_1 
       (.I0(\Q_retimed_reg[9] [4]),
        .I1(\Q_reg[6]_0 ),
        .I2(Q[5]),
        .I3(Q[3]),
        .I4(\Q[2]_i_2_n_0 ),
        .I5(Q[4]),
        .O(p_0_in__0[5]));
  LUT3 #(
    .INIT(8'h80)) 
    \Q[2]_i_2 
       (.I0(Q[2]),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(\Q[2]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h8BB8B8B8)) 
    \Q[3]_i_1 
       (.I0(\Q_retimed_reg[9] [3]),
        .I1(\Q_reg[6]_0 ),
        .I2(Q[4]),
        .I3(\Q[2]_i_2_n_0 ),
        .I4(Q[3]),
        .O(p_0_in__0[4]));
  LUT6 #(
    .INIT(64'h8BB8B8B8B8B8B8B8)) 
    \Q[4]_i_1 
       (.I0(\Q_retimed_reg[9] [2]),
        .I1(\Q_reg[6]_0 ),
        .I2(Q[3]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(Q[2]),
        .O(p_0_in__0[3]));
  LUT5 #(
    .INIT(32'h8BBBB888)) 
    \Q[5]_i_1__0 
       (.I0(\Q_retimed_reg[9] [1]),
        .I1(\Q_reg[6]_0 ),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(Q[2]),
        .O(p_0_in__0[2]));
  LUT4 #(
    .INIT(16'h8BB8)) 
    \Q[6]_i_1__0 
       (.I0(\Q_retimed_reg[9] [0]),
        .I1(\Q_reg[6]_0 ),
        .I2(Q[0]),
        .I3(Q[1]),
        .O(p_0_in__0[1]));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[0] 
       (.C(clock_BUFG),
        .CE(E),
        .D(p_0_in__0[7]),
        .Q(Q[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[1] 
       (.C(clock_BUFG),
        .CE(E),
        .D(p_0_in__0[6]),
        .Q(Q[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[2] 
       (.C(clock_BUFG),
        .CE(E),
        .D(p_0_in__0[5]),
        .Q(Q[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[3] 
       (.C(clock_BUFG),
        .CE(E),
        .D(p_0_in__0[4]),
        .Q(Q[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[4] 
       (.C(clock_BUFG),
        .CE(E),
        .D(p_0_in__0[3]),
        .Q(Q[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[5] 
       (.C(clock_BUFG),
        .CE(E),
        .D(p_0_in__0[2]),
        .Q(Q[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[6] 
       (.C(clock_BUFG),
        .CE(E),
        .D(p_0_in__0[1]),
        .Q(Q[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[7] 
       (.C(clock_BUFG),
        .CE(E),
        .D(D),
        .Q(Q[0]),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "binaryCounter" *) 
module binaryCounter_5
   (microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867,
    invert_clock_signale4215683_a56a_4837_9894_65acfeeac185);
  output [0:2]microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867;
  input invert_clock_signale4215683_a56a_4837_9894_65acfeeac185;

  wire [2:0]Q0;
  wire invert_clock_signale4215683_a56a_4837_9894_65acfeeac185;
  wire [0:2]microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867;

  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \Q[5]_i_1 
       (.I0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .I1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .I2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .O(Q0[2]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \Q[6]_i_1 
       (.I0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .I1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .O(Q0[1]));
  LUT1 #(
    .INIT(2'h1)) 
    \Q[7]_i_1 
       (.I0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .O(Q0[0]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \Q_reg[5] 
       (.C(invert_clock_signale4215683_a56a_4837_9894_65acfeeac185),
        .CE(1'b1),
        .D(Q0[2]),
        .Q(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \Q_reg[6] 
       (.C(invert_clock_signale4215683_a56a_4837_9894_65acfeeac185),
        .CE(1'b1),
        .D(Q0[1]),
        .Q(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \Q_reg[7] 
       (.C(invert_clock_signale4215683_a56a_4837_9894_65acfeeac185),
        .CE(1'b1),
        .D(Q0[0]),
        .Q(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .R(1'b0));
endmodule

module nRegister
   (DI,
    Q,
    S,
    \Q_reg[4]_0 ,
    \Q_reg[0]_0 ,
    \Q_reg[0]_1 ,
    \Q_retimed_reg[7] ,
    D,
    clock_BUFG);
  output [3:0]DI;
  output [7:0]Q;
  output [1:0]S;
  output [3:0]\Q_reg[4]_0 ;
  output [2:0]\Q_reg[0]_0 ;
  input [7:0]\Q_reg[0]_1 ;
  input [0:0]\Q_retimed_reg[7] ;
  input [7:0]D;
  input clock_BUFG;

  wire [7:0]D;
  wire [3:0]DI;
  wire [7:0]Q;
  wire [2:0]\Q_reg[0]_0 ;
  wire [7:0]\Q_reg[0]_1 ;
  wire [3:0]\Q_reg[4]_0 ;
  wire [0:0]\Q_retimed_reg[7] ;
  wire [1:0]S;
  wire clock_BUFG;

  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[0] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[7]),
        .Q(Q[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[1] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[6]),
        .Q(Q[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[2] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[5]),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[3] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[4]),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[4] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[3]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[5] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[2]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[6] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[1]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[7] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[7] ),
        .D(D[0]),
        .Q(Q[0]),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h40F4)) 
    lower_carry_i_1
       (.I0(Q[6]),
        .I1(\Q_reg[0]_1 [6]),
        .I2(\Q_reg[0]_1 [7]),
        .I3(Q[7]),
        .O(DI[3]));
  LUT4 #(
    .INIT(16'h44D4)) 
    lower_carry_i_2
       (.I0(Q[5]),
        .I1(\Q_reg[0]_1 [5]),
        .I2(\Q_reg[0]_1 [4]),
        .I3(Q[4]),
        .O(DI[2]));
  LUT4 #(
    .INIT(16'h44D4)) 
    lower_carry_i_3
       (.I0(Q[3]),
        .I1(\Q_reg[0]_1 [3]),
        .I2(\Q_reg[0]_1 [2]),
        .I3(Q[2]),
        .O(DI[1]));
  LUT4 #(
    .INIT(16'h44D4)) 
    lower_carry_i_4
       (.I0(Q[1]),
        .I1(\Q_reg[0]_1 [1]),
        .I2(\Q_reg[0]_1 [0]),
        .I3(Q[0]),
        .O(DI[0]));
  LUT4 #(
    .INIT(16'h9009)) 
    lower_carry_i_6
       (.I0(Q[4]),
        .I1(\Q_reg[0]_1 [4]),
        .I2(Q[5]),
        .I3(\Q_reg[0]_1 [5]),
        .O(S[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    lower_carry_i_7
       (.I0(Q[2]),
        .I1(\Q_reg[0]_1 [2]),
        .I2(Q[3]),
        .I3(\Q_reg[0]_1 [3]),
        .O(S[0]));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry__0_i_2
       (.I0(Q[6]),
        .I1(\Q_reg[0]_1 [6]),
        .O(\Q_reg[0]_0 [2]));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry__0_i_3
       (.I0(Q[5]),
        .I1(\Q_reg[0]_1 [5]),
        .O(\Q_reg[0]_0 [1]));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry__0_i_4
       (.I0(Q[4]),
        .I1(\Q_reg[0]_1 [4]),
        .O(\Q_reg[0]_0 [0]));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry_i_1
       (.I0(Q[3]),
        .I1(\Q_reg[0]_1 [3]),
        .O(\Q_reg[4]_0 [3]));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry_i_2
       (.I0(Q[2]),
        .I1(\Q_reg[0]_1 [2]),
        .O(\Q_reg[4]_0 [2]));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry_i_3
       (.I0(Q[1]),
        .I1(\Q_reg[0]_1 [1]),
        .O(\Q_reg[4]_0 [1]));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry_i_4
       (.I0(Q[0]),
        .I1(\Q_reg[0]_1 [0]),
        .O(\Q_reg[4]_0 [0]));
endmodule

(* ORIG_REF_NAME = "nRegister" *) 
module nRegister_0
   (A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7,
    \Q_reg[0]_0 ,
    S,
    \Q_reg[0]_1 ,
    \Q_reg[1]_0 ,
    \Q_reg[2]_0 ,
    \Q_reg[3]_0 ,
    \Q_reg[4]_0 ,
    \Q_reg[5]_0 ,
    \Q_reg[6]_0 ,
    \Q_reg[7]_0 ,
    \Q_reg[0]_2 ,
    Q,
    \Q_retimed_reg[14] ,
    D,
    clock_BUFG);
  output A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7;
  output [7:0]\Q_reg[0]_0 ;
  output [1:0]S;
  output \Q_reg[0]_1 ;
  output \Q_reg[1]_0 ;
  output \Q_reg[2]_0 ;
  output \Q_reg[3]_0 ;
  output \Q_reg[4]_0 ;
  output \Q_reg[5]_0 ;
  output \Q_reg[6]_0 ;
  output \Q_reg[7]_0 ;
  output [0:0]\Q_reg[0]_2 ;
  input [7:0]Q;
  input [1:0]\Q_retimed_reg[14] ;
  input [7:0]D;
  input clock_BUFG;

  wire A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7;
  wire [7:0]D;
  wire [7:0]Q;
  wire \Q[4]_i_3_n_0 ;
  wire \Q[4]_i_4_n_0 ;
  wire \Q[4]_i_5_n_0 ;
  wire \Q[4]_i_6_n_0 ;
  wire [7:0]\Q_reg[0]_0 ;
  wire \Q_reg[0]_1 ;
  wire [0:0]\Q_reg[0]_2 ;
  wire \Q_reg[1]_0 ;
  wire \Q_reg[2]_0 ;
  wire \Q_reg[3]_0 ;
  wire \Q_reg[4]_0 ;
  wire \Q_reg[5]_0 ;
  wire \Q_reg[6]_0 ;
  wire \Q_reg[7]_0 ;
  wire [1:0]\Q_retimed_reg[14] ;
  wire [1:0]S;
  wire clock_BUFG;

  LUT6 #(
    .INIT(64'h0000004100000000)) 
    \Q[4]_i_2 
       (.I0(\Q[4]_i_3_n_0 ),
        .I1(Q[6]),
        .I2(\Q_reg[0]_0 [6]),
        .I3(\Q[4]_i_4_n_0 ),
        .I4(\Q[4]_i_5_n_0 ),
        .I5(\Q[4]_i_6_n_0 ),
        .O(A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7));
  LUT2 #(
    .INIT(4'h6)) 
    \Q[4]_i_3 
       (.I0(\Q_reg[0]_0 [7]),
        .I1(Q[7]),
        .O(\Q[4]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h6FF6)) 
    \Q[4]_i_4 
       (.I0(\Q_reg[0]_0 [5]),
        .I1(Q[5]),
        .I2(\Q_reg[0]_0 [4]),
        .I3(Q[4]),
        .O(\Q[4]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h6FF6)) 
    \Q[4]_i_5 
       (.I0(\Q_reg[0]_0 [3]),
        .I1(Q[3]),
        .I2(\Q_reg[0]_0 [2]),
        .I3(Q[2]),
        .O(\Q[4]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    \Q[4]_i_6 
       (.I0(\Q_reg[0]_0 [1]),
        .I1(Q[1]),
        .I2(\Q_reg[0]_0 [0]),
        .I3(Q[0]),
        .O(\Q[4]_i_6_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[0] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[7]),
        .Q(\Q_reg[0]_0 [7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[1] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[6]),
        .Q(\Q_reg[0]_0 [6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[2] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[5]),
        .Q(\Q_reg[0]_0 [5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[3] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[4]),
        .Q(\Q_reg[0]_0 [4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[4] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[3]),
        .Q(\Q_reg[0]_0 [3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[5] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[2]),
        .Q(\Q_reg[0]_0 [2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[6] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[1]),
        .Q(\Q_reg[0]_0 [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[7] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[14] [1]),
        .D(D[0]),
        .Q(\Q_reg[0]_0 [0]),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h9009)) 
    lower_carry_i_5
       (.I0(\Q_reg[0]_0 [6]),
        .I1(Q[6]),
        .I2(Q[7]),
        .I3(\Q_reg[0]_0 [7]),
        .O(S[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    lower_carry_i_8
       (.I0(\Q_reg[0]_0 [1]),
        .I1(Q[1]),
        .I2(\Q_reg[0]_0 [0]),
        .I3(Q[0]),
        .O(S[0]));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_11
       (.I0(\Q_reg[0]_0 [6]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[1]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_13
       (.I0(\Q_reg[0]_0 [5]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[2]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_15
       (.I0(\Q_reg[0]_0 [4]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[3]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_17
       (.I0(\Q_reg[0]_0 [3]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[4]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_19
       (.I0(\Q_reg[0]_0 [2]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[5]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_21
       (.I0(\Q_reg[0]_0 [1]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[6]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_23
       (.I0(\Q_reg[0]_0 [0]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[7]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_i_9
       (.I0(\Q_reg[0]_0 [7]),
        .I1(\Q_retimed_reg[14] [0]),
        .O(\Q_reg[0]_1 ));
  LUT2 #(
    .INIT(4'h6)) 
    sum0_carry__0_i_1
       (.I0(\Q_reg[0]_0 [7]),
        .I1(Q[7]),
        .O(\Q_reg[0]_2 ));
endmodule

(* ORIG_REF_NAME = "nRegister" *) 
module nRegister_1
   (Q,
    \Q_retimed_reg[16] ,
    D,
    clock_BUFG);
  output [3:0]Q;
  input [0:0]\Q_retimed_reg[16] ;
  input [3:0]D;
  input clock_BUFG;

  wire [3:0]D;
  wire [3:0]Q;
  wire [0:0]\Q_retimed_reg[16] ;
  wire clock_BUFG;

  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[4] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[16] ),
        .D(D[3]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[5] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[16] ),
        .D(D[2]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[6] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[16] ),
        .D(D[1]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[7] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[16] ),
        .D(D[0]),
        .Q(Q[0]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "nRegister" *) 
module nRegister_2
   (\Q_reg[0] ,
    Q,
    D,
    A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7,
    clock_BUFG);
  output \Q_reg[0] ;
  input [3:0]Q;
  input [0:0]D;
  input A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7;
  input clock_BUFG;

  wire A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7;
  wire [0:0]D;
  wire [3:0]Q;
  wire \Q[4]_i_1_n_0 ;
  wire \Q[5]_i_1_n_0 ;
  wire \Q[6]_i_1_n_0 ;
  wire \Q_reg[0] ;
  wire clock_BUFG;
  wire [3:1]flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0;

  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \Q[0]_i_3 
       (.I0(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[1]),
        .I1(Q[3]),
        .I2(Q[1]),
        .I3(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[3]),
        .I4(Q[2]),
        .I5(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[2]),
        .O(\Q_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h1F10)) 
    \Q[4]_i_1 
       (.I0(D),
        .I1(A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7),
        .I2(Q[0]),
        .I3(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[3]),
        .O(\Q[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \Q[5]_i_1 
       (.I0(A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7),
        .I1(Q[0]),
        .I2(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[2]),
        .O(\Q[5]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \Q[6]_i_1 
       (.I0(D),
        .I1(Q[0]),
        .I2(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[1]),
        .O(\Q[6]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[4] 
       (.C(clock_BUFG),
        .CE(1'b1),
        .D(\Q[4]_i_1_n_0 ),
        .Q(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[5] 
       (.C(clock_BUFG),
        .CE(1'b1),
        .D(\Q[5]_i_1_n_0 ),
        .Q(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[6] 
       (.C(clock_BUFG),
        .CE(1'b1),
        .D(\Q[6]_i_1_n_0 ),
        .Q(flags_register4c9a351f_3729_4319_be1e_20bbeca8a4d0[1]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "nRegister" *) 
module nRegister_3
   (Q,
    \Q_retimed_reg[2] ,
    D,
    clock_BUFG);
  output [3:0]Q;
  input [0:0]\Q_retimed_reg[2] ;
  input [3:0]D;
  input clock_BUFG;

  wire [3:0]D;
  wire [3:0]Q;
  wire [0:0]\Q_retimed_reg[2] ;
  wire clock_BUFG;

  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[4] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[2] ),
        .D(D[3]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[5] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[2] ),
        .D(D[2]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[6] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[2] ),
        .D(D[1]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[7] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[2] ),
        .D(D[0]),
        .Q(Q[0]),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "nRegister" *) 
module nRegister_4
   (Q,
    \Q_retimed_reg[18] ,
    D,
    clock_BUFG);
  output [7:0]Q;
  input [0:0]\Q_retimed_reg[18] ;
  input [7:0]D;
  input clock_BUFG;

  wire [7:0]D;
  wire [7:0]Q;
  wire [0:0]\Q_retimed_reg[18] ;
  wire clock_BUFG;

  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[0] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[7]),
        .Q(Q[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[1] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[6]),
        .Q(Q[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[2] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[5]),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[3] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[4]),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[4] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[3]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[5] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[2]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[6] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[1]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[7] 
       (.C(clock_BUFG),
        .CE(\Q_retimed_reg[18] ),
        .D(D[0]),
        .Q(Q[0]),
        .R(1'b0));
endmodule

module nbitAdder
   (O,
    \Q_reg[0] ,
    Q,
    \Q_reg[4] ,
    S);
  output [3:0]O;
  output [3:0]\Q_reg[0] ;
  input [6:0]Q;
  input [3:0]\Q_reg[4] ;
  input [3:0]S;

  wire [3:0]O;
  wire [6:0]Q;
  wire [3:0]\Q_reg[0] ;
  wire [3:0]\Q_reg[4] ;
  wire [3:0]S;
  wire sum0_carry_n_0;
  wire [2:0]NLW_sum0_carry_CO_UNCONNECTED;
  wire [3:0]NLW_sum0_carry__0_CO_UNCONNECTED;

  CARRY4 sum0_carry
       (.CI(1'b0),
        .CO({sum0_carry_n_0,NLW_sum0_carry_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI(Q[3:0]),
        .O(O),
        .S(\Q_reg[4] ));
  CARRY4 sum0_carry__0
       (.CI(sum0_carry_n_0),
        .CO(NLW_sum0_carry__0_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,Q[6:4]}),
        .O(\Q_reg[0] ),
        .S(S));
endmodule

module nbitComparator
   (D,
    DI,
    S);
  output [0:0]D;
  input [3:0]DI;
  input [3:0]S;

  wire [0:0]D;
  wire [3:0]DI;
  wire [3:0]S;
  wire [2:0]NLW_lower_carry_CO_UNCONNECTED;
  wire [3:0]NLW_lower_carry_O_UNCONNECTED;

  CARRY4 lower_carry
       (.CI(1'b0),
        .CO({D,NLW_lower_carry_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI(DI),
        .O(NLW_lower_carry_O_UNCONNECTED[3:0]),
        .S(S));
endmodule

module staticRamDiscretePorts
   (E,
    Q,
    D,
    \Q_reg[0] ,
    \clock_reg[0] ,
    \Q_reg[6] ,
    \Q_reg[0]_0 ,
    \Q_reg[1] ,
    \Q_reg[0]_1 ,
    DOADO,
    \Q_reg[0]_2 ,
    \Q_reg[1]_0 ,
    \Q_reg[2] ,
    \Q_reg[3] ,
    O,
    \Q_reg[4] ,
    \Q_reg[5] ,
    \Q_reg[6]_0 ,
    \Q_reg[7] ,
    clock,
    out,
    clockFaster_BUFG,
    microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867,
    \Q_reg[4]_0 );
  output [0:0]E;
  output [10:0]Q;
  output [0:0]D;
  output [7:0]\Q_reg[0] ;
  output \clock_reg[0] ;
  input \Q_reg[6] ;
  input [7:0]\Q_reg[0]_0 ;
  input [3:0]\Q_reg[1] ;
  input \Q_reg[0]_1 ;
  input [7:0]DOADO;
  input [7:0]\Q_reg[0]_2 ;
  input \Q_reg[1]_0 ;
  input \Q_reg[2] ;
  input \Q_reg[3] ;
  input [3:0]O;
  input \Q_reg[4] ;
  input \Q_reg[5] ;
  input \Q_reg[6]_0 ;
  input \Q_reg[7] ;
  input clock;
  input [0:0]out;
  input clockFaster_BUFG;
  input [0:2]microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867;
  input [3:0]\Q_reg[4]_0 ;

  wire [0:0]D;
  wire [7:0]DOADO;
  wire [0:0]E;
  wire [3:0]O;
  wire [10:0]Q;
  wire [23:1]Q1;
  wire [7:0]\Q_reg[0] ;
  wire [7:0]\Q_reg[0]_0 ;
  wire \Q_reg[0]_1 ;
  wire [7:0]\Q_reg[0]_2 ;
  wire [3:0]\Q_reg[1] ;
  wire \Q_reg[1]_0 ;
  wire \Q_reg[2] ;
  wire \Q_reg[3] ;
  wire \Q_reg[4] ;
  wire [3:0]\Q_reg[4]_0 ;
  wire \Q_reg[5] ;
  wire \Q_reg[6] ;
  wire \Q_reg[6]_0 ;
  wire \Q_reg[7] ;
  wire clock;
  wire clockFaster_BUFG;
  wire \clock_reg[0] ;
  wire mem_reg_i_10_n_0;
  wire mem_reg_i_12_n_0;
  wire mem_reg_i_14_n_0;
  wire mem_reg_i_16_n_0;
  wire mem_reg_i_18_n_0;
  wire mem_reg_i_20_n_0;
  wire mem_reg_i_22_n_0;
  wire mem_reg_i_24_n_0;
  wire [1:17]microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d;
  wire [0:2]microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867;
  wire [0:0]out;

  LUT2 #(
    .INIT(4'hE)) 
    \Q[0]_i_1 
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[6]),
        .I1(\Q_reg[6] ),
        .O(E));
  LUT3 #(
    .INIT(8'h8B)) 
    \Q[7]_i_1__0 
       (.I0(\Q_reg[0] [0]),
        .I1(\Q_reg[6] ),
        .I2(\Q_reg[0]_0 [0]),
        .O(D));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[0] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[23]),
        .Q(Q[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[14] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[9]),
        .Q(Q[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[15] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[8]),
        .Q(Q[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[16] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[7]),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[17] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[6]),
        .Q(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[18] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[5]),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[19] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[4]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[1] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[22]),
        .Q(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[20] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[3]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[21] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[2]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[22] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[1]),
        .Q(Q[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[2] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[21]),
        .Q(Q[9]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[4] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[19]),
        .Q(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[6] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[17]),
        .Q(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[7] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[16]),
        .Q(Q[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[8] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[15]),
        .Q(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \Q_retimed_reg[9] 
       (.C(clockFaster_BUFG),
        .CE(1'b1),
        .D(Q1[14]),
        .Q(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hB8)) 
    \clock[0]_i_1 
       (.I0(clock),
        .I1(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[17]),
        .I2(out),
        .O(\clock_reg[0] ));
  RAM128X1S #(
    .INIT(128'h00000000000000000000002020000000)) 
    mem_reg_0_127_14_14
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[14]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00000000000000000000100000040000)) 
    mem_reg_0_127_15_15
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[15]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00000000000000000008002020001000)) 
    mem_reg_0_127_16_16
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[16]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h0202120A120A0A0A020A121212021202)) 
    mem_reg_0_127_17_17
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[17]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h01010505050505050505050505010501)) 
    mem_reg_0_127_19_19
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[19]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00040000000000000000000000000000)) 
    mem_reg_0_127_1_1
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[1]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h02020202020202020202020202020202)) 
    mem_reg_0_127_21_21
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[21]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h02020A0A1A1212120A0A0A1A1A021A02)) 
    mem_reg_0_127_22_22
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[22]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00001000000000000000100000000000)) 
    mem_reg_0_127_23_23
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[23]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00000000001000000800000000000000)) 
    mem_reg_0_127_2_2
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[2]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00000000000000100800000000000000)) 
    mem_reg_0_127_3_3
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[3]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00000000000010000800000000000000)) 
    mem_reg_0_127_4_4
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[4]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h01010D050D05050505050D0D0D010D01)) 
    mem_reg_0_127_5_5
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[5]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h04000000000000000000000000000000)) 
    mem_reg_0_127_6_6
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[6]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00000000000000000000000000040000)) 
    mem_reg_0_127_7_7
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[7]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00001000000000000000000000000000)) 
    mem_reg_0_127_8_8
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[8]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  RAM128X1S #(
    .INIT(128'h00000008100000000000001010000000)) 
    mem_reg_0_127_9_9
       (.A0(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[2]),
        .A1(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[1]),
        .A2(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867[0]),
        .A3(\Q_reg[4]_0 [0]),
        .A4(\Q_reg[4]_0 [1]),
        .A5(\Q_reg[4]_0 [2]),
        .A6(\Q_reg[4]_0 [3]),
        .D(1'b0),
        .O(Q1[9]),
        .WCLK(clockFaster_BUFG),
        .WE(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_1
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I1(\Q_reg[1] [3]),
        .I2(\Q_reg[0]_1 ),
        .I3(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I4(DOADO[7]),
        .I5(mem_reg_i_10_n_0),
        .O(\Q_reg[0] [7]));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_10
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [7]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [7]),
        .O(mem_reg_i_10_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_12
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [6]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [6]),
        .O(mem_reg_i_12_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_14
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [5]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [5]),
        .O(mem_reg_i_14_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_16
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [4]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [4]),
        .O(mem_reg_i_16_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_18
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [3]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [3]),
        .O(mem_reg_i_18_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_2
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I1(\Q_reg[1] [2]),
        .I2(\Q_reg[1]_0 ),
        .I3(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I4(DOADO[6]),
        .I5(mem_reg_i_12_n_0),
        .O(\Q_reg[0] [6]));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_20
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [2]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [2]),
        .O(mem_reg_i_20_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_22
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [1]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [1]),
        .O(mem_reg_i_22_n_0));
  LUT4 #(
    .INIT(16'hF888)) 
    mem_reg_i_24
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[8]),
        .I1(\Q_reg[0]_2 [0]),
        .I2(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[4]),
        .I3(\Q_reg[0]_0 [0]),
        .O(mem_reg_i_24_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_3
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I1(\Q_reg[1] [1]),
        .I2(\Q_reg[2] ),
        .I3(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I4(DOADO[5]),
        .I5(mem_reg_i_14_n_0),
        .O(\Q_reg[0] [5]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_4
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I1(\Q_reg[1] [0]),
        .I2(\Q_reg[3] ),
        .I3(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I4(DOADO[4]),
        .I5(mem_reg_i_16_n_0),
        .O(\Q_reg[0] [4]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_5
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I1(O[3]),
        .I2(\Q_reg[4] ),
        .I3(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I4(DOADO[3]),
        .I5(mem_reg_i_18_n_0),
        .O(\Q_reg[0] [3]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_6
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I1(O[2]),
        .I2(\Q_reg[5] ),
        .I3(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I4(DOADO[2]),
        .I5(mem_reg_i_20_n_0),
        .O(\Q_reg[0] [2]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_7
       (.I0(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I1(O[1]),
        .I2(\Q_reg[6]_0 ),
        .I3(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I4(DOADO[1]),
        .I5(mem_reg_i_22_n_0),
        .O(\Q_reg[0] [1]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF8F8F8)) 
    mem_reg_i_8
       (.I0(O[0]),
        .I1(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[9]),
        .I2(\Q_reg[7] ),
        .I3(DOADO[0]),
        .I4(microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[1]),
        .I5(mem_reg_i_24_n_0),
        .O(\Q_reg[0] [0]));
endmodule

(* ORIG_REF_NAME = "staticRamDiscretePorts" *) 
module staticRamDiscretePorts__parameterized0
   (DOADO,
    clockFaster_BUFG,
    Q,
    D,
    \Q_retimed_reg[0] );
  output [7:0]DOADO;
  input clockFaster_BUFG;
  input [7:0]Q;
  input [7:0]D;
  input [0:0]\Q_retimed_reg[0] ;

  wire [7:0]D;
  wire [7:0]DOADO;
  wire [7:0]Q;
  wire [0:0]\Q_retimed_reg[0] ;
  wire clockFaster_BUFG;
  wire [15:8]NLW_mem_reg_DOADO_UNCONNECTED;
  wire [15:0]NLW_mem_reg_DOBDO_UNCONNECTED;
  wire [1:0]NLW_mem_reg_DOPADOP_UNCONNECTED;
  wire [1:0]NLW_mem_reg_DOPBDOP_UNCONNECTED;

  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d8" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-6 {cell *THIS*}}" *) 
  (* RTL_RAM_BITS = "2048" *) 
  (* RTL_RAM_NAME = "main_ram058f23a5_f365_4220_8e38_da596e15e48f/mem" *) 
  (* bram_addr_begin = "0" *) 
  (* bram_addr_end = "1023" *) 
  (* bram_slice_begin = "0" *) 
  (* bram_slice_end = "7" *) 
  RAMB18E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h00000000000000000000000F000200020009000E0019000C0064000300140006),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000010000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("PERFORMANCE"),
    .READ_WIDTH_A(18),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(18),
    .WRITE_WIDTH_B(0)) 
    mem_reg
       (.ADDRARDADDR({1'b0,1'b0,Q,1'b0,1'b0,1'b0,1'b0}),
        .ADDRBWRADDR({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CLKARDCLK(clockFaster_BUFG),
        .CLKBWRCLK(1'b0),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,D}),
        .DIBDI({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .DIPADIP({1'b0,1'b0}),
        .DIPBDIP({1'b1,1'b1}),
        .DOADO({NLW_mem_reg_DOADO_UNCONNECTED[15:8],DOADO}),
        .DOBDO(NLW_mem_reg_DOBDO_UNCONNECTED[15:0]),
        .DOPADOP(NLW_mem_reg_DOPADOP_UNCONNECTED[1:0]),
        .DOPBDOP(NLW_mem_reg_DOPBDOP_UNCONNECTED[1:0]),
        .ENARDEN(1'b1),
        .ENBWREN(1'b0),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .WEA({\Q_retimed_reg[0] ,\Q_retimed_reg[0] }),
        .WEBWE({1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ECO_CHECKSUM = "e7c14116" *) (* POWER_OPT_BRAM_CDC = "1" *) (* POWER_OPT_BRAM_SR_ADDR = "0" *) 
(* POWER_OPT_LOOPED_NET_PERCENTAGE = "0" *) 
(* NotValidForBitStream *)
module top
   (CLK,
    BTN,
    ck_io,
    LED,
    ja);
  input CLK;
  input [0:0]BTN;
  output [0:1]ck_io;
  output [0:3]LED;
  output [0:7]ja;

  wire A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7;
  wire A_B_Comparatoree489946_8ec0_4155_b5ba_aa3198a2d8e2;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_0;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_1;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_12;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_13;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_14;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_15;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_16;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_17;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_18;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_19;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_2;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_20;
  wire A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_3;
  wire [0:0]BTN;
  wire [0:0]BTN_IBUF;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_1;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_10;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_11;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_12;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_13;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_14;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_15;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_16;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_17;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_18;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_19;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_2;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_3;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_4;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_5;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_6;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_7;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_8;
  wire B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_9;
  wire CLK;
  wire CLK_IBUF;
  wire CLK_IBUF_BUFG;
  wire [0:3]LED;
  wire [0:3]LED_OBUF;
  wire OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_0;
  wire OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_1;
  wire OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_2;
  wire OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_3;
  wire [0:7]Q_reg__0;
  wire [0:7]a;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_0;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_1;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_2;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_3;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_4;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_5;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_6;
  wire adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_7;
  wire [0:1]ck_io;
  wire [0:1]ck_io_OBUF;
  wire clock;
  wire clockFaster;
  wire clockFaster_BUFG;
  wire clock_BUFG;
  wire \counter[32]_i_2_n_0 ;
  wire \counter_reg[12]_i_1_n_4 ;
  wire \counter_reg[12]_i_1_n_5 ;
  wire \counter_reg[12]_i_1_n_6 ;
  wire \counter_reg[12]_i_1_n_7 ;
  wire \counter_reg[16]_i_1_n_0 ;
  wire \counter_reg[16]_i_1_n_4 ;
  wire \counter_reg[16]_i_1_n_5 ;
  wire \counter_reg[16]_i_1_n_6 ;
  wire \counter_reg[16]_i_1_n_7 ;
  wire \counter_reg[20]_i_1_n_0 ;
  wire \counter_reg[20]_i_1_n_4 ;
  wire \counter_reg[20]_i_1_n_5 ;
  wire \counter_reg[20]_i_1_n_6 ;
  wire \counter_reg[20]_i_1_n_7 ;
  wire \counter_reg[24]_i_1_n_0 ;
  wire \counter_reg[24]_i_1_n_4 ;
  wire \counter_reg[24]_i_1_n_5 ;
  wire \counter_reg[24]_i_1_n_6 ;
  wire \counter_reg[24]_i_1_n_7 ;
  wire \counter_reg[28]_i_1_n_0 ;
  wire \counter_reg[28]_i_1_n_4 ;
  wire \counter_reg[28]_i_1_n_5 ;
  wire \counter_reg[28]_i_1_n_6 ;
  wire \counter_reg[28]_i_1_n_7 ;
  wire \counter_reg[32]_i_1_n_0 ;
  wire \counter_reg[32]_i_1_n_4 ;
  wire \counter_reg[32]_i_1_n_5 ;
  wire \counter_reg[32]_i_1_n_6 ;
  wire \counter_reg[32]_i_1_n_7 ;
  wire \counter_reg_n_0_[10] ;
  wire \counter_reg_n_0_[11] ;
  wire \counter_reg_n_0_[13] ;
  wire \counter_reg_n_0_[14] ;
  wire \counter_reg_n_0_[15] ;
  wire \counter_reg_n_0_[16] ;
  wire \counter_reg_n_0_[17] ;
  wire \counter_reg_n_0_[18] ;
  wire \counter_reg_n_0_[19] ;
  wire \counter_reg_n_0_[20] ;
  wire \counter_reg_n_0_[21] ;
  wire \counter_reg_n_0_[22] ;
  wire \counter_reg_n_0_[23] ;
  wire \counter_reg_n_0_[24] ;
  wire \counter_reg_n_0_[25] ;
  wire \counter_reg_n_0_[26] ;
  wire \counter_reg_n_0_[27] ;
  wire \counter_reg_n_0_[28] ;
  wire \counter_reg_n_0_[29] ;
  wire \counter_reg_n_0_[30] ;
  wire \counter_reg_n_0_[31] ;
  wire \counter_reg_n_0_[32] ;
  wire flags_register7767ffe9_fc7b_465a_994c_5b37fa114233_n_0;
  wire [3:0]instruction_register9cf21404_4514_41e1_a233_f7d5c5411526;
  wire [0:7]ja;
  wire [0:7]ja_OBUF;
  wire [0:7]main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d;
  wire [0:7]main_ram118b3127_9ac9_438d_b207_2884b5d16b15;
  wire [0:7]memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6;
  wire microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2_n_0;
  wire microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2_n_21;
  wire [0:22]microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d;
  wire [0:2]microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867;
  wire p_0_in;
  wire [0:0]p_0_in__0;
  wire p_1_in;
  wire [3:0]\NLW_counter_reg[12]_i_1_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[16]_i_1_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[20]_i_1_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[24]_i_1_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[28]_i_1_CO_UNCONNECTED ;
  wire [2:0]\NLW_counter_reg[32]_i_1_CO_UNCONNECTED ;

  nbitComparator A_B_Comparator2a1c439a_c9bd_4101_94e0_ddbf4974c53c
       (.D(A_B_Comparatoree489946_8ec0_4155_b5ba_aa3198a2d8e2),
        .DI({A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_0,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_1,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_2,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_3}),
        .S({B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_9,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_12,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_13,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_10}));
  nRegister A_register7f6259ba_4079_4214_8482_3b7541d380bc
       (.D({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]}),
        .DI({A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_0,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_1,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_2,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_3}),
        .Q({a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]}),
        .\Q_reg[0]_0 ({A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_18,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_19,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_20}),
        .\Q_reg[0]_1 ({B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_1,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_2,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_3,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_4,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_5,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_6,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_7,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_8}),
        .\Q_reg[4]_0 ({A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_14,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_15,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_16,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_17}),
        .\Q_retimed_reg[7] (microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[7]),
        .S({A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_12,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_13}),
        .clock_BUFG(clock_BUFG));
  IBUF \BTN_IBUF[0]_inst 
       (.I(BTN),
        .O(BTN_IBUF));
  nRegister_0 B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2
       (.A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7(A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7),
        .D({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]}),
        .Q({a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]}),
        .\Q_reg[0]_0 ({B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_1,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_2,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_3,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_4,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_5,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_6,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_7,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_8}),
        .\Q_reg[0]_1 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_11),
        .\Q_reg[0]_2 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_19),
        .\Q_reg[1]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_12),
        .\Q_reg[2]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_13),
        .\Q_reg[3]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_14),
        .\Q_reg[4]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_15),
        .\Q_reg[5]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_16),
        .\Q_reg[6]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_17),
        .\Q_reg[7]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_18),
        .\Q_retimed_reg[14] ({microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[14],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[15]}),
        .S({B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_9,B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_10}),
        .clock_BUFG(clock_BUFG));
  BUFG CLK_IBUF_BUFG_inst
       (.I(CLK_IBUF),
        .O(CLK_IBUF_BUFG));
  IBUF CLK_IBUF_inst
       (.I(CLK),
        .O(CLK_IBUF));
  OBUF \LED_OBUF[0]_inst 
       (.I(LED_OBUF[0]),
        .O(LED[0]));
  OBUF \LED_OBUF[1]_inst 
       (.I(LED_OBUF[1]),
        .O(LED[1]));
  OBUF \LED_OBUF[2]_inst 
       (.I(LED_OBUF[2]),
        .O(LED[2]));
  OBUF \LED_OBUF[3]_inst 
       (.I(LED_OBUF[3]),
        .O(LED[3]));
  FDRE #(
    .INIT(1'b0)) 
    \LED_reg[0] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_0),
        .Q(LED_OBUF[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \LED_reg[1] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_1),
        .Q(LED_OBUF[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \LED_reg[2] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_2),
        .Q(LED_OBUF[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \LED_reg[3] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_3),
        .Q(LED_OBUF[3]),
        .R(1'b0));
  nRegister_1 OUT_registerb6bda39a_f152_436e_a45e_e386c475386c
       (.D({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]}),
        .Q({OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_0,OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_1,OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_2,OUT_registerb6bda39a_f152_436e_a45e_e386c475386c_n_3}),
        .\Q_retimed_reg[16] (microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[16]),
        .clock_BUFG(clock_BUFG));
  binaryCounter Program_Counterc36da09d_cc52_43a9_a1d9_c841131cb066
       (.D(p_0_in__0),
        .E(microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2_n_0),
        .Q({Q_reg__0[0],Q_reg__0[1],Q_reg__0[2],Q_reg__0[3],Q_reg__0[4],Q_reg__0[5],Q_reg__0[6],Q_reg__0[7]}),
        .\Q_reg[6]_0 (flags_register7767ffe9_fc7b_465a_994c_5b37fa114233_n_0),
        .\Q_retimed_reg[9] ({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6]}),
        .SR(BTN_IBUF),
        .clock_BUFG(clock_BUFG));
  nbitAdder adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed
       (.O({adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_0,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_1,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_2,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_3}),
        .Q({a[1],a[2],a[3],a[4],a[5],a[6],a[7]}),
        .\Q_reg[0] ({adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_4,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_5,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_6,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_7}),
        .\Q_reg[4] ({A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_14,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_15,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_16,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_17}),
        .S({B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_19,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_18,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_19,A_register7f6259ba_4079_4214_8482_3b7541d380bc_n_20}));
  OBUF \ck_io_OBUF[0]_inst 
       (.I(ck_io_OBUF[0]),
        .O(ck_io[0]));
  OBUF \ck_io_OBUF[1]_inst 
       (.I(ck_io_OBUF[1]),
        .O(ck_io[1]));
  FDRE #(
    .INIT(1'b0)) 
    \ck_io_reg[0] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(clock_BUFG),
        .Q(ck_io_OBUF[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ck_io_reg[1] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(clockFaster_BUFG),
        .Q(ck_io_OBUF[1]),
        .R(1'b0));
  BUFG clockFaster_BUFG_inst
       (.I(clockFaster),
        .O(clockFaster_BUFG));
  FDRE #(
    .INIT(1'b0)) 
    \clockFaster_reg[0] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_in),
        .Q(clockFaster),
        .R(1'b0));
  BUFG clock_BUFG_inst
       (.I(clock),
        .O(clock_BUFG));
  FDRE #(
    .INIT(1'b0)) 
    \clock_reg[0] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2_n_21),
        .Q(clock),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[32]_i_2 
       (.I0(\counter_reg_n_0_[32] ),
        .O(\counter[32]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[10] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[11] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_7 ),
        .Q(p_0_in),
        .R(1'b0));
  CARRY4 \counter_reg[12]_i_1 
       (.CI(\counter_reg[16]_i_1_n_0 ),
        .CO(\NLW_counter_reg[12]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[12]_i_1_n_4 ,\counter_reg[12]_i_1_n_5 ,\counter_reg[12]_i_1_n_6 ,\counter_reg[12]_i_1_n_7 }),
        .S({p_1_in,\counter_reg_n_0_[10] ,\counter_reg_n_0_[11] ,p_0_in}));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[13] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[13] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[14] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[14] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[15] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[15] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[16] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[16] ),
        .R(1'b0));
  CARRY4 \counter_reg[16]_i_1 
       (.CI(\counter_reg[20]_i_1_n_0 ),
        .CO({\counter_reg[16]_i_1_n_0 ,\NLW_counter_reg[16]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[16]_i_1_n_4 ,\counter_reg[16]_i_1_n_5 ,\counter_reg[16]_i_1_n_6 ,\counter_reg[16]_i_1_n_7 }),
        .S({\counter_reg_n_0_[13] ,\counter_reg_n_0_[14] ,\counter_reg_n_0_[15] ,\counter_reg_n_0_[16] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[17] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[17] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[18] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[18] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[19] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[19] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[20] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[20] ),
        .R(1'b0));
  CARRY4 \counter_reg[20]_i_1 
       (.CI(\counter_reg[24]_i_1_n_0 ),
        .CO({\counter_reg[20]_i_1_n_0 ,\NLW_counter_reg[20]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[20]_i_1_n_4 ,\counter_reg[20]_i_1_n_5 ,\counter_reg[20]_i_1_n_6 ,\counter_reg[20]_i_1_n_7 }),
        .S({\counter_reg_n_0_[17] ,\counter_reg_n_0_[18] ,\counter_reg_n_0_[19] ,\counter_reg_n_0_[20] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[21] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[21] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[22] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[22] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[23] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[23] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[24] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[24] ),
        .R(1'b0));
  CARRY4 \counter_reg[24]_i_1 
       (.CI(\counter_reg[28]_i_1_n_0 ),
        .CO({\counter_reg[24]_i_1_n_0 ,\NLW_counter_reg[24]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[24]_i_1_n_4 ,\counter_reg[24]_i_1_n_5 ,\counter_reg[24]_i_1_n_6 ,\counter_reg[24]_i_1_n_7 }),
        .S({\counter_reg_n_0_[21] ,\counter_reg_n_0_[22] ,\counter_reg_n_0_[23] ,\counter_reg_n_0_[24] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[25] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[28]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[25] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[26] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[28]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[26] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[27] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[28]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[27] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[28] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[28]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[28] ),
        .R(1'b0));
  CARRY4 \counter_reg[28]_i_1 
       (.CI(\counter_reg[32]_i_1_n_0 ),
        .CO({\counter_reg[28]_i_1_n_0 ,\NLW_counter_reg[28]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[28]_i_1_n_4 ,\counter_reg[28]_i_1_n_5 ,\counter_reg[28]_i_1_n_6 ,\counter_reg[28]_i_1_n_7 }),
        .S({\counter_reg_n_0_[25] ,\counter_reg_n_0_[26] ,\counter_reg_n_0_[27] ,\counter_reg_n_0_[28] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[29] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[32]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[29] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[30] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[32]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[30] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[31] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[32]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[31] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[32] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[32]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[32] ),
        .R(1'b0));
  CARRY4 \counter_reg[32]_i_1 
       (.CI(1'b0),
        .CO({\counter_reg[32]_i_1_n_0 ,\NLW_counter_reg[32]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\counter_reg[32]_i_1_n_4 ,\counter_reg[32]_i_1_n_5 ,\counter_reg[32]_i_1_n_6 ,\counter_reg[32]_i_1_n_7 }),
        .S({\counter_reg_n_0_[29] ,\counter_reg_n_0_[30] ,\counter_reg_n_0_[31] ,\counter[32]_i_2_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_4 ),
        .Q(p_1_in),
        .R(1'b0));
  nRegister_2 flags_register7767ffe9_fc7b_465a_994c_5b37fa114233
       (.A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7(A_B_Comparator24b031dd_6879_4b4a_99c5_d4232582f3e7),
        .D(A_B_Comparatoree489946_8ec0_4155_b5ba_aa3198a2d8e2),
        .Q({microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[19],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[20],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[21],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[22]}),
        .\Q_reg[0] (flags_register7767ffe9_fc7b_465a_994c_5b37fa114233_n_0),
        .clock_BUFG(clock_BUFG));
  nRegister_3 instruction_register9e5dabe8_e0a0_42c4_b393_6af36048eb59
       (.D({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]}),
        .Q(instruction_register9cf21404_4514_41e1_a233_f7d5c5411526),
        .\Q_retimed_reg[2] (microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[2]),
        .clock_BUFG(clock_BUFG));
  OBUF \ja_OBUF[0]_inst 
       (.I(ja_OBUF[0]),
        .O(ja[0]));
  OBUF \ja_OBUF[1]_inst 
       (.I(ja_OBUF[1]),
        .O(ja[1]));
  OBUF \ja_OBUF[2]_inst 
       (.I(ja_OBUF[2]),
        .O(ja[2]));
  OBUF \ja_OBUF[3]_inst 
       (.I(ja_OBUF[3]),
        .O(ja[3]));
  OBUF \ja_OBUF[4]_inst 
       (.I(ja_OBUF[4]),
        .O(ja[4]));
  OBUF \ja_OBUF[5]_inst 
       (.I(ja_OBUF[5]),
        .O(ja[5]));
  OBUF \ja_OBUF[6]_inst 
       (.I(ja_OBUF[6]),
        .O(ja[6]));
  OBUF \ja_OBUF[7]_inst 
       (.I(ja_OBUF[7]),
        .O(ja[7]));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[0] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[0]),
        .Q(ja_OBUF[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[1] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[1]),
        .Q(ja_OBUF[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[2] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[2]),
        .Q(ja_OBUF[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[3] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[3]),
        .Q(ja_OBUF[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[4] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[4]),
        .Q(ja_OBUF[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[5] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[5]),
        .Q(ja_OBUF[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[6] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[6]),
        .Q(ja_OBUF[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ja_reg[7] 
       (.C(CLK_IBUF_BUFG),
        .CE(1'b1),
        .D(a[7]),
        .Q(ja_OBUF[7]),
        .R(1'b0));
  staticRamDiscretePorts__parameterized0 main_ram058f23a5_f365_4220_8e38_da596e15e48f
       (.D({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]}),
        .DOADO({main_ram118b3127_9ac9_438d_b207_2884b5d16b15[0],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[1],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[2],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[3],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[4],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[5],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[6],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[7]}),
        .Q({memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[0],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[1],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[2],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[3],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[4],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[5],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[6],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[7]}),
        .\Q_retimed_reg[0] (microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[0]),
        .clockFaster_BUFG(clockFaster_BUFG));
  nRegister_4 memory_address_register04bc32f9_9690_4e31_8392_6fb6950c4c9d
       (.D({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]}),
        .Q({memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[0],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[1],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[2],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[3],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[4],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[5],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[6],memory_address_register57c8479b_2686_4065_bd62_34c1fc9b6ba6[7]}),
        .\Q_retimed_reg[18] (microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[18]),
        .clock_BUFG(clock_BUFG));
  staticRamDiscretePorts microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2
       (.D(p_0_in__0),
        .DOADO({main_ram118b3127_9ac9_438d_b207_2884b5d16b15[0],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[1],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[2],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[3],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[4],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[5],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[6],main_ram118b3127_9ac9_438d_b207_2884b5d16b15[7]}),
        .E(microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2_n_0),
        .O({adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_0,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_1,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_2,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_3}),
        .Q({microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[0],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[2],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[7],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[14],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[15],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[16],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[18],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[19],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[20],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[21],microcode_rom39f1ec71_5723_4837_b16c_9464a4b69e4d[22]}),
        .\Q_reg[0] ({main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[0],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[1],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[2],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[3],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[4],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[5],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[6],main_busf188ceed_17b5_45e1_b4ae_43fe4b75fd3d[7]}),
        .\Q_reg[0]_0 ({Q_reg__0[0],Q_reg__0[1],Q_reg__0[2],Q_reg__0[3],Q_reg__0[4],Q_reg__0[5],Q_reg__0[6],Q_reg__0[7]}),
        .\Q_reg[0]_1 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_11),
        .\Q_reg[0]_2 ({a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]}),
        .\Q_reg[1] ({adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_4,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_5,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_6,adder4bbdc06a_df58_4a3d_8b2d_dab62b1a1fed_n_7}),
        .\Q_reg[1]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_12),
        .\Q_reg[2] (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_13),
        .\Q_reg[3] (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_14),
        .\Q_reg[4] (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_15),
        .\Q_reg[4]_0 (instruction_register9cf21404_4514_41e1_a233_f7d5c5411526),
        .\Q_reg[5] (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_16),
        .\Q_reg[6] (flags_register7767ffe9_fc7b_465a_994c_5b37fa114233_n_0),
        .\Q_reg[6]_0 (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_17),
        .\Q_reg[7] (B_register6a6161ba_30b5_46f4_b70b_5d08d83841f2_n_18),
        .clock(clock),
        .clockFaster_BUFG(clockFaster_BUFG),
        .\clock_reg[0] (microcode_rom196a21c8_55be_4cef_aca1_0dcc542d7eb2_n_21),
        .microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867),
        .out(p_1_in));
  binaryCounter_5 microcode_step_counterdade7a7c_6f4d_4d87_97e4_e6ad97bc619f
       (.invert_clock_signale4215683_a56a_4837_9894_65acfeeac185(clock_BUFG),
        .microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867(microcode_step_counterff8caaab_b07f_4bbb_b863_58e917fd3867));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
