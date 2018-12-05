module  instruction_memory(address, instruction);

input [31:0]address;
output [31:0]instruction;

wire address;
reg instruction;
reg [7:0] memory [0:23];

initial begin
 $readmemb("../Resources/instruction_memory.list", memory);
end 

always @(address) begin 
 	instruction = {memory[address], memory[address + 1],  memory[address + 2], memory[address + 3]};
end
endmodule