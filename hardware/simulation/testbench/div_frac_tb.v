`timescale 1ns / 1ps

module div_frac_tb;

   localparam clk_frequency = `CLK_FREQ;
   localparam clk_period = 1e9/clk_frequency; //ns
   localparam DATA_W = 24; //data gen is limited to 31 bits
   localparam TEST_SZ = 1;
   localparam LEN = 100000;
                       

   reg clk;
   reg rst;
   wire ready;

   //data
   reg [DATA_W-1:0] dividend [0:TEST_SZ-1];
   reg [DATA_W-1:0] divisor [0:TEST_SZ-1];

   //core outputs
   wire [DATA_W-1:0]        quotient_out;
   wire                     quotient_valid;
   
   integer           i;
   real              qacc = 0;
   integer           qcnt = 0;
   
 
   initial begin

`ifdef VCD
      $dumpfile("div.vcd");
      $dumpvars();
`endif

      rst = 0;
      clk = 1;

      #4 rst = 1;
      @(posedge clk) #1 rst = 0;

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
	 //dividend[i] = $random;
	 //divisor[i] = $random;
	 dividend[i] = 48000;
	 divisor[i] = 44100;
      end

      //compute divisions
      for (i=0; i < TEST_SZ; i=i+1) begin
         @(posedge ready) #1;
         
         repeat(LEN) begin
            if(quotient_valid) begin
               qacc = qacc + quotient_out;
               qcnt = qcnt + 1;
            end
            @(posedge clk) #1;
         end

         $display ("%d / %d = %f and got %f", dividend[i], divisor[i], 1.0*dividend[i]/divisor[i] , qacc/qcnt);
         
         //reset module
         rst = 1;
         @(posedge clk) #1 rst = 0;

      end

      $finish;

   end

   //clock
   always #(clk_period/2) clk = ~clk;   

   //instantiate frac divider
   div_frac
     # (
        .DATA_W(DATA_W)
        )
   uut 
     (
      .clk(clk),
      .rst(rst),
      .ready(ready),
      
      .dividend(dividend[i]),
      .divisor(divisor[i]),
      .quotient(quotient_out),
      .valid(quotient_valid)
      );

endmodule
