`include "decode.v"

// Testbench Code Goes here
module decode_tb;

reg [6:0]opcode;
wire [13:0] y;

initial begin
  $monitor ("y=%b", y);
  opcode = 8'h1;
  #4 $finish;
end

decode U0 (opcode, y);

endmodule