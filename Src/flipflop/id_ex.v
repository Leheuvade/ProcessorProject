module id_ex(
	flush, 
	clock
);

input clock, flush;

reg [31:0]readData1, readData2, address, pc;
reg [0:8]controlBits;
reg [4:0]rt, rs, rd;
reg [1:0]aluCtrl;
reg aluSrc, memRead, branch;

always @ (posedge clock) begin
	if (flush) begin
		controlBits <= 0;
		aluSrc <= 0;
		memRead <= 0;
		branch <= 0;
	end else begin 
		controlBits <= decode.outControlBits;
		aluSrc <= decode.outControlBits[5];
		memRead <= decode.outControlBits[2];
		branch <= decode.outControlBits[1];
	end
	readData1 <= decode.readData1;
	readData2 <= decode.readData2;
	address <= decode.address;
	aluCtrl <= decode.aluCtrl;
	rd <= decode.rd;
	pc <= if_id.pc;
	rs <= decode.rs;
	rt <= decode.rt;
end

endmodule