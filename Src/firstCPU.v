//Include stages modules
`include "stages/fetch/fetch.v"
`include "stages/decode/decode.v"
`include "stages/exec/exec.v"
`include "stages/memory/memory.v"
`include "stages/wb/wb.v"
//Include flip flop modules
`include "flipflop/pc.v"
`include "flipflop/if_id.v"
`include "flipflop/id_ex.v"
`include "flipflop/ex_mem.v"
`include "flipflop/mem_wb.v"
//Include genericComponents
`include "genericComponents/mux32Bits.v"

module firstCPU;

reg clock;
reg rst_PC;
reg rst_IFID;
wire [31:0]newPc;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  // $monitor ("%g\t clock=%b", $time, clock);
  clock = 0;
  rst_PC = 1;
  rst_IFID = 1;
  #4 rst_PC = 0;rst_IFID = 0;
  #36 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

mux32 mux32(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(newPc));

//Flip Flop PC 
pc pc(.rst(rst_PC), .clock(clock));

//Fetch stage 
fetch fetch();

//Flip Flop IF_ID
if_id if_id(.rst(rst_IFID), .flush(ex_mem.flushPrevInstr), .clock(clock));

//Decode stage 
decode decode();

//Flip Flop ID_EX
id_ex id_ex(.flush(ex_mem.flushPrevInstr), .clock(clock));

//Exec stage
exec exec();

//Flip Flop EX_MEM
ex_mem ex_mem(.flush(ex_mem.flushPrevInstr), .clock(clock));

//Memory stage 
memory memory();

//Flip Flop MEM_WB
mem_wb mem_wb(.clock(clock));

//Write Back stage
wb wb();

endmodule