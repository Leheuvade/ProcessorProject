`include "./instructionMemory/instruction_memory.v"
// `include "./file_register/update_pc.v"

module fetch(instruction);

output [31:0]instruction;

wire instruction;
wire [31:0]valuePC;
reg [4:0]regNumberPC = 5'b0;

read_file_register readPC(.index(regNumberPC), .value(valuePC));
// update_pc update_pc(.clock(clock));
instruction_memory getInstruction(.address(valuePC), .instruction(instruction));

endmodule