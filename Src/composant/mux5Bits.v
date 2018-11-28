module mux5(in1, in2, ctrl, out);//Generic mux ???

input [4:0]in1, in2;
input ctrl;
output [4:0]out; 

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