`include "stages/fetch/components/instruction_memory.v"

module fetch();

wire [31:0]instruction;
wire [31:0]pcIncr;
wire [31:0]pcJump;
assign pcJump = {pcIncr[31:28], instruction[25:0]<<2};
assign pcIncr = pc.pc + 4;

instruction_memory getInstruction(.address(pc.pc), .instruction(instruction));

endmodule

