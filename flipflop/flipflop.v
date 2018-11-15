module flipflop (
d,
q, 
clock
);

input [2:0]d;
input clock;
output [2:0]q;

wire d, clock;
reg q;

always @ (posedge clock)
q <= d;
endmodule
