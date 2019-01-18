module ex_mem( 
	clock
);

input clock;

reg memWrite, memRead, word, regWrite, memToReg, pcSrc;
reg [31:0]result, readData2, pcBranch; 
reg [4:0]rd;
   wire  we = ~stall_control.stall_at_memory;
   wire  rst = stall_control.bubble_at_memory;
   reg 	 exception;
   reg [31:0] faulty_address;   
   reg [31:0] pc;
   
always @ (posedge clock) begin
   if(!we) begin
      $display("Stall at mem");
   end else if (rst) begin
      $display("Bubble at mem");
			memRead <= 0;
			memWrite <= 0;
			word <= 0;
			memToReg <= 0;
			regWrite <= 0;
		   exception <= 0;
	   faulty_address <= 0;
	   pc <= 0;
      result <= 0;
		readData2 <= 0;
		rd <= 0;
		pcBranch <= 0;
		pcSrc <= 0;
   end else begin 
			memRead <= id_ex.memRead;
			memWrite <=  id_ex.memWrite;
			word <= id_ex.word;
			memToReg <= id_ex.memToReg;
			regWrite <= id_ex.regWrite;
		result <= exec.result;
		readData2 <= id_ex.readData2;
		rd <= id_ex.rd;
		pcBranch <= exec.resultBranch;
		pcSrc <= exec.pcSrc;
	   exception <= id_ex.exception;
	   faulty_address <= id_ex.faulty_address;
	   pc <= id_ex.pc;
   end
end

endmodule
