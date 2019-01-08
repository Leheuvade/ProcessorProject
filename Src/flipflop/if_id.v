module if_id(rst, clock);

input clock, rst;

wire we = !stall_control.stall_at_decode;
wire flush = stall_control.bubble_at_decode;
reg [31:0]instruction, pc, pcJump;
	
always @ (posedge clock) begin
	if (rst || flush) begin
		instruction <= 32'bx00000000000000000000000000;
	 	pc <= 0;
	 	pcJump <= 0;
	end else if (we) begin
	  instruction <= fetch.instruction;
	  pc <= fetch.pcIncr;
	  pcJump <= fetch.pcJump;
	end
end

endmodule
