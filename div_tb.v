`timescale 1ns / 1ps

module div_tb;

   parameter DATA_W = 32;
   parameter TEST_SZ = 100;
   parameter clk_period =20;

   reg clk;

   wire [DATA_W-1:0] dividend;
   wire [DATA_W-1:0] divisor;
   wire [DATA_W-1:0] quotient;
   wire [DATA_W-1:0] remainder;

   wire [DATA_W-1:0] q;
   wire [DATA_W-1:0] r;

   reg [DATA_W-1:0]  dividend_in [0:TEST_SZ-1];
   reg [DATA_W-1:0]  divisor_in [0:TEST_SZ-1];
   reg [DATA_W-1:0]  quotient_out [0:TEST_SZ-1];
   reg [DATA_W-1:0]  remainder_out [0:TEST_SZ-1];

   integer           i, j;

   div # (
          .DATA_W(DATA_W),
          .OPERS_PER_STAGE(8)
          )
   uut (
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

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
	     dividend_in[i] = $random%(2**DATA_W);
	     divisor_in[i] = $random%(2**DATA_W);
	     quotient_out[i] = dividend_in[i] / divisor_in[i];
	     remainder_out[i] = dividend_in[i] % divisor_in[i];
      end

      clk = 0;

      #(TEST_SZ*clk_period)

      $display("Test completed successfully");
      $finish;
   end

   always 
     #(clk_period/2) clk = ~clk;   

   always @ (posedge clk) begin
      j <= j+1;
   end

   // assign inputs
   assign dividend = dividend_in[j];
   assign divisor = divisor_in[j];

   // show expected results
   assign q = quotient_out[j];
   assign r = remainder_out[j];

   always @ (negedge clk) begin
      if(j >= DATA_W && (quotient != quotient_out[j-DATA_W] ||
                         remainder != remainder_out[j-DATA_W])) begin
	     $display("Test failed at %d", $time);
	     $finish;
      end
   end

endmodule
