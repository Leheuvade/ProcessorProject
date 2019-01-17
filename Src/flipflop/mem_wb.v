module mem_wb( 
	input clock,
	       input wire dtlb_miss,
	       input wire dtlb_ready
);

reg [31:0]result, readData;
reg [4:0]rd;
reg memToReg, regWrite;
reg clear;
reg exception;
   reg [31:0] faulty_address;
   reg [31:0] pc;
   
always @ (posedge clock)begin 
	if (clear) begin 
		result <= 32'bx;
		readData <= 32'bx;
		rd <= 5'bx;
		memToReg <= 1'bx;
		regWrite <= 1'bx;
	   exception <= 0;
	   faulty_address <= 0;
	   pc <= 0;
	end else begin
		result <= ex_mem.result;
		readData <= cache.readData;
		rd <= ex_mem.rd;
		memToReg <= ex_mem.memToReg;
		regWrite <= ex_mem.regWrite;
	   pc <= ex_mem.pc;
	   exception <= ex_mem.exception || (dtlb_miss && dtlb_ready && memory.enable);
	   if (ex_mem.exception) faulty_address <= ex_mem.faulty_address;
	   else if (dtlb_miss && dtlb_ready && memory.enable) faulty_address <= memory.address;
	end
 end

endmodule
