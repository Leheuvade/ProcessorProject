`include "fetch/fetch.v"
`include "decode/decode.v"

module firstCPU;

reg clock;
wire [12:0]controlBits;
wire [4:0]rs, rt, rd;
wire [14:0]address;
wire [31:0]instruction;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  $monitor ("%g\t clock=%b instruction=%h controlBits=%b rs=%b rt=%b rd=%b address=%h", $time, clock, instruction, controlBits, rs, rt, rd, address);
  clock = 1;
  #15 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

fetch fetch(.clock(clock), .instruction(instruction));
decode decode(.clock(clock), .instruction(instruction), .address(address), .rs(rs), .rt(rt), .rd(rd), .controlBits(controlBits));

endmodule