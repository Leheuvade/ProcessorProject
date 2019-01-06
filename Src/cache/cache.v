'include "./preprocessor_directives.v"

module cache(
	     input wire 		  clock,
	     // Interface with main memory
	     input wire [LINE_WIDTH-1:0]  from_memory_input_data,
	     input wire 		  completed_write_to_memory,
	     input wire 		  from_memory_write_enable,

	     // Interface with pipeline stage
	     input wire [LINE_WIDTH-1:0]  in_data,
	     input wire 		  enable,
	     input wire 		  write_or_read,
	     input wire [ADDR_SIZE-1:0]   address,

	     // Interface with main memory
	     output wire 		  write_to_memory,
	     output wire 		  cache_miss,
	     output wire [ADDR_SIZE-1:0]  to_memory_address,
	     output wire [LINE_WIDTH-1:0] to_memory_out_data,
	     
	     // Interface with pipeline stage
	     output wire [LINE_WIDTH-1:0] out_data,
	     output wire 		  ready);
   
      
   parameter ADDR_SIZE = 'PHYS_ADDR_SIZE;
   parameter CACHE_LINES = 'CACHE_LINES;
   parameter LINE_WIDTH = 'LINE_WIDTH;
   parameter CACHE_TYPE = "DATA";

   localparam LINE_ADDR_SIZE = 'LINE_ADDR_SIZE;
   localparam TAG_SIZE = 'TAG_SIZE;
   localparam LINE_ADDR_START_INDEX = 'LINE_ADDR_START_INDEX;

   reg 					  dirty[0:CACHE_LINES-1];
   reg 					  valid[0:CACHE_LINES-1];
   reg [TAG_SIZE-1:0] 			  tags[0:CACHE_LINES-1];
   reg [LINE_WIDTH-1:0] 		    cache [0:CACHE_LINES-1];
   
   wire [LINE_ADDR_SIZE-1:0] 		    line_addr = address['CACHE_ADDR_RANGE];
   wire [TAG_SIZE-1:0] 			    tag = address[ADDR_SIZE-1:ADDR_SIZE-TAG_SIZE];
   wire 				    dirty_evict = valid[line_addr] && dirty[line_addr] && tags[line_addr]!=tag;
   wire 				    should_update_cache = (ready && enable && write_or_read=='WRITE);
   
   
   assign write_to_memory = (enable && write_or_read=='WRITE && dirty_evict);
   assign cache_miss = (enable && !dirty_evict && (!valid[line_addr] || tags[line_addr]!=tag));
   assign to_memory_address = {tags[line_addr],line_addr,LINE_ADDR_START_INDEX{1'b0}};
   assign to_memory_out_data = cache[line_addr];

   assign out_data = cache[line_addr];
   assign ready = (!enable || (!cache_miss && !write_to_memory));

   always@(posedge clock) begin
      if (completed_write_to_memory && dirty_evict) begin
	 'COUT("[%s cache] Wrote dirty data from address %x back to main memory (dirty_evict)", CACHE_TYPE, to_memory_address);
	 dirty[line_addr] <= 0;
      end else if (enable && cache_miss && from_memory_write_enable) begin
	 'COUT("[%s cache] Got value %x from address %x from memory following a cache miss", CACHE_TYPE, from_memory_input_data, address);
	 cache[line_addr] <= from_memory_input_data;
	 tags[line_addr] <= tag;
	 dirty[line_addr] <= 0;
	 valid[line_addr] <= 1;
      end else if (should_update_cache) begin
	 'COUT("[%s cache] Wrote new value %x to address %x into cache, which is now dirty", CACHE_TYPE, in_data, address);
	 cache[line_addr] <= in_data;
	 tags[line_addr] <= tag;
	 dirty[line_addr] <= 1;
	 valid[line_addr] <= 1;
      end
   end

endmodule 
