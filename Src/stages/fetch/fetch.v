`include "preprocessor_directives.v"
`include "stages/fetch/components/instCache.v"
`include "TLB/tlb.v"
module fetch(
	     input wire [31-`OFFSET:0] 	       itlb_w_virtual_page_i,
	     input wire [31-`OFFSET:0] 	       itlb_w_phys_page_i,
	     input wire 		       itlb_write_enable_i,
	     output wire 		       itlb_miss,
	     output wire 		       itlb_ready,
	     input wire 		       privilege,
	     output wire [`PHYS_ADDR_SIZE-1:0] phys_address,
	     output 			       instruction_not_ready
);

reg [31:0]instruction;
wire [31:0]pcIncr;
wire [31:0]pcJump;
wire miss;

assign pcJump = {pcIncr[31:28], instruction[25:0]<<2};
assign pcIncr = pc.pc + 4;

   assign instruction_not_ready = miss && ~itlb_miss;
   

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

instCache instCache(.address(phys_address), .miss(miss));

   assign waitInstr = miss || instCache.data;
   
   
always @(*) begin
	if (!waitInstr) begin
		if (miss == 0) begin
		   instruction = instCache.data;
		end else begin
		   if (!itlb_miss) begin
		      $display("Cache miss for pc %x and phys %x", pc.pc, phys_address);
		      arb.reqI = 1;
		      arb.reqAddrI = phys_address;
		   end
		end
	end
/*	end else begin // if (waitInst == 0)
	   $display("Wait Inst");
	end*/
end

endmodule

