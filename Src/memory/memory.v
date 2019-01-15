`include "preprocessor_directives.v"

module main_memory();

localparam MEM_LINES_INDEX_SIZE = $clog2(`MEM_LINES);

reg [`LINE_WIDTH - 1:0] memoryFile [0:`MEM_LINES - 1];
reg [`LINE_WIDTH - 1:0]line; 
reg [MEM_LINES_INDEX_SIZE - 1:0]indexLine; 

always @(indexLine) begin
	#`LATENCY line = memoryFile[indexLine];
end

endmodule