`include "preprocessor_directives.v"

//Include stages modules
`include "stages/fetch/fetch.v"
`include "stages/decode/decode.v"
`include "stages/exec/exec.v"
// `include "stages/cache/memory.v"
`include "stages/cache/cache.v"
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

`include "stall_control/stall_control.v"


module firstCPU;

reg clock;
reg rst_PC;
reg rst_IFID;
wire [31:0]newPc;
   reg 	   privilege;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  // $monitor ("%g\t clock=%b", $time, clock);
  //Set clock
  clock = 0;


   //Set privilege
   privilege = 0;

  #74 $finish;
end

// Privilege reg update
   always@(posedge clock) begin
      if (mem_wb.exception) begin
	 $display("Got an exception propagated through the pipeline");
	 $display("Faulty_address %x, pc to return to %x", mem_wb.faulty_address, mem_wb.pc);
	 privilege <= 1;
      end else if (id_ex.iret) begin
	 $display("Got an iret");
	 privilege <= 0;
      end
   end

   
// Clock generator
always begin
  #2 clock = ~clock;
   $display("------------------------------");
end

mux32 mux32(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(newPc));

//Flip Flop PC 
pc pc(.clock(clock));

   // Stall control
   wire 	 exec_flushPrevInstr;
   wire 	 decode_detectHazard_flush_CtrlBits;
   wire 	 id_ex_iret;
   wire 	 mem_wb_exception;
   stall_control stall_control(
			       // Memory stage
			       .d_cache_miss(d_cache_miss),
			       .enable_write_from_cache_to_memory(enable_write_from_d_cache_to_memory),

			       // Fetch stage
			       .instruction_not_ready(instruction_not_ready),
			       .exec_flushPrevInstr(exec_flushPrevInstr),
		      	       .decode_detectHazard_flush_CtrlBits(decode_detectHazard_flush_CtrlBits),

			       .stall_at_wb(),
			       .bubble_at_wb(),
			       .stall_at_memory(),
			       .bubble_at_memory(),
			       .stall_at_exec(),
			       .bubble_at_exec(),
			       .stall_at_decode(),
			       .bubble_at_decode(),
			       .stall_at_fetch(),
			       .bubble_at_fetch()
			       );

//Fetch stage
   
   wire [31-`OFFSET:0] itlb_w_virtual_page_i;
   wire [31-`OFFSET:0] itlb_w_phys_page_i;
   wire 	       itlb_write_enable_i;
   wire 	       itlb_miss;
   wire 	       itlb_ready;
   wire [`PHYS_ADDR_SIZE-1:0]   pc_phys_address;
   wire 			instruction_not_ready;
  
fetch fetch(
		.itlb_w_virtual_page_i(itlb_w_virtual_page_i),
		.itlb_w_phys_page_i(itlb_w_phys_page_i),
		.itlb_write_enable_i(itlb_write_enable_i),
 		.itlb_miss(itlb_miss),
 		.itlb_ready(itlb_ready),
		.privilege(privilege),
		.phys_address(pc_phys_address),

	    .instruction_not_ready(instruction_not_ready)
);

main_memory main_memory();

arb arb();

//Flip Flop IF_ID
if_id if_id(.clock(clock), .itlb_miss(itlb_miss), .itlb_ready(itlb_ready));

//Decode stage 
decode decode(.decode_detectHazard_flush_CtrlBits(decode_detectHazard_flush_CtrlBits));

//Flip Flop ID_EX
id_ex id_ex(.clock(clock), .privilege(privilege));

//Exec stage
   assign dtlb_write_enable_i = itlb_write_enable_i;
   assign dtlb_w_phys_page_i = itlb_w_phys_page_i;
   assign dtlb_w_virtual_page_i = itlb_w_virtual_page_i;
   exec exec(.enable_tlb_write_o(itlb_write_enable_i),
	     .virtual_page_o(itlb_w_virtual_page_i),
	     .phys_page_o(itlb_w_phys_page_i),
	     .exec_flushPrevInstr(exec_flushPrevInstr));

//Flip Flop EX_MEM
ex_mem ex_mem(.clock(clock));

//Memory stage 
   wire [31-`OFFSET:0] 	  dtlb_w_virtual_page_i;
   wire [31-`OFFSET:0] 	  dtlb_w_phys_page_i;
   wire 		  dtlb_write_enable_i;
   wire 		  dtlb_miss;
   wire 		  dtlb_ready;
   wire 		  d_cache_miss;
   wire 		  enable_write_from_d_cache_to_memory;
cache cache(
		       .dtlb_w_virtual_page_i(dtlb_w_virtual_page_i),
		       .dtlb_w_phys_page_i(dtlb_w_phys_page_i),
		       .dtlb_write_enable_i(dtlb_write_enable_i),
 		       .dtlb_miss(dtlb_miss),
 		       .dtlb_ready(dtlb_ready),
		       .privilege(privilege),

	    .d_cache_miss(d_cache_miss),
	    .enable_write_from_d_cache_to_memory(enable_write_from_d_cache_to_memory)
);

//Flip Flop MEM_WB
mem_wb mem_wb(.clock(clock), .dtlb_miss(dtlb_miss), .dtlb_ready(dtlb_ready));

//Write Back stage
wb wb();

endmodule
