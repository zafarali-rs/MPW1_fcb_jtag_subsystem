`timescale 1ns/10ps

module FCB_APBS (
  input wire FCB_CLK,
  input wire FCB_RST_N,

  input wire FCB_APBS_PSEL,
  input wire FCB_APBS_PENABLE,
  input wire FCB_APBS_PWRITE,
  input wire [31:0] FCB_APBS_PADDR,
  input wire [31:0] FCB_APBS_PWDATA,
  input wire [31:0] CSR_APBS_prdata,

	input wire CFG_APBS_fmask_win_write_operation, 

  output wire  FCB_APBS_PREADY,
  output wire  FCB_APBS_PSLVERR,
  output wire [31:0] FCB_APBS_PRDATA, 
  output reg  [31:0] fAPBS_CHKS_wdata, 
  output wire [66:0] APBS_CSR_wdata
);

localparam CK2Q = 0.01;

localparam  MAIN_S00 = 4'h0; //IDLE
localparam  MAIN_S01 = 4'h1; //SETUP
localparam  MAIN_S02 = 4'h2; //WRITE
localparam  MAIN_S03 = 4'h3; //READ
localparam  MAIN_S04 = 4'h4; 
localparam  MAIN_S05 = 4'h5;
localparam  MAIN_S06 = 4'h6;
localparam  MAIN_S07 = 4'h7;

reg  [3:0] fapbs_stm_cs; 
reg  [3:0] apbs_stm_ns;

reg  apbs_pready_ns;

assign  FCB_APBS_PRDATA  = CSR_APBS_prdata;

assign  FCB_APBS_PSLVERR = 1'b0;  


assign APBS_CSR_wdata = { //total 67
  FCB_APBS_PSEL,        // 1
  FCB_APBS_PWRITE,      // 1
  FCB_APBS_PENABLE,     // 1
  FCB_APBS_PADDR[31:0], //32
  FCB_APBS_PWDATA[31:0] //32
};    

always@(posedge FCB_CLK or negedge FCB_RST_N)
  if (~FCB_RST_N)
    fAPBS_CHKS_wdata <= #CK2Q 32'h0;
  else
    fAPBS_CHKS_wdata <= #CK2Q FCB_APBS_PWDATA[31:0];    

always@(posedge FCB_CLK or negedge FCB_RST_N) begin : APBS_STM_FF
  if (~FCB_RST_N)
    fapbs_stm_cs <= #CK2Q MAIN_S00; 
  else 
    fapbs_stm_cs <= #CK2Q apbs_stm_ns; 
end

assign FCB_APBS_PREADY = apbs_pready_ns;    


always@(*) begin: APBS_STM_COMB
  case (fapbs_stm_cs)
    MAIN_S00: begin //IDLE
      if (FCB_APBS_PSEL == 1'b1 )
        apbs_stm_ns = MAIN_S01; 
      else  
        apbs_stm_ns = fapbs_stm_cs; 
    end //MAIN_S00
    MAIN_S01: begin //SETUP
      if (FCB_APBS_PENABLE & FCB_APBS_PWRITE)
        apbs_stm_ns = MAIN_S02; 
      else if (FCB_APBS_PENABLE & ~FCB_APBS_PWRITE)   
        apbs_stm_ns = MAIN_S03; 
      else  
        apbs_stm_ns = fapbs_stm_cs; 
    end //MAIN_S01
    MAIN_S02: begin //WRITE
      if (apbs_pready_ns)
        apbs_stm_ns = MAIN_S01; 
      else   
        apbs_stm_ns = fapbs_stm_cs;
    end //MAIN_S02
    MAIN_S03: begin //READ
      if (apbs_pready_ns)
        apbs_stm_ns = MAIN_S01; 
      else  
        apbs_stm_ns = fapbs_stm_cs; 
    end //MAIN_S03
    default :
      apbs_stm_ns = fapbs_stm_cs; 
  endcase
end 
  
always@(*) begin : OUT_APBS_PREADY
  if (CFG_APBS_fmask_win_write_operation)
   apbs_pready_ns = 1'b0;
  else if (~FCB_APBS_PENABLE)
   apbs_pready_ns = 1'b0;
  else 
   apbs_pready_ns = 1'b1;
end

endmodule
