module ex_mem( 
	clock
);

input clock;

reg memWrite, memRead, word, regWrite, memToReg, pcSrc, flushPrevInstr;
reg [31:0]result, readData2, pcBranch; 
reg [4:0]rd;

always @ (posedge clock) begin
	if (flushPrevInstr) begin 
		memRead <= 0;
		memWrite <= 0;
		word <= 0;
		memToReg <= 0;
		regWrite <= 0;
	end else begin 
		memRead <= id_ex.memRead;
		memWrite <=  id_ex.memWrite;
		word <= id_ex.word;
		memToReg <= id_ex.memToReg;
		regWrite <= id_ex.regWrite;
	end 
	result <= exec.result;
	readData2 <= id_ex.readData2;
	rd <= id_ex.rd;
	pcBranch <= exec.resultBranch;
	pcSrc <= exec.pcSrc;
	flushPrevInstr <= exec.flushPrevInstr;
end

endmodule