`timescale 1ns/10ps

module FCB_CFG (
  input  wire FCB_CLK,
  input  wire fcb_reg_rstn,
  input  wire [66:0] APBS_CSR_wdata,
  input  wire        CSR_CFG_fb_cfg_kickoff,  
  input  wire        CSR_CFG_fb_cfg_done,  
  input  wire [31:0] CSR_CFG_bl_max_length,
  input  wire [31:0] CSR_CFG_wl_max_length,
  input  wire [26:0] CSR_CFG_wt_operation,
  input  wire [31:0] CSR_CFG_rd_operation,
  input  wire [31:0] CSR_CFG_wl_data_shift,
  input  wire [ 1:0] CSR_CFG_cfgcmd,       

  output wire CFG_CHKS_win_postchs_rdata,
  output wire CFG_CSR_fb_cfg_done,
  output wire CFG_CHKS_fprechksum_w0_en, 
  output wire CFG_CHKS_fprechksum_w1_en, 
  output wire CFG_CHKS_fpostchksum_w0_en, 
  output wire CFG_CHKS_fpostchksum_w1_en, 
  output wire CFG_APBS_fmask_win_write_operation, 
  output wire [31:0] CFG_CHKS_fis_ctrl_head, 
  
  output wire BL_CLK,
  output wire BLWEN,
  output wire BLREN,
  output wire WL_CLK,
  output wire WLWEN,
  output wire WLREN

);

localparam CK2Q = 0.01;

localparam BL_MAX_LENGTH  = 8'h10;
localparam WL_MAX_LENGTH  = 8'h14;
localparam WT_OPERATION   = 8'h18;
localparam RD_OPERATION   = 8'h1C;
localparam BL_DATA_SHIFT  = 8'h1E;
localparam WL_DATA_SHIFT  = 8'h1F;

localparam [2:0]  S_WIDLE   = 3'h0, 
                  S_WWLCLK  = 3'h1, 
                  S_SUBLWEN = 3'h2, 
                  S_WSU     = 3'h3, 
                  S_WRITE   = 3'h4, 
                  S_WHD     = 3'h5; 

localparam [3:0]  S_RIDLE   = 4'h0, 
                  S_RWLCLK  = 4'h1, 
                  S_SUBLREN = 4'h2, 
                  S_RSU     = 4'h3, 
                  S_READ    = 4'h4,
                  S_RHD     = 4'h5, 
                  S_RBLCLKSU= 4'h6, 
                  S_RBLCLK  = 4'h7, 
                  S_RBLCLKHD= 4'h8; 

wire         apbs_psel    = APBS_CSR_wdata[66];
wire         apbs_pwrite  = APBS_CSR_wdata[65];
wire         apbs_penable = APBS_CSR_wdata[64];
wire  [31:0] apbs_paddr   = APBS_CSR_wdata[63:32];
wire  [31:0] apbs_pwdata  = APBS_CSR_wdata[31:0];

wire [2:0] csr_tsublwen = CSR_CFG_wt_operation[26:24];
wire [7:0] csr_twsu     = CSR_CFG_wt_operation[23:16];
wire [7:0] csr_twrite   = CSR_CFG_wt_operation[15:8];
wire [7:0] csr_twhd     = CSR_CFG_wt_operation[7:0]; 

wire [1:0] csr_trblclksu= CSR_CFG_rd_operation[31:30];
wire [2:0] csr_trblclkhd= CSR_CFG_rd_operation[29:27];
wire [2:0] csr_tsublren = CSR_CFG_rd_operation[26:24];
wire [7:0] csr_trsu     = CSR_CFG_rd_operation[23:16];
wire [7:0] csr_tread    = CSR_CFG_rd_operation[15:8];
wire [7:0] csr_trhd     = CSR_CFG_rd_operation[7:0]; 


wire  disable_chksum = CSR_CFG_cfgcmd==2'h0; 
wire  pre_chksum_en  = CSR_CFG_cfgcmd==2'h1; 
wire  post_chksum_en = CSR_CFG_cfgcmd==2'h2; 

reg fis_read_operation;
reg fmask_win_write_operation;

wire apbs_wr_en  = apbs_penable & apbs_pwrite & ~fmask_win_write_operation;


// WRITE OPERATION

reg [2:0] nxt_sublwen_cnt, fsublwen_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    fsublwen_cnt <= #CK2Q 3'h0;
  else if (fsublwen_cnt == csr_tsublwen)  
    fsublwen_cnt <= #CK2Q 3'h0;
  else  
    fsublwen_cnt <= #CK2Q nxt_sublwen_cnt;
end

reg [7:0] nxt_wsu_cnt, fwsu_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    fwsu_cnt<= #CK2Q 8'h0;
  else if (fwsu_cnt == csr_twsu)  
    fwsu_cnt <= #CK2Q 8'h0;
  else  
    fwsu_cnt <= #CK2Q nxt_wsu_cnt;
end

reg [7:0] nxt_write_cnt, fwrite_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    fwrite_cnt<= #CK2Q 8'h0;
  else if (fwrite_cnt == csr_twrite)  
    fwrite_cnt <= #CK2Q 8'h0;
  else  
    fwrite_cnt <= #CK2Q nxt_write_cnt;
end

reg [7:0] nxt_whd_cnt, fwhd_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    fwhd_cnt<= #CK2Q 8'h0;
  else if (fwhd_cnt==csr_twhd) 
    fwhd_cnt <= #CK2Q 8'h0;
  else
    fwhd_cnt <= #CK2Q nxt_whd_cnt;
end

reg fis_wl_clk; 

reg [31:0] fwl_cnt;
reg [31:0] fbl_cnt;
reg [2:0] write_operation_ns, fwrite_operation_cs;  
reg [3:0] read_operation_ns, fread_operation_cs;  

wire is_write_operation_done = (csr_twhd != 8'h0) ? CSR_CFG_fb_cfg_kickoff & (fwhd_cnt==csr_twhd)
                                                  : fwrite_operation_cs==S_WHD; 

wire is_final_write_operation_done = is_write_operation_done & fwl_cnt==CSR_CFG_wl_max_length+'h1;

wire is_final_read_operation       = fwl_cnt==CSR_CFG_wl_max_length+'h1;

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin : IS_WL_CLK
  if (~fcb_reg_rstn)
    fis_wl_clk <= #CK2Q 1'b0;
  else if (write_operation_ns==S_SUBLWEN | read_operation_ns==S_SUBLREN)
    fis_wl_clk <= #CK2Q 1'b0;
  else if (~fis_read_operation & fbl_cnt==CSR_CFG_bl_max_length+'h1 & CSR_CFG_fb_cfg_kickoff & fwrite_operation_cs==S_WWLCLK)
    fis_wl_clk <= #CK2Q 1'b1;
  else if (fis_read_operation & CSR_CFG_fb_cfg_kickoff & fread_operation_cs==S_RWLCLK & CSR_CFG_bl_max_length=='h0 & ~CSR_CFG_fb_cfg_done)
    fis_wl_clk <= #CK2Q 1'b1;
  else if (fis_read_operation & CSR_CFG_fb_cfg_kickoff & fread_operation_cs==S_RWLCLK & ~is_final_read_operation & ~CSR_CFG_fb_cfg_done)
    fis_wl_clk <= #CK2Q 1'b1;
end 

reg [31:0] fis_ctrl_head;
assign CFG_CHKS_fis_ctrl_head = fis_ctrl_head; 

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin 
  if (~fcb_reg_rstn)
    fis_ctrl_head <= #CK2Q 32'h0;
  else if (fwrite_operation_cs==S_SUBLWEN & ~fis_read_operation)
    fis_ctrl_head <= #CK2Q 32'h0;
  else if (fread_operation_cs==S_SUBLREN & fis_read_operation)
    fis_ctrl_head <= #CK2Q 32'h0;
  else if (~fis_read_operation & fwl_cnt==32'h0 & CSR_CFG_fb_cfg_kickoff & write_operation_ns==S_WWLCLK)
    fis_ctrl_head <= #CK2Q CSR_CFG_wl_data_shift;
  else if (fis_read_operation & fwl_cnt==32'h0 & CSR_CFG_fb_cfg_kickoff & read_operation_ns==S_RWLCLK & ~is_final_read_operation)
    fis_ctrl_head <= #CK2Q CSR_CFG_wl_data_shift;
end 

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin : WT_OP_STM_FF
  if (~fcb_reg_rstn) begin
    fwrite_operation_cs <= #CK2Q 3'h0;
  end else begin
    fwrite_operation_cs <= #CK2Q write_operation_ns;
  end  
end

reg bl_wen;
reg wl_wen;

always@(*) begin : WT_OP_STM_COMB
  write_operation_ns = fwrite_operation_cs ;
  bl_wen = 1'b0;
  wl_wen = 1'b0;
  nxt_sublwen_cnt = fsublwen_cnt;
  nxt_wsu_cnt     = fwsu_cnt;
  nxt_write_cnt   = fwrite_cnt; 
  nxt_whd_cnt     = fwhd_cnt;
  case (fwrite_operation_cs) 
  S_WIDLE: begin
    bl_wen = 1'b0;
    wl_wen = 1'b0;
    if (fbl_cnt==CSR_CFG_bl_max_length+'h1 & fbl_cnt!=32'h0 & CSR_CFG_fb_cfg_kickoff & ~fis_read_operation) 
      write_operation_ns = S_WWLCLK;
  end        
  S_WWLCLK: begin
      bl_wen = 1'b0;
      wl_wen = 1'b0;
    if (CSR_CFG_fb_cfg_kickoff & fis_wl_clk & ~fis_read_operation ) 
      write_operation_ns = S_SUBLWEN;
  end
  S_SUBLWEN: begin
      bl_wen = 1'b0;
      wl_wen = 1'b0;
      if (fsublwen_cnt==csr_tsublwen || csr_tsublwen=='h0 ) 
      write_operation_ns = S_WSU;
    else
      nxt_sublwen_cnt = fsublwen_cnt + 3'h1;
  end
  S_WSU: begin
      bl_wen = 1'b1;
      wl_wen = 1'b0;
    if (fwsu_cnt == csr_twsu || csr_twsu=='h0) 
      write_operation_ns = S_WRITE;
    else
      nxt_wsu_cnt = fwsu_cnt + 8'h1;
  end
  S_WRITE: begin
      bl_wen = 1'b1;
      wl_wen = 1'b1;
      if (fwrite_cnt==csr_twrite || csr_twrite=='h0) 
      write_operation_ns = S_WHD;
    else
      nxt_write_cnt = fwrite_cnt + 8'h1; 
  end
  S_WHD: begin
    bl_wen = 1'b1;
    wl_wen = 1'b0;
    if (fwhd_cnt==csr_twhd || csr_twhd=='h0) 
      write_operation_ns = S_WIDLE;
    else  
      nxt_whd_cnt = fwhd_cnt + 8'h1;
  end
  default: begin
      write_operation_ns = S_WIDLE;
      bl_wen = 1'b0;
      wl_wen = 1'b0;
      nxt_sublwen_cnt = 3'h0;
      nxt_wsu_cnt     = 8'h0;
      nxt_write_cnt   = 8'h0; 
      nxt_whd_cnt     = 8'h0;
  end    
  endcase  
end


// READ OPERATION

reg [2:0] nxt_sublren_cnt, fsublren_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    fsublren_cnt <= #CK2Q 3'h0;
  else if (fsublren_cnt == csr_tsublren)  
    fsublren_cnt <= #CK2Q 3'h0;
  else  
    fsublren_cnt <= #CK2Q nxt_sublren_cnt ;
end

reg [7:0] nxt_rsu_cnt, frsu_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    frsu_cnt<= #CK2Q 8'h0;
  else if (frsu_cnt == csr_trsu)  
    frsu_cnt <= #CK2Q 8'h0;
  else  
    frsu_cnt <= #CK2Q nxt_rsu_cnt;
end

reg [7:0] nxt_read_cnt, fread_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    fread_cnt<= #CK2Q 8'h0;
  else if (fread_cnt == csr_tread)  
    fread_cnt <= #CK2Q 8'h0;
  else  
    fread_cnt <= #CK2Q nxt_read_cnt;
end

reg [7:0] nxt_rhd_cnt, frhd_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    frhd_cnt<= #CK2Q 8'h0;
  else if (frhd_cnt == csr_trhd)  
    frhd_cnt <= #CK2Q 8'h0;
  else  
    frhd_cnt <= #CK2Q nxt_rhd_cnt;
end

reg [2:0] nxt_rblclksu_cnt, frblclksu_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    frblclksu_cnt<= #CK2Q 3'h0;
  else if (frblclksu_cnt == csr_trblclksu)  
    frblclksu_cnt <= #CK2Q 3'h0;
  else  
    frblclksu_cnt <= #CK2Q nxt_rblclksu_cnt;
end

reg [2:0] nxt_rblclkhd_cnt, frblclkhd_cnt; 
always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    frblclkhd_cnt<= #CK2Q 3'h0;
  else if (frblclkhd_cnt == csr_trblclkhd)  
    frblclkhd_cnt <= #CK2Q 3'h0;
  else  
    frblclkhd_cnt <= #CK2Q nxt_rblclkhd_cnt;
end

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin : RD_OP_STM_FF
  if (~fcb_reg_rstn) begin
    fread_operation_cs <= #CK2Q 4'h0;
  end else begin
    fread_operation_cs <= #CK2Q read_operation_ns;
  end  
end


reg bl_ren;
reg wl_ren;

always@(*) begin : RD_OP_STM_COMB
  read_operation_ns = fread_operation_cs ;
  bl_ren = 1'b0;
  wl_ren = 1'b0;
  nxt_sublren_cnt = fsublren_cnt;
  nxt_rsu_cnt     = frsu_cnt;
  nxt_read_cnt    = fread_cnt; 
  nxt_rhd_cnt     = frhd_cnt;
  nxt_rblclksu_cnt= frblclksu_cnt;
  nxt_rblclkhd_cnt= frblclkhd_cnt;
  case (fread_operation_cs) 
  S_RIDLE: begin
    bl_ren = 1'b0;
    wl_ren = 1'b0;
    if (CSR_CFG_fb_cfg_kickoff & fis_read_operation)
      read_operation_ns = S_RWLCLK;
  end
  S_RWLCLK: begin
    bl_ren = 1'b0;
    wl_ren = 1'b0;
    if (CSR_CFG_fb_cfg_kickoff & fis_read_operation & fis_wl_clk)
      read_operation_ns = S_SUBLREN;
  end
  S_SUBLREN: begin
    bl_ren = 1'b0;
    wl_ren = 1'b0;
    if (fsublren_cnt==csr_tsublren || csr_tsublren=='h0) 
      read_operation_ns = S_RSU;
    else 
      nxt_sublren_cnt = fsublren_cnt + 3'h1;
  end
  S_RSU: begin
    bl_ren = 1'b1;
    wl_ren = 1'b0;
    if (frsu_cnt==csr_trsu || csr_trsu=='h0) 
      read_operation_ns = S_READ;
    else
      nxt_rsu_cnt = frsu_cnt + 8'h1;
  end
  S_READ: begin
    bl_ren = 1'b1;
    wl_ren = 1'b1;
    if (fread_cnt==csr_tread || csr_tread=='h0) 
      read_operation_ns = S_RHD;
    else
      nxt_read_cnt = fread_cnt + 8'h1; 
  end
  S_RHD: begin
    bl_ren = 1'b1;
    wl_ren = 1'b0;
    if (frhd_cnt==csr_trhd || csr_trhd=='h0) 
      read_operation_ns = S_RBLCLKSU;
    else
      nxt_rhd_cnt = frhd_cnt + 8'h1;
  end
  S_RBLCLKSU: begin
    bl_ren = 1'b0;
    wl_ren = 1'b0;
    if (frblclksu_cnt==csr_trblclksu  || csr_trblclksu=='h0) 
      read_operation_ns = S_RBLCLK;
    else
      nxt_rblclksu_cnt = frblclksu_cnt + 3'h1;
  end  
  S_RBLCLK: begin
    bl_ren = 1'b0;
    wl_ren = 1'b0;
    read_operation_ns = S_RBLCLKHD;
  end
  S_RBLCLKHD: begin
    bl_ren = 1'b0;
    wl_ren = 1'b0;
    if (fbl_cnt==CSR_CFG_bl_max_length+'h1)
      read_operation_ns = S_RIDLE;
    else if (frblclkhd_cnt==csr_trblclkhd || csr_trblclkhd=='h0) 
      read_operation_ns = S_RBLCLKSU;
    else
      nxt_rblclkhd_cnt = frblclkhd_cnt + 3'h1;
  end
  default: begin
    read_operation_ns = S_RIDLE;
    bl_ren = 1'b0;
    wl_ren = 1'b0;
    nxt_sublren_cnt = 3'h0;
    nxt_rsu_cnt     = 8'h0;
    nxt_read_cnt    = 8'h0; 
    nxt_rhd_cnt     = 8'h0;
    nxt_rblclksu_cnt = 3'h0;
    nxt_rblclkhd_cnt = 3'h0;
  end    
  endcase  
end


// CFG_DONE
reg  fis_bl_clk;

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin: BL_CNT
  if (~fcb_reg_rstn)
    fbl_cnt <= #CK2Q 32'h0;
  else if (is_write_operation_done) 
    fbl_cnt <= #CK2Q 32'h0;
  else if (fis_read_operation & WL_CLK) 
    fbl_cnt <= #CK2Q 32'h0;
  //vincent@20211116 else if ( apbs_wr_en & apbs_paddr==BL_DATA_SHIFT & ~fmask_win_write_operation)
  else if ( apbs_wr_en & apbs_paddr==BL_DATA_SHIFT & ~fmask_win_write_operation)
    fbl_cnt <= #CK2Q fbl_cnt + 32'h1;
  else if ( fis_read_operation & fread_operation_cs==S_RBLCLK & fbl_cnt< CSR_CFG_bl_max_length+'h1)
    fbl_cnt <= #CK2Q fbl_cnt + 32'h1;
end


always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin: WL_CNT
  if (~fcb_reg_rstn)
    fwl_cnt <= #CK2Q 32'h0;
  else if (is_final_write_operation_done)
    fwl_cnt <= #CK2Q 32'h0;
  else if (fbl_cnt==CSR_CFG_bl_max_length+'h1 & fis_wl_clk & !fis_read_operation)
    fwl_cnt <= #CK2Q fwl_cnt + 32'h1;
  else if (fis_wl_clk & fis_read_operation)
    fwl_cnt <= #CK2Q fwl_cnt + 32'h1;
end


always@(posedge FCB_CLK or negedge fcb_reg_rstn)
  if (~fcb_reg_rstn)
    fis_read_operation <= #CK2Q 1'b0;
  else if ( post_chksum_en & fwrite_operation_cs==S_WHD & (fwl_cnt==CSR_CFG_wl_max_length+'h1) & fwhd_cnt==csr_twhd)
    fis_read_operation <= #CK2Q 1'b1 ;


wire is_wt_cfg_done = ((fbl_cnt==CSR_CFG_bl_max_length+'h1) && (fwl_cnt==CSR_CFG_wl_max_length+'h1)) && is_write_operation_done;
wire is_rb_cfg_done = CSR_CFG_wl_max_length!='h0 ? ((fbl_cnt==CSR_CFG_bl_max_length+'h1) && (fwl_cnt==CSR_CFG_wl_max_length+'h1)) 
                                                   && fread_operation_cs==S_RBLCLKHD  && fis_read_operation
                                                 : ((fbl_cnt==CSR_CFG_bl_max_length+'h1) && (fwl_cnt==CSR_CFG_wl_max_length+'h1))
                                                   && fread_operation_cs==S_RBLCLKHD  && fis_read_operation
                                                 ;

assign CFG_CSR_fb_cfg_done = (pre_chksum_en || disable_chksum) 
                             ? CSR_CFG_fb_cfg_kickoff ? is_wt_cfg_done 
                                                      : 1'b0 
                             : post_chksum_en ? CSR_CFG_fb_cfg_kickoff ? is_rb_cfg_done 
                                                                       : 1'b0
                                              : 1'b0;                      

assign CFG_CHKS_win_postchs_rdata = fis_read_operation;


// BL_CLK

assign BL_CLK = fis_bl_clk;

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin : IS_BL_CLK
  if (~fcb_reg_rstn)
   fis_bl_clk <= #CK2Q 1'b0;
  else if (fis_read_operation && csr_tread==8'h0) 
   fis_bl_clk <= #CK2Q (read_operation_ns==S_READ) | (fread_operation_cs==S_RBLCLK);
  else if (fis_read_operation && csr_tread==8'h1) 
    fis_bl_clk <= #CK2Q (!fread_cnt[0]&nxt_read_cnt[0]) | (fread_operation_cs==S_RBLCLK);

  else if (fis_read_operation & (csr_tread!=8'h0) & (fread_operation_cs!=S_RBLCLK)) 
   fis_bl_clk <= #CK2Q nxt_read_cnt==(csr_tread>>1); //bl_clk in period of read_operation
  else if (fis_read_operation & fread_operation_cs==S_RBLCLK & fbl_cnt<CSR_CFG_bl_max_length+'h1) 
    fis_bl_clk <= #CK2Q 1'b1; 
  else 
		fis_bl_clk <= #CK2Q apbs_wr_en & (apbs_paddr == BL_DATA_SHIFT) & CSR_CFG_fb_cfg_kickoff & ~fmask_win_write_operation;
end 


// WL_CLK
assign WL_CLK = fis_wl_clk;

//B/WLWEN & B/WREN
assign BLWEN = bl_wen;
assign WLWEN = wl_wen;
assign BLREN = bl_ren;
assign WLREN = wl_ren;

reg fprechksum_w0_en;
reg fprechksum_w0_en_dly1;

assign CFG_CHKS_fprechksum_w0_en = fprechksum_w0_en;
assign CFG_CHKS_fprechksum_w1_en = fprechksum_w0_en_dly1;

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) begin
   fprechksum_w0_en      <= #CK2Q 1'b0;
   fprechksum_w0_en_dly1 <= #CK2Q 1'b0;
  end else begin  
   fprechksum_w0_en      <= #CK2Q apbs_wr_en & (apbs_paddr == BL_DATA_SHIFT);
   fprechksum_w0_en_dly1 <= #CK2Q fprechksum_w0_en ;
  end 
end 

reg fpostchksum_w0_en, fpostchksum_w1_en;

assign CFG_CHKS_fpostchksum_w0_en = fpostchksum_w0_en;
assign CFG_CHKS_fpostchksum_w1_en = fpostchksum_w1_en;

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) begin
   fpostchksum_w0_en <= #CK2Q 1'b0;
   fpostchksum_w1_en <= #CK2Q 1'b0;
  end else begin  
   fpostchksum_w0_en <= #CK2Q (fis_read_operation & fread_operation_cs==S_RBLCLK & fbl_cnt<CSR_CFG_bl_max_length+'h1);
   fpostchksum_w1_en <= #CK2Q fpostchksum_w0_en ;
  end 
end 

// Link to PREADY 

always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) 
    fmask_win_write_operation <= #CK2Q 1'b0;
  else if (is_write_operation_done)    
    fmask_win_write_operation <= #CK2Q 1'b0;
	else if ((fbl_cnt==CSR_CFG_bl_max_length) & apbs_penable & CSR_CFG_fb_cfg_kickoff)
    fmask_win_write_operation <= #CK2Q 1'b1;
end

assign CFG_APBS_fmask_win_write_operation = fmask_win_write_operation;  

endmodule
