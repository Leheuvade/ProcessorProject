module mux32Bits3To1(in1, in2, in3, ctrl, out);

input [31:0]in1, in2, in3;
input [1:0]ctrl;
output [31:0]out;

reg out;

always @(in1 or in2 or in3 or ctrl) begin
	if (ctrl == 2'b00) begin
		out = in1;
	end else if (ctrl == 2'b10) begin
		out = in3;
	end else if (ctrl == 2'b01) begin
		out = in2;
	end
end

endmodule