`timescale 1ns / 1ps

module div_subshift 
  # (
     parameter DATA_W = 32
     )
   (
    input               clk,
    
    input               en,
    input               sign,
    output reg          done,

    input [DATA_W-1:0]  dividend,
    input [DATA_W-1:0]  divisor,
    output [DATA_W-1:0] quotient,
    output [DATA_W-1:0] remainder
    );

   reg [2*DATA_W-1:0]   rq;
   reg [DATA_W-1:0]     divisor_reg;
   reg                  sign_reg;
   reg [$clog2(DATA_W+2):0] pc;  //program counter
   wire [DATA_W-1:0]        subtraend = rq[2*DATA_W-2-:DATA_W];

   //output quotient and remainder
   assign quotient = rq[DATA_W-1:0];
   assign remainder = rq[2*DATA_W-1:DATA_W];

   //
   //PROGRAM
   //
   
   always @(posedge clk) begin
      if(en) begin
         pc <= pc+1'b1;
         
         case (pc)
	   0: begin //load operands and result sign
              if(sign) begin
                 divisor_reg <= divisor[DATA_W-1]? -divisor: divisor;
                 rq[DATA_W-1:0] <= dividend[DATA_W-1]? -dividend: dividend;
                 sign_reg <= dividend[DATA_W-1] ^ divisor[DATA_W-1];
              end else begin
                 divisor_reg <= divisor;
                 rq[DATA_W-1:0] <= dividend;
                 sign_reg <= 1'b0;
              end
	   end

	   DATA_W: begin  //apply sign
              done <= 1'b1;
              if( subtraend >=  divisor_reg ) begin
                 if(sign_reg)
                   rq <= {-(subtraend-divisor_reg), -{rq[DATA_W-2 : 0], 1'b1}};
                 else
                   rq <= {subtraend-divisor_reg, rq[DATA_W-2 : 0], 1'b1};
              end else begin
                 if(sign_reg)
                   rq <= -{rq[2*DATA_W-2 : 0], 1'b0};
                 else
                   rq <= {rq[2*DATA_W-2 : 0], 1'b0};
              end
	   end

	   DATA_W+1: pc <= pc;  //finish

	   default: begin //shift and subtract
              if( subtraend >=  divisor_reg )
                rq <= {subtraend-divisor_reg, rq[DATA_W-2 : 0], 1'b1};
              else 
                rq <= {rq[2*DATA_W-2 : 0], 1'b0};
           end
         endcase // case (pc)
         
      end else begin // if (en)
         rq <= 1'b0;
         done <= 1'b0;
         pc <= 1'b0;
      end
   end // always @ *

endmodule
