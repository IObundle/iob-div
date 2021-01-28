`timescale 1ns / 1ps

module div_subshift_tb;

   parameter clk_frequency = `CLK_FREQ;
   parameter clk_period = 1e9/clk_frequency; //ns
   parameter DATA_W = 16; //data gen is limited to 31 bits
   parameter TEST_SZ = 100;

   reg clk;
   reg en;
   wire done;

   //data
   reg [DATA_W-1:0]  dividend [0:TEST_SZ-1];
   reg [DATA_W-1:0]  divisor [0:TEST_SZ-1];
   reg signed [DATA_W-1:0] dividend_s [0:TEST_SZ-1];
   reg signed [DATA_W-1:0] divisor_s [0:TEST_SZ-1];
   reg [DATA_W-1:0]        quotient [0:TEST_SZ-1];
   reg [DATA_W-1:0]        remainder [0:TEST_SZ-1];
   reg signed [DATA_W-1:0] quotient_s [0:TEST_SZ-1];
   reg signed [DATA_W-1:0] remainder_s [0:TEST_SZ-1];

   //core outputs
   wire [DATA_W-1:0]        quotient_out;
   wire [DATA_W-1:0]        remainder_out;
   wire signed [DATA_W-1:0] quotient_s_out;
   wire signed [DATA_W-1:0] remainder_s_out;
   
   integer           i;

 
   initial begin

`ifdef VCD
      $dumpfile("div.vcd");
      $dumpvars();
`endif

      clk = 1;
      en = 0;

      // generate test data
      for (i=0; i < TEST_SZ; i=i+1) begin
	 dividend[i] = $random;
	 divisor[i] = $random;
	 quotient[i] = dividend[i] / divisor[i];
	 remainder[i] = dividend[i] % divisor[i];
         dividend_s[i] = $random%(DATA_W)-2**(DATA_W-1);
	 divisor_s[i] = $random%(DATA_W)-2**(DATA_W-1);
	 quotient_s[i] = dividend_s[i] / divisor_s[i];
	 remainder_s[i] = dividend_s[i] % divisor_s[i];         
      end
      
      
      //copmpute divisions
      for (i=0; i < TEST_SZ; i=i+1) begin
         @(posedge clk) #1 en = 1;
         @(posedge done) #1;
         if(quotient_out != quotient[i] || remainder_out != remainder[i])
           $display ("%d / %d = %d with rem %d but got %d with rem %d", dividend[i], divisor[i], quotient[i], remainder[i], quotient_out, remainder_out);
         else if (quotient_s_out != quotient_s[i] || remainder_s_out != remainder_s[i])
           $display ("%d / %d = %d with rem %d but got %d with rem %d", dividend_s[i], divisor_s[i], quotient[i], remainder[i], quotient_s_out, remainder_s_out);
         @(posedge clk) #1 en = 0;
      end

      $finish;

   end

   //clock
   always #(clk_period/2) clk = ~clk;   

   //instantiate unsigned divider
   div_subshift 
     # (
        .DATA_W(DATA_W)
        )
   uut 
     (
      .clk(clk),
      .en(en),
      .done(done),
      .sign(1'b0),
      .dividend(dividend[i]),
      .divisor(divisor[i]),
      .quotient(quotient_out),
      .remainder(remainder_out)
      );

   //instantiate signed divider
   div_subshift 
     # (
        .DATA_W(DATA_W)
        )
   uut_s 
     (
      .clk(clk),
      .en(en),
      .done(done),
      .sign(1'b1),
      .dividend(dividend_s[i]),
      .divisor(divisor_s[i]),
      .quotient(quotient_s_out),
      .remainder(remainder_s_out)
      );
   
endmodule
