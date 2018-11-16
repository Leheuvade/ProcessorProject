`include "ffInstr.v"

// Testbench Code Goes here
module flipflop_tb;

reg clock;
reg [31:0]d;
wire [31:0]q;

initial begin
  $monitor ("%g\t   clock = %b     d = %b      q = %b", 
    $time, clock, d, q);
  clock = 0;
  d = 32'b0;
  #3 d = 32'b1;
  #5 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

ffInstr U0 (d, q, clock);

endmodule