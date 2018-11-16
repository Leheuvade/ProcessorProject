`include "alu.v"

// Testbench Code Goes here
module alu_tb;

wire zero;
wire [31:0]result;
reg [31:0]op1, op2; 
reg [1:0]opcode;

initial begin
  $monitor ("%g\t op1=%b op2=%b zero=%b result=%b", 
    $time, op1, op2, zero, result);
  op1 = 32'b10;
  op2 = 32'b10;
  opcode = 2'b0;
  #3 opcode = 2'b1;
  #5 $finish;
end

alu U0(op1, op2, opcode, zero, result);

endmodule