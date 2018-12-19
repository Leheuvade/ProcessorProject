module ex_mem(inResult, 
	inPcBranch,
	inPcSrc, 
	inFlushPrevInstruction,
	flush,
	clock, 
	outPcBranch, 
	outPcSrc, 
	outFlushPrevInstruction
);

input [31:0]inResult, inPcBranch; 
input clock, inPcSrc, flush, inFlushPrevInstruction;
output outPcSrc, outFlushPrevInstruction;
output [31:0] outPcBranch;

reg memWrite, memRead, word, regWrite, outPcSrc, outFlushPrevInstruction;
reg [31:0]result, readData2; 
reg outPcBranch;
reg [4:0]rd;
reg [0:8]controlBits;

always @ (posedge clock) begin
	if (flush) begin 
		memRead <= 0;
		controlBits <= 0;
		memWrite <= 0;
		word <= 0;
		regWrite <= 0;
	end else begin 
		memRead <= id_ex.controlBits[2];
		controlBits <= id_ex.controlBits;
		memWrite <=  id_ex.controlBits[4];
		word <= id_ex.controlBits[8];
		regWrite <= id_ex.controlBits[6];
	end 
	result <= inResult;
	readData2 <= id_ex.readData2;
	rd <= id_ex.rd;
	outPcBranch <= inPcBranch;
	outPcSrc <= inPcSrc;
	outFlushPrevInstruction <= inFlushPrevInstruction;
end

endmodule