module ex_mem( 
	clock
);

input clock;

reg memWrite, memRead, word, regWrite, memToReg, pcSrc, flushPrevInstr;
reg [31:0]result, readData2, pcBranch; 
reg [4:0]rd;
reg we;
   reg 	 exception;
   reg [31:0] faulty_address;   
   reg [31:0] pc;
   
always @ (posedge clock) begin
	if (we) begin
		if (flushPrevInstr) begin 
			memRead <= 0;
			memWrite <= 0;
			word <= 0;
			memToReg <= 0;
			regWrite <= 0;
		   exception <= 0;
	   faulty_address <= 0;
	   pc <= 0;
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
	   exception <= id_ex.exception;
	   faulty_address <= id_ex.faulty_address;
	   pc <= id_ex.pc;
	end
end

endmodule
