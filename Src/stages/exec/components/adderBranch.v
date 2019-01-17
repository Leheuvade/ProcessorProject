module adderBranch(address, pcIncr, result);

input [31:0]address, pcIncr;
output reg [31:0]result;

reg [31:0]shiftAddress;

always @(address or pcIncr) begin
	shiftAddress = address << 2;
	result = shiftAddress + pcIncr;
end

endmodule
