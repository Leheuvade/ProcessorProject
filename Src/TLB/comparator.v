module comparator(input wire [SIZE-1:0] cmp1,
		  input wire [SIZE-1:0]        cmp2,
		  input 		       valid,
		  output reg		       found,
		  output reg [INDEX_SIZE-1:0] out_index);
   parameter SIZE = 32;
   parameter INDEX = 0;
   parameter INDEX_SIZE = 1;
   
   always @ (*) begin
      if (cmp1 == cmp2 && valid) begin
	 found = 1;
	 out_index = INDEX;
	 $display("TLB comparator found valid page with index = %x", INDEX);
      end else begin
	 found = 0;
	 out_index = 0;
      end
   end
endmodule
