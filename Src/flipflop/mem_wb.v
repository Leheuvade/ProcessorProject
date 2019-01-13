module mem_wb( 
	       input clock,
	       input wire dtlb_miss,
	       input wire dtlb_ready
);

reg [31:0]result, readData;
reg [4:0]rd;
reg memToReg, regWrite;
   reg exception;
   reg [31:0] faulty_address;
   reg [31:0] pc;
   reg 	      iret; // TODO : l'incorporer dans quelque contrôle central
         
always @ (posedge clock)begin
   if (stall_control.bubble_at_wb) begin
	result <= 0;
	readData <= 0;
	rd <= 0;
	memToReg <= 0;
	regWrite <= 0;
      exception <= 0;
      faulty_address <= 0;
      pc <= 0;
   end else begin
        result <= ex_mem.result;
	readData <= memory.readData;
	rd <= ex_mem.rd;
	memToReg <= ex_mem.memToReg;
	regWrite <= ex_mem.regWrite;
      pc <= ex_mem.pc;
      exception <= ex_mem.exception || (dtlb_miss && dtlb_ready && memory.enable);
      if (ex_mem.exception) faulty_address <= ex_mem.faulty_address;
      else if (dtlb_miss && dtlb_ready && memory.enable) faulty_address <= memory.address;
   end
 end

endmodule
