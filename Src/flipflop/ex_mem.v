module ex_mem( 
	clock
);

input clock, inPcSrc;
output outFlushPrevInstruction;

reg memWrite, memRead, word, regWrite, pcSrc, flushPrevInstr;
reg [31:0]result, readData2, pcBranch; 
reg [4:0]rd;
reg [0:8]controlBits;

always @ (posedge clock) begin
	if (flushPrevInstr) begin 
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
	result <= exec.result;
	readData2 <= id_ex.readData2;
	rd <= id_ex.rd;
	pcBranch <= exec.resultBranch;
	pcSrc <= exec.pcSrc;
	flushPrevInstr <= exec.flushPrevInstr;
end

endmodule