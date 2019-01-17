`include "TLB/comparator.v"
`include "TLB/preprocessor_directives.v"
`include "TLB/or_module.v"
module tlb(input wire clock,
	   input wire [31:0] 		     virtual_address_i,
	   output wire [`PHYS_ADDR_SIZE-1:0] phys_address_o,
	   output reg 			     ready_o,
	   output reg 			     tlb_miss_o,
	   input wire 			     privilege_i,
	   
	   // For modifying the tlb
	   input wire [31-OFFSET:0] 	     w_virtual_page_i,
	   input wire [31-OFFSET:0] 	     w_phys_page_i,
	   input wire 			     write_enable_i
	   );

   reg [31-OFFSET:0] 			    virtual_page[0:TLB_SIZE-1];
   reg [`PHYS_ADDR_SIZE-1-OFFSET:0] 	    phys_page[0:TLB_SIZE-1];
   reg 					    valid[0:TLB_SIZE-1];

   parameter OFFSET = `OFFSET;
   parameter TLB_SIZE = `TLB_SIZE;
   localparam INDEX_SIZE = $clog2(TLB_SIZE);
   
   wire [INDEX_SIZE-1:0] 		    TLB_index;
   wire [TLB_SIZE-1:0] 			    found;

   wire [31-OFFSET:0]				    virtual_page_i = virtual_address_i[31:OFFSET];
   reg [`PHYS_ADDR_SIZE-1-OFFSET:0] 		    phys_page_o;
   wire [INDEX_SIZE-1:0] 			    out_index[0:TLB_SIZE-1];
   wire [INDEX_SIZE-1:0] 			    out_index_ored[0:TLB_SIZE-1];
   
   reg [INDEX_SIZE-1:0] 			    TLB_write_index;
   //always@(*) TLB_write_index = out_index_ored[`TLB_SIZE-1];

   integer 					    j;
   initial begin
      TLB_write_index = 0;
      phys_page_o = 0;
      for (j = 0; j < TLB_SIZE; j = j + 1) begin
	 virtual_page[j] = 0;
	 phys_page[j] = 0;
	 valid[j] = 0;
      end
   end
      
   assign phys_address_o = {phys_page_o, virtual_address_i[OFFSET-1:0]};
   assign out_index_ored[0] = out_index[0];

   generate
      genvar 				    i;
      for (i = 0; i < TLB_SIZE; i = i + 1) begin
	 comparator #(
		      .SIZE(32-OFFSET),
		      .INDEX(i),
		      .INDEX_SIZE(INDEX_SIZE)) comparator (.cmp1(virtual_page_i),
							   .cmp2(virtual_page[i]),
							   .valid(valid[i]),
							   .found(found[i]),
							   .out_index(out_index[i]));
	 if (i>=1) begin
	    or_module #(.SIZE(INDEX_SIZE)) or_instance(out_index_ored[i],out_index_ored[i-1], out_index[i]); // Remarque : on pourrait le faire logarithmiquement
	 end
      end
   endgenerate

   assign TLB_index = out_index_ored[TLB_SIZE-1];

   always@(*) begin
      phys_page_o = 0;
      tlb_miss_o = 1;
      if (privilege_i) begin
	 phys_page_o = virtual_page_i;
	 tlb_miss_o = 0;
      end else if (found!=0) begin
	    phys_page_o = phys_page[TLB_index];
	    tlb_miss_o = 0;
      end 
      ready_o = 1;
   end 

   always@(posedge clock) begin
      if (write_enable_i) begin
	 virtual_page[TLB_write_index] <= w_virtual_page_i;
	 phys_page[TLB_write_index] <= w_phys_page_i;
	 valid[TLB_write_index] <= 1;
	 TLB_write_index <= TLB_write_index + 1;
      end
   end
   
endmodule
