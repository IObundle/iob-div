`timescale 1ns / 1ps

module div_subshift_frac
  # (
     parameter DATA_W = 32
     )
   (
    input               clk,
    input               rst,
    input               en,
    output reg          done,

    input [DATA_W-1:0]  dividend,
    input [DATA_W-1:0]  divisor,
    output [DATA_W-1:0] quotient,
    output [DATA_W-1:0] remainder
    );

   reg [2*DATA_W:0]     rq;
   reg [DATA_W-1:0] 	divisor_reg;
   reg [$clog2(DATA_W+5):0] pc;  //program counter
   wire [DATA_W-1:0] 	    subtraend = rq[2*DATA_W-2-:DATA_W];
   reg [DATA_W:0]           tmp;

   wire               q_valid; //residue
   
   //output quotient and remainder
   assign quotient = rq[DATA_W-1:0] + q_valid;
   assign remainder = rq[2*DATA_W-1:DATA_W];

   
   //
   //PROGRAM
   //
   
   always @(posedge clk, posedge rst) begin
      if(rst) begin
         pc <= 1'b0;
         rq <= 1'b0;
         done <= 1'b0;
      end else if(en) begin
         pc <= pc+1'b1;
         
         case (pc)
	   0: begin //load operands
              divisor_reg <= divisor;
              rq[DATA_W-1:0] <= dividend;
	   end // case: 0

	   DATA_W+1: begin  //finish 
 	      done <= 1'b1;
              pc <= pc;
	   end
	   
	   default: begin //shift and subtract
	      tmp = {1'b0, subtraend} - {1'b0, divisor_reg};
              if(~tmp[DATA_W])
                rq <= {tmp, rq[DATA_W-2 : 0], 1'b1};
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


   //instantiate frac divider
   div_frac
     # (
        .DATA_W(DATA_W)
        )
   div_frac0 
     (
      .clk(clk),
      .rst(~done),
      .ready(),
      
      .dividend(divisor_reg),
      .divisor(remainder),
      .quotient(),
      .valid(q_valid)
      );

   
endmodule
