module if_id(in, clock, out);

input [31:0]in; 
input clock;
output [31:0]out;

wire clock;
wire in;
reg out;

always @ (posedge clock)
  out <= in;


endmodule