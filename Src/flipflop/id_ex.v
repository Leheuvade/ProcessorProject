module id_ex(
	     input wire clock,
	     input wire privilege
);

reg [31:0]readData1, readData2, address, pc;
reg [4:0]rt, rs, rd;
reg [1:0]aluCtrl;
reg we;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, word;
   reg exception;
   reg [31:0] faulty_address;
   reg 	      ignore_op2, iret, tlb_write;

always@(iret) begin
   if(iret) begin
      fetch.waitInst = 1;
   end
end
   
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
		   ignore_op2 <= 0;
	        iret <= 0;
	        tlb_write <= 0;

	   exception <= 0;
	   faulty_address <= 0;
		end else begin 
			regDst <= decode.regDst; 
			branch <= decode.branch;
			memRead <= decode.memRead;
			memToReg <= decode.memToReg;
			memWrite <= decode.memWrite; 
			aluSrc <= decode.aluSrc;
			regWrite <= decode.regWrite;
			word <= decode.word;
		   exception <= if_id.exception || (!privilege && decode.control.tlb_write);
	   faulty_address <= if_id.faulty_address;
	   ignore_op2 <= decode.control.ignore_op2;
	   iret <= decode.control.iret;
	   tlb_write <= decode.control.tlb_write;
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
