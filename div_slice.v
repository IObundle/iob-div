module div_slice (
		  input 	       clk,
		  
		  input [N-1:0]        dividend_i,
		  input [2*N-2:0]      divisor_i,
		  input [N-1:0]        quotient_i,

		  output reg [N-1:0]   dividend_o,
		  output reg [2*N-2:0] divisor_o,
		  output reg [N-1:0]   quotient_o
		  );

   parameter N = 8;
   
   wire 			    sub_sign;
   wire [2*N-2:0] 		    sub_res;

   assign sub_res = {{(N-1){1'b0}},dividend_i} - divisor_i;
   assign sub_sign = sub_res[2*N-2];

   always @ (posedge clk) begin
      dividend_o <= (sub_sign == 1)? dividend_i: sub_res;
      quotient_o <= (quotient_i << 1) | {{(N-1){1'b0}},~sub_sign};
      divisor_o <= divisor_i >> 1;   
   end

  
endmodule // div_slice

     