module pc(inPC, rst, write, clock, outPC);

input [31:0]inPC; 
input clock, rst, write;
output [31:0]outPC;

wire clock, rst;
wire inPC;
reg outPC;

always @ (posedge clock) begin
	if (rst) begin
		outPC <= 0;
	end else if (write) begin 
		outPC <= inPC;
	end
end

endmodule
