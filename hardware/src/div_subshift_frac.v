`timescale 1ns / 1ps

module div_subshift_frac
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

   reg [DATA_W-1:0]   divisor_reg;
   always @(posedge clk, posedge rst) 
     if(rst) 
       divisor_reg <= 1'b0;
     else 
       divisor_reg <= divisor;
   
   //output quotient
   wire [DATA_W-1:0]  quotient_int;
   reg                incr; //residue   
   assign quotient =  quotient_int + incr;

   div_subshift
     # (
        .DATA_W(DATA_W)
        )
   div_subshift0
     (
      .clk(clk),
      .rst(rst),
      .start(start),
      .done(done),
      
      .dividend(dividend),
      .divisor(divisor),
      .quotient(quotient_int),
      .remainder(remainder)
      );

   //residue accum
   reg [DATA_W:0]     res_acc, res_acc_nxt;
   reg res_acc_en;
                
   always @(posedge clk, posedge rst)
     if(rst)
       res_acc <= 1'b0;
     else if (res_acc_en)
       res_acc <= res_acc_nxt;
   
   //pc register
   reg [1:0] pc, pc_nxt;
   always @(posedge clk, posedge rst)
     if(rst)
       pc <= 1'b0;
     else
       pc <= pc_nxt;
   
   always @* begin
      incr=1'b0;
      res_acc_nxt = res_acc + remainder;
      res_acc_en = 1'b0;
      pc_nxt = pc+1'b1;
      
      case (pc)
        0: begin //wait for div start
           if(!start)
             pc_nxt = pc;
        end

        1: begin //wait for div done
           if(!done)
             pc_nxt = pc;
        end
        
        default: begin
           res_acc_en = 1'b1;
           if(res_acc_nxt >= divisor) begin
              incr = 1'b1;
              res_acc_nxt = res_acc + remainder - divisor;
           end
           if(!start)
             pc_nxt = pc;
           else
             pc_nxt = 1'b1;
        end
      endcase // case (pc)
      
   end

   
endmodule
