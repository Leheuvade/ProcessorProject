module if_id(
	     input clock,
	     input itlb_miss,
	     input itlb_ready);

reg [31:0]instruction, pc, pcJump;
   reg 	  exception;
   reg [31:0]	  faulty_address;
   wire 	  we = ~ stall_control.stall_at_decode;
   wire 	  rst = ~stall_control.bubble_at_decode;
	
always @ (posedge clock) begin
	if (!we) begin
	   $display("Stall at decode");
	end else if (rst) begin
	   $display("Bubble at decode");
		instruction <= 32'bx00000000000000000000000000;
	 	pc <= 0;
	 	pcJump <= 0;
	   exception <= 0;
	   faulty_address <= 0;
	end else  begin
	  instruction <= fetch.instruction;
	  pc <= pc.pc;
	  pcJump <= fetch.pcJump;
	   exception <= itlb_miss && itlb_ready;
	   faulty_address <= (itlb_miss && itlb_ready)? pc.pc : 0;
	end
end

endmodule
