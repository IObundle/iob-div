`timescale 1ns / 1ps

module div #( parameter N = 32 )(
		  input 	 clk,
		  
		  input [N-1:0]  dividend,
		  input [N-1:0]  divisor,

		  output [N-1:0] quotient,
		  output [N-1:0] remainder
		  );

   wire [(N+1)*N-1:0]		    dividend_int;
   wire [(N+1)*N-1:0]		    divisor_int;
   wire [(N+1)*N-1:0]		    quotient_int;

   assign dividend_int[N-1: 0] = dividend;
   assign divisor_int[N-1: 0] = divisor;
   assign quotient_int[N-1: 0] = {N{1'b0}};

   genvar 			    k;
   generate
      for(k=1; k<=N; k=k+1) begin : div_slice_array_el
	 div_slice #(.N(N), .S(k)) uut (
					.clk(clk),
		       
					.dividend_i(dividend_int[k*N-1-:N]),
					.divisor_i(divisor_int[k*N-1-:N]),
					.quotient_i(quotient_int[k*N-1-:N]),

					.dividend_o(dividend_int[(k+1)*N-1-:N]),
					.divisor_o(divisor_int[(k+1)*N-1-:N]),
					.quotient_o(quotient_int[(k+1)*N-1-:N])
					);
 
      end
   endgenerate
   
   assign quotient = quotient_int[(N+1)*N-1-:N];
   assign remainder = dividend_int[(N+1)*N-1-:N];
   
  
endmodule // div_slice

     