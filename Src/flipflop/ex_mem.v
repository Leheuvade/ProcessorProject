module ex_mem(inResult, 
	inPcBranch,
	inPcSrc, 
	inFlushPrevInstruction,
	flush,
	clock, 
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

input [31:0]inResult, inPcBranch; 
input clock, inPcSrc, flush, inFlushPrevInstruction;
output outMemRead, outMemWrite, outWord, outRegWrite, outPcSrc, outFlushPrevInstruction;
output [31:0]outReadRegister2, outPcBranch;
output [4:0]outRd;
output [0:8]outControlBits_EXMEM;

reg outMemWrite, outMemRead, outWord, outRegWrite, outPcSrc, outFlushPrevInstruction;
reg [31:0]result; 
reg outReadRegister2, outPcBranch;
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
		outMemRead <= id_ex.controlBits[2];
		outControlBits_EXMEM <= id_ex.controlBits;
		outMemWrite <=  id_ex.controlBits[4];
		outWord <= id_ex.controlBits[8];
		outRegWrite <= id_ex.controlBits[6];
	end 
	result <= inResult;
	outReadRegister2 <= id_ex.readData2;
	outRd <= id_ex.rd;
	outPcBranch <= inPcBranch;
	outPcSrc <= inPcSrc;
	outFlushPrevInstruction <= inFlushPrevInstruction;
end

endmodule