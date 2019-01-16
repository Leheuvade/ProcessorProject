module main_memory();

localparam MEM_LINES_INDEX_SIZE = $clog2(`MEM_LINES);

reg [`LINE_WIDTH - 1:0] memoryFile [0:`MEM_LINES - 1];
reg [`LINE_WIDTH - 1:0]line; 
reg [MEM_LINES_INDEX_SIZE - 1:0]indexLine; 
reg fillCache;

initial begin
	$readmemb("../Resources/memory.list", memoryFile);
end 

always @(arb.reqI) begin
    $monitor ("%g\t memoryCall", $time); 
	#`LATENCY line = memoryFile[indexLine];
	fetch.waitInst = 0;
	fillCache = 1;
	arb.reqI = 0;
	pc.we = 1;
	if_id.clear = 0;
end

endmodule