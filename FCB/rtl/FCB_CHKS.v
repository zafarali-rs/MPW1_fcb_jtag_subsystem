`timescale 1ns/10ps

module FCB_CHKS (
  input wire FCB_CLK,
  input wire fcb_reg_rstn,

  input wire [ 1:0]  CSR_CHKS_cfgcmd,        
  input wire [31:0]  fAPBS_CHKS_wdata,
  input wire [0:31]  CCFF_TAIL, 

  input wire         CFG_CHKS_fprechksum_w0_en, 
  input wire         CFG_CHKS_fprechksum_w1_en, 
  input wire         CFG_CHKS_fpostchksum_w0_en, 
  input wire         CFG_CHKS_fpostchksum_w1_en, 

  input wire         CFG_CHKS_win_postchs_rdata,
  input wire [31:0]  CSR_CHKS_chksum,

  output wire        CHKS_CSR_chksum_status

);

localparam CK2Q = 0.01;

wire pre_chksum_en;
assign pre_chksum_en  = CSR_CHKS_cfgcmd == 2'h1; 

wire post_chksum_en;
assign post_chksum_en = CSR_CHKS_cfgcmd == 2'h2; 


reg  fwin_postchs_rdata_dly1;
reg  fwin_postchs_rdata_dly2;
always@(posedge FCB_CLK or negedge fcb_reg_rstn)
  if (~fcb_reg_rstn) begin
    fwin_postchs_rdata_dly1 <= #CK2Q 1'b0; 
    fwin_postchs_rdata_dly2 <= #CK2Q 1'b0; 
  end else begin	
    fwin_postchs_rdata_dly1 <= #CK2Q CFG_CHKS_win_postchs_rdata;
    fwin_postchs_rdata_dly2 <= #CK2Q fwin_postchs_rdata_dly1;
  end	

wire win_postchs_rdata = fwin_postchs_rdata_dly1 || fwin_postchs_rdata_dly2;


wire [15:0] chksum_c0_w0, chksum_c0_w1; 
wire [15:0] chksum_c1_w0, chksum_c1_w1; 
reg  [15:0] fchksum_c0,   fchksum_c1;

wire [15:0] frfu_csum_w0 = CSR_CHKS_chksum[15: 0];
wire [15:0] frfu_csum_w1 = CSR_CHKS_chksum[31:16];

assign CHKS_CSR_chksum_status =  ~(   |(fchksum_c0 + frfu_csum_w0 + frfu_csum_w1) 
                                   || |(fchksum_c1 - frfu_csum_w1)
                                  ); 

//wire [15:0] A = (fchksum_c0 + frfu_csum_w0 + frfu_csum_w1); 
//wire [15:0] B = (fchksum_c1 - frfu_csum_w1);
                                  
wire [31:0] LE_CCFF_TAIL = { CCFF_TAIL[31], CCFF_TAIL[30], CCFF_TAIL[29], CCFF_TAIL[28],
                             CCFF_TAIL[27], CCFF_TAIL[26], CCFF_TAIL[25], CCFF_TAIL[24],
                             CCFF_TAIL[23], CCFF_TAIL[22], CCFF_TAIL[21], CCFF_TAIL[20],
                             CCFF_TAIL[19], CCFF_TAIL[18], CCFF_TAIL[17], CCFF_TAIL[16],
                             CCFF_TAIL[15], CCFF_TAIL[14], CCFF_TAIL[13], CCFF_TAIL[12],
                             CCFF_TAIL[11], CCFF_TAIL[10], CCFF_TAIL[9],  CCFF_TAIL[8],
                             CCFF_TAIL[7],  CCFF_TAIL[6],  CCFF_TAIL[5],  CCFF_TAIL[4],
                             CCFF_TAIL[3],  CCFF_TAIL[2],  CCFF_TAIL[1],  CCFF_TAIL[0]
                            };  

reg  [31:0] fFB_CHKS_RDATA; 
reg  [31:0] fFB_CHKS_RDATA_dly1; 

always@(posedge FCB_CLK or negedge fcb_reg_rstn)
  if (~fcb_reg_rstn) begin
    fFB_CHKS_RDATA      <= #CK2Q 32'h0;
    fFB_CHKS_RDATA_dly1 <= #CK2Q 32'h0;
  end else begin 	
    fFB_CHKS_RDATA      <= #CK2Q LE_CCFF_TAIL; 
    fFB_CHKS_RDATA_dly1 <= #CK2Q fFB_CHKS_RDATA; 
  end	


assign chksum_c0_w0 = pre_chksum_en ? fchksum_c0 + fAPBS_CHKS_wdata[15: 0] 
                                    : post_chksum_en && win_postchs_rdata ? fchksum_c0 + fFB_CHKS_RDATA_dly1[15:0] 
                                    : 16'h0 ;

assign chksum_c0_w1 = pre_chksum_en ? fchksum_c0 + fAPBS_CHKS_wdata[31:16]
                                    : post_chksum_en && win_postchs_rdata ? fchksum_c0 + fFB_CHKS_RDATA_dly1[31:16] 
                                    : 16'h0 ;

assign chksum_c1_w0 = pre_chksum_en ? fchksum_c0 + fchksum_c1 + fAPBS_CHKS_wdata[15:0]
                                    : post_chksum_en && win_postchs_rdata ? fchksum_c0 + fchksum_c1 + fFB_CHKS_RDATA_dly1[15:0]
                                    : 16'h0 ;

assign chksum_c1_w1 = pre_chksum_en ? fchksum_c0 + fchksum_c1 + fAPBS_CHKS_wdata[31:16]
                                    : post_chksum_en && win_postchs_rdata ? fchksum_c0 + fchksum_c1 + fFB_CHKS_RDATA_dly1[31:16]
                                    : 16'h0 ;                                                  


always@(posedge FCB_CLK or negedge fcb_reg_rstn) begin
  if (~fcb_reg_rstn) begin
    fchksum_c0 <= #CK2Q 16'h0; 
    fchksum_c1 <= #CK2Q 16'h0;
  end else if (pre_chksum_en && CFG_CHKS_fprechksum_w0_en == 1'b1) begin
    fchksum_c0 <= #CK2Q chksum_c0_w0;
    fchksum_c1 <= #CK2Q chksum_c1_w0;
  end else if (pre_chksum_en && CFG_CHKS_fprechksum_w1_en == 1'b1) begin
    fchksum_c0 <= #CK2Q chksum_c0_w1;
    fchksum_c1 <= #CK2Q chksum_c1_w1;
  end else if (post_chksum_en && CFG_CHKS_fpostchksum_w0_en == 1'b1) begin
    fchksum_c0 <= #CK2Q chksum_c0_w0;
    fchksum_c1 <= #CK2Q chksum_c1_w0;
  end else if (post_chksum_en && CFG_CHKS_fpostchksum_w1_en == 1'b1) begin
    fchksum_c0 <= #CK2Q chksum_c0_w1;
    fchksum_c1 <= #CK2Q chksum_c1_w1;
  end
end


endmodule
