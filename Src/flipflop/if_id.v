module if_id(clock);

input clock;

reg rst;
reg we;
reg clear;
reg weFromHazard;
wire flush;
reg [31:0]instruction, pc, pcJump;
	
assign flush = ex_mem.flushPrevInstr || decode.jump;
always @ (posedge clock) begin
	if (rst || flush || clear) begin
		instruction <= 32'bx00000000000000000000000000;
	 	pc <= 0;
	 	pcJump <= 0;
	end else if (we && weFromHazard) begin
	  instruction <= fetch.instruction;
	  pc <= fetch.pcIncr;
	  pcJump <= fetch.pcJump;
	end
end

endmodule