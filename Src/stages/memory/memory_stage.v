`include "preprocessor_directives.v"
`include "cache/cache.v"

module  memory_stage(
		     input wire 		  clock,
   
		     output wire [31:0] 	  readData,
		     output wire 		  data_hot_and_ready,

		     // Input for memory_arbiter and stall_control
		     input wire [`LINE_WIDTH-1:0] from_memory_to_cache_data,
		     input wire 		  completed_write_from_cache_to_memory,
		     input wire 		  enable_write_from_memory_to_cache,

		     // Output for memory_arbiter and stall_control
		     output wire 		  enable_write_from_cache_to_memory,
		     output wire 		  cache_miss,
		     output wire [`PHYS_ADDR_SIZE-1:0]  to_memory_address,
		     output wire [`LINE_WIDTH-1:0] to_memory_out_data
		     );

   // Input from previous stage 
   wire [31:0] 					  address = ex_mem.result;
   wire [31:0] 					  write_data = ex_mem.readData2;
   wire 					  memRead = ex_mem.memRead;
   wire 					  memWrite = ex_mem.memWrite;
   wire 					  word = ex_mem.word;

   wire [`LINE_WIDTH-1:0] 			  cache_out_data;
   wire 					  offset = address[`LINE_ADDR_START_INDEX-1:0] << 3;
   wire 					  enable = memRead || memWrite;
   wire 					  write_or_read = memWrite? `WRITE : `READ;
   wire 					  data_length = word? `WORD_SIZE : `BYTE_SIZE;
   
   assign readData = cache_out_data >> offset;
   
   cache d_cache(
	     	 .clock(clock),
      
	     	 .from_memory_input_data(from_memory_to_cache_data),
	     	 .completed_write_to_memory(completed_write_from_cache_to_memory),
	     	 .from_memory_write_enable(enable_write_from_memory_to_cache),

	     	 .in_data(write_data),
	     	 .enable(enable),
	     	 .write_or_read(write_or_read),
		 .address(address),

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
