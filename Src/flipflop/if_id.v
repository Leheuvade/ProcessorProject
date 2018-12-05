module if_id(inInstr, inPc, write, rst, clock, outInstr, outPc);

input [31:0]inInstr, inPc; 
input clock, write, rst;
output [31:0]outInstr, outPc;

wire clock, rst;
wire inInstr, inPc;
reg outInstr, outPc;

always @ (posedge clock) begin
	if (rst) begin
		outInstr <= 0;
	 	outPc <= 0;
	end else if (write) begin
	  outInstr <= inInstr;
	  outPc <= inPc;
	end
end

endmodule