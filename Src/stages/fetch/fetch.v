`include "preprocessor_directives.v"
`include "cache/cache.v"
`include "TLB/tlb.v"

module fetch(// Input for memory_arbiter and stall_control
	     input wire [`LINE_WIDTH-1:0]      from_memory_to_cache_data,
	     input wire 		       enable_write_from_memory_to_cache,
	     // For iTLB
	     input wire [31-`OFFSET:0] 	       itlb_w_virtual_page_i,
	     input wire [31-`OFFSET:0] 	       itlb_w_phys_page_i,
	     input wire 		       itlb_write_enable_i,
	     output wire 		       itlb_miss,
	     output wire 		       itlb_ready,
	     input wire 		       privilege,
	     output wire [`PHYS_ADDR_SIZE-1:0] phys_address,

	     output wire [31:0] 	       instruction,
	     output wire [31:0] 	       pcIncr,
	     output wire [31:0] 	       pcJump,
	     output wire 		       instruction_hot_and_ready
	     );

   wire [`LINE_WIDTH-1:0] 	cache_out_data;

   // TODO : input
   wire [`LINE_ADDR_START_INDEX+2:0] offset = pc.pc[`LINE_ADDR_START_INDEX-1:0] << 3;
   
   assign instruction = cache_out_data >> offset;
   
   assign pcJump = {pcIncr[31:28], instruction[25:0]<<2};
   assign pcIncr = pc.pc + 4;

   tlb itlb(  .clock(clock),
	      .virtual_address_i(pc.pc),
	      .phys_address_o(phys_address),
  	      .ready_o(itlb_ready),
  	      .tlb_miss_o(itlb_miss),
	      .privilege_i(privilege),
      
	      // For modifying the tlb
	      .w_virtual_page_i(itlb_w_virtual_page_i),
	      .w_phys_page_i(itlb_w_phys_page_i),
 	      .write_enable_i(itlb_write_enable_i)
	      );

   cache i_cache(
	     	 .clock(clock),
      
	     	 .from_memory_input_data(from_memory_to_cache_data),
	     	 .completed_write_to_memory(`NONE),
	     	 .from_memory_write_enable(enable_write_from_memory_to_cache),

	     	 .in_data(`NONE),
		 .size(`NONE),
	     	 .enable(!itlb_miss && itlb_ready),
	     	 .write_or_read(`READ),
		 .address(phys_address),

	     	 .write_to_memory(),
	     	 .cache_miss(), // If instruction is not ready, it means we have a cache miss
		 .to_memory_address(),
		 .to_memory_out_data(),
      
	     	 .out_data(cache_out_data),
	     	 .ready(instruction_hot_and_ready)
		 );

   always@(*) begin
      if(offset+`INSTRUCTION_LENGTH > `LINE_WIDTH) begin
	 `CERR(("[fetch] Unaligned is not supported yet ! : pc %x, offset %x, instruction_length %x !", pc.pc, offset, `INSTRUCTION_LENGTH))
	 $finish;
      end
   end
   

endmodule

