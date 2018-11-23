`include "./memory/instruction_memory.v"
`include "./file_register/read_file_register.v"
`include "./file_register/update_pc.v"

module fetch(clock, instruction);

input clock;
output [31:0]instruction;

wire clock;
wire instruction;
wire [31:0]valuePC;
reg [4:0]regNumberPC = 5'b0;

read_file_register readPC(.clock(clock), .index(regNumberPC), .value(valuePC));
update_pc update_pc(.clock(clock));
instruction_memory getInstruction(.address(valuePC), .instruction(instruction));

endmodule