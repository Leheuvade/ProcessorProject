module mem_wb( 
	clock
);

input clock;

reg [31:0]result, readData;
reg [4:0]rd;
reg memToReg, regWrite;
reg clear;

always @ (posedge clock)begin 
	if (clear) begin 
		result <= 32'bx;
		readData <= 32'bx;
		rd <= 5'bx;
		memToReg <= 1'bx;
		regWrite <= 1'bx;
	end else begin
		result <= ex_mem.result;
		readData <= memory.readData;
		rd <= ex_mem.rd;
		memToReg <= ex_mem.memToReg;
		regWrite <= ex_mem.regWrite;
	end
 end

endmodule