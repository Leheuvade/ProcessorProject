//Include stages modules
`include "stages/fetch/fetch.v"
`include "stages/decode/decode.v"
`include "stages/exec/exec.v"
`include "stages/memory/memory_stage.v"
`include "stages/wb/wb.v"
//Include flip flop modules
`include "flipflop/pc.v"
`include "flipflop/if_id.v"
`include "flipflop/id_ex.v"
`include "flipflop/ex_mem.v"
`include "flipflop/mem_wb.v"
//Include genericComponents
`include "genericComponents/mux32Bits.v"
//Include memory_arbiter and stall_control
`include "memory/memory_arbiter.v"
`include "stall_control/stall_control.v"

module firstCPU;

   reg clock;
   reg rst_PC;
   reg rst_IFID;
   reg privilege;
   wire [31:0] newPc;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  // $monitor ("%g\t clock=%b", $time, clock);
  clock = 0;
  rst_PC = 1;
  rst_IFID = 1;
   privilege = 1;
  #4 rst_PC = 0;rst_IFID = 0;
  #36 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

   always@(posedge clock) begin
      if (mem_wb.exception) begin
	 privilege <= 1;
      end else if (mem_wb.iret) begin
	 privilege <= 0;
      end
   end
   
mux32 mux32(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(newPc));

//Flip Flop PC 
pc pc(.rst(rst_PC), .clock(clock));

   //Stall_control
   stall_control stall_control(
			       // Memory stage
			       .d_cache_miss(d_cache_miss),
			       .enable_write_from_cache_to_memory(enable_write_from_d_cache_to_memory),

			       // Fetch stage
			       .instruction_not_ready(instruction_not_ready),

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

   //Memory arbiter
   wire d_cache_enable = d_cache_miss || enable_write_from_d_cache_to_memory;
   wire d_cache_write_or_read = enable_write_from_d_cache_to_memory? `WRITE : `READ;
   wire d_cache_ready;
   memory_arbiter memory_arbiter(
				 // i_cache interface
				 .i_cache_address(pc_phys_address),
				 .i_cache_enable(instruction_not_ready),
				 .i_cache_out_data(from_memory_to_i_cache_data),
				 .i_cache_ready(enable_write_from_memory_to_i_cache), 
				 
				 // d_cache interface
				 .d_cache_address(from_d_cache_to_memory_address),
				 .d_cache_in_data(from_d_cache_to_memory_out_data),
				 .d_cache_write_or_read(d_cache_write_or_read),
				 .d_cache_enable(d_cache_enable),
				 .d_cache_out_data(from_memory_to_d_cache_data),
				 .d_cache_ready(d_cache_ready)
				 );
      

//Fetch stage

   wire instruction_hot_and_ready;
   wire [`LINE_WIDTH-1:0] from_memory_to_i_cache_data;
   wire enable_write_from_memory_to_i_cache;
   wire instruction_not_ready = ~instruction_hot_and_ready;

   wire [31-`OFFSET:0] itlb_w_virtual_page_i;
   wire [31-`OFFSET:0] itlb_w_phys_page_i;
   wire 	       itlb_write_enable_i;
   wire 	       itlb_miss;
   wire 	       itlb_ready;
   wire [`PHYS_ADDR_SIZE-1:0]   pc_phys_address;
   
   fetch fetch( // Input for memory_arbiter and stall_control
		.from_memory_to_cache_data(from_memory_to_i_cache_data),
		.enable_write_from_memory_to_cache(enable_write_from_memory_to_i_cache),

		// iTLB
		.itlb_w_virtual_page_i(itlb_w_virtual_page_i),
		.itlb_w_phys_page_i(itlb_w_phys_page_i),
		.itlb_write_enable_i(itlb_write_enable_i),
 		.itlb_miss(itlb_miss),
 		.itlb_ready(itlb_ready),
		.privilege(privilege),
		.phys_address(pc_phys_address),
		
		// TODO : faudra peut-être les set
		.instruction(),
 		.pcIncr(),
 		.pcJump(),
		.instruction_hot_and_ready(instruction_hot_and_ready)
		);

//Flip Flop IF_ID
if_id if_id(.rst(rst_IFID), .clock(clock), .itlb_miss(itlb_miss), .itlb_ready(itlb_ready));

//Decode stage 
decode decode();

//Flip Flop ID_EX
id_ex id_ex(.clock(clock));

//Exec stage
exec exec();

//Flip Flop EX_MEM
ex_mem ex_mem(.clock(clock));

//Memory stage
   wire data_hot_and_ready;
   wire [`LINE_WIDTH-1:0] from_memory_to_d_cache_data;
   wire completed_write_from_d_cache_to_memory = d_cache_ready && enable_write_from_d_cache_to_memory;
   wire enable_write_from_memory_to_d_cache = d_cache_ready && (d_cache_write_or_read==`READ);
   wire enable_write_from_d_cache_to_memory;
   wire d_cache_miss;
   wire [`PHYS_ADDR_SIZE-1:0] from_d_cache_to_memory_address;
   wire [`LINE_WIDTH-1:0] from_d_cache_to_memory_out_data;

   wire [31-`OFFSET:0] 	  dtlb_w_virtual_page_i;
   wire [31-`OFFSET:0] 	  dtlb_w_phys_page_i;
   wire 		  dtlb_write_enable_i;
   wire 		  dtlb_miss;
   wire 		  dtlb_ready;
   
   memory_stage memory(
		       .clock(clock),
      
 		       .readData(),
		       .data_hot_and_ready(data_hot_and_ready),

		       // Input for memory_arbiter and stall_control
		       .from_memory_to_cache_data(from_memory_to_d_cache_data),
		       .completed_write_from_cache_to_memory(completed_write_from_d_cache_to_memory),
		       .enable_write_from_memory_to_cache(enable_write_from_memory_to_d_cache),

		       // dTLB
		       .dtlb_w_virtual_page_i(dtlb_w_virtual_page_i),
		       .dtlb_w_phys_page_i(dtlb_w_phys_page_i),
		       .dtlb_write_enable_i(dtlb_write_enable_i),
 		       .dtlb_miss(dtlb_miss),
 		       .dtlb_ready(dtlb_ready),
		       .privilege(privilege),
		       
		       // Output for memory_arbiter and stall_control
		       .enable_write_from_cache_to_memory(enable_write_from_d_cache_to_memory),
		       .cache_miss(d_cache_miss),
		       .to_memory_address(from_d_cache_to_memory_address),
		       .to_memory_out_data(from_d_cache_to_memory_out_data)
		       );

//Flip Flop MEM_WB
mem_wb mem_wb(.clock(clock), .dtlb_miss(dtlb_miss), .dtlb_ready(dtlb_ready));

//Write Back stage
wb wb();

endmodule
