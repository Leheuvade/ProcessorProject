module if_id(rst, clock);

input clock, rst;

wire we;
reg [31:0]instruction, pc;

always @ (posedge clock) begin
	if (rst || ex_mem.flushPrevInstr) begin
		instruction <= 32'bx00000000000000000000000000;
	 	pc <= 0;
	end else if (we) begin
	  instruction <= fetch.instruction;
	  pc <= fetch.pcIncr;
	end
end

endmodule