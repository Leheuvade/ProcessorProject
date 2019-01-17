module arb;

reg reqI, reqD, reqW; 
reg [`INSTRUCTION_LENGTH-1:0]reqAddrI, reqAddrD, writeAddr; 
reg [`LINE_WIDTH - 1:0]writeData;
reg lineIndex;

initial begin
	reqD = 0;
	reqI = 0;
	reqW = 0;
end

always @(reqAddrI or reqI or reqAddrD or reqD or reqW) begin //Handle conflict
	if (reqW) begin 
		$display("toto2");
		main_memory.indexLine = writeAddr[31:4];
		main_memory.writeData = writeData;
		main_memory.mission = `WRITEDATA;
	end else if (reqD) begin
		main_memory.indexLine = reqAddrD[31:4];
		main_memory.mission = `READDATA;
	end else  if (reqI) begin
		 main_memory.indexLine = reqAddrI[31:4];
		 main_memory.mission = `READINST;
	end
end

endmodule
