module if_id(
	     input clock,
	     input itlb_miss,
	     input itlb_ready);

reg rst;
reg we;
reg clear;
reg weFromHazard;
wire flush;
reg [31:0]instruction, pc, pcJump;
   reg 	  exception;
   reg [31:0]	  faulty_address;
	
assign flush = ex_mem.flushPrevInstr || decode.jump;
always @ (posedge clock) begin
	if (rst || flush || clear) begin
		instruction <= 32'bx00000000000000000000000000;
	 	pc <= 0;
	 	pcJump <= 0;
	   exception <= 0;
	   faulty_address <= 0;
	end else if (we && weFromHazard) begin
	  instruction <= fetch.instruction;
	  pc <= fetch.pcIncr;
	  pcJump <= fetch.pcJump;
	   exception <= itlb_miss && itlb_ready;
	   faulty_address <= (itlb_miss && itlb_ready)? pc.pc : 0;
	end
end

endmodule
