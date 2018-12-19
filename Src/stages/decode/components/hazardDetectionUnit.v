module hazardDetectionUnit(flush_CtrlBits, write_PC, write_IFID);

output flush_CtrlBits, write_PC, write_IFID;

reg write_IFID, write_PC, flush_CtrlBits;

always @(decode.rs or decode.rt or id_ex.rt or id_ex.memRead) begin
	flush_CtrlBits = 0;
	write_PC = 1; 
	write_IFID = 1;
	if (id_ex.memRead == 1 && (decode.rs == id_ex.rt || decode.rt == id_ex.rt)) begin 
		flush_CtrlBits = 1;
		write_PC = 0; 
		write_IFID = 0;
	end
end

endmodule