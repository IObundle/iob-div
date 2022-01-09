`timescale 1ns / 1ps

module div_subshift
  # (
     parameter DATA_W = 32
     )
   (
    input               clk,
    input               rst,
    input               start,
    output              done,

    input [DATA_W-1:0]  dividend,
    input [DATA_W-1:0]  divisor,
    output [DATA_W-1:0] quotient,
    output [DATA_W-1:0] remainder
    );

   //dividend/quotient/remainder register
   reg [2*DATA_W:0]     dqr_reg, dqr_nxt;
   always @(posedge clk, posedge rst) if(rst) dqr_reg <= 1'b1; else dqr_reg <= dqr_nxt;

   //divisor register
   reg [DATA_W-1:0]     divisor_reg, divisor_nxt;
   always @(posedge clk, posedge rst) if(rst) divisor_reg <= 1'b1; else divisor_reg <= divisor_nxt;
   
   wire [DATA_W-1:0]    subtraend = dqr_reg[2*DATA_W-2-:DATA_W];
   reg [DATA_W:0]       tmp;

   //output quotient and remainder
   assign quotient = dqr_reg[DATA_W-1:0];
   assign remainder = dqr_reg[2*DATA_W-1:DATA_W];

   //done register
   reg                  done_reg, done_nxt;
   always @(posedge clk, posedge rst) if(rst) done_reg <= 1'b1; else done_reg <= done_nxt;
   assign done = done_reg;
   
                        
   //
   //PROGRAM
   //

   reg [$clog2(DATA_W+1):0] pc, pc_nxt;  //program counter
   always @(posedge clk, posedge rst) if(rst) pc <= 1'b0; else pc <= pc_nxt;

   always @* begin
      pc_nxt = pc+1'b1;
      dqr_nxt = dqr_reg;
      done_nxt = done_reg;
      divisor_nxt = divisor;
      
      case (pc)
	0: begin //wait for start, load operands and deassert done
           divisor_nxt = 1'b0;
           dqr_nxt = 1'b0;
           if(!start) begin
              pc_nxt = pc;
           end else begin
              done_nxt = 1'b0;
              divisor_nxt = divisor;
              dqr_nxt[DATA_W-1:0] = dividend;
	   end
        end
	   
	default: begin //shift and subtract
	   tmp = {1'b0, subtraend} - {1'b0, divisor_reg};
           if(~tmp[DATA_W])
             dqr_nxt = {tmp, dqr_reg[DATA_W-2 : 0], 1'b1};
           else 
             dqr_nxt = {dqr_reg[2*DATA_W-2 : 0], 1'b0};

           if(pc == DATA_W) begin
              done_nxt = 1'b1;
              pc_nxt = 1'b0;
           end
        end
      endcase // case (pc)
   end
   
endmodule
