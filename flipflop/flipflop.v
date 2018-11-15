module flipflop (
d,
q, 
clock
);

input [14:0]d;
input clock;
output [14:0]q;

wire d, clock;
reg q;

always @ (posedge clock)
q <= d;
endmodule
