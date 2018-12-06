module hazardDetectionUnit(rs_IFID, rt_IFID, rt_IDEX, memRead_IDEX, flush_CtrlBits, write_PC, write_IFID);

input [4:0]rs_IFID, rt_IFID, rt_IDEX;
input memRead_IDEX;
output flush_CtrlBits, write_PC, write_IFID;

reg write_IFID, write_PC, flush_CtrlBits;

always @(rs_IFID or rt_IFID or rt_IDEX or memRead_IDEX) begin
	flush_CtrlBits = 0;
	write_PC = 1; 
	write_IFID = 1;
	if (memRead_IDEX == 1 && (rs_IFID == rt_IDEX || rt_IFID == rt_IDEX)) begin 
		flush_CtrlBits = 1;
		write_PC = 0; 
		write_IFID = 0;
	end
end

endmodule