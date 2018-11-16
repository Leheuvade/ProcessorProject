module fetch(d, q, clock);

input [31:0]d;
input clock;
output [31:0]q;

wire d, clock;
reg q;

always @ (posedge clock) begin
	q <= d;
end

endmodule
