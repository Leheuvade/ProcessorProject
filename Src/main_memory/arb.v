module arb;

reg reqI; 
reg [`INSTRUCTION_LENGTH-1:0]reqAdrrI; 
reg lineIndex;

always @(reqAdrrI) begin
	if (reqI) begin
		main_memory.indexLine = reqAdrrI[11:4];
	end
end

endmodule
