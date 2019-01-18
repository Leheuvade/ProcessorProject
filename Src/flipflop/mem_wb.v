module mem_wb( 
	input clock,
	       input wire dtlb_miss,
	       input wire dtlb_ready
);

reg [31:0]result, readData;
reg [4:0]rd;
reg memToReg, regWrite;
wire clear = stall_control.bubble_at_wb;
   wire we = ~ stall_control.stall_at_wb;
reg exception;
   reg [31:0] faulty_address;
   reg [31:0] pc;

wire should_raise_exception = (ex_mem.exception || (dtlb_miss && dtlb_ready && cache.enable));
   
always @ (posedge clock)begin 
   if (!we) begin
      $display("Stall at wb");
   end else if (clear) begin 
		result <= 32'bx;
		readData <= 32'bx;
		rd <= 5'bx;
		memToReg <= 1'bx;
		regWrite <= 1'bx;
	   exception <= 0;
	   faulty_address <= 0;
	   pc <= 0;
   end else begin
		result <= ex_mem.result;
		readData <= cache.readData;
		rd <= ex_mem.rd;
		memToReg <= ex_mem.memToReg;
		regWrite <= ex_mem.regWrite;
	   pc <= ex_mem.pc;
	   exception <= should_raise_exception;
	   if (ex_mem.exception) faulty_address <= ex_mem.faulty_address;
	   else if (dtlb_miss && dtlb_ready && cache.enable) faulty_address <= cache.address;
   end
 end

endmodule
