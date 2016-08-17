`timescale 1ns / 1ps

module div_tb;
   
   parameter N = 8;
   parameter clk_period =20;
   
   
   reg clk;
   
   reg [N-1:0] dividend_i;  
   reg [2*N-2:0] divisor_i;
   reg [N-1:0] 	 quotient_i;
   

   wire [N-1:0] dividend_o;
   wire [2*N-2:0] divisor_o;
   wire [N-1:0]   quotient_o;
   
   div_slice #(.N(N)) uut (
		      .clk(clk),
		       
		      .dividend_i(dividend_i),
		      .divisor_i(divisor_i),
		      .quotient_i(quotient_i),

		      .dividend_o(dividend_o),
		      .divisor_o(divisor_o),
		      .quotient_o(quotient_o)
		      );
   

   initial begin
      $dumpfile("div.vcd");
      $dumpvars();      

      clk = 0;

      divisor_i = 3 << (N-1);
      dividend_i = 10;
      quotient_i = 0;
      
      #(3*clk_period) $finish;
      
   end

   always 
     #(clk_period/2) clk = ~clk;        

endmodule // div_tb

     