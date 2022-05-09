
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
############## clock define##################
#create_clock -period 5.000 [get_ports sys_clk_p]
#set_property PACKAGE_PIN Ak17 [get_ports sys_clk_p]
#set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]
############## key define##################
#set_property PACKAGE_PIN AK8 [get_ports rst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports rst_n]
#################fan define##################
#set_property IOSTANDARD LVCMOS18 [get_ports fan_pwm]
#set_property PACKAGE_PIN P20 [get_ports fan_pwm]
##############LED define##################
#set_property PACKAGE_PIN L20 [get_ports {led[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
#set_property PACKAGE_PIN M20 [get_ports {led[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
#set_property PACKAGE_PIN M21 [get_ports {led[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
#set_property PACKAGE_PIN N21 [get_ports {led[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
###################PL_KEY1####################
#set_property PACKAGE_PIN AK8 [get_ports rst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports rst_n]
####################power lp873220 #########3
#set_property IOSTANDARD LVCMOS18 [get_ports pwr_en]
#set_property PACKAGE_PIN L17 [get_ports pwr_en]
#set_property IOSTANDARD LVCMOS18 [get_ports pwr_scl]
#set_property PACKAGE_PIN P24 [get_ports pwr_scl]
#set_property IOSTANDARD LVCMOS18 [get_ports pwr_sda]
#set_property PACKAGE_PIN P25 [get_ports pwr_sda]
####################PLL#########################
#set_property PACKAGE_PIN AB24 [get_ports clk_out]
#set_property PACKAGE_PIN K21 [get_ports rst_n]
#set_property PACKAGE_PIN AK17 [get_ports sys_clk_p]
#set_property IOSTANDARD LVCMOS18 [get_ports clk_out]
#set_property IOSTANDARD LVCMOS18 [get_ports rst_n]
#set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]
##############uart define###########################
#set_property IOSTANDARD LVCMOS18 [get_ports uart_rx]
#set_property PACKAGE_PIN N27 [get_ports uart_rx]
#set_property IOSTANDARD LVCMOS18 [get_ports uart_tx]
#set_property PACKAGE_PIN K22 [get_ports uart_tx]
############## key define##################
#set_property PACKAGE_PIN AK8 [get_ports rst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports rst_n]
############## SD define##################
#set_property IOSTANDARD LVCMOS18 [get_ports sd_dclk]
#set_property PACKAGE_PIN AN8 [get_ports sd_dclk]
#set_property IOSTANDARD LVCMOS18 [get_ports sd_ncs]
#set_property PACKAGE_PIN AK10 [get_ports sd_ncs]
#set_property IOSTANDARD LVCMOS18 [get_ports sd_mosi]
#set_property PACKAGE_PIN AL9 [get_ports sd_mosi]
#set_property IOSTANDARD LVCMOS18 [get_ports sd_miso]
#set_property PACKAGE_PIN AL8 [get_ports sd_miso]
#############LED Setting##################
#set_property PACKAGE_PIN L20 [get_ports {led[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
#set_property PACKAGE_PIN M20 [get_ports {led[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
#set_property PACKAGE_PIN M21 [get_ports {led[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
#set_property PACKAGE_PIN N21 [get_ports {led[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
############## key define KEY2##################
#set_property PACKAGE_PIN K21 [get_ports key]
#set_property IOSTANDARD LVCMOS18 [get_ports key]
##############################DDR4###################
#set_property PACKAGE_PIN AG14 [get_ports {c0_ddr4_adr[0]}]
#set_property PACKAGE_PIN AF17 [get_ports {c0_ddr4_adr[1]}]
#set_property PACKAGE_PIN AF15 [get_ports {c0_ddr4_adr[2]}]
#set_property PACKAGE_PIN AJ14 [get_ports {c0_ddr4_adr[3]}]
#set_property PACKAGE_PIN AD18 [get_ports {c0_ddr4_adr[4]}]
#set_property PACKAGE_PIN AG17 [get_ports {c0_ddr4_adr[5]}]
#set_property PACKAGE_PIN AE17 [get_ports {c0_ddr4_adr[6]}]
#set_property PACKAGE_PIN AK18 [get_ports {c0_ddr4_adr[7]}]
#set_property PACKAGE_PIN AD16 [get_ports {c0_ddr4_adr[8]}]
#set_property PACKAGE_PIN AH18 [get_ports {c0_ddr4_adr[9]}]
#set_property PACKAGE_PIN AD19 [get_ports {c0_ddr4_adr[10]}]
#set_property PACKAGE_PIN AD15 [get_ports {c0_ddr4_adr[11]}]
#set_property PACKAGE_PIN AH16 [get_ports {c0_ddr4_adr[12]}]
#set_property PACKAGE_PIN AL17 [get_ports {c0_ddr4_adr[13]}]
#set_property PACKAGE_PIN AL15 [get_ports {c0_ddr4_adr[14]}]
#set_property PACKAGE_PIN AL19 [get_ports {c0_ddr4_adr[15]}]
#set_property PACKAGE_PIN AM19 [get_ports {c0_ddr4_adr[16]}]
#set_property PACKAGE_PIN AG15 [get_ports {c0_ddr4_ba[0]}]
#set_property PACKAGE_PIN AL18 [get_ports {c0_ddr4_ba[1]}]
#set_property PACKAGE_PIN AJ15 [get_ports {c0_ddr4_bg[0]}]
#set_property PACKAGE_PIN AE15 [get_ports {c0_ddr4_ck_c[0]}]
#set_property PACKAGE_PIN AE16 [get_ports {c0_ddr4_ck_t[0]}]
#set_property PACKAGE_PIN AE18 [get_ports {c0_ddr4_cs_n[0]}]
#set_property PACKAGE_PIN AJ16 [get_ports {c0_ddr4_cke[0]}]
#set_property PACKAGE_PIN AG19 [get_ports {c0_ddr4_odt[0]}]
#set_property PACKAGE_PIN AF18 [get_ports c0_ddr4_act_n]
#set_property PACKAGE_PIN AG16 [get_ports c0_ddr4_re#set_n]
#set_property PACKAGE_PIN AP34 [get_ports {c0_ddr4_dqs_c[7]}]
#set_property PACKAGE_PIN AN34 [get_ports {c0_ddr4_dqs_t[7]}]
#set_property PACKAGE_PIN AL32 [get_ports {c0_ddr4_dm_dbi_n[7]}]
#set_property PACKAGE_PIN AN31 [get_ports {c0_ddr4_dq[56]}]
#set_property PACKAGE_PIN AL34 [get_ports {c0_ddr4_dq[57]}]
#set_property PACKAGE_PIN AN32 [get_ports {c0_ddr4_dq[58]}]
#set_property PACKAGE_PIN AN33 [get_ports {c0_ddr4_dq[59]}]
#set_property PACKAGE_PIN AM32 [get_ports {c0_ddr4_dq[60]}]
#set_property PACKAGE_PIN AM34 [get_ports {c0_ddr4_dq[61]}]
#set_property PACKAGE_PIN AP31 [get_ports {c0_ddr4_dq[62]}]
#set_property PACKAGE_PIN AP33 [get_ports {c0_ddr4_dq[63]}]
#set_property PACKAGE_PIN AJ33 [get_ports {c0_ddr4_dqs_c[6]}]
#set_property PACKAGE_PIN AH33 [get_ports {c0_ddr4_dqs_t[6]}]
#set_property PACKAGE_PIN AJ29 [get_ports {c0_ddr4_dm_dbi_n[6]}]
#set_property PACKAGE_PIN AK31 [get_ports {c0_ddr4_dq[48]}]
#set_property PACKAGE_PIN AH34 [get_ports {c0_ddr4_dq[49]}]
#set_property PACKAGE_PIN AK32 [get_ports {c0_ddr4_dq[50]}]
#set_property PACKAGE_PIN AJ31 [get_ports {c0_ddr4_dq[51]}]
#set_property PACKAGE_PIN AJ30 [get_ports {c0_ddr4_dq[52]}]
#set_property PACKAGE_PIN AH31 [get_ports {c0_ddr4_dq[53]}]
#set_property PACKAGE_PIN AJ34 [get_ports {c0_ddr4_dq[54]}]
#set_property PACKAGE_PIN AH32 [get_ports {c0_ddr4_dq[55]}]
#set_property PACKAGE_PIN AP30 [get_ports {c0_ddr4_dqs_c[5]}]
#set_property PACKAGE_PIN AN29 [get_ports {c0_ddr4_dqs_t[5]}]
#set_property PACKAGE_PIN AN26 [get_ports {c0_ddr4_dm_dbi_n[5]}]
#set_property PACKAGE_PIN AN28 [get_ports {c0_ddr4_dq[40]}]
#set_property PACKAGE_PIN AM30 [get_ports {c0_ddr4_dq[41]}]
#set_property PACKAGE_PIN AP28 [get_ports {c0_ddr4_dq[42]}]
#set_property PACKAGE_PIN AM29 [get_ports {c0_ddr4_dq[43]}]
#set_property PACKAGE_PIN AN27 [get_ports {c0_ddr4_dq[44]}]
#set_property PACKAGE_PIN AL30 [get_ports {c0_ddr4_dq[45]}]
#set_property PACKAGE_PIN AL29 [get_ports {c0_ddr4_dq[46]}]
#set_property PACKAGE_PIN AP29 [get_ports {c0_ddr4_dq[47]}]
#set_property PACKAGE_PIN AL28 [get_ports {c0_ddr4_dqs_c[4]}]
#set_property PACKAGE_PIN AL27 [get_ports {c0_ddr4_dqs_t[4]}]
#set_property PACKAGE_PIN AH26 [get_ports {c0_ddr4_dm_dbi_n[4]}]
#set_property PACKAGE_PIN AM26 [get_ports {c0_ddr4_dq[32]}]
#set_property PACKAGE_PIN AJ28 [get_ports {c0_ddr4_dq[33]}]
#set_property PACKAGE_PIN AM27 [get_ports {c0_ddr4_dq[34]}]
#set_property PACKAGE_PIN AK28 [get_ports {c0_ddr4_dq[35]}]
#set_property PACKAGE_PIN AH27 [get_ports {c0_ddr4_dq[36]}]
#set_property PACKAGE_PIN AH28 [get_ports {c0_ddr4_dq[37]}]
#set_property PACKAGE_PIN AK26 [get_ports {c0_ddr4_dq[38]}]
#set_property PACKAGE_PIN AK27 [get_ports {c0_ddr4_dq[39]}]
#set_property PACKAGE_PIN AP21 [get_ports {c0_ddr4_dqs_c[3]}]
#set_property PACKAGE_PIN AP20 [get_ports {c0_ddr4_dqs_t[3]}]
#set_property PACKAGE_PIN AM21 [get_ports {c0_ddr4_dm_dbi_n[3]}]
#set_property PACKAGE_PIN AM22 [get_ports {c0_ddr4_dq[24]}]
#set_property PACKAGE_PIN AP24 [get_ports {c0_ddr4_dq[25]}]
#set_property PACKAGE_PIN AN22 [get_ports {c0_ddr4_dq[26]}]
#set_property PACKAGE_PIN AN24 [get_ports {c0_ddr4_dq[27]}]
#set_property PACKAGE_PIN AN23 [get_ports {c0_ddr4_dq[28]}]
#set_property PACKAGE_PIN AP25 [get_ports {c0_ddr4_dq[29]}]
#set_property PACKAGE_PIN AP23 [get_ports {c0_ddr4_dq[30]}]
#set_property PACKAGE_PIN AM24 [get_ports {c0_ddr4_dq[31]}]
#set_property PACKAGE_PIN AK20 [get_ports {c0_ddr4_dqs_c[2]}]
#set_property PACKAGE_PIN AJ20 [get_ports {c0_ddr4_dqs_t[2]}]
#set_property PACKAGE_PIN AJ21 [get_ports {c0_ddr4_dm_dbi_n[2]}]
#set_property PACKAGE_PIN AK22 [get_ports {c0_ddr4_dq[16]}]
#set_property PACKAGE_PIN AL22 [get_ports {c0_ddr4_dq[17]}]
#set_property PACKAGE_PIN AM20 [get_ports {c0_ddr4_dq[18]}]
#set_property PACKAGE_PIN AL23 [get_ports {c0_ddr4_dq[19]}]
#set_property PACKAGE_PIN AK23 [get_ports {c0_ddr4_dq[20]}]
#set_property PACKAGE_PIN AL25 [get_ports {c0_ddr4_dq[21]}]
#set_property PACKAGE_PIN AL20 [get_ports {c0_ddr4_dq[22]}]
#set_property PACKAGE_PIN AL24 [get_ports {c0_ddr4_dq[23]}]
#set_property PACKAGE_PIN AJ25 [get_ports {c0_ddr4_dqs_c[1]}]
#set_property PACKAGE_PIN AH24 [get_ports {c0_ddr4_dqs_t[1]}]
#set_property PACKAGE_PIN AE25 [get_ports {c0_ddr4_dm_dbi_n[1]}]
#set_property PACKAGE_PIN AF24 [get_ports {c0_ddr4_dq[8]}]
#set_property PACKAGE_PIN AJ23 [get_ports {c0_ddr4_dq[9]}]
#set_property PACKAGE_PIN AF23 [get_ports {c0_ddr4_dq[10]}]
#set_property PACKAGE_PIN AH23 [get_ports {c0_ddr4_dq[11]}]
#set_property PACKAGE_PIN AG25 [get_ports {c0_ddr4_dq[12]}]
#set_property PACKAGE_PIN AJ24 [get_ports {c0_ddr4_dq[13]}]
#set_property PACKAGE_PIN AG24 [get_ports {c0_ddr4_dq[14]}]
#set_property PACKAGE_PIN AH22 [get_ports {c0_ddr4_dq[15]}]
#set_property PACKAGE_PIN AH21 [get_ports {c0_ddr4_dqs_c[0]}]
#set_property PACKAGE_PIN AG21 [get_ports {c0_ddr4_dqs_t[0]}]
#set_property PACKAGE_PIN AD21 [get_ports {c0_ddr4_dm_dbi_n[0]}]
#set_property PACKAGE_PIN AE20 [get_ports {c0_ddr4_dq[0]}]
#set_property PACKAGE_PIN AG20 [get_ports {c0_ddr4_dq[1]}]
#set_property PACKAGE_PIN AF20 [get_ports {c0_ddr4_dq[2]}]
#set_property PACKAGE_PIN AE22 [get_ports {c0_ddr4_dq[3]}]
#set_property PACKAGE_PIN AD20 [get_ports {c0_ddr4_dq[4]}]
#set_property PACKAGE_PIN AG22 [get_ports {c0_ddr4_dq[5]}]
#set_property PACKAGE_PIN AF22 [get_ports {c0_ddr4_dq[6]}]
#set_property PACKAGE_PIN AE23 [get_ports {c0_ddr4_dq[7]}]
###########################HDMI########################
#set_property PACKAGE_PIN V33  [get_ports hdmi_clk]
#set_property PACKAGE_PIN Y30 [get_ports {hdmi_d[0]}]
#set_property PACKAGE_PIN Y33 [get_ports {hdmi_d[1]}]
#set_property PACKAGE_PIN Y32 [get_ports {hdmi_d[2]}]
#set_property PACKAGE_PIN W33 [get_ports {hdmi_d[3]}]
#set_property PACKAGE_PIN W34 [get_ports {hdmi_d[4]}]
#set_property PACKAGE_PIN W31 [get_ports {hdmi_d[5]}]
#set_property PACKAGE_PIN Y31 [get_ports {hdmi_d[6]}]
#set_property PACKAGE_PIN V34 [get_ports {hdmi_d[7]}]
#set_property PACKAGE_PIN V32 [get_ports {hdmi_d[8]}]
#set_property PACKAGE_PIN U34 [get_ports {hdmi_d[9]}]
#set_property PACKAGE_PIN V31 [get_ports {hdmi_d[10]}]
#set_property PACKAGE_PIN W30 [get_ports {hdmi_d[11]}]
#set_property PACKAGE_PIN W29 [get_ports {hdmi_d[12]}]
#set_property PACKAGE_PIN V29 [get_ports {hdmi_d[13]}]
#set_property PACKAGE_PIN W28 [get_ports {hdmi_d[14]}]
#set_property PACKAGE_PIN V28 [get_ports {hdmi_d[15]}]
#set_property PACKAGE_PIN V27 [get_ports {hdmi_d[16]}]
#set_property PACKAGE_PIN W26 [get_ports {hdmi_d[17]}]
#set_property PACKAGE_PIN V26 [get_ports {hdmi_d[18]}]
#set_property PACKAGE_PIN U27 [get_ports {hdmi_d[19]}]
#set_property PACKAGE_PIN U26 [get_ports {hdmi_d[20]}]
#set_property PACKAGE_PIN U25 [get_ports {hdmi_d[21]}]
#set_property PACKAGE_PIN U24 [get_ports {hdmi_d[22]}]
#set_property PACKAGE_PIN Y22 [get_ports {hdmi_d[23]}]
#set_property PACKAGE_PIN AA33 [get_ports hdmi_de]
#set_property PACKAGE_PIN Y28 [get_ports hdmi_hs]
#set_property PACKAGE_PIN AE31 [get_ports hdmi_vs]
#set_property PACKAGE_PIN R22 [get_ports hdmi_scl]
#set_property PACKAGE_PIN R21 [get_ports hdmi_sda]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_scl]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_sda]
#set_property IOSTANDARD LVCMOS18 [get_ports {hdmi_d[*]}]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_clk]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_de]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_vs]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_hs]
#set_property PULLUP true [get_ports hdmi_scl]
#set_property PULLUP true [get_ports hdmi_sda]
#set_property SLEW FAST [get_ports {hdmi_d[*]}]
#set_property DRIVE 8 [get_ports {hdmi_d[*]}]
#set_property SLEW FAST [get_ports hdmi_clk]
#set_property SLEW FAST [get_ports hdmi_de]
#set_property SLEW FAST [get_ports hdmi_hs]
#set_property SLEW FAST [get_ports hdmi_scl]
#set_property SLEW FAST [get_ports hdmi_sda]
#set_property SLEW FAST [get_ports hdmi_vs]
#################9134 setting##############################
#set_property PACKAGE_PIN V33 [get_ports vout_clk]
#set_property PACKAGE_PIN Y30 [get_ports {vout_data[0]}]
#set_property PACKAGE_PIN Y33 [get_ports {vout_data[1]}]
#set_property PACKAGE_PIN Y32 [get_ports {vout_data[2]}]
#set_property PACKAGE_PIN W33 [get_ports {vout_data[3]}]
#set_property PACKAGE_PIN W34 [get_ports {vout_data[4]}]
#set_property PACKAGE_PIN W31 [get_ports {vout_data[5]}]
#set_property PACKAGE_PIN Y31 [get_ports {vout_data[6]}]
#set_property PACKAGE_PIN V34 [get_ports {vout_data[7]}]
#set_property PACKAGE_PIN V32 [get_ports {vout_data[8]}]
#set_property PACKAGE_PIN U34 [get_ports {vout_data[9]}]
#set_property PACKAGE_PIN V31 [get_ports {vout_data[10]}]
#set_property PACKAGE_PIN W30 [get_ports {vout_data[11]}]
#set_property PACKAGE_PIN W29 [get_ports {vout_data[12]}]
#set_property PACKAGE_PIN V29 [get_ports {vout_data[13]}]
#set_property PACKAGE_PIN W28 [get_ports {vout_data[14]}]
#set_property PACKAGE_PIN V28 [get_ports {vout_data[15]}]
#set_property PACKAGE_PIN V27 [get_ports {vout_data[16]}]
#set_property PACKAGE_PIN W26 [get_ports {vout_data[17]}]
#set_property PACKAGE_PIN V26 [get_ports {vout_data[18]}]
#set_property PACKAGE_PIN U27 [get_ports {vout_data[19]}]
#set_property PACKAGE_PIN U26 [get_ports {vout_data[20]}]
#set_property PACKAGE_PIN U25 [get_ports {vout_data[21]}]
#set_property PACKAGE_PIN U24 [get_ports {vout_data[22]}]
#set_property PACKAGE_PIN Y22 [get_ports {vout_data[23]}]
#set_property PACKAGE_PIN AA33 [get_ports vout_de]
#set_property PACKAGE_PIN Y28 [get_ports vout_hs]
#set_property PACKAGE_PIN AE31 [get_ports vout_vs]
#set_property PACKAGE_PIN R22 [get_ports hdmi_scl]
#set_property PACKAGE_PIN R21 [get_ports hdmi_sda]
#set_property IOSTANDARD LVCMOS18 [get_ports vout_clk]
#set_property IOSTANDARD LVCMOS18 [get_ports {vout_data[*]}]
#set_property IOSTANDARD LVCMOS18 [get_ports vout_de]
#set_property IOSTANDARD LVCMOS18 [get_ports vout_hs]
#set_property IOSTANDARD LVCMOS18 [get_ports vout_vs]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_scl]
#set_property IOSTANDARD LVCMOS18 [get_ports hdmi_sda]
#set_property SLEW FAST [get_ports {vout_data[*]}]
#set_property SLEW FAST [get_ports vout_de]
#set_property SLEW FAST [get_ports vout_hs]
#set_property SLEW FAST [get_ports vout_vs]

set_property PACKAGE_PIN R25 [get_ports cfg_rst_no_0]
set_property PACKAGE_PIN W23 [get_ports clk_out2]
set_property PACKAGE_PIN R26 [get_ports cfg_blsr_region_0_clk_o_0]
set_property PACKAGE_PIN P23 [get_ports cfg_blsr_region_0_ren_o_0]
set_property PACKAGE_PIN T25 [get_ports cfg_blsr_region_0_wen_o_0]
set_property PACKAGE_PIN M22 [get_ports cfg_wlsr_region_0_wen_o_0]
set_property PACKAGE_PIN L27 [get_ports cfg_blsr_head_f2e_ot]
set_property PACKAGE_PIN L23 [get_ports cfg_blsr_tail_e2f]
set_property PACKAGE_PIN R23 [get_ports cfg_done_o_0]
set_property PACKAGE_PIN M27 [get_ports cfg_wlsr_head_f2e_ot]
set_property PACKAGE_PIN K25 [get_ports cfg_wlsr_region_0_clk_o_0]
set_property PACKAGE_PIN L25 [get_ports cfg_wlsr_region_0_ren_o_0]
set_property PACKAGE_PIN N22 [get_ports cfg_wlsr_tail_e2f]
set_property PACKAGE_PIN AA25 [get_ports clk_out1]
set_property PACKAGE_PIN W24 [get_ports clk_out3]
set_property PACKAGE_PIN AK17 [get_ports clk_in1_0]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]