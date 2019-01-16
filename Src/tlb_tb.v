`include "TLB/tlb.v"
`include "TLB/preprocessor_directives.v"
module tlb_tb;

   wire [31:0] virtual_address_i;
   reg [31-`OFFSET:0] virtual_page_i;
   wire [`PHYS_ADDR_SIZE-1:0] phys_address_o;
   wire 		      ready_o;
   wire 		      tlb_miss_o;
   reg 			      privilege_i;
   
   // For modifying the tlb
   reg [31-`OFFSET:0] 	      w_virtual_page_i;
   reg [31-`OFFSET:0] 	      w_phys_page_i;
   reg 			      write_enable_i;
   reg 			      clock;

   assign virtual_address_i = {virtual_page_i, `OFFSET'b0};

   tlb DUT( .clock(clock),
	    .virtual_address_i(virtual_address_i),
	    .phys_address_o(phys_address_o),
 	    .ready_o(ready_o),
	    .tlb_miss_o(tlb_miss_o),
 	    .privilege_i(privilege_i),
   
	    // For modifying the tlb
  	    .w_virtual_page_i(w_virtual_page_i),
  	    .w_phys_page_i(w_phys_page_i),
 	    .write_enable_i(write_enable_i));
   
initial begin
   clock = 0;
   forever #1 clock = ~clock;
end

   initial begin
   $dumpfile("test.vcd");
   $dumpvars(0,tlb_tb);
   virtual_page_i = 0;
   privilege_i = 0;
   w_virtual_page_i = 0;
   w_phys_page_i = 0;
   write_enable_i = 0;
   // A - Empty tlb
   
   #2 // Random address
     virtual_page_i = 32'b1;
   #2 // Random address with privilege
     privilege_i = 0;
   #2 // Random address with privilege and noise
     w_virtual_page_i = 546;
   w_phys_page_i = 6856;
   #2 // Random address with noise
     privilege_i = 1;

   // B - Non-empty tlb

   #2
     virtual_page_i = 0;
   w_phys_page_i = 4;
   w_virtual_page_i = 2;
   write_enable_i = 1;
   #2 // Writing with no privilege (should be allowed)
     privilege_i = 0;
   w_phys_page_i = 5;
   w_virtual_page_i = 3;
   #2 // Writing with virtual_page_i non null
     virtual_page_i = 45;
        w_phys_page_i = 6;
   w_virtual_page_i = 4;
   #2 // Getting tlb from previous write
     write_enable_i = 0;
   virtual_page_i = 2;
   #2 // Same with privilege (should return same value as input)
     privilege_i = 1;
   #2 // Multiple writes
     write_enable_i = 1;
   w_phys_page_i = 7;
   w_virtual_page_i = 5;
   #2
     w_phys_page_i = 8;
   w_virtual_page_i = 6;
   #2
     w_phys_page_i = 9;
   w_virtual_page_i = 7;
   #2
     w_phys_page_i = 10;
   w_virtual_page_i = 8;
   $finish;
end
endmodule
