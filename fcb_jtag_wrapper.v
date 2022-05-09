//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
//Date        : Mon May  9 09:55:20 2022
//Host        : rslpt05.rapidsilicon.local running 64-bit Ubuntu 20.04.4 LTS
//Command     : generate_target fcb_jtag_wrapper.bd
//Design      : fcb_jtag_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module fcb_jtag_wrapper
   (
    cfg_blsr_region_0_clk_o_0,
    //cfg_blsr_region_0_i_0,
    cfg_blsr_head_f2e_ot,
    cfg_blsr_region_0_ren_o_0,
    cfg_blsr_region_0_wen_o_0,
    cfg_done_o_0,
    cfg_rst_no_0,
    cfg_wlsr_region_0_clk_o_0,
   // cfg_wlsr_region_0_i_0,
    cfg_wlsr_head_f2e_ot,
    cfg_wlsr_region_0_ren_o_0,cfg_blsr_tail_e2f,cfg_wlsr_tail_e2f,
    cfg_wlsr_region_0_wen_o_0,
     clk_in1_0,
    clk_out1,   
    clk_out2,
     clk_out3,
     clk_out4,
    ext_reset_in);

  output cfg_blsr_region_0_clk_o_0;
  input cfg_blsr_tail_e2f,cfg_wlsr_tail_e2f;
  //input [0:31]cfg_blsr_region_0_i_0;
  //output [0:31]cfg_blsr_region_0_o_0;
  output cfg_blsr_head_f2e_ot;
  output cfg_blsr_region_0_ren_o_0;
  output cfg_blsr_region_0_wen_o_0;
  output cfg_done_o_0;
  output cfg_rst_no_0;
  output cfg_wlsr_region_0_clk_o_0;
  //input [0:31]cfg_wlsr_region_0_i_0;
  //output [0:31]cfg_wlsr_region_0_o_0;
  output cfg_wlsr_head_f2e_ot;
  output cfg_wlsr_region_0_ren_o_0;
  output cfg_wlsr_region_0_wen_o_0;
  input clk_in1_0;
  output clk_out1;  
  output clk_out2;
  output clk_out3;
  output clk_out4;
  input ext_reset_in;

  wire aresetn_0;
  wire cfg_blsr_region_0_clk_o_0;
  wire [0:31]cfg_blsr_region_0_i_0;
  wire [0:31]cfg_blsr_region_0_o_0;
  wire cfg_blsr_region_0_ren_o_0;
  wire cfg_blsr_region_0_wen_o_0;
  wire cfg_done_o_0;
  wire cfg_rst_no_0;
  wire cfg_wlsr_region_0_clk_o_0;
  wire [0:31]cfg_wlsr_region_0_i_0;
  wire [0:31]cfg_wlsr_region_0_o_0;
  wire cfg_wlsr_region_0_ren_o_0;
  wire cfg_wlsr_region_0_wen_o_0;
  wire clk_in1_0,cfg_blsr_tail_e2f,cfg_wlsr_tail_e2f,cfg_blsr_head_f2e_ot,cfg_wlsr_head_f2e_ot;
  wire clk_out1;
  wire clk_out2;
  wire clk_out3;
  wire clk_out4;
  wire ext_reset_in;

  assign cfg_blsr_region_0_i_0 = {cfg_blsr_tail_e2f,31'h0};
  assign cfg_wlsr_region_0_i_0 = {cfg_wlsr_tail_e2f,31'h0};
    
  assign cfg_blsr_head_f2e_ot = cfg_blsr_region_0_o_0[0];
  assign cfg_wlsr_head_f2e_ot = cfg_wlsr_region_0_o_0[0];

  fcb_jtag fcb_jtag_i
       (.cfg_blsr_region_0_clk_o_0(cfg_blsr_region_0_clk_o_0),
        .cfg_blsr_region_0_i_0(cfg_blsr_region_0_i_0),
        .cfg_blsr_region_0_o_0(cfg_blsr_region_0_o_0),
        .cfg_blsr_region_0_ren_o_0(cfg_blsr_region_0_ren_o_0),
        .cfg_blsr_region_0_wen_o_0(cfg_blsr_region_0_wen_o_0),
        .cfg_done_o_0(cfg_done_o_0),
        .cfg_rst_no_0(cfg_rst_no_0),
        .cfg_wlsr_region_0_clk_o_0(cfg_wlsr_region_0_clk_o_0),
        .cfg_wlsr_region_0_i_0(cfg_wlsr_region_0_i_0),
        .cfg_wlsr_region_0_o_0(cfg_wlsr_region_0_o_0),
        .cfg_wlsr_region_0_ren_o_0(cfg_wlsr_region_0_ren_o_0),
        .cfg_wlsr_region_0_wen_o_0(cfg_wlsr_region_0_wen_o_0),
        .clk_in1_0(clk_in1_0),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .clk_out3(clk_out3),
        .clk_out4(clk_out4),
        .ext_reset_in(ext_reset_in));
endmodule
