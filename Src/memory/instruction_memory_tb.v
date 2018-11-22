`include "instruction_memory.v"

// Testbench Code Goes here
module instruction_memory_tb;

reg [31:0]address;
wire [31:0]instruction;

initial begin
  $monitor ("address=%b instruction=%b", address, instruction);
  address = 32'b1;
  #5 $finish;
end

instruction_memory U0 (address, instruction);

endmodule