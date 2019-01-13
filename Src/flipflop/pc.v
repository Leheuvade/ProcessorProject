`include "preprocessor_directives.v"
module pc(rst, clock);

input clock, rst;

wire we = ~stall_control.stall_at_fetch;
reg [31:0]pc;
wire [31:0]intermediatePc, finalPc;

mux32 getIntermediatePc(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(intermediatePc));
mux32 getFinalPc(.in1(intermediatePc), .in2(if_id.pcJump), .ctrl(decode.jump), .out(finalPc));
   wire [32:0] pc_with_exceptions = mem_wb.exception? `EXCEPTIONS_ADDR : finalPc;
   
always @ (posedge clock) begin
	if (rst) begin
		pc <= `BOOT_ADDR;
	end else if (we) begin 
		pc <= finalPc;
	end
end

endmodule
