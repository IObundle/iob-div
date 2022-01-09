`timescale 1ns / 1ps

module div_subshift_frac_tb;

   parameter clk_frequency = `CLK_FREQ;
   parameter clk_period = 1e9/clk_frequency; //ns
   parameter DATA_W = 56; //data gen is limited to 31 bits
   parameter TEST_SZ = 11;
   localparam LEN = 100000;

   reg clk;
   reg en;
   wire done;

   //data
   reg [DATA_W-1:0]  dividend [0:TEST_SZ-1];
   reg [DATA_W-1:0]  divisor [0:TEST_SZ-1];
   reg [DATA_W-1:0]        quotient [0:TEST_SZ-1];
   reg [DATA_W-1:0]        remainder [0:TEST_SZ-1];

   //core outputs
   wire [DATA_W-1:0]        quotient_out;
   wire [DATA_W-1:0]        remainder_out;
   
   integer           i;
   real              qacc = 0;
   
 
   initial begin

`ifdef VCD
      $dumpfile("div.vcd");
      $dumpvars();
`endif

      clk = 1;
      en = 0;

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
//	 dividend[i] = $random;
//	 divisor[i] = $random;
	 dividend[i] = 1<<46;
	 divisor[i] = 1<<22;
	 quotient[i] = dividend[i] / divisor[i];
	 remainder[i] = dividend[i] % divisor[i];
      end
      
      
      //copmpute divisions
      for (i=0; i < TEST_SZ; i=i+1) begin
         @(posedge clk) #1 en = 1;
         @(posedge done) #1;

         qacc = 0;
         
         repeat(LEN) begin
            qacc = qacc + quotient_out;

            @(posedge clk) #1;
         end
         
         $display ("%d / %d = %f and got %f", dividend[i], divisor[i], 1.0*dividend[i]/divisor[i] , qacc/LEN);

         @(posedge clk) #1 en=0;
      end

      $finish;

   end

   //clock
   always #(clk_period/2) clk = ~clk;   

   //instantiate divider
   div_subshift_frac
     # (
        .DATA_W(DATA_W)
        )
   uut 
     (
      .clk(clk),
      .en(en),
      .done(done),
      .dividend(dividend[i]),
      .divisor(divisor[i]),
      .quotient(quotient_out),
      .remainder(remainder_out)
      );

endmodule
