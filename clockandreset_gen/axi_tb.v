`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2022 01:59:27 PM
// Design Name: 
// Module Name: axi_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_rst_gen_tb;

  // Parameters
  localparam integer C_S_AXI_DATA_WIDTH = 32;
  localparam integer C_S_AXI_ADDR_WIDTH = 4;
  localparam integer DUT_RESET_VALUE = 165;
   parameter PERIOD = 10;

  // Ports
  reg  S_AXI_ACLK = 0;
  reg  S_AXI_ARESETN = 0;
  reg [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR;
  reg [2 : 0] S_AXI_AWPROT;
  reg  S_AXI_AWVALID = 0;
  wire  S_AXI_AWREADY;
  reg [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA;
  reg [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB;
  reg  S_AXI_WVALID = 0;
  wire  S_AXI_WREADY;
  wire [1 : 0] S_AXI_BRESP;
  wire  S_AXI_BVALID;
  reg  S_AXI_BREADY = 0;
  reg [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR;
  reg [2 : 0] S_AXI_ARPROT;
  reg  S_AXI_ARVALID = 0;
  wire  S_AXI_ARREADY;
  wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA;
  wire [1 : 0] S_AXI_RRESP;
  wire  S_AXI_RVALID;
  reg  S_AXI_RREADY = 0;
  wire clk_2dut;
  wire rst_2dut;
  reg config_done;
  reg CLK;
  clk_rst_gen 
  #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH ),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH ),
    .DUT_RESET_VALUE (DUT_RESET_VALUE )
  )
  clk_rst_gen_dut (
    .S_AXI_ACLK (S_AXI_ACLK),
    .S_AXI_ARESETN (S_AXI_ARESETN ),
    .S_AXI_AWADDR (S_AXI_AWADDR ),
    .S_AXI_AWPROT (S_AXI_AWPROT ),
    .S_AXI_AWVALID (S_AXI_AWVALID ),
    .S_AXI_AWREADY (S_AXI_AWREADY ),
    .S_AXI_WDATA (S_AXI_WDATA ),
    .S_AXI_WSTRB (S_AXI_WSTRB ),
    .S_AXI_WVALID (S_AXI_WVALID ),
    .S_AXI_WREADY (S_AXI_WREADY ),
    .S_AXI_BRESP (S_AXI_BRESP ),
    .S_AXI_BVALID (S_AXI_BVALID ),
    .S_AXI_BREADY (S_AXI_BREADY ),
    .S_AXI_ARADDR (S_AXI_ARADDR ),
    .S_AXI_ARPROT (S_AXI_ARPROT ),
    .S_AXI_ARVALID (S_AXI_ARVALID ),
    .S_AXI_ARREADY (S_AXI_ARREADY ),
    .S_AXI_RDATA (S_AXI_RDATA ),
    .S_AXI_RRESP (S_AXI_RRESP ),
    .S_AXI_RVALID (S_AXI_RVALID ),
    .S_AXI_RREADY (S_AXI_RREADY ),
    
    .config_done(config_done),
    .clk_2dut (clk_2dut ),
    .rst_2dut  ( rst_2dut)
    
  );

  initial begin				
    begin
    reset;
    config_done = 0;
           repeat(1) @(posedge S_AXI_ACLK);
    axi_wtransaction('d0,'d165);
    axi_rtransaction('d0);
       repeat(1) @(posedge S_AXI_ACLK);

    axi_wtransaction('d4,'d25);
    axi_rtransaction('d4);
           repeat(1) @(posedge S_AXI_ACLK);
           
           repeat(1) @(posedge S_AXI_ACLK);
    
        axi_wtransaction('d8,'d7);
        axi_rtransaction('d8);
               repeat(1) @(posedge S_AXI_ACLK);       
    axi_wtransaction('d12,'d30);
    axi_rtransaction('d12);
           repeat(1) @(posedge S_AXI_ACLK);

    config_done = 1;
   repeat(100) @(posedge S_AXI_ACLK);
   
   wait (clk_rst_gen_dut.pulse_counter == 'd30);  
   repeat(100) @(posedge S_AXI_ACLK);
    repeat(1) @(posedge S_AXI_ACLK);
    axi_wtransaction('d12,'d2);
    axi_rtransaction('d12);
    repeat(1) @(posedge S_AXI_ACLK);
    wait (clk_rst_gen_dut.pulse_counter == 'd2);  
   repeat(100) @(posedge S_AXI_ACLK);
    axi_wtransaction('d12,'d808);
    axi_rtransaction('d12);
    repeat(1) @(posedge S_AXI_ACLK);
    wait (clk_rst_gen_dut.pulse_counter == 'd10);  
   
   repeat(10000) @(posedge S_AXI_ACLK);
     axi_wtransaction('d12,'d10);
     axi_rtransaction('d12);
     repeat(1) @(posedge S_AXI_ACLK);
     wait (clk_rst_gen_dut.pulse_counter == 'd10);  

    //config_done = 0;

      $finish;
    end
  end
  
  
  
  initial begin
    $dumpvars(0,clk_rst_gen_tb);
  end
  
   task reset;     
      begin
        S_AXI_ARESETN <= 1'b1;
       repeat(1) @(posedge S_AXI_ACLK);
        S_AXI_ARESETN <= 1'b0;
       repeat(5) @(posedge S_AXI_ACLK);
        S_AXI_ARESETN <= 1'b1;
      end
   endtask
			
   task axi_wtransaction; 
      input [3:0]addr;
      input [31:0]data;
      begin

      S_AXI_AWADDR  = addr;
      S_AXI_AWPROT  = 0;
      S_AXI_AWVALID = 1;
      //S_AXI_AWREADY;
      S_AXI_WDATA  = data;
      S_AXI_WSTRB = 'b1111;
      S_AXI_WVALID = 1;
     // S_AXI_WREADY = 0;
     // S_AXI_BRESP = 0;
     //  S_AXI_BVALID ;
      S_AXI_BREADY = 1;
      
      wait (S_AXI_AWREADY == 1 );           
      repeat(1) @(posedge S_AXI_ACLK);
      #3;
      wait (S_AXI_WREADY == 1)       
      repeat(1) @(posedge S_AXI_ACLK);
      #3; 
         S_AXI_AWADDR  = 0;
      S_AXI_AWPROT  = 0;
      S_AXI_AWVALID = 0;
      //S_AXI_AWREADY;
      S_AXI_WDATA  = 0;
      S_AXI_WSTRB = 'b0;
      S_AXI_WVALID = 0;
     // S_AXI_WREADY = 0;
     // S_AXI_BRESP = 0;
     //  S_AXI_BVALID ;
      wait (S_AXI_BVALID == 1);
            repeat(1) @(posedge S_AXI_ACLK);
      #3;     
      S_AXI_BREADY = 0;

			
      end
    endtask
    
    
 task axi_rtransaction; 
      input [3:0]addr;
      
      begin    
    
       S_AXI_ARADDR = addr;
      S_AXI_ARPROT = 0;
      S_AXI_ARVALID= 1;
     // S_AXI_RDATA = 0;
      //S_AXI_RRESP = 0;
     // S_AXI_RVALID   = 0;  
     wait (S_AXI_ARREADY == 1);      
      repeat(1) @(posedge S_AXI_ACLK);
      #3;         
      S_AXI_ARVALID= 0;

      S_AXI_RREADY   =1; 
      wait (S_AXI_RVALID == 1);        
      S_AXI_RREADY   = 1; 
    
      repeat(1) @(posedge S_AXI_ACLK);      
      #3;         

      S_AXI_ARADDR = 0;
      S_AXI_ARPROT = 0;
      S_AXI_ARVALID= 0;
     //// S_AXI_RDATA = 0;
     // S_AXI_RRESP = 0;
     // S_AXI_RVALID   = 0;    
      S_AXI_RREADY   = 0; 
      		
      end
    endtask
    
      
   always begin
      S_AXI_ACLK = 1'b0;
      #(PERIOD/2) S_AXI_ACLK = 1'b1;
      #(PERIOD/2);
   end
				
				

endmodule
