module id_ex(
	clock
);

input clock;

reg [31:0]readData1, readData2, address;
reg [4:0]rt, rs, rd;
reg [1:0]aluCtrl;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, word;
   reg exception;
   reg [31:0] faulty_address;
   reg [31:0] pc;
      
always @ (posedge clock) begin
	if (stall_control.bubble_at_exec) begin
		regDst <= 0; 
		branch <= 0;
		memRead <= 0;
		memToReg <= 0;
		memWrite <= 0; 
		aluSrc <= 0;
		regWrite <= 0;
		word <= 0;

	        // I also set the following to 0 for clock gating (he explained this in the last course I think, it avoids activating gates and wires worthlessly)
	        readData1 <= 0;
	        readData2 <= 0;
	        address <= 0;
	        aluCtrl <= 0;
	        rd <= 0;
	        pc <= 0;
	        rs <= 0;
	        rt <= 0;

	   exception <= 0;
	   faulty_address <= 0;
	end else if (!stall_control.stall_at_exec) begin 
		regDst <= decode.regDst; 
		branch <= decode.branch;
		memRead <= decode.memRead;
		memToReg <= decode.memToReg;
		memWrite <= decode.memWrite; 
		aluSrc <= decode.aluSrc;
		regWrite <= decode.regWrite;
		word <= decode.word;
	        readData1 <= decode.file_register.readData1;
	        readData2 <= decode.file_register.readData2;
	        address <= decode.address;
	        aluCtrl <= decode.aluControl.aluCtrl;
	        rd <= decode.rd;
	        pc <= if_id.pc;
	        rs <= decode.rs;
	        rt <= decode.rt;
	   exception <= if_id.exception;
	   faulty_address <= if_id.faulty_address;
	end
end

endmodule
