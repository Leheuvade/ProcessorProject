module ex_mem( 
	clock
);

input clock;

reg memWrite, memRead, word, regWrite, memToReg, pcSrc;
reg [31:0]result, readData2, pcBranch; 
reg [4:0]rd;

always @ (posedge clock) begin
	if (stall_control.bubble_at_memory) begin 
		memRead <= 0;
		memWrite <= 0;
		word <= 0;
		memToReg <= 0;
		regWrite <= 0;
	        result <= 0;
	        readData2 <= 0;
	        rd <= 0;
	        pcBranch <= 0;
	        pcSrc <= 0;
	end else if (~stall_control.stall_at_memory) begin 
		memRead <= id_ex.memRead;
		memWrite <=  id_ex.memWrite;
		word <= id_ex.word;
		memToReg <= id_ex.memToReg;
		regWrite <= id_ex.regWrite;
	        result <= exec.result;
	        readData2 <= id_ex.readData2;
	        rd <= id_ex.rd;
	        pcBranch <= exec.resultBranch;
	        pcSrc <= exec.pcSrc;
	end
end

endmodule
