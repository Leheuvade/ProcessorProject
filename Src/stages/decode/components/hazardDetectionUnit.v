module hazardDetectionUnit(flush_CtrlBits);

output flush_CtrlBits;

reg flush_CtrlBits;

always @(decode.rs or decode.rt or id_ex.rt or id_ex.memRead) begin
	if (id_ex.memRead == 1 && (decode.rs == id_ex.rt || decode.rt == id_ex.rt)) begin 
		flush_CtrlBits = 1;
		pc.weFromHazard = 0; 
		if_id.weFromHazard = 0;
	end else begin
		flush_CtrlBits = 0;
		pc.weFromHazard = 1; 
		if_id.weFromHazard = 1;
	end
end

endmodule