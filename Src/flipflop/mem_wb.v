module mem_wb( 
	inReadData, 
	inRd, 
	clock, 
	outResult, 
	outReadData, 
	outRd, 
	outMemToReg, 
	outRegWrite
);

input [31:0]inReadData; 
input [4:0]inRd;
input clock;
output [31:0]outResult, outReadData;
output [4:0]outRd;
output outMemToReg, outRegWrite;

reg outResult, outReadData;
reg outRd;
reg outMemToReg, outRegWrite;

always @ (posedge clock)begin 
	outResult <= ex_mem.result;
	outReadData <= inReadData;
	outRd <= inRd;
	outMemToReg <= ex_mem.controlBits[3];
	outRegWrite <= ex_mem.controlBits[6];
 end

endmodule