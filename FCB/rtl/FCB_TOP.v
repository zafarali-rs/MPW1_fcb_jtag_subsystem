`timescale 1ns / 10ps 

module FCB_TOP(
//{{{
   // Outputs
   cfg_blsr_region_0_o, cfg_wlsr_region_0_o, cfg_done_o, fcb_apbs_prdata_o, fcb_apbs_pready_o,
   fcb_apbs_pslverr_o, cfg_rst_no, cfg_blsr_region_0_clk_o, cfg_wlsr_region_0_clk_o, 
   cfg_blsr_region_0_wen_o, cfg_blsr_region_0_ren_o, cfg_wlsr_region_0_wen_o,
   cfg_wlsr_region_0_ren_o,
   // Inputs
   cfg_blsr_region_0_i, cfg_wlsr_region_0_i, fcb_apbs_paddr_i, fcb_apbs_penable_i,
   fcb_apbs_psel_i, fcb_apbs_pwdata_i, fcb_apbs_pwrite_i, fcb_clk_i,
   fcb_rst_ni
   );
//}}}

//{{{
/*OUTPUT*/
output [0:31] cfg_blsr_region_0_o;
output [0:31] cfg_wlsr_region_0_o;
output        cfg_done_o;  
output [31:0] fcb_apbs_prdata_o;  
output        fcb_apbs_pready_o;  
output        fcb_apbs_pslverr_o;  
output        cfg_rst_no;

output        cfg_blsr_region_0_clk_o;
output        cfg_wlsr_region_0_clk_o;
output        cfg_blsr_region_0_wen_o;
output        cfg_blsr_region_0_ren_o;
output        cfg_wlsr_region_0_wen_o;
output        cfg_wlsr_region_0_ren_o;

/*INPUT*/
input [0:31] cfg_blsr_region_0_i;   
input [0:31] cfg_wlsr_region_0_i;   
input [31:0] fcb_apbs_paddr_i;  
input        fcb_apbs_penable_i; 
input        fcb_apbs_psel_i;    
input [31:0] fcb_apbs_pwdata_i;  
input        fcb_apbs_pwrite_i; 
input        fcb_clk_i;    

input        fcb_rst_ni;
//}}}

//{{{
/*WIRE*/
wire [66:0]             APBS_CSR_wdata;         // From U_FCB_APBS of FCB_APBS.v
wire [31:0]             CFG_CHKS_fis_ctrl_head; // From U_FCB_CFG of FCB_CFG.v
wire                    CFG_CHKS_fpostchksum_w0_en;// From U_FCB_CFG of FCB_CFG.v
wire                    CFG_CHKS_fpostchksum_w1_en;// From U_FCB_CFG of FCB_CFG.v
wire                    CFG_CHKS_fprechksum_w0_en;// From U_FCB_CFG of FCB_CFG.v
wire                    CFG_CHKS_fprechksum_w1_en;// From U_FCB_CFG of FCB_CFG.v
wire                    CFG_CHKS_win_postchs_rdata;// From U_FCB_CFG of FCB_CFG.v
wire                    CFG_CSR_fb_cfg_done;    // From U_FCB_CFG of FCB_CFG.v
wire                    CHKS_CSR_chksum_status; // From U_FCB_CHKS of FCB_CHKS.v
wire [31:0]             CSR_APBS_prdata;        // From U_FCB_CSR of FCB_CSR.v
wire [31:0]             CSR_CFG_wl_data_shift;// From U_FCB_CSR of FCB_CSR.v
wire [31:0]             CSR_CFG_bl_max_length;  // From U_FCB_CSR of FCB_CSR.v
wire [1:0]              CSR_CFG_cfgcmd;         // From U_FCB_CSR of FCB_CSR.v
wire                    CSR_CFG_fb_cfg_kickoff; // From U_FCB_CSR of FCB_CSR.v
wire                    CSR_CFG_fb_cfg_done;    // From U_FCB_CSR of FCB_CSR.v
wire [31:0]             CSR_CFG_rd_operation;   // From U_FCB_CSR of FCB_CSR.v
wire [31:0]             CSR_CFG_wl_max_length;  // From U_FCB_CSR of FCB_CSR.v
wire [26:0]             CSR_CFG_wt_operation;   // From U_FCB_CSR of FCB_CSR.v
wire [1:0]              CSR_CHKS_cfgcmd;        // From U_FCB_CSR of FCB_CSR.v
wire [31:0]             CSR_CHKS_chksum;        // From U_FCB_CSR of FCB_CSR.v
wire [31:0]             fAPBS_CHKS_wdata;       // From U_FCB_APBS of FCB_APBS.v
wire                    fcb_reg_rstn;           // From U_FCB_CSR of FCB_CSR.v
//}}}
wire                    CFG_APBS_fmask_win_write_operation;

localparam CK2Q = 0.01;

// Async Reset Synchronizer
reg int_FCB_RST_N;
reg s_FCB_RST_N; 
always@(posedge fcb_clk_i or negedge fcb_rst_ni) begin : FCB_RST_N_SYNC
  if (~fcb_rst_ni) begin
    int_FCB_RST_N <= #CK2Q 1'b0;
    s_FCB_RST_N   <= #CK2Q 1'b0;
  end else begin  
    int_FCB_RST_N <= #CK2Q 1'b1;
    s_FCB_RST_N   <= #CK2Q int_FCB_RST_N;
  end  
end 


FCB_APBS U_FCB_APBS( 
//{{{
                    // Outputs
                    .FCB_APBS_PREADY    (fcb_apbs_pready_o),   
                    .FCB_APBS_PSLVERR   (fcb_apbs_pslverr_o),  
                    .FCB_APBS_PRDATA    (fcb_apbs_prdata_o[31:0]), 
                    .fAPBS_CHKS_wdata   (fAPBS_CHKS_wdata[31:0]),
                    .APBS_CSR_wdata     (APBS_CSR_wdata[66:0]),
                    // Inputs
                    .FCB_CLK            (fcb_clk_i),              
                    .FCB_RST_N          (s_FCB_RST_N),           
                    .FCB_APBS_PSEL      (fcb_apbs_psel_i),      
                    .FCB_APBS_PENABLE   (fcb_apbs_penable_i),  
                    .FCB_APBS_PWRITE    (fcb_apbs_pwrite_i),   
                    .FCB_APBS_PADDR     (fcb_apbs_paddr_i[31:0]),
                    .FCB_APBS_PWDATA    (fcb_apbs_pwdata_i[31:0]),
                    .CSR_APBS_prdata    (CSR_APBS_prdata[31:0]),
                    .CFG_APBS_fmask_win_write_operation(CFG_APBS_fmask_win_write_operation));
//}}} 


FCB_CSR U_FCB_CSR( 
//{{{
                  // Outputs
                  .CSR_CHKS_chksum      (CSR_CHKS_chksum[31:0]),
                  .CSR_APBS_prdata      (CSR_APBS_prdata[31:0]),
                  .CSR_CHKS_cfgcmd      (CSR_CHKS_cfgcmd[1:0]),
                  .CSR_CFG_fb_cfg_kickoff(CSR_CFG_fb_cfg_kickoff),
                  .CSR_CFG_fb_cfg_done  (CSR_CFG_fb_cfg_done),
                  .CSR_CFG_bl_max_length(CSR_CFG_bl_max_length[31:0]),
                  .CSR_CFG_wl_max_length(CSR_CFG_wl_max_length[31:0]),
                  .CSR_CFG_wt_operation (CSR_CFG_wt_operation[26:0]),
                  .CSR_CFG_rd_operation (CSR_CFG_rd_operation[31:0]),
                  .CSR_CFG_wl_data_shift(CSR_CFG_wl_data_shift[31:0]),
                  .CSR_CFG_cfgcmd       (CSR_CFG_cfgcmd[1:0]),
                  .CCFF_HEAD            (cfg_blsr_region_0_o[0:31]),   
                  .CTRL_HEAD            (cfg_wlsr_region_0_o[0:31]),  
                  .CFG_DONE             (cfg_done_o),              
                  .PRESETN              (cfg_rst_no),              
                  .fcb_reg_rstn         (fcb_reg_rstn),
                  // Inputs
                  .FCB_CLK              (fcb_clk_i),             
                  .FCB_RST_N            (s_FCB_RST_N),          
                  .APBS_CSR_wdata       (APBS_CSR_wdata[66:0]),
                  .CHKS_CSR_chksum_status(CHKS_CSR_chksum_status),
                  .CFG_CSR_fb_cfg_done  (CFG_CSR_fb_cfg_done),
                  .CFG_CHKS_fis_ctrl_head(CFG_CHKS_fis_ctrl_head[31:0]));
//}}} 


FCB_CHKS U_FCB_CHKS( 
//{{{
                    // Outputs
                    .CHKS_CSR_chksum_status(CHKS_CSR_chksum_status),
                    // Inputs
                    .FCB_CLK            (fcb_clk_i),              
                    .fcb_reg_rstn       (fcb_reg_rstn),
                    .CSR_CHKS_cfgcmd    (CSR_CHKS_cfgcmd[1:0]),
                    .fAPBS_CHKS_wdata   (fAPBS_CHKS_wdata[31:0]),
                    .CCFF_TAIL          (cfg_blsr_region_0_i[0:31]),    
                    .CFG_CHKS_fprechksum_w0_en(CFG_CHKS_fprechksum_w0_en),
                    .CFG_CHKS_fprechksum_w1_en(CFG_CHKS_fprechksum_w1_en),
                    .CFG_CHKS_fpostchksum_w0_en(CFG_CHKS_fpostchksum_w0_en),
                    .CFG_CHKS_fpostchksum_w1_en(CFG_CHKS_fpostchksum_w1_en),
                    .CFG_CHKS_win_postchs_rdata(CFG_CHKS_win_postchs_rdata),
                    .CSR_CHKS_chksum    (CSR_CHKS_chksum[31:0]));
//}}} 


FCB_CFG U_FCB_CFG( 
//{{{
                  // Outputs
                  .CFG_CHKS_win_postchs_rdata(CFG_CHKS_win_postchs_rdata),
                  .CFG_CSR_fb_cfg_done  (CFG_CSR_fb_cfg_done),
                  .CFG_CHKS_fprechksum_w0_en(CFG_CHKS_fprechksum_w0_en),
                  .CFG_CHKS_fprechksum_w1_en(CFG_CHKS_fprechksum_w1_en),
                  .CFG_CHKS_fpostchksum_w0_en(CFG_CHKS_fpostchksum_w0_en),
                  .CFG_CHKS_fpostchksum_w1_en(CFG_CHKS_fpostchksum_w1_en),
                  .CFG_APBS_fmask_win_write_operation(CFG_APBS_fmask_win_write_operation),
                  .CFG_CHKS_fis_ctrl_head(CFG_CHKS_fis_ctrl_head[31:0]),
                  .BL_CLK               (cfg_blsr_region_0_clk_o), 
                  .BLWEN                (cfg_blsr_region_0_wen_o),
                  .BLREN                (cfg_blsr_region_0_ren_o),
                  .WL_CLK               (cfg_wlsr_region_0_clk_o),
                  .WLWEN                (cfg_wlsr_region_0_wen_o),
                  .WLREN                (cfg_wlsr_region_0_ren_o),
                  // Inputs
                  .FCB_CLK              (fcb_clk_i),               
                  .fcb_reg_rstn         (fcb_reg_rstn),
                  .APBS_CSR_wdata       (APBS_CSR_wdata[66:0]),
                  .CSR_CFG_fb_cfg_kickoff(CSR_CFG_fb_cfg_kickoff),
                  .CSR_CFG_fb_cfg_done  (CSR_CFG_fb_cfg_done),
                  .CSR_CFG_bl_max_length(CSR_CFG_bl_max_length[31:0]),
                  .CSR_CFG_wl_max_length(CSR_CFG_wl_max_length[31:0]),
                  .CSR_CFG_wt_operation (CSR_CFG_wt_operation[26:0]),
                  .CSR_CFG_rd_operation (CSR_CFG_rd_operation[31:0]),
                  .CSR_CFG_wl_data_shift(CSR_CFG_wl_data_shift[31:0]),
                  .CSR_CFG_cfgcmd       (CSR_CFG_cfgcmd[1:0]));
//}}} 


endmodule

