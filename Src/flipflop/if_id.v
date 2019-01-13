module if_id(input rst, 
	     input clock,
	     input itlb_miss,
	     input itlb_ready);

wire we = !stall_control.stall_at_decode;
wire flush = stall_control.bubble_at_decode;
reg [31:0]instruction, pc, pcJump;
   reg 	  exception;
   reg [31:0]	  faulty_address;
   	
always @ (posedge clock) begin
	if (rst || flush) begin
		instruction <= 32'bx00000000000000000000000000;
	 	pc <= 0;
	 	pcJump <= 0;
	   exception <= 0;
	   faulty_address <= 0;
	end else if (we) begin
	  instruction <= fetch.instruction;
	  pc <= fetch.pcIncr;
	  pcJump <= fetch.pcJump;
	   exception <= itlb_miss && itlb_ready;
	   faulty_address <= (itlb_miss && itlb_ready)? pc.pc : 0;
	end
end

endmodule
