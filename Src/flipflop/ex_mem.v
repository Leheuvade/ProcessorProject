module ex_mem(inResult, 
	inPcBranch,
	inPcSrc, 
	inFlushPrevInstruction,
	flush,
	clock, 
	outControlBits_EXMEM, 
	outRegWrite,
	outWord,
	outRd, 
	outPcBranch, 
	outPcSrc, 
	outFlushPrevInstruction
);

input [31:0]inResult, inPcBranch; 
input clock, inPcSrc, flush, inFlushPrevInstruction;
output outWord, outRegWrite, outPcSrc, outFlushPrevInstruction;
output [31:0] outPcBranch;
output [4:0]outRd;
output [0:8]outControlBits_EXMEM;

reg memWrite, memRead, outWord, outRegWrite, outPcSrc, outFlushPrevInstruction;
reg [31:0]result, readData2; 
reg outPcBranch;
reg outRd;
reg outControlBits_EXMEM;

always @ (posedge clock) begin
	if (flush) begin 
		memRead <= 0;
		outControlBits_EXMEM <= 0;
		memWrite <= 0;
		outWord <= 0;
		outRegWrite <= 0;
	end else begin 
		memRead <= id_ex.controlBits[2];
		outControlBits_EXMEM <= id_ex.controlBits;
		memWrite <=  id_ex.controlBits[4];
		outWord <= id_ex.controlBits[8];
		outRegWrite <= id_ex.controlBits[6];
	end 
	result <= inResult;
	readData2 <= id_ex.readData2;
	outRd <= id_ex.rd;
	outPcBranch <= inPcBranch;
	outPcSrc <= inPcSrc;
	outFlushPrevInstruction <= inFlushPrevInstruction;
end

endmodule