`timescale 1ns / 1ps

module div_tb;
   
   parameter N = 32; //data width

   parameter M = 100; //test size
   

   parameter clk_period =20;
   
   
   reg clk;
   
   wire [N-1:0] dividend;  
   wire [N-1:0] divisor;
   wire [N-1:0] quotient;
   wire [N-1:0] remainder;

   wire [N-1:0] q;
   wire [N-1:0] r;

   reg [N-1:0] dividend_in [0:M-1];
   reg [N-1:0] divisor_in [0:M-1];
   reg [N-1:0] quotient_out [0:M-1];
   reg [N-1:0] remainder_out [0:M-1];

   integer     i, j;
   
   
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

      j=0;
      

      //generate test data
      for (i=0; i<M; i=i+1) begin
	 dividend_in[i] = $random%(2**N);
	 divisor_in[i] = $random%(2**N);
	 quotient_out[i] = dividend_in[i] / divisor_in[i];
	 remainder_out[i] = dividend_in[i] % divisor_in[i];
      end

      clk = 0;

      #(M*clk_period) 

      //check results

      

      $finish;
      
   end

   always 
     #(clk_period/2) clk = ~clk;   

   
   always @ (posedge clk) begin
      j <= j+1;
   end

   //assign inputs
   assign dividend = dividend_in[j];
   assign divisor = divisor_in[j];

   //show expected results
   assign q = quotient_out[j];
   assign r = remainder_out[j];
       
   always @ (negedge clk) begin
      if(j >=N && (quotient != quotient_out[j-N] || remainder != remainder_out[j-N])) begin
	 $display("Test failed at %d", $time);
	 $finish;	 
      end
   end


endmodule // div_tb

     
