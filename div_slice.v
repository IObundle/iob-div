`timescale 1ns / 1ps

module div_slice (
		  input 	     clk,
		  
		  input [N-1:0]      dividend_i,
		  input [N-1:0]      divisor_i,
		  input [N-1:0]      quotient_i,

		  output reg [N-1:0] dividend_o,
		  output reg [N-1:0] divisor_o,
		  output reg [N-1:0] quotient_o
		  );

   parameter N = 8; //data width 
   parameter S = 1; //pipeline stage
   
   wire 			    sub_sign;
   wire [2*N-S:0] 		    sub_res;

   assign sub_res = {1'b0,{(N-S){1'b0}},dividend_i} - {1'b0,divisor_i,{(N-S){1'b0}}};
   assign sub_sign = sub_res[2*N-S];

   always @ (posedge clk) begin
      dividend_o <= (sub_sign == 1)? dividend_i: sub_res[2*N-S-1-:N];
      quotient_o <= quotient_i << 1 | {{(N-1){1'b0}},~sub_sign};
      divisor_o <= divisor_i;   
   end

  
endmodule // div_slice

     