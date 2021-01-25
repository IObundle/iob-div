`timescale 1ns / 1ps

module div_serial_tb;

   parameter clk_frequency = `CLK_FREQ;
   parameter clk_period = 1e9/clk_frequency; //ns

   parameter DATA_W = 32;

   parameter TEST_SZ = 100;

   reg clk;
   reg rst;

   reg start;
   wire done;

   wire [DATA_W-1:0] dividend;
   wire [DATA_W-1:0] divisor;
   wire [DATA_W-1:0] quotient;
   wire [DATA_W-1:0] remainder;

   wire [DATA_W-1:0] q;
   wire [DATA_W-1:0] r;

   reg [DATA_W-1:0]  dividend_in [0:TEST_SZ-1];
   reg [DATA_W-1:0]  divisor_in [0:TEST_SZ-1];
   reg [DATA_W-1:0]  quotient_out [0:TEST_SZ-1];
   reg [DATA_W-1:0]  remainder_out [0:TEST_SZ-1];

   integer           i, j;

   div_serial # (
                 .DATA_W(DATA_W)
                 )
   uut (
		.clk(clk),
        .rst(rst),

        .start(start),
        .done(done),
	.sign(1'b0),
		.dividend(dividend),
		.divisor(divisor),

		.quotient(quotient),
		.remainder(remainder)
		);

   initial begin

`ifdef VCD
      $dumpfile("div_serial.vcd");
      $dumpvars();
`endif

      // Global reset of FPGA
      #100;

      clk = 1;
      rst = 0;

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
	     dividend_in[i] = $random%(2**(DATA_W-1));
	     divisor_in[i] = $random%(2**(DATA_W-1));
	     quotient_out[i] = dividend_in[i] / divisor_in[i];
	     remainder_out[i] = dividend_in[i] % divisor_in[i];
      end

      // Global reset
      #(clk_period+1);
      rst = 1;

      #clk_period;
      rst = 0;

      #(TEST_SZ*(DATA_W+2)*clk_period);

      $display("Test completed successfully");
      $finish;
   end

   always 
     #(clk_period/2) clk = ~clk;   

   always @ (posedge clk) begin
      if (rst) begin
         start <= 0;
      end else if (done & ~start) begin
         start <= 1;
      end else begin
         start <= 0;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         j <= 0;
      end else if (start) begin
         j <= j+1;
      end
   end

   // assign inputs
   assign dividend = dividend_in[j];
   assign divisor = divisor_in[j];

   // show expected results
   assign q = quotient_out[j];
   assign r = remainder_out[j];

   always @ (posedge clk) begin
      if(done && ~start && j > 0 && (quotient != quotient_out[j-1] ||
                                     remainder != remainder_out[j-1])) begin
	     $display("Test failed at %d", $time);
	     $finish;
      end
   end

endmodule
