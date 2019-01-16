module id_ex(
	clock
);

input clock;

reg [31:0]readData1, readData2, address, pc;
reg [4:0]rt, rs, rd;
reg [1:0]aluCtrl;
reg we;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, word;

always @ (posedge clock) begin
	if (we) begin
		if (ex_mem.flushPrevInstr) begin
			regDst <= 0; 
			branch <= 0;
			memRead <= 0;
			memToReg <= 0;
			memWrite <= 0; 
			aluSrc <= 0;
			regWrite <= 0;
			word <= 0;
		end else begin 
			regDst <= decode.regDst; 
			branch <= decode.branch;
			memRead <= decode.memRead;
			memToReg <= decode.memToReg;
			memWrite <= decode.memWrite; 
			aluSrc <= decode.aluSrc;
			regWrite <= decode.regWrite;
			word <= decode.word;
		end
		readData1 <= decode.file_register.readData1;
		readData2 <= decode.file_register.readData2;
		address <= decode.address;
		aluCtrl <= decode.aluControl.aluCtrl;
		rd <= decode.rd;
		pc <= if_id.pc;
		rs <= decode.rs;
		rt <= decode.rt;
	end
end

endmodule