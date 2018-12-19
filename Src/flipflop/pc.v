module pc(rst, clock);

input clock, rst;

reg we;
reg [31:0]pc;
wire [31:0]newPc;

mux32 mux32(.in1(fetch.pcIncr), .in2(ex_mem.pcBranch), .ctrl(ex_mem.pcSrc), .out(newPc));

always @ (posedge clock) begin
	if (rst) begin
		pc <= 0;
	end else if (we) begin 
		pc <= newPc;
	end
end

endmodule
