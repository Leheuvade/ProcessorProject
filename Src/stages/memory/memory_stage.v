`include "preprocessor_directives.v"
`include "cache/cache.v"

module  memory_stage(
		     input wire 		       clock,
   
		     output wire [31:0] 	       readData,
		     output wire 		       data_hot_and_ready,

		     // Input for memory_arbiter and stall_control
		     input wire [`LINE_WIDTH-1:0]      from_memory_to_cache_data,
		     input wire 		       completed_write_from_cache_to_memory,
		     input wire 		       enable_write_from_memory_to_cache,
		     // For dTLB
		     input wire [31-`OFFSET:0] 	       dtlb_w_virtual_page_i,
		     input wire [31-`OFFSET:0] 	       dtlb_w_phys_page_i,
		     input wire 		       dtlb_write_enable_i,
		     output wire 		       dtlb_miss,
		     output wire 		       dtlb_ready,
		     input wire 		       privilege,

		     // Output for memory_arbiter and stall_control
		     output wire 		       enable_write_from_cache_to_memory,
		     output wire 		       cache_miss,
		     output wire [`PHYS_ADDR_SIZE-1:0] to_memory_address,
		     output wire [`LINE_WIDTH-1:0]     to_memory_out_data
		     );

   // Input from previous stage 
   wire [31:0] 					  address = ex_mem.result;
   wire [31:0] 					  write_data = ex_mem.readData2;
   wire 					  memRead = ex_mem.memRead;
   wire 					  memWrite = ex_mem.memWrite;
   wire 					  word = ex_mem.word;

   wire [`LINE_WIDTH-1:0] 			  cache_out_data;
   wire [`LINE_ADDR_START_INDEX+2:0] 		  offset = address[`LINE_ADDR_START_INDEX-1:0] << 3;
   wire 					  enable = (memRead || memWrite) && !ex_mem.exception;
   wire 					  write_or_read = memWrite? `WRITE : `READ;
   wire 					  data_length = word? `WORD_SIZE : `BYTE_SIZE;

   wire [31:0] cache_data_no_offset = cache_out_data >> offset;
   assign readData = cache_data_no_offset << (32-write_data_size) >> (32-write_data_size);
   wire        write_data_size = word? `WORD : `BYTE;

   wire [`PHYS_ADDR_SIZE-1:0] phys_address;
   wire [31:0] virtual_address = enable ? address : 0;

   tlb dtlb(  .virtual_address_i(virtual_address),
	      .phys_address_o(phys_address),
  	      .ready_o(dtlb_ready),
  	      .tlb_miss_o(dtlb_miss),
	      .privilege_i(privilege),
      
	      // For modifying the tlb
	      .w_virtual_page_i(dtlb_w_virtual_page_i),
	      .w_phys_page_i(dtlb_w_phys_page_i),
 	      .write_enable_i(dtlb_write_enable_i)
	      );
   
   cache d_cache(
	     	 .clock(clock),
      
	     	 .from_memory_input_data(from_memory_to_cache_data),
	     	 .completed_write_to_memory(completed_write_from_cache_to_memory),
	     	 .from_memory_write_enable(enable_write_from_memory_to_cache),

	     	 .in_data(write_data),
		 .size(write_data_size),
	     	 .enable(enable && dtlb_ready && !dtlb_miss),
	     	 .write_or_read(write_or_read),
		 .address(phys_address),

	     	 .write_to_memory(enable_write_from_cache_to_memory),
	     	 .cache_miss(cache_miss), 
		 .to_memory_address(to_memory_address),
		 .to_memory_out_data(to_memory_out_data),
      
	     	 .out_data(cache_out_data),
	     	 .ready(data_hot_and_ready)
		 );
   
   always@(*) begin
      if(offset+data_length > `LINE_WIDTH) begin
	 `CERR(("[memory] Unaligned is not supported yet : address %x, offset %x, data_length %x !", address, offset, data_length))
	 $finish;
      end
   end

endmodule
