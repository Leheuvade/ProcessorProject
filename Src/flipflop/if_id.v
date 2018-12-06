module if_id(inInstr, inPc, write, rst, flush, clock, outInstr, outPc);

input [31:0]inInstr, inPc; 
input clock, write, rst, flush;
output [31:0]outInstr, outPc;

wire clock, rst, flush;
wire inInstr, inPc;
reg outInstr, outPc;

always @ (posedge clock) begin
	if (rst || flush) begin
		outInstr <= 32'bx00000000000000000000000000;
	 	outPc <= 0;
	end else if (write) begin
	  outInstr <= inInstr;
	  outPc <= inPc;
	end
end

endmodule