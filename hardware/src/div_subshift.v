`timescale 1ns / 1ps

module div_subshift
  # (
     parameter DATA_W = 32
     )
   (
    input               clk,
    input               rst,
    input               start,
    output reg          done,

    input [DATA_W-1:0]  dividend,
    input [DATA_W-1:0]  divisor,
    output [DATA_W-1:0] quotient,
    output [DATA_W-1:0] remainder
    );

   reg [2*DATA_W:0]     rq;
   reg [DATA_W-1:0]     divisor_reg;
   wire [DATA_W-1:0] subtraend = rq[2*DATA_W-2-:DATA_W];
   reg [DATA_W:0]           tmp;

   //output quotient and remainder
   assign quotient = rq[DATA_W-1:0];
   assign remainder = rq[2*DATA_W-1:DATA_W];


   reg [$clog2(DATA_W+5):0] pc;  //program counter

   //
   //PROGRAM
   //
   
   always @(posedge clk, posedge rst) begin
      if(rst) begin
         pc <= 1'b0;
         rq <= 1'b0;
         done <= 1'b1;
         divisor_reg <= 1'b0;
     end else begin
         pc <= pc+1'b1;
         
         case (pc)
	   0: begin //wait start
              divisor_reg <= 1'b0;
              rq <= 1'b0;
              if(!start) begin
                 pc <= pc;
                 done <= 1'b0;
              end
	   end // case: 0

           1:  begin //load operands
              divisor_reg <= divisor;
              rq[DATA_W-1:0] <= dividend;
           end
           
	   DATA_W+2: begin  //finish 
 	      done <= 1'b1;
              pc <= 1'b0;
	   end
	   
	   default: begin //shift and subtract
	      tmp = {1'b0, subtraend} - {1'b0, divisor_reg};
              if(~tmp[DATA_W])
                rq <= {tmp, rq[DATA_W-2 : 0], 1'b1};
              else 
                rq <= {rq[2*DATA_W-2 : 0], 1'b0};
           end
         endcase // case (pc)
      end
   end // always @ *
   
endmodule
