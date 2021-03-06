module pc(rst, clock);

input clock, rst;

reg we;
reg [31:0]pc;
wire [31:0]intermediatePc, finalPc;

mux32 getIntermediatePc(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(intermediatePc));
mux32 getFinalPc(.in1(intermediatePc), .in2(if_id.pcJump), .ctrl(decode.jump), .out(finalPc));
always @ (posedge clock) begin
	if (rst) begin
		pc <= 0;
	end else if (we) begin 
		pc <= finalPc;
	end
end

endmodule
