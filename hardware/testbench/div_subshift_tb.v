`timescale 1ns / 1ps

module div_subshift_tb;

   parameter clk_frequency = `CLK_FREQ;
   parameter clk_period = 1e9/clk_frequency; //ns
   parameter DATA_W = 32;
   parameter TEST_SZ = 5;

   reg clk;
   reg en;
   reg sign;
   wire done;

   //data
   reg [DATA_W-1:0]  dividend [0:TEST_SZ-1];
   reg [DATA_W-1:0]  divisor [0:TEST_SZ-1];
   reg [DATA_W-1:0]  quotient [0:TEST_SZ-1];
   reg [DATA_W-1:0]  remainder [0:TEST_SZ-1];


   //outputs
   wire [DATA_W-1:0]  quotient_out;
   wire [DATA_W-1:0]  remainder_out;

   
   integer           i;

 
   initial begin

`ifdef VCD
      $dumpfile("div_serial.vcd");
      $dumpvars();
`endif

      clk = 1;
      en = 0;

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
	     dividend[i] = $random%(2**(DATA_W-1));
	     divisor[i] = $random%(2**(DATA_W-1));
	     quotient[i] = dividend[i] / divisor[i];
	     remainder[i] = dividend[i] % divisor[i];
      end

      for (i=0; i < TEST_SZ; i=i+1) begin
         @(posedge clk) #1 en = 1;
         @(posedge done) #1;
         if(quotient_out != quotient[i] || remainder_out != remainder[i])
           $display ("%d / %d = %d with rem %d but got %d with rem %d", dividend[i], divisor[i], quotient[i], remainder[i], quotient_out, remainder_out);
         @(posedge clk) #1 en = 0;
      end      

      $finish;
   end

   //clock
   always #(clk_period/2) clk = ~clk;   

  div_subshift 
    # (
       .DATA_W(DATA_W)
       )
   uut (
	.clk(clk),
        .en(en),
        .done(done),
	.sign(sign),
	.dividend(dividend[i]),
	.divisor(divisor[i]),
	.quotient(quotient_out),
	.remainder(remainder_out)
	);

   
endmodule
