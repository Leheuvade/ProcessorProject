module ex_mem(inResult, 
	inReadRegister2, 
	inControlBits_IDEX, 
	inRd, 
	clock, 
	outResult, 
	outReadRegister2, 
	outMemRead,
	outControlBits_EXMEM, 
	outMemWrite, 
	outRegWrite,
	outWord,
	outRd
);

input [31:0]inResult, inReadRegister2; 
input clock;
input [4:0]inRd;
input [0:8]inControlBits_IDEX;
output outMemRead, outMemWrite, outWord, outRegWrite;
output [31:0]outResult, outReadRegister2;
output [4:0]outRd;
output [0:8]outControlBits_EXMEM;

reg outMemWrite, outMemRead, outWord, outRegWrite;
reg outResult, outReadRegister2;
reg outRd;
reg outControlBits_EXMEM;

always @ (posedge clock) begin
	outResult <= inResult;
	outReadRegister2 <= inReadRegister2;
	outMemRead <= inControlBits_IDEX[2];
	outControlBits_EXMEM <= inControlBits_IDEX;
	outMemWrite <= inControlBits_IDEX[4];
	outRd <= inRd;
	outWord <= inControlBits_IDEX[8];
	outRegWrite <= inControlBits_IDEX[6];
end

endmodule