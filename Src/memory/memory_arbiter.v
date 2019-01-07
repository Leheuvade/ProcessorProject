`include "memory/preprocessor_directives.v"
`include "./memory.v"

module memory_arbiter(
		      // i_cache interface
		      input wire [ADDR_SIZE-1:0]   i_cache_address,
		      input wire 		   i_cache_enable,
		      output wire [LINE_WIDTH-1:0] i_cache_out_data = 0,
		      output wire 		   i_cache_ready, 

		      // d_cache interface
		      input wire [ADDR_SIZE-1:0]   d_cache_address,
		      input wire [LINE_WIDTH-1:0]  d_cache_in_data,
		      input wire 		   d_cache_write_or_read,
		      input wire 		   d_cache_enable,
		      output wire [LINE_WIDTH-1:0] d_cache_out_data = 0,
		      output wire 		   d_cache_ready);

   parameter LINE_WIDTH = `LINE_WIDTH;
   parameter ADDR_SIZE = `PHYS_ADDR_SIZE;
   
   wire 					   reset;
   
   memory memory(
		 .p1_read_address(i_cache_address),
		 .p1_enable(i_cache_enable),
		 .p1_out_data(i_cache_out_data),
		 .p1_ready(i_cache_ready), 

		 // d_cache interface
		 .p2_address(d_cache_address),
		 .p2_in_data(d_cache_in_data),
		 .p2_write_or_read(d_cache_write_or_read),
		 .p2_enable(d_cache_enable),
		 .p2_out_data(d_cache_out_data),
		 .p2_ready(d_cache_ready)
		 );

   initial begin
      reset = 1;
      #1 reset = 0;
   end
		 
endmodule
