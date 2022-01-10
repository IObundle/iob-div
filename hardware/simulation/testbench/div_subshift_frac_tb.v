`timescale 1ns / 1ps

module div_subshift_frac_tb;

   parameter clk_frequency = `CLK_FREQ;
   parameter clk_period = 1e9/clk_frequency; //ns
   parameter DATA_W = 8;
   parameter TEST_SZ = 100;

   reg clk = 0;
   reg rst = 0;
   reg start = 0;
   wire done;

   //data
   reg [DATA_W-1:0]  dividend [0:TEST_SZ-1];
   reg [DATA_W-1:0]  divisor [0:TEST_SZ-1];
   reg [DATA_W-1:0]  quotient [0:TEST_SZ-1];
   reg [DATA_W-1:0]  remainder [0:TEST_SZ-1];

   //core outputs
   wire [DATA_W-1:0]        quotient_out;
   wire [DATA_W-1:0]        remainder_out;
   
   integer           i;
 
   initial begin

`ifdef VCD
      $dumpfile("div.vcd");
      $dumpvars();
`endif

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
//	 dividend[i] = $random;
//	 divisor[i] = $random;
	 dividend[i] = 10;
	 divisor[i] = 3;
	 quotient[i] = dividend[i] / divisor[i];
	 remainder[i] = dividend[i] % divisor[i];
      end
      
      //reset pulse
      #100 rst = 1;
      @(posedge clk) #1 rst = 0;
      
      //compute divisions
      for (i=0; i < TEST_SZ; i=i+1) begin
        //pulse start
         @(posedge clk) #1 start = 1;
         @(posedge clk) #1 start = 0;

         //wait for done
         while(!done)
           @(posedge clk) #1;
         
         //verify results
         if(quotient_out != quotient[i] || remainder_out != remainder[i])
           $display ("%d / %d = %d with rem %d but got %d with rem %d", dividend[i], divisor[i], quotient[i], remainder[i], quotient_out, remainder_out);

         
         #1000;
         
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
      .rst(rst),
      .start(start),
      .done(done),

      .dividend(dividend[i]),
      .divisor(divisor[i]),
      .quotient(quotient_out),
      .remainder(remainder_out)
      );

endmodule
