`include "./stages/fetch/components/instruction_memory.v"

module fetch(pc, pcBranch, pcSrc, instruction, pcIncr, newPc);

input [31:0]pc, pcBranch;
input pcSrc;
output [31:0]instruction, newPc, pcIncr;

assign pcIncr = pc + 4;

mux32 mux32(.in1(pcIncr), .in2(pcBranch), .ctrl(pcSrc), .out(newPc));
instruction_memory getInstruction(.address(pc), .instruction(instruction));

endmodule

