`timescale 1ns / 1ps

module div # (
              parameter DATA_W = 32,
              parameter OPERS_PER_STAGE = 8
              )
   (
	input               clk,

	input [DATA_W-1:0]  dividend,
	input [DATA_W-1:0]  divisor,

	output [DATA_W-1:0] quotient,
	output [DATA_W-1:0] remainder
	);

   wire [(DATA_W+1)*DATA_W-1:0] dividend_int;
   wire [(DATA_W+1)*DATA_W-1:0] divisor_int;
   wire [(DATA_W+1)*DATA_W-1:0] quotient_int;

   assign dividend_int[DATA_W-1:0] = dividend;
   assign divisor_int[DATA_W-1:0]  = divisor;
   assign quotient_int[DATA_W-1:0] = {DATA_W{1'b0}};

   genvar                       k;
   generate
      for(k=1; k <= DATA_W; k=k+1) begin : div_slice_array_el
	     div_slice # (
                      .DATA_W(DATA_W),
                      .STAGE(k),
                      .OUTPUT_REG(!(k%OPERS_PER_STAGE))
                      )
         uut (
			  .clk(clk),

			  .dividend_i(dividend_int[k*DATA_W-1-:DATA_W]),
			  .divisor_i(divisor_int[k*DATA_W-1-:DATA_W]),
			  .quotient_i(quotient_int[k*DATA_W-1-:DATA_W]),

			  .dividend_o(dividend_int[(k+1)*DATA_W-1-:DATA_W]),
			  .divisor_o(divisor_int[(k+1)*DATA_W-1-:DATA_W]),
			  .quotient_o(quotient_int[(k+1)*DATA_W-1-:DATA_W])
			  );
      end
   endgenerate

   assign quotient = quotient_int[(DATA_W+1)*DATA_W-1-:DATA_W];
   assign remainder = dividend_int[(DATA_W+1)*DATA_W-1-:DATA_W];

endmodule
