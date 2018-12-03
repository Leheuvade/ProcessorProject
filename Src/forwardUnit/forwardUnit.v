module forwardUnit(rs_IDEX, 
	rt_IDEX, 
	rd_EXMEM, 
	rd_MEMWB, 
	regWrite_EXMEM, 
	regWrite_MEMWB, 
	forwardA, 
	forwardB
);

input [4:0]rs_IDEX, rt_IDEX, rd_EXMEM, rd_MEMWB;
input regWrite_EXMEM, regWrite_MEMWB;
output [1:0]forwardA, forwardB;

reg [1:0]forwardA, forwardB;

always @(rt_IDEX or rs_IDEX or rd_MEMWB or rd_EXMEM or regWrite_EXMEM or regWrite_MEMWB) begin
	//MEM hazard
	if (regWrite_EXMEM == 1&& rd_MEMWB != 0 && rd_MEMWB == rt_IDEX) begin 
		forwardA = 2'b10;
	end else if (regWrite_MEMWB == 1 && rd_MEMWB != 0 && rd_MEMWB == rs_IDEX) begin 
		forwardA = 2'b01;
	end 


	//WB hazard
	if (regWrite_EXMEM == 1 && rd_EXMEM != 0  && rd_EXMEM == rt_IDEX) begin 
		forwardB = 2'b10;
	end else if (regWrite_MEMWB == 1 && rd_MEMWB != 0 && rd_MEMWB == rt_IDEX) begin 
		forwardB = 2'b01;
	end 
end


endmodule