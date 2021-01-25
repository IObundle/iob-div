`timescale 1ns / 1ps

module div_serial # (
                     parameter DATA_W = 32
                     )
   (
    input 		clk,
    input 		rst,
    input 		sign,
    
    input 		start,
    output 		done,

    input [DATA_W-1:0] 	dividend,
    input [DATA_W-1:0] 	divisor,
    output [DATA_W-1:0] quotient,
    output [DATA_W-1:0] remainder
    );

   reg [$clog2(DATA_W):0]   counter;
   reg 			    div_done;
   wire                     en = (counter != DATA_W)? 1'b1: 1'b0;

   assign done = div_done;

   //quotient sign register
   reg 			    quot_sign;
   always @ (posedge clk)
     if(start)
       quot_sign <= sign ? dividend[DATA_W-1]^divisor[DATA_W-1] : 1'b0;
   
   always @ (posedge clk) begin
      if (rst) begin
         counter <= DATA_W;
      end else if (start) begin
         counter <= 0;
      end else if (en) begin
         counter <= counter + 1'b1;
      end
   end

   //auxiliary signals
   reg [DATA_W-1:0] 	  dividend_nxt;
   reg [DATA_W-1:0] 	  divisor_nxt;
   reg [DATA_W-1:0] 	  quotient_nxt;
   reg [DATA_W-1:0] 	  remainder_nxt;
   
   reg [DATA_W-1:0] 	  dividend_reg;
   reg [DATA_W-1:0] 	  divisor_reg;
   reg [DATA_W-1:0] 	  quotient_reg;
   reg [DATA_W-1:0] 	  remainder_reg;
   
   reg 			  div_done_nxt;
   
   wire [DATA_W-1:0] 	  tmp = remainder_reg<<1 | dividend_reg[DATA_W-counter-1];
   wire 		  cmp = (tmp >= divisor_reg)? 1'b1 : 1'b0;
   
   //program counter register
   reg [1:0] 		  pc, pc_nxt;
   
   //
   //PROGRAM
   //

   always @ (posedge clk)
     if (rst)
       pc <= 1'b0;
     else
       pc <= pc_nxt;

   always @* begin
      pc_nxt = pc+1'b1;
      
      dividend_nxt = dividend_reg;
      divisor_nxt = divisor_reg;
      
      quotient_nxt = quotient_reg;
      remainder_nxt = remainder_reg;
      
      div_done_nxt = div_done;
      
      case (pc)
	 0: begin //wait for start, register operands
	    if(start) begin
	       //invert dividend and divisor if signed
	       dividend_nxt = dividend;
	       divisor_nxt = divisor;
	       
	       if (sign && dividend[DATA_W-1])
		 dividend_nxt = -dividend;
	       
	       if (sign && divisor[DATA_W-1])
		 divisor_nxt = -divisor;
	       
	       quotient_nxt = 0;
	       remainder_nxt = 0;
	       
	       div_done_nxt = 1'b0;
	    end
	    else
	      pc_nxt = pc;
	 end // case: 0
	
	1: begin //perform division
	   if (en) begin
              quotient_nxt =  quotient_reg << 1 | cmp;
              remainder_nxt = cmp? tmp-divisor_reg: tmp;	    
	      pc_nxt = pc;
	   end
	end

	2: begin //add sign to quotient and activate done signal
	   quotient_nxt = quot_sign ? -quotient_reg : quotient_reg;
	   div_done_nxt = 1'b1;
	end
	
	default:;
      endcase // case (pc)
   end // always @ *
   
   always @ (posedge clk) begin
      dividend_reg <= dividend_nxt;
      divisor_reg <= divisor_nxt;
      quotient_reg <= quotient_nxt;
      remainder_reg <= remainder_nxt;
   end // always @ (posedge clk)
   
   always @ (posedge clk)
     if (rst)
       div_done <= 1'b1;
     else
       div_done <= div_done_nxt;
   
   assign quotient = quotient_reg;
   assign remainder = remainder_reg;

endmodule
