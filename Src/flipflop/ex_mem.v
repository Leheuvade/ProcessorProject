module ex_mem(inResult, 
	inReadRegister2, 
	inControlBits_IDEX, 
	inRd, 
	inPcBranch,
	inPcSrc, 
	inFlushPrevInstruction,
	flush,
	clock, 
	outResult, 
	outReadRegister2, 
	outMemRead,
	outControlBits_EXMEM, 
	outMemWrite, 
	outRegWrite,
	outWord,
	outRd, 
	outPcBranch, 
	outPcSrc, 
	outFlushPrevInstruction
);

input [31:0]inResult, inReadRegister2, inPcBranch; 
input clock, inPcSrc, flush, inFlushPrevInstruction;
input [4:0]inRd;
input [0:8]inControlBits_IDEX;
output outMemRead, outMemWrite, outWord, outRegWrite, outPcSrc, outFlushPrevInstruction;
output [31:0]outResult, outReadRegister2, outPcBranch;
output [4:0]outRd;
output [0:8]outControlBits_EXMEM;

reg outMemWrite, outMemRead, outWord, outRegWrite, outPcSrc, outFlushPrevInstruction;
reg outResult, outReadRegister2, outPcBranch;
reg outRd;
reg outControlBits_EXMEM;

always @ (posedge clock) begin
	if (flush) begin 
		outMemRead <= 0;
		outControlBits_EXMEM <= 0;
		outMemWrite <= 0;
		outWord <= 0;
		outRegWrite <= 0;
	end else begin 
		outMemRead <= inControlBits_IDEX[2];
		outControlBits_EXMEM <= inControlBits_IDEX;
		outMemWrite <= inControlBits_IDEX[4];
		outWord <= inControlBits_IDEX[8];
		outRegWrite <= inControlBits_IDEX[6];
	end 
	outResult <= inResult;
	outReadRegister2 <= inReadRegister2;
	outRd <= inRd;
	outPcBranch <= inPcBranch;
	outPcSrc <= inPcSrc;
	outFlushPrevInstruction <= inFlushPrevInstruction;
end

endmodule