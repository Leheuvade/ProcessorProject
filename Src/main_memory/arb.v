module arb;

reg reqI, reqD;
// reqW; 
reg [`INSTRUCTION_LENGTH-1:0]reqAdrrI, reqAdrrD; 
// reg [`LINE_WIDTH - 1:0]reqWriteValue;
reg lineIndex;

always @(reqAdrrI or reqI or reqAdrrD or reqD) begin //Handle conflict
	if (reqD) begin
		main_memory.indexLine = reqAdrrD[31:4];
	end else if (reqI) begin
		main_memory.indexLine = reqAdrrI[11:4];
	end
	// end else if (reqW) begin
	// 	main_memory.writeData = reqWriteValue;
	// end	
end

endmodule
