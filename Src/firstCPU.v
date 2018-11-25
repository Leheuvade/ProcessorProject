`include "fetch/fetch.v"
`include "decode/decode.v"
`include "alu/alu.v"
`include "flipflop/if_id.v"
`include "./file_register/write_file_register.v"
`include "./file_register/read_file_register.v"
`include "./flipflop/id_ex.v"
`include "./flipflop/ex_mem.v"

module firstCPU;

reg clock;
wire [31:0]instruction, newInstruction;
wire [31:0]op1, op2, op1FF, op2FF;
wire [1:0]aluCtrl, aluCtrlFF;
wire zero, zeroFF;
wire [31:0]result, resultFF;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  $monitor ("%g\t clock=%b newInstruction=%h newOp1=%h newOp2=%h aluCtrlFF=%b zero=%h result=%h", $time, clock, newInstruction, op1FF, op2FF, aluCtrlFF, zeroFF, resultFF);
  clock = 0;
  #15 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

fetch fetch(.instruction(instruction));
if_id if_id(.in(instruction), .clock(clock), .out(newInstruction));
decode decode(.instruction(newInstruction), .op1(op1), .op2(op2), .aluCtrl(aluCtrl));
id_ex id_ex(.inOp1(op1), .inOp2(op2), .inAluCtrl(aluCtrl), .clock(clock), .outOp1(op1FF), .outOp2(op2FF), .outAluCtrl(aluCtrlFF));
alu alu(.op1(op1FF), .op2(op2FF), .aluCtrl(aluCtrlFF), .zero(zero), .result(result));
ex_mem ex_mem(.inZero(zero), .inResult(result), .clock(clock), .outZero(zeroFF), .outResult(resultFF));
endmodule