module adderBranch(address, pcIncr, result);

input [31:0]address, pcIncr;
output [31:0]result;

reg [31:0]shiftAddress;
reg result;

always @(address or pcIncr) begin
	shiftAddress = address << 2;
	result = shiftAddress + pcIncr;
end

endmodule