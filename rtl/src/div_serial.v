`timescale 1ns / 1ps

module div_serial # (
                     parameter DATA_W = 32
                     )
   (
    input                   clk,
    input                   rst,

    input                   start,
    output                  done,

    input [DATA_W-1:0]      dividend,
    input [DATA_W-1:0]      divisor,
    output reg [DATA_W-1:0] quotient,
    output reg [DATA_W-1:0] remainder
    );

   reg [$clog2(DATA_W):0]   counter;
   wire                     en = (counter != DATA_W)? 1'b1: 1'b0;

   assign done = ~en;

   always @ (posedge clk) begin
      if (rst) begin
         counter <= DATA_W;
      end else if (start) begin
         counter <= 0;
      end else if (en) begin
         counter <= counter + 1'b1;
      end
   end

   reg [DATA_W-1:0] dividend_reg;
   reg [DATA_W-1:0] divisor_reg;

   always @ (posedge clk) begin
      if (start) begin
         dividend_reg <= dividend;
         divisor_reg <= divisor;
      end
   end

   wire [DATA_W-1:0]        tmp = remainder<<1 | dividend_reg[DATA_W-counter-1];

   always @ (posedge clk) begin
      if (start) begin
         quotient <= 0;
         remainder <= 0;
      end else if (en) begin 
         quotient <= quotient << 1 | ( tmp > divisor_reg);
         remainder <= tmp > divisor_reg? tmp-divisor_reg: tmp;
      end
   end

endmodule
