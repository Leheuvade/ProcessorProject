module mux(in1, in2, ctrl, out);

input [4:0]in1, in2;
input ctrl;
output [0:4]out; 

reg out; 
wire in1, in2, ctrl;

always @(in1 or in2 or ctrl) begin
	if (ctrl == 1) begin 
		out <= in2;
	end else begin
		out <= in1;
	end
end

endmodule