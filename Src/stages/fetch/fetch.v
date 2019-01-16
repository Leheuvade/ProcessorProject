`include "stages/fetch/components/cache.v"

module fetch();

reg [31:0]instruction;
wire [31:0]pcIncr;
wire [31:0]pcJump;
reg waitInst;
wire miss;

assign pcJump = {pcIncr[31:28], instruction[25:0]<<2};
assign pcIncr = pc.pc + 4;

initial begin
	waitInst = 0;
end 

cache cache(.address(pc.pc), .miss(miss));

always @(miss or cache.data) begin
	if (waitInst == 0) begin
		if (miss == 0) begin
			instruction = cache.data;
		end else begin
			arb.reqI = 1;
			arb.reqAdrrI = pc.pc;
			pc.we = 0;
			if_id.clear = 1;
			waitInst = 1;
		end
	end else begin
		pc.we = 0;
		if_id.clear = 1;
	end
end

endmodule

