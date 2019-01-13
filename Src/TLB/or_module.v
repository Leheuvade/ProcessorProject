module or_module(output reg[SIZE-1:0] rslt,
	  input wire[SIZE-1:0] in_1,
	  input wire[SIZE-1:0] in_2);
   parameter SIZE = 3;

   always @ (*) begin
      rslt = in_1 | in_2;
   end
endmodule
