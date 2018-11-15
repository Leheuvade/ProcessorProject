`include "control/control.v"
`include "flipflop/flipflop.v"

module program(clock, opcode, q);

input [7:0]opcode;
input clock;
output [14:0]q;
wire [14:0]control;

control ctrl(.opcode(opcode), .y(control));
flipflop flop(.d(control), .q(q), .clock(clock));

endmodule

// Testbench Code Goes here
module program_tb;

reg clock;
reg [7:0]opcode;
wire [14:0]q;

initial begin
  $monitor ("%g\t   clock = %b     d = %b      q = %b", 
    $time, clock, opcode, q);
  clock = 0;
  opcode = 8'h1;
  #3 opcode = 8'h2;
  #8 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

program U0(clock, opcode, q);
 
endmodule
