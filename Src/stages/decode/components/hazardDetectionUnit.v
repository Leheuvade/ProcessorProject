module hazardDetectionUnit(rs_IFID, rt_IFID, rt_IDEX, memRead_IDEX, rstIDEX, pcWrite, if_idWrite);

input [4:0]rs_IFID, rt_IFID, rt_IDEX;
input memRead_IDEX;
output rstIDEX, pcWrite, if_idWrite;

reg if_idWrite, pcWrite, rstIDEX;

always @(rs_IFID or rt_IFID or rt_IDEX or memRead_IDEX) begin
	rstIDEX = 0;
	pcWrite = 1; 
	if_idWrite = 1;
	if (memRead_IDEX == 1 && (rs_IFID == rt_IDEX || rt_IFID == rt_IDEX)) begin 
		rstIDEX = 1;
		pcWrite = 0; 
		if_idWrite = 0;
	end
end

endmodule