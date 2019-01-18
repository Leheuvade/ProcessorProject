`include "stages/cache/components/dataCache.v"

module cache(
	     		     input wire [31-`OFFSET:0] 	       dtlb_w_virtual_page_i,
		     input wire [31-`OFFSET:0] 	       dtlb_w_phys_page_i,
		     input wire 		       dtlb_write_enable_i,
		     output wire 		       dtlb_miss,
		     output wire 		       dtlb_ready,
		     input wire 		       privilege,
	     output d_cache_miss,
	     output enable_write_from_d_cache_to_memory
	     );
   

reg [31:0]readData;
reg waitData, writeData;
wire [31:0]address = ex_mem.result;
wire [31:0]write_data = ex_mem.readData2;
wire memRead = ex_mem.memRead;
wire memWrite = ex_mem.memWrite;
wire word = ex_mem.word;

   assign enable_write_from_d_cache_to_memory = dataCache.dirtyEvict;
   assign d_cache_miss = miss && (memRead || memWrite);

initial begin
	waitData = 0;
	writeData = 0;
end 
   wire 					  enable = (memRead || memWrite) && !ex_mem.exception;
   wire [`PHYS_ADDR_SIZE-1:0] phys_address;
   wire [31:0] virtual_address = enable ? address : 0;

   tlb dtlb(  .clock(clock),
	      .virtual_address_i(virtual_address),
	      .phys_address_o(phys_address),
  	      .ready_o(dtlb_ready),
  	      .tlb_miss_o(dtlb_miss),
	      .privilege_i(privilege),
      
	      // For modifying the tlb
	      .w_virtual_page_i(dtlb_w_virtual_page_i),
	      .w_phys_page_i(dtlb_w_phys_page_i),
 	      .write_enable_i(dtlb_write_enable_i)
	      );

   
dataCache dataCache(.address(phys_address), .miss(miss));

always @(miss or dataCache.data or memRead or memWrite or write_data or dataCache.dirtyEvict) begin 
	if(memRead || memWrite) begin
		if(writeData == 0) begin
			if (dataCache.dirtyEvict == 1) begin
				arb.reqW = 1;
				arb.writeAddr = address;
				arb.writeData = dataCache.lineToSaveToMem;
				writeData = 1;
			end
		end else begin
		end

		if (waitData == 0) begin
			if (miss == 0) begin
				readData = dataCache.data; //Voir pour LDWByte
			end else begin
				arb.reqD = 1;
				arb.reqAddrD = address;
				waitData = 1;
			end
		end else begin
		end
	end
end

endmodule 
