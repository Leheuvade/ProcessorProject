module mem_wb( 
	clock
);

input clock;

reg [31:0]result, readData;
reg [4:0]rd;
reg memToReg, regWrite;

always @ (posedge clock)begin
   if (stall_control.bubble_at_wb) begin
	result <= 0;
	readData <= 0;
	rd <= 0;
	memToReg <= 0;
	regWrite <= 0;
   end else begin
        result <= ex_mem.result;
	readData <= memory.readData;
	rd <= ex_mem.rd;
	memToReg <= ex_mem.memToReg;
	regWrite <= ex_mem.regWrite;
   end
 end

endmodule
