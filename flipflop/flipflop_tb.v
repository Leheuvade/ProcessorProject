`include "flipflop.v"

// Testbench Code Goes here
module flipflop_tb;

reg clock;
reg [14:0]d;
wire [14:0]q;

initial begin
  $monitor ("%g\t   clock = %b     d = %b      q = %b", 
    $time, clock, d, q);
  clock = 0;
  d = 15'b1;
  #3 d = 15'b0;
  #5 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

flipflop U0 (
d,
q, 
clock
);

endmodule