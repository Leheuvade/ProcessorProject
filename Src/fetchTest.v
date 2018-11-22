`include "memory/instruction_memory.v"
`include "file_register/file_register.v"
`include "file_register/update_pc.v"

module fetchTest;

reg clock;
wire [31:0]valuePC;
wire [31:0]instruction;
reg [4:0]regNumberPC = 5'b0;

initial begin
  $dumpfile("fetchTest.vcd");
  $dumpvars(0, fetchTest);
  $monitor ("%g\t clock=%b instruction=%b valuePC=", $time, clock, instruction, valuePC);
  clock = 1;
  #15 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

read_file_register readPC(.clock(clock), .index(regNumberPC), .value(valuePC));
update_pc update_pc(.clock(clock));
instruction_memory getInstruction(.address(valuePC), .instruction(instruction));

endmodule