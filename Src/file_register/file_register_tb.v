`include "file_register.v"

// Testbench Code Goes here
module file_register_tb;

reg clock;
reg [4:0]index;
wire [31:0]value;

initial begin
  $monitor ("%g\t clock=%b index=%h value=%h", $time, clock, index, value);
  index = 1'h0;
  clock = 0;
  #8 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock; // Toggle clock every 5 ticks
end

read_file_register U0 (clock, index, value);

endmodule