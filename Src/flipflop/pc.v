`include "preprocessor_directives.v"
module pc(clock);

input clock;

reg rst;
reg we;
reg weFromHazard;
reg [31:0]pc;
wire [31:0]intermediatePc, finalPc;

mux32 getIntermediatePc(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(intermediatePc));
mux32 getFinalPc(.in1(intermediatePc), .in2(if_id.pcJump), .ctrl(decode.jump), .out(finalPc));
   wire [31:0] pc_with_exceptions = mem_wb.exception? `EXCEPTIONS_ADDR : finalPc;
   wire [31:0] pc_with_exceptions_and_iret = id_ex.iret ? decode.file_register.rm[0] : pc_with_exceptions;
always @ (posedge clock) begin
	if (rst) begin
	   pc <= `BOOT_ADDR;
	end else if (we && weFromHazard) begin 
	   pc <= pc_with_exceptions_and_iret;
	end
end

endmodule
