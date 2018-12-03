`include "./stages/fetch/components/instruction_memory.v"

module fetch(pc, instruction, newPc);

input [31:0]pc;
output [31:0]instruction, newPc;

wire pc;
wire instruction;
reg newPc;

instruction_memory getInstruction(.address(pc), .instruction(instruction));
always @(pc) begin
	newPc = pc + 4;
end
endmodule