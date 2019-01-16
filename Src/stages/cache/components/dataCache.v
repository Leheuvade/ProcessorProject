`include "genericComponents/dataLineSelector.v"

module dataCache(address, miss);

reg [`LINE_WIDTH - 1:0]caches[0:3];
reg [`TAG_ADDR_SIZE - 1:0]tags[0:3];
reg validTable[0:3];
reg dirty[0:3];

integer i;

input [`INSTRUCTION_LENGTH - 1:0]address;
reg [`TAG_ADDR_SIZE - 1:0]tag;
reg [`INDEX_ADDR_SIZE - 1:0]index;
reg [`OFFSET_ADDR_SIZE - 1:0]offset;
wire [`INSTRUCTION_LENGTH - 1:0]data;
// reg lineToSaveToMem;
reg valid;
reg match;
reg dirtyEvict;
output reg miss;

initial begin
  for (i=0; i<4; i=i+1) begin
    validTable[i] = 1'b0;
    dirty[i] = 1'b0;
  end
end

dataLineSelector dDataLineSelector(.offset(offset), .line(caches[index]), .data(data));

always @ (address or main_memory.line) begin
	tag = address[`INSTRUCTION_LENGTH - 1:`INSTRUCTION_LENGTH - `TAG_ADDR_SIZE];
	index = address[`OFFSET_ADDR_SIZE + `INDEX_ADDR_SIZE - 1:`OFFSET_ADDR_SIZE];
	offset = address[`OFFSET_ADDR_SIZE - 1:0];
	
	if(main_memory.fillDCache == 1) begin
		$display("DCACHEFILL", main_memory.fillDCache);
		caches[index] = main_memory.line;
		tags[index] = tag;
		validTable[index] = 1;
		main_memory.fillDCache = 0;
	end

	// if (dirty [index]) begin
	// 	dirtyEvict = 1;
	// 	lineToSaveToMem = cache[index];
	// end

	valid = validTable[index];
	match = tags[index] === tag;
	
	if (!valid || !match) begin
		miss = 1;
	end else begin 
		miss = 0;
	end

	// if (cache.memWrite) begin 
	// 	caches[index][31:0] = cache.write_data;
	// 	dirty[index] = 1;
	// end
end

endmodule
