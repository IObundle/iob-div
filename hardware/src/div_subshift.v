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

   //dividend/quotient/remainder register
   reg [2*DATA_W:0]     dqr_reg, dqr_nxt;
   always @(posedge clk, posedge rst) if(rst) dqr_reg <= 1'b0; else dqr_reg <= dqr_nxt;

   //divisor register
   reg [DATA_W-1:0]     divisor_reg, divisor_nxt;
   always @(posedge clk, posedge rst) if(rst) divisor_reg <= 1'b0; else divisor_reg <= divisor_nxt;
   
   wire [DATA_W-1:0]    subtraend = dqr_reg[2*DATA_W-2-:DATA_W];
   reg [DATA_W:0]       tmp;

   //output quotient and remainder
   assign quotient = dqr_reg[DATA_W-1:0];
   assign remainder = dqr_reg[2*DATA_W-1:DATA_W];
   
                        
   //
   //PROGRAM
   //

   reg [$clog2(DATA_W+2):0] pc, pc_nxt;  //program counter
   always @(posedge clk, posedge rst) if(rst) pc <= 1'b0; else pc <= pc_nxt;

   always @* begin
      pc_nxt = pc+1'b1;
      dqr_nxt = dqr_reg;
      divisor_nxt = divisor;
      done = 1'b1;
      
      case (pc)
	0: begin //wait for start, load operands and do it
           if(!start) begin
              pc_nxt = pc;
           end else begin
              divisor_nxt = divisor;
              dqr_nxt = {{DATA_W{1'b0}}, dividend};
	   end
        end
	
        DATA_W+1: begin
           pc_nxt = 1'b0;
        end
	
        default: begin //shift and subtract
           done = 1'b0;
	   tmp = {1'b0, subtraend} - {1'b0, divisor_reg};
           if(~tmp[DATA_W])
             dqr_nxt = {tmp, dqr_reg[DATA_W-2 : 0], 1'b1};
           else 
             dqr_nxt = {dqr_reg[2*DATA_W-2 : 0], 1'b0};
        end
      endcase // case (pc)
   end
   
endmodule
