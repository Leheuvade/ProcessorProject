`include "preprocessor_directives.v"

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
//Include memory
`include "main_memory/main_memory.v"
`include "main_memory/arb.v"


module firstCPU;

reg clock;
reg rst_PC;
reg rst_IFID;
wire [31:0]newPc;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  // $monitor ("%g\t clock=%b", $time, clock);
  //Set clock
  clock = 0;

  //Set rst
  pc.rst = 1;
  if_id.rst = 1;
  mem_wb.clear = 0;

  //Set we
  pc.we = 1;
  if_id.we = 1;
  id_ex.we = 1;
  ex_mem.we = 1;
  
  #4 pc.rst = 0;if_id.rst = 0;
  #74 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

mux32 mux32(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(newPc));

//Flip Flop PC 
pc pc(.clock(clock));

//Fetch stage 
fetch fetch();

main_memory main_memory();

arb arb();

//Flip Flop IF_ID
if_id if_id(.clock(clock));

//Decode stage 
decode decode();

//Flip Flop ID_EX
id_ex id_ex(.clock(clock));

//Exec stage
exec exec();

//Flip Flop EX_MEM
ex_mem ex_mem(.clock(clock));

//Memory stage 
memory memory();

//Flip Flop MEM_WB
mem_wb mem_wb(.clock(clock));

//Write Back stage
wb wb();

endmodule