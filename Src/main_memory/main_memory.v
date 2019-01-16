module main_memory();

localparam MEM_LINES_INDEX_SIZE = $clog2(`MEM_LINES);

reg [`LINE_WIDTH - 1:0] memoryFile [0:`MEM_LINES - 1];
reg [`LINE_WIDTH - 1:0]line; 
// reg writeData;
reg [MEM_LINES_INDEX_SIZE - 1:0]indexLine; 
reg fillICache, fillDCache;

initial begin
	$readmemb("../Resources/memory.list", memoryFile);
end 

always @(indexLine) begin
	#`LATENCY line = memoryFile[indexLine];
	if (arb.reqD) begin
		cache.waitData = 0;
		fillDCache = 1;
		arb.reqD = 0;
		pc.we = 1;
		if_id.we = 1;
		id_ex.we = 1;
		ex_mem.we = 1;
		mem_wb.clear = 0;
	end else if (arb.reqI) begin 
		fetch.waitInst = 0;
		fillICache = 1;
		arb.reqI = 0;
		pc.we = 1;
		if_id.clear = 0;
	end
	//  else if (arb.writeData) begin
	// 	// memoryFile[arb.reqAddrD] = writeData; Mettre une latency
	// 	cache.writeData = 0;
	// 	arb.writeData = 0;
	// 	pc.we = 1;
	// 	if_id.we = 1;
	// 	id_ex.we = 1;
	// 	ex_mem.we = 1;
	// 	mem_wb.clear = 0;
	// end
end

endmodule