`include "control/control.v"
`include "flipflop/flipflop.v"
`include "alu/alu_control.v"
`include "alu/alu.v"

module program(clock, opcode, op1, op2, zero, result);

input [7:0]opcode;
input [31:0]op1;
input [31:0]op2;
input clock;
output [31:0]result;
output zero;
wire [14:0]control, q;
wire [1:0]aluCtrl;

control ctrl(.opcode(opcode), .y(control));
flipflop flop(.d(control), .q(q), .clock(clock));
alu_control ctrlAlu(.aluOp(q[10:3]), .aluCtrl(aluCtrl));
alu alu(.op1(op1), .op2(op2), .ctrl(aluCtrl), .zero(zero), .result(result));

endmodule

// Testbench Code Goes here
module program_tb;

reg clock;
reg [7:0]opcode;
reg [31:0]op1, op2;
wire zero;
wire [31:0]result;

initial begin
  $monitor ("%g\t clock=%b opcode=%h op1=%h op2=%h result=%h zero=%h", 
    $time, clock, opcode, op1, op2, result, zero);
  clock = 0;
  opcode = 8'h0;
  op1 = 32'h2;
  op2 = 32'h4;
  #3 op2 = 8'h2;
  #8 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

program U0(clock, opcode, op1, op2, zero, result);
 
endmodule
