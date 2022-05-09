`timescale 1ns/10ps

module FCB_CSR (
  input  wire FCB_CLK,
  input  wire FCB_RST_N,

  input  wire [66:0] APBS_CSR_wdata,
  input  wire        CHKS_CSR_chksum_status,
  
  input  wire        CFG_CSR_fb_cfg_done, 
  input  wire [31:0] CFG_CHKS_fis_ctrl_head, 
  
  output wire [31:0] CSR_CHKS_chksum, 
  output wire [31:0] CSR_APBS_prdata,
  output wire [ 1:0] CSR_CHKS_cfgcmd,     

  output wire        CSR_CFG_fb_cfg_kickoff,  
  output wire        CSR_CFG_fb_cfg_done,  
  output wire [31:0] CSR_CFG_bl_max_length,
  output wire [31:0] CSR_CFG_wl_max_length,
  output wire [26:0] CSR_CFG_wt_operation,
  output wire [31:0] CSR_CFG_rd_operation,
  output wire [31:0] CSR_CFG_wl_data_shift, 
  output wire [ 1:0] CSR_CFG_cfgcmd,       

  output wire [0:31] CCFF_HEAD,
  output wire [0:31] CTRL_HEAD,
  output wire        CFG_DONE,
  output wire        PRESETN,
  output wire        fcb_reg_rstn	
);

localparam CK2Q = 0.01;

localparam DEVICE_ID      = 8'h00;
localparam FB_CFG_CMD     = 8'h01; 
localparam FB_CFG_KICKOFF = 8'h02;
localparam FB_CFG_DONE    = 8'h03;
localparam FB_CFG_DATA    = 8'h04;
localparam LOOP_BIT_CNT   = 8'h05;
localparam CHKSUM_WORD    = 8'h06;
localparam CHKSUM_STATUS  = 8'h07;
localparam PD_FABRIC      = 8'h08;
localparam IO_ISOLATE_CTL = 8'h09;
localparam FB_SOFT_RESET  = 8'h0A;

localparam BL_MAX_LENGTH  = 8'h10;
localparam WL_MAX_LENGTH  = 8'h14;
localparam WT_OPERATION   = 8'h18;
localparam RD_OPERATION   = 8'h1C;
localparam BL_DATA_SHIFT  = 8'h1E;
localparam WL_DATA_SHIFT  = 8'h1F;


reg  [ 7:0] fCSR_DEVICE_ID;
reg  [ 1:0] fCSR_FB_CFG_CMD;
reg         fCSR_FB_CFG_KICKOFF;
reg         fCSR_FB_CFG_DONE;
reg  [31:0] fCSR_CFG_BIT_LOOP_CNT;
reg  [31:0] fCSR_CHKSUM_WORD;
reg         fCSR_CHKSUM_STATUS;
reg  [ 1:0] fCSR_PD_FABRIC_CTL;
reg  [ 1:0] fCSR_IO_ISOLATE_CTL;
reg         fCSR_FB_SOFT_RESET;

reg  [31:0] fCSR_BL_MAX_LENGTH;
reg  [31:0] fCSR_WL_MAX_LENGTH;
reg  [26:0] fCSR_WT_OPERATION;
reg  [31:0] fCSR_RD_OPERATION;
reg  [31:0] fCSR_BL_DATA_SHIFT;
reg  [31:0] fCSR_WL_DATA_SHIFT;

reg  set_CSR_DEVICE_ID; 
reg  set_CSR_FB_CFG_CMD; 
reg  set_CSR_FB_CFG_KICKOFF; 
reg  set_CSR_FB_CFG_DONE; 
reg  set_CSR_CFG_BIT_LOOP_CNT; 
reg  set_CSR_CHKSUM_WORD; 
reg  set_CSR_PD_ACTIVATE;
reg  set_CSR_IO_ISOLATE_CTL; 
reg  set_CSR_FB_SOFT_RESET; 
//reg  set_CSR_FB_CFG_DATA; 
reg  set_CSR_BL_MAX_LENGTH; 
reg  set_CSR_WL_MAX_LENGTH; 
reg  set_CSR_WT_OPERATION; 
reg  set_CSR_RD_OPERATION; 
reg  set_CSR_BL_DATA_SHIFT; 
reg  set_CSR_WL_DATA_SHIFT; 

reg  rd_CSR_DEVICE_ID; 
reg  rd_CSR_FB_CFG_CMD; 
reg  rd_CSR_FB_CFG_KICKOFF; 
reg  rd_CSR_FB_CFG_DONE; 
reg  rd_CSR_CFG_BIT_LOOP_CNT; 
reg  rd_CSR_CHKSUM_WORD; 
reg  rd_CSR_CHKSUM_STATUS; 
//reg  rd_CSR_PD_FABRIC; 
//reg  rd_CSR_IO_ISOLATE_CTL; 
reg  rd_CSR_OVER_PROG_CLK; 
reg  rd_CSR_FB_SOFT_RESET; 
reg  rd_CSR_BL_MAX_LENGTH; 
reg  rd_CSR_WL_MAX_LENGTH; 
reg  rd_CSR_WT_OPERATION; 
reg  rd_CSR_RD_OPERATION; 
reg  rd_CSR_BL_DATA_SHIFT; 
reg  rd_CSR_WL_DATA_SHIFT; 

reg   [31:0] apbs_prdata;

wire         apbs_psel    = APBS_CSR_wdata[66];
wire         apbs_pwrite  = APBS_CSR_wdata[65];
wire         apbs_penable = APBS_CSR_wdata[64];
wire  [31:0] apbs_paddr   = APBS_CSR_wdata[63:32];
wire  [31:0] apbs_pwdata  = APBS_CSR_wdata[31:0];

wire ccff_wr_en = apbs_psel & apbs_pwrite;
wire apbs_wr_en = apbs_penable & apbs_pwrite;
wire apbs_rd_en = apbs_penable & ~apbs_pwrite;

wire hwset_CSR_FB_CFG_DONE = CFG_CSR_fb_cfg_done; 

assign CFG_DONE             = fCSR_FB_CFG_DONE;    
assign CSR_CHKS_chksum      = fCSR_CHKSUM_WORD;
assign CSR_CHKS_cfgcmd      = fCSR_FB_CFG_CMD;
//assign CSR_PMU_pd_activate  = fCSR_PD_FABRIC_CTL[0];
//assign CSR_PMU_ioisol_drive = fCSR_IO_ISOLATE_CTL[1];
//assign CSR_PMU_iso_en       = fCSR_IO_ISOLATE_CTL[0];

assign CSR_CFG_fb_cfg_kickoff    = fCSR_FB_CFG_KICKOFF;
assign CSR_CFG_fb_cfg_done       = fCSR_FB_CFG_DONE;
assign CSR_CFG_bl_max_length     = fCSR_BL_MAX_LENGTH[31:0];
assign CSR_CFG_wl_max_length     = fCSR_WL_MAX_LENGTH[31:0];

assign CSR_CFG_wt_operation      = fCSR_WT_OPERATION[26:0];
assign CSR_CFG_rd_operation      = fCSR_RD_OPERATION[31:0];
assign CSR_CFG_wl_data_shift     = fCSR_WL_DATA_SHIFT[31:0];
assign CSR_CFG_cfgcmd            = fCSR_FB_CFG_CMD;

//RWHC: Read/Write HW auto Clear
reg   clr_CSR_FB_CFG_KICKOFF;   
reg  [2:0] FB_CFG_KICKOFF_ns, fFB_CFG_KICKOFF_cs; 

wire disable_chksum;
assign disable_chksum = fCSR_FB_CFG_CMD==2'h0; 

wire pre_chksum_en;
assign pre_chksum_en  = fCSR_FB_CFG_CMD==2'h1; 

wire post_chksum_en;
assign post_chksum_en = fCSR_FB_CFG_CMD==2'h2; 

always@(posedge FCB_CLK or negedge fcb_reg_rstn)
  if (~fcb_reg_rstn)
    fFB_CFG_KICKOFF_cs <= #CK2Q 3'h0;
  else 
    fFB_CFG_KICKOFF_cs <= #CK2Q FB_CFG_KICKOFF_ns; 

always@(*)begin
  case (fFB_CFG_KICKOFF_cs)
    3'h0 : begin
      clr_CSR_FB_CFG_KICKOFF = 1'b0;
      if ( hwset_CSR_FB_CFG_DONE ) 
        FB_CFG_KICKOFF_ns = 3'h1;
      else  
        FB_CFG_KICKOFF_ns = 3'h0;
    end    
    3'h1 : begin
      if ( post_chksum_en || pre_chksum_en || disable_chksum) begin
        clr_CSR_FB_CFG_KICKOFF = 1'b0;
        FB_CFG_KICKOFF_ns = 3'h2;
      end else begin 
        clr_CSR_FB_CFG_KICKOFF = 1'b0;
        FB_CFG_KICKOFF_ns = 3'h4;
      end 
    end   
    3'h2 : begin
      if (post_chksum_en == 1'b1) begin
        clr_CSR_FB_CFG_KICKOFF = 1'b0;
        FB_CFG_KICKOFF_ns = 3'h3;
      end else begin 
        clr_CSR_FB_CFG_KICKOFF = 1'b1;
        FB_CFG_KICKOFF_ns = 3'h3;
      end 
    end   
    3'h3 : begin
      if (post_chksum_en == 1'b1) begin
        clr_CSR_FB_CFG_KICKOFF = 1'b1;
        FB_CFG_KICKOFF_ns = 3'h4;
      end else begin 
        clr_CSR_FB_CFG_KICKOFF = 1'b0;
        FB_CFG_KICKOFF_ns = 3'h0;
      end
    end   
    3'h4 : begin
      clr_CSR_FB_CFG_KICKOFF = 1'b0;
      FB_CFG_KICKOFF_ns = 3'h0;
    end   
    default : begin
      clr_CSR_FB_CFG_KICKOFF = 1'b0;
      FB_CFG_KICKOFF_ns = fFB_CFG_KICKOFF_cs;
    end   
  endcase   
end     


//RESET 
assign  fcb_reg_rstn = FCB_RST_N && ~fCSR_FB_SOFT_RESET;  

assign  PRESETN =  fcb_reg_rstn; 

assign CSR_APBS_prdata = apbs_prdata;


reg [31:0] fLE_CCFF_HEAD;
assign CCFF_HEAD[0:31] = { fLE_CCFF_HEAD[0],  fLE_CCFF_HEAD[1],  fLE_CCFF_HEAD[2],  fLE_CCFF_HEAD[3],
                           fLE_CCFF_HEAD[4],  fLE_CCFF_HEAD[5],  fLE_CCFF_HEAD[6],  fLE_CCFF_HEAD[7],
                           fLE_CCFF_HEAD[8],  fLE_CCFF_HEAD[9],  fLE_CCFF_HEAD[10], fLE_CCFF_HEAD[11],
                           fLE_CCFF_HEAD[12], fLE_CCFF_HEAD[13], fLE_CCFF_HEAD[14], fLE_CCFF_HEAD[15],
                           fLE_CCFF_HEAD[16], fLE_CCFF_HEAD[17], fLE_CCFF_HEAD[18], fLE_CCFF_HEAD[19],
                           fLE_CCFF_HEAD[20], fLE_CCFF_HEAD[21], fLE_CCFF_HEAD[22], fLE_CCFF_HEAD[23],
                           fLE_CCFF_HEAD[24], fLE_CCFF_HEAD[25], fLE_CCFF_HEAD[26], fLE_CCFF_HEAD[27],
                           fLE_CCFF_HEAD[28], fLE_CCFF_HEAD[29], fLE_CCFF_HEAD[30], fLE_CCFF_HEAD[31]
                         };
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn)
    fLE_CCFF_HEAD <= #CK2Q 32'h0;
  else if ( fCSR_FB_CFG_KICKOFF==8'h1 && set_CSR_BL_DATA_SHIFT) 
    fLE_CCFF_HEAD <= #CK2Q apbs_pwdata; 
  else  
    fLE_CCFF_HEAD <= #CK2Q 32'h0; 
end 

wire [31:0] LE_CTRL_HEAD;
assign CTRL_HEAD[0:31] = { LE_CTRL_HEAD[0],  LE_CTRL_HEAD[1],  LE_CTRL_HEAD[2],  LE_CTRL_HEAD[3],
                           LE_CTRL_HEAD[4],  LE_CTRL_HEAD[5],  LE_CTRL_HEAD[6],  LE_CTRL_HEAD[7],
                           LE_CTRL_HEAD[8],  LE_CTRL_HEAD[9],  LE_CTRL_HEAD[10], LE_CTRL_HEAD[11],
                           LE_CTRL_HEAD[12], LE_CTRL_HEAD[13], LE_CTRL_HEAD[14], LE_CTRL_HEAD[15],
                           LE_CTRL_HEAD[16], LE_CTRL_HEAD[17], LE_CTRL_HEAD[18], LE_CTRL_HEAD[19],
                           LE_CTRL_HEAD[20], LE_CTRL_HEAD[21], LE_CTRL_HEAD[22], LE_CTRL_HEAD[23],
                           LE_CTRL_HEAD[24], LE_CTRL_HEAD[25], LE_CTRL_HEAD[26], LE_CTRL_HEAD[27],
                           LE_CTRL_HEAD[28], LE_CTRL_HEAD[29], LE_CTRL_HEAD[30], LE_CTRL_HEAD[31]
                         };

assign LE_CTRL_HEAD = CFG_CHKS_fis_ctrl_head;

always@(*) begin : SET_CSR
  set_CSR_DEVICE_ID        = 1'b0;
  set_CSR_FB_CFG_CMD       = 1'b0;
  set_CSR_FB_CFG_KICKOFF   = 1'b0; 
  set_CSR_FB_CFG_DONE      = 1'b0; 
//  set_CSR_FB_CFG_DATA      = 1'b0;  
  set_CSR_CFG_BIT_LOOP_CNT = 1'b0; 
  set_CSR_CHKSUM_WORD      = 1'b0; 
  set_CSR_PD_ACTIVATE      = 1'b0; 
  set_CSR_IO_ISOLATE_CTL   = 1'b0; 
  set_CSR_FB_SOFT_RESET    = 1'b0; 
  set_CSR_BL_MAX_LENGTH    = 1'b0; 
  set_CSR_WL_MAX_LENGTH    = 1'b0; 
  set_CSR_WT_OPERATION     = 1'b0; 
  set_CSR_RD_OPERATION     = 1'b0; 
  set_CSR_BL_DATA_SHIFT    = 1'b0; 
  set_CSR_WL_DATA_SHIFT    = 1'b0; 

  case(apbs_paddr)
    DEVICE_ID :
      if (apbs_wr_en)
        set_CSR_DEVICE_ID      = 1'b1;
      else
        set_CSR_DEVICE_ID      = 1'b0;
    FB_CFG_CMD :
      if (apbs_wr_en)
        set_CSR_FB_CFG_CMD     = 1'b1;
      else
        set_CSR_FB_CFG_CMD     = 1'b0;
    FB_CFG_KICKOFF :
      if (apbs_wr_en)
        set_CSR_FB_CFG_KICKOFF = 1'b1;
      else
        set_CSR_FB_CFG_KICKOFF = 1'b0;
    FB_CFG_DONE :
      if (apbs_wr_en)
        set_CSR_FB_CFG_DONE    = 1'b1;
      else
        set_CSR_FB_CFG_DONE    = 1'b0;
    LOOP_BIT_CNT :
      if (apbs_wr_en)
        set_CSR_CFG_BIT_LOOP_CNT = 1'b1;
      else
        set_CSR_CFG_BIT_LOOP_CNT = 1'b0;
    CHKSUM_WORD :
      if (apbs_wr_en)
        set_CSR_CHKSUM_WORD    = 1'b1;
      else
        set_CSR_CHKSUM_WORD    = 1'b0;
    PD_FABRIC :
      if (apbs_wr_en)
        set_CSR_PD_ACTIVATE      = 1'b1;
      else
        set_CSR_PD_ACTIVATE      = 1'b0;
    IO_ISOLATE_CTL :
      if (apbs_wr_en)
        set_CSR_IO_ISOLATE_CTL = 1'b1;
      else
        set_CSR_IO_ISOLATE_CTL = 1'b0;
    FB_SOFT_RESET :
      if (apbs_wr_en)
        set_CSR_FB_SOFT_RESET  = 1'b1;
      else
        set_CSR_FB_SOFT_RESET  = 1'b0;
//    FB_CFG_DATA :    
//      if (ccff_wr_en)
//        set_CSR_FB_CFG_DATA    = 1'b1;
//      else
//        set_CSR_FB_CFG_DATA    = 1'b0;
    BL_MAX_LENGTH : 
      if (ccff_wr_en)
        set_CSR_BL_MAX_LENGTH = 1'b1;
      else
        set_CSR_BL_MAX_LENGTH = 1'b0;
    WL_MAX_LENGTH : 
      if (ccff_wr_en)
        set_CSR_WL_MAX_LENGTH = 1'b1;
      else
        set_CSR_WL_MAX_LENGTH = 1'b0;
    WT_OPERATION :  
      if (ccff_wr_en)
        set_CSR_WT_OPERATION = 1'b1;
      else
        set_CSR_WT_OPERATION = 1'b0;
    RD_OPERATION :  
      if (ccff_wr_en)
        set_CSR_RD_OPERATION = 1'b1;
      else
        set_CSR_RD_OPERATION = 1'b0;
    BL_DATA_SHIFT :  
      if (ccff_wr_en)
        set_CSR_BL_DATA_SHIFT = 1'b1;
      else
        set_CSR_BL_DATA_SHIFT = 1'b0;
    WL_DATA_SHIFT :  
      if (ccff_wr_en)
        set_CSR_WL_DATA_SHIFT = 1'b1;
      else
        set_CSR_WL_DATA_SHIFT = 1'b0;
    default : begin
      set_CSR_DEVICE_ID        = 1'b0;
      set_CSR_FB_CFG_CMD       = 1'b0;
      set_CSR_FB_CFG_KICKOFF   = 1'b0; 
      set_CSR_FB_CFG_DONE      = 1'b0; 
      set_CSR_CFG_BIT_LOOP_CNT = 1'b0; 
      set_CSR_CHKSUM_WORD      = 1'b0; 
      set_CSR_PD_ACTIVATE      = 1'b0; 
      set_CSR_IO_ISOLATE_CTL   = 1'b0; 
      set_CSR_FB_SOFT_RESET    = 1'b0; 
//      set_CSR_FB_CFG_DATA      = 1'b0;  
      set_CSR_BL_MAX_LENGTH    = 1'b0; 
      set_CSR_WL_MAX_LENGTH    = 1'b0; 
      set_CSR_WT_OPERATION     = 1'b0; 
      set_CSR_RD_OPERATION     = 1'b0; 
      set_CSR_BL_DATA_SHIFT    = 1'b0; 
      set_CSR_WL_DATA_SHIFT    = 1'b0; 
    end
  endcase  
end


always@(*) begin : CSR_RD_EN
  rd_CSR_DEVICE_ID        = 1'b0;
  rd_CSR_FB_CFG_CMD       = 1'b0;
  rd_CSR_FB_CFG_KICKOFF   = 1'b0; 
  rd_CSR_FB_CFG_DONE      = 1'b0; 
  rd_CSR_CFG_BIT_LOOP_CNT = 1'b0; 
  rd_CSR_CHKSUM_WORD      = 1'b0; 
  rd_CSR_CHKSUM_STATUS    = 1'b0; 
//  rd_CSR_PD_FABRIC        = 1'b0; 
//  rd_CSR_IO_ISOLATE_CTL   = 1'b0; 
  rd_CSR_FB_SOFT_RESET    = 1'b0; 
  rd_CSR_BL_MAX_LENGTH    = 1'b0; 
  rd_CSR_WL_MAX_LENGTH    = 1'b0; 
  rd_CSR_WT_OPERATION     = 1'b0; 
  rd_CSR_RD_OPERATION     = 1'b0; 
  rd_CSR_BL_DATA_SHIFT    = 1'b0; 
  rd_CSR_WL_DATA_SHIFT    = 1'b0; 

  case(apbs_paddr)
    DEVICE_ID :
      if (apbs_rd_en)
        rd_CSR_DEVICE_ID      = 1'b1;
      else
        rd_CSR_DEVICE_ID      = 1'b0;
    FB_CFG_CMD :
      if (apbs_rd_en)
        rd_CSR_FB_CFG_CMD     = 1'b1;
      else
        rd_CSR_FB_CFG_CMD     = 1'b0;
    FB_CFG_KICKOFF :
      if (apbs_rd_en)
        rd_CSR_FB_CFG_KICKOFF = 1'b1;
      else
        rd_CSR_FB_CFG_KICKOFF = 1'b0;
    FB_CFG_DONE :
      if (apbs_rd_en)
        rd_CSR_FB_CFG_DONE    = 1'b1;
      else
        rd_CSR_FB_CFG_DONE    = 1'b0;
    LOOP_BIT_CNT :
      if (apbs_rd_en)
        rd_CSR_CFG_BIT_LOOP_CNT = 1'b1;
      else
        rd_CSR_CFG_BIT_LOOP_CNT = 1'b0;
    CHKSUM_WORD :
      if (apbs_rd_en)
        rd_CSR_CHKSUM_WORD    = 1'b1;
      else
        rd_CSR_CHKSUM_WORD    = 1'b0;
    CHKSUM_STATUS :
      if (apbs_rd_en)
        rd_CSR_CHKSUM_STATUS  = 1'b1;
      else
        rd_CSR_CHKSUM_STATUS  = 1'b0;
//    PD_FABRIC :
//      if (apbs_rd_en)
//        rd_CSR_PD_FABRIC      = 1'b1;
//      else
//        rd_CSR_PD_FABRIC      = 1'b0;
//    IO_ISOLATE_CTL :
//      if (apbs_rd_en)
//        rd_CSR_IO_ISOLATE_CTL = 1'b1;
//      else
//        rd_CSR_IO_ISOLATE_CTL = 1'b0;
    FB_SOFT_RESET :
      if (apbs_rd_en)
        rd_CSR_FB_SOFT_RESET  = 1'b1;
      else  
        rd_CSR_FB_SOFT_RESET  = 1'b0;
    BL_MAX_LENGTH : 
      if (apbs_rd_en)
        rd_CSR_BL_MAX_LENGTH = 1'b1;
      else
        rd_CSR_BL_MAX_LENGTH = 1'b0;
    WL_MAX_LENGTH : 
      if (apbs_rd_en)
        rd_CSR_WL_MAX_LENGTH = 1'b1;
      else
        rd_CSR_WL_MAX_LENGTH = 1'b0;
    WT_OPERATION :  
      if (apbs_rd_en)
        rd_CSR_WT_OPERATION = 1'b1;
      else
        rd_CSR_WT_OPERATION = 1'b0;
    RD_OPERATION :  
      if (apbs_rd_en)
        rd_CSR_RD_OPERATION = 1'b1;
      else
        rd_CSR_RD_OPERATION = 1'b0;
    BL_DATA_SHIFT :  
      if (apbs_rd_en)
        rd_CSR_BL_DATA_SHIFT = 1'b1;
      else
        rd_CSR_BL_DATA_SHIFT = 1'b0;
    WL_DATA_SHIFT :  
      if (apbs_rd_en)
        rd_CSR_WL_DATA_SHIFT = 1'b1;
      else
        rd_CSR_WL_DATA_SHIFT = 1'b0;
     default: begin
       rd_CSR_DEVICE_ID        = 1'b0;
       rd_CSR_FB_CFG_CMD       = 1'b0;
       rd_CSR_FB_CFG_KICKOFF   = 1'b0; 
       rd_CSR_FB_CFG_DONE      = 1'b0; 
       rd_CSR_CFG_BIT_LOOP_CNT = 1'b0; 
       rd_CSR_CHKSUM_WORD      = 1'b0; 
       rd_CSR_CHKSUM_STATUS    = 1'b0; 
//       rd_CSR_PD_FABRIC        = 1'b0; 
//       rd_CSR_IO_ISOLATE_CTL   = 1'b0; 
       rd_CSR_FB_SOFT_RESET    = 1'b0; 
       rd_CSR_BL_MAX_LENGTH    = 1'b0; 
       rd_CSR_WL_MAX_LENGTH    = 1'b0; 
       rd_CSR_WT_OPERATION     = 1'b0; 
       rd_CSR_RD_OPERATION     = 1'b0; 
       rd_CSR_BL_DATA_SHIFT    = 1'b0; 
       rd_CSR_WL_DATA_SHIFT    = 1'b0; 
     end  
  endcase  
end


always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin : FCB_REG_FILES
  if (~fcb_reg_rstn) begin
    fCSR_DEVICE_ID        <= #CK2Q 8'h22;
    fCSR_FB_CFG_CMD       <= #CK2Q 2'h0; 
    fCSR_FB_CFG_KICKOFF   <= #CK2Q 1'b0;
    fCSR_FB_CFG_DONE      <= #CK2Q 1'b0;
    fCSR_CFG_BIT_LOOP_CNT <= #CK2Q 32'h0; 
    fCSR_CHKSUM_WORD      <= #CK2Q 32'h0;
    fCSR_CHKSUM_STATUS    <= #CK2Q 1'b0;
    fCSR_IO_ISOLATE_CTL   <= #CK2Q 2'b01;
    fCSR_BL_MAX_LENGTH    <= #CK2Q 32'h0; 
    fCSR_WL_MAX_LENGTH    <= #CK2Q 32'h0;
    fCSR_WT_OPERATION     <= #CK2Q 27'h0;
    fCSR_RD_OPERATION     <= #CK2Q 32'h0;
    fCSR_BL_DATA_SHIFT    <= #CK2Q 32'h0;
    fCSR_WL_DATA_SHIFT    <= #CK2Q 32'h0;
  end 
  else if (set_CSR_DEVICE_ID) 
    fCSR_DEVICE_ID      <= #CK2Q apbs_pwdata[7:0]; 
  else if (set_CSR_FB_CFG_CMD)  
    fCSR_FB_CFG_CMD     <= #CK2Q apbs_pwdata[1:0];
  else if (set_CSR_FB_CFG_KICKOFF)  //RWHC
    fCSR_FB_CFG_KICKOFF <= #CK2Q apbs_pwdata[0]; 
  else if (clr_CSR_FB_CFG_KICKOFF) begin 
    fCSR_FB_CFG_KICKOFF <= #CK2Q 1'h0; //RWHC
    fCSR_CHKSUM_STATUS  <= #CK2Q CHKS_CSR_chksum_status; //RHW
  end else if (hwset_CSR_FB_CFG_DONE )
    fCSR_FB_CFG_DONE    <= #CK2Q 1'b1;
  else if ( set_CSR_FB_CFG_DONE )    
    fCSR_FB_CFG_DONE    <= #CK2Q apbs_pwdata[0];
  else if (set_CSR_CFG_BIT_LOOP_CNT)  
    fCSR_CFG_BIT_LOOP_CNT <= #CK2Q apbs_pwdata[31:0]; 
  else if (set_CSR_CHKSUM_WORD)
    fCSR_CHKSUM_WORD    <= #CK2Q apbs_pwdata[31:0];
  else if (set_CSR_IO_ISOLATE_CTL)  
    fCSR_IO_ISOLATE_CTL <= #CK2Q apbs_pwdata[1:0];
  else if (set_CSR_BL_MAX_LENGTH)  
    fCSR_BL_MAX_LENGTH <= #CK2Q apbs_pwdata[31:0]; 
  else if (set_CSR_WL_MAX_LENGTH)  
    fCSR_WL_MAX_LENGTH <= #CK2Q apbs_pwdata[31:0];  
  else if (set_CSR_WT_OPERATION)  
    fCSR_WT_OPERATION <= #CK2Q apbs_pwdata[26:0];
  else if (set_CSR_RD_OPERATION)  
    fCSR_RD_OPERATION <= #CK2Q apbs_pwdata[31:0];
  else if (set_CSR_BL_DATA_SHIFT)  
    fCSR_BL_DATA_SHIFT <= #CK2Q apbs_pwdata[31:0];
  else if (set_CSR_WL_DATA_SHIFT)  
    fCSR_WL_DATA_SHIFT <= #CK2Q apbs_pwdata[31:0];
end

always@(posedge FCB_CLK or negedge FCB_RST_N) begin : REG_RESET_BY_SYS_RESET
  if (~FCB_RST_N) begin
    fCSR_FB_SOFT_RESET  <= #CK2Q 1'b0;
    fCSR_PD_FABRIC_CTL  <= #CK2Q 2'b01; //Specific for Waves
  end else if (set_CSR_FB_SOFT_RESET) 
    fCSR_FB_SOFT_RESET  <= #CK2Q apbs_pwdata[0];
  else if (set_CSR_PD_ACTIVATE )  
    fCSR_PD_FABRIC_CTL[0]  <= #CK2Q apbs_pwdata[0];
end	

always@(*) begin : READ_FCB_CSR
  if ( rd_CSR_DEVICE_ID )
    apbs_prdata = {24'h0,fCSR_DEVICE_ID}; 
  else if ( rd_CSR_FB_CFG_CMD )
    apbs_prdata = {30'h0,fCSR_FB_CFG_CMD};
  else if ( rd_CSR_FB_CFG_KICKOFF )
    apbs_prdata = {31'h0,fCSR_FB_CFG_KICKOFF};
  else if ( rd_CSR_FB_CFG_DONE )
    apbs_prdata = {31'h0,fCSR_FB_CFG_DONE};
  else if ( rd_CSR_CFG_BIT_LOOP_CNT )
    apbs_prdata = fCSR_CFG_BIT_LOOP_CNT[31:0];
  else if ( rd_CSR_CHKSUM_WORD )
    apbs_prdata = fCSR_CHKSUM_WORD[31:0];
  else if ( rd_CSR_CHKSUM_STATUS  )
    apbs_prdata = {31'h0,fCSR_CHKSUM_STATUS};
  else if ( rd_CSR_FB_SOFT_RESET )
    apbs_prdata = {31'h0,fCSR_FB_SOFT_RESET};
  else if (rd_CSR_BL_MAX_LENGTH)
    apbs_prdata = fCSR_BL_MAX_LENGTH[31:0];
  else if (rd_CSR_WL_MAX_LENGTH)
    apbs_prdata = fCSR_WL_MAX_LENGTH[31:0];
  else if (rd_CSR_WT_OPERATION)
    apbs_prdata = {5'h0,fCSR_WT_OPERATION};
  else if (rd_CSR_RD_OPERATION)
    apbs_prdata = fCSR_RD_OPERATION;
  else if (rd_CSR_BL_DATA_SHIFT)
    apbs_prdata = fCSR_BL_DATA_SHIFT[31:0];
  else if (rd_CSR_WL_DATA_SHIFT)
    apbs_prdata = fCSR_WL_DATA_SHIFT[31:0];
  else  
    apbs_prdata = 32'h0;
end

endmodule 
