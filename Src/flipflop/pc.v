module pc(rst, clock);

input clock, rst;

wire we;
reg [31:0]pc;

always @ (posedge clock) begin
	if (rst) begin
		pc <= 0;
	end else if (we) begin 
		pc <= firstCPU.newPc;
	end
end

endmodule
