`include "stages/fetch/components/instruction_memory.v"

module fetch();

wire [31:0]instruction;
wire [31:0]pcIncr;
assign pcIncr = pc.pc + 4;

instruction_memory getInstruction(.address(pc.pc), .instruction(instruction));

endmodule

