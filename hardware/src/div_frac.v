`timescale 1ns / 1ps

module div_frac
  # (
     parameter DATA_W = 32
     )
   (
    input                      clk,
    input                      rst,
    output reg                 ready,

    input [DATA_W-1:0]  dividend,
    input [DATA_W-1:0]  divisor,
    output [DATA_W-1:0] quotient,
    output reg valid
   );

   reg [DATA_W-1:0]      divisor_cnt;
   reg  [DATA_W:0] level;
   reg [DATA_W-1:0]      quotient_int;
                   
   assign quotient = quotient_int;
   
   always @(posedge clk, posedge rst) begin
      if(rst) begin
         divisor_cnt <= 1'b1;
         level <= 1'b1;
         quotient_int <= 1'b0;
         ready <= 1'b0;
         valid <= 1'b0;
      end else begin
         divisor_cnt <= divisor_cnt + 1'b1;
         level <= level + divisor;
         valid <= 1'b0;
         if( (level+divisor) > dividend) begin
            ready <= 1'b1;
            divisor_cnt <= 1'b1;
            level <= level + divisor - dividend;
            quotient_int <= divisor_cnt;
            valid <= 1'b1;
         end 
      end // else: !if(rst)
   end // always @ (posedge clk, posedge rst)
   

endmodule
