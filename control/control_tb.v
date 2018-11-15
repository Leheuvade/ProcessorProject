`include "control.v"

// Testbench Code Goes here
module control_tb;

reg [7:0]opcode;
wire [14:0] y;

initial begin
  $monitor ("y=%b", y);
  opcode = 8'h1;
  #4 $finish;
end

control U0 (opcode, y);

endmodule