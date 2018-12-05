module mem_wb(inResult, 
	inReadData, 
	inRd, 
	inControlBits_EXMEM,
	clock, 
	outResult, 
	outReadData, 
	outRd, 
	outMemToReg, 
	outRegWrite
);

input [31:0]inResult, inReadData; 
input [4:0]inRd;
input [0:8]inControlBits_EXMEM;
input clock;
output [31:0]outResult, outReadData;
output [4:0]outRd;
output outMemToReg, outRegWrite;

wire [0:8]inControlBits_EXMEM;
reg outResult, outReadData;
reg outRd;
reg outMemToReg, outRegWrite;

always @ (posedge clock)begin 
	outResult <= inResult;
	outReadData <= inReadData;
	outRd <= inRd;
	outMemToReg <= inControlBits_EXMEM[3];
	outRegWrite <= inControlBits_EXMEM[6];
 end

endmodule