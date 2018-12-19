module mem_wb( 
	clock,
	outRegWrite
);

input clock;
output outMemToReg, outRegWrite;

reg [31:0]result, readData;
reg [4:0]rd;
reg memToReg, outRegWrite;

always @ (posedge clock)begin 
	result <= ex_mem.result;
	readData <= memory.readData;
	rd <= ex_mem.rd;
	memToReg <= ex_mem.controlBits[3];
	outRegWrite <= ex_mem.controlBits[6];
 end

endmodule