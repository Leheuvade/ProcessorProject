`include "decode/decode.v"
`include "fetch/fetch.v"

module program(clock, instruction, control);

input [31:0]instruction;
input clock;
output [13:0]control;
wire [31:0]instructionf;

fetch fetch(.d(instruction), .q(instructionf), .clock(clock));
decode decode(.opcode(instructionf[31:25]), .y(control), .clock(clock));

endmodule

// Testbench Code Goes here
module program_tb;

reg clock;
reg [31:0]instruction;
wire [13:0]control;

initial begin
  $dumpfile("program.vcd");
  $dumpvars(0, program_tb);
  $monitor ("%g\t clock=%b instruction=%b control=%b", 
  	$time, clock, instruction, control);
  clock = 0;
  instruction = 32'b0;
  #8 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

program U0(clock, instruction, control);
 
endmodule
