`include "decode/decode.v"
`include "fetch/fetch.v"
`include "alu/alu.v"

module program(clock, instruction, op1, op2, zero, result, instructionf, control);

input [31:0]instruction, op1, op2;
input clock;
output zero;
output [31:0]result;
output [13:0]control;
output [31:0]instructionf;

fetch fetch(.d(instruction), .q(instructionf), .clock(clock));
decode decode(.opcode(instructionf[31:25]), .y(control), .clock(clock));
alu alu(.op1(op1), .op2(op2), .aluOp(control[6:0]), .zero(zero), .result(result), .clock(clock));
endmodule

// Testbench Code Goes here
module program_tb;

reg clock;
reg [31:0]instruction, op1, op2;
wire zero; 
wire [31:0]result;
wire [31:0]instructionf;
wire [13:0]control;

initial begin
  $dumpfile("program.vcd");
  $dumpvars(0, program_tb);
  $monitor ("%g\t clock=%b op1=%h op2=%h  instFetch=%h control=%h result=%h zero=%b", 
  	$time, clock, op1, op2, instructionf, control, result, zero);
  clock = 0;
  instruction = 32'b0;
  op1 = 32'b1;
  op2 = 32'b10;
  #20 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

program U0(clock, instruction, op1, op2, zero, result, instructionf, control);
 
endmodule
