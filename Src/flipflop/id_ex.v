module id_ex(
	clock
);

input clock;

reg [31:0]readData1, readData2, address, pc;
reg [0:8]controlBits;
reg [4:0]rt, rs, rd;
reg [1:0]aluCtrl;
reg aluSrc, memRead, branch;

always @ (posedge clock) begin
	if (ex_mem.flushPrevInstr) begin
		controlBits <= 0;
		aluSrc <= 0;
		memRead <= 0;
		branch <= 0;
	end else begin 
		controlBits <= decode.controlBits;
		aluSrc <= decode.controlBits[5];
		memRead <= decode.controlBits[2];
		branch <= decode.controlBits[1];
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

endmodule