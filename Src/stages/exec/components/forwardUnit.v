module forwardUnit();

reg [1:0]forwardA, forwardB;

always @(id_ex.rt or id_ex.rs or mem_wb.rd or ex_mem.rd or ex_mem.regWrite or mem_wb.regWrite) begin

	if (ex_mem.regWrite == 1 && ex_mem.rd != 0 && ex_mem.rd == id_ex.rs) begin //EX Hazard
		forwardA = 2'b10;
	end else if (mem_wb.regWrite == 1 && mem_wb.rd != 0 && mem_wb.rd == id_ex.rs) begin //MEM Hazard
		forwardA = 2'b01;
	end else begin //No Hazard
		forwardA = 2'b00;
	end

	if (ex_mem.regWrite == 1 && ex_mem.rd != 0  && ex_mem.rd == id_ex.rt) begin //EX Hazard
		forwardB = 2'b10;
	end else if (mem_wb.regWrite == 1 && mem_wb.rd != 0 && mem_wb.rd == id_ex.rt) begin //MEM Hazard
		forwardB = 2'b01;
	end else begin //No Hazard
		forwardB = 2'b00;
	end
end


endmodule