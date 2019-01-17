module main_memory();

localparam MEM_LINES_INDEX_SIZE = $clog2(`MEM_LINES);

reg [`LINE_WIDTH - 1:0] memoryFile [0:`MEM_LINES - 1];
reg [`LINE_WIDTH - 1:0]line; 
reg [`LINE_WIDTH - 1:0]writeData;
reg [MEM_LINES_INDEX_SIZE - 1:0]indexLine; 
reg fillICache, fillDCache;
reg writeDataFinished;
integer mission;

initial begin
	fillICache = 0;
	fillDCache = 0;
	writeDataFinished = 0;
end 

always @(indexLine or writeData) begin
	$readmemb("../Resources/memory.list", memoryFile);
	case(mission)
  	0 : begin // READDATA
  	  		$display("tata");
        #`LATENCY line = memoryFile[indexLine];
		cache.waitData = 0;
		fillDCache = 1;
		arb.reqD = 0;
		if_id.we = 1;
		id_ex.we = 1;
		ex_mem.we = 1;
		mem_wb.clear = 0;
            end
 	1 : begin // READINST
 		 $display("titi");
        #`LATENCY line = memoryFile[indexLine];
		fetch.waitInst = 0;
		fillICache = 1;
		arb.reqI = 0;
		if_id.clear = 0;
            end
  	2 : begin // WRITEDATA
  		$display("toto");
        #`LATENCY memoryFile[indexLine] = writeData;
		$writememb("../Resources/memory.list", memoryFile);
		cache.writeData = 0;
		writeDataFinished = 1;
		arb.reqW= 0;
		if_id.we = 1;
		id_ex.we = 1;
		ex_mem.we = 1;
		mem_wb.clear = 0;
            end
	endcase	
	if (arb.reqI == 0 && arb.reqD == 0 && arb.reqW == 0) begin
		pc.we = 1;
	end else begin
		pc.we = 0;
	end
end

endmodule