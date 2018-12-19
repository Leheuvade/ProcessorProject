module ex_mem(inResult, 
	inPcBranch,
	inPcSrc, 
	inFlushPrevInstruction,
	flush,
	clock,  
	outFlushPrevInstruction
);

input [31:0]inResult, inPcBranch; 
input clock, inPcSrc, flush, inFlushPrevInstruction;
output outFlushPrevInstruction;

reg memWrite, memRead, word, regWrite, pcSrc, outFlushPrevInstruction;
reg [31:0]result, readData2, pcBranch; 
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
	pcBranch <= inPcBranch;
	pcSrc <= inPcSrc;
	outFlushPrevInstruction <= inFlushPrevInstruction;
end

endmodule