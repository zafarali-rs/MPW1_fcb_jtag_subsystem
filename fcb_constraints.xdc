

set_property PACKAGE_PIN R25 [get_ports cfg_rst_no_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_rst_no_0]

set_property PACKAGE_PIN W23 [get_ports clk_out2]
set_property IOSTANDARD LVCMOS18 [get_ports clk_out2]

set_property PACKAGE_PIN R26 [get_ports cfg_blsr_region_0_clk_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_blsr_region_0_clk_o_0]

set_property PACKAGE_PIN P23 [get_ports cfg_blsr_region_0_ren_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_blsr_region_0_ren_o_0]

set_property PACKAGE_PIN T25 [get_ports cfg_blsr_region_0_wen_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_blsr_region_0_wen_o_0]

set_property PACKAGE_PIN M22 [get_ports cfg_wlsr_region_0_wen_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_wlsr_region_0_wen_o_0]

set_property PACKAGE_PIN L27 [get_ports cfg_blsr_head_f2e_ot]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_blsr_head_f2e_ot]

set_property PACKAGE_PIN L23 [get_ports cfg_blsr_tail_e2f]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_blsr_tail_e2f]

set_property PACKAGE_PIN R23 [get_ports cfg_done_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_done_o_0]

set_property PACKAGE_PIN M27 [get_ports cfg_wlsr_head_f2e_ot]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_wlsr_head_f2e_ot]

set_property PACKAGE_PIN K25 [get_ports cfg_wlsr_region_0_clk_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_wlsr_region_0_clk_o_0]

set_property PACKAGE_PIN L25 [get_ports cfg_wlsr_region_0_ren_o_0]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_wlsr_region_0_ren_o_0]

set_property PACKAGE_PIN N22 [get_ports cfg_wlsr_tail_e2f]
set_property IOSTANDARD LVCMOS18 [get_ports cfg_wlsr_tail_e2f]

set_property PACKAGE_PIN AA25 [get_ports clk_out1]
set_property IOSTANDARD LVCMOS18 [get_ports clk_out1]


set_property PACKAGE_PIN W24 [get_ports clk_out3]
set_property IOSTANDARD LVCMOS18 [get_ports clk_out3]

set_property PACKAGE_PIN AA24 [get_ports clk_out4]
set_property IOSTANDARD LVCMOS18 [get_ports clk_out4]

set_property PACKAGE_PIN AK17 [get_ports clk_in1_0]
set_property IOSTANDARD LVCMOS18 [get_ports clk_in1_0]

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]

set_property PACKAGE_PIN AK8  [get_ports ext_reset_in]
set_property IOSTANDARD LVCMOS18 [get_ports ext_reset_in]
