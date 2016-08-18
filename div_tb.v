`timescale 1ns / 1ps

module div_tb;
   
   parameter N = 8;

   parameter clk_period =20;
   
   
   reg clk;
   
   reg [N-1:0] dividend;  
   reg [N-1:0] divisor;
   wire [N-1:0] quotient;
   wire [N-1:0] remainder;
   
   div #(.N(N)) uut (
		     .clk(clk),
		     
		     .dividend(dividend),
		     .divisor(divisor),

		     .quotient(quotient),
		     .remainder(remainder)
		     );
   

   initial begin
      $dumpfile("div.vcd");
      $dumpvars();      

      clk = 0;

      dividend = 10;
      divisor = 3;
      
      #(40*clk_period) $finish;
      
   end

   always 
     #(clk_period/2) clk = ~clk;        

endmodule // div_tb

     