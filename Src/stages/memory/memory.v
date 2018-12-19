module  memory;

reg [31:0]readData;
reg [7:0] memory [0:21];
wire [31:0]address = ex_mem.result;
wire [31:0]write_data = ex_mem.readData2;
wire memRead = ex_mem.memRead;
wire memWrite = ex_mem.memWrite;
wire word = ex_mem.word;

always @(address or memRead or memWrite or write_data) begin 
	$readmemb("../Resources/data_memory.list", memory);
	if(memWrite == 1'b1) begin
		if(word == 1'b1) begin
			memory[address] = write_data[7:0];
			memory[address + 1] = write_data[15:8];
			memory[address + 2] = write_data[23:16];
			memory[address + 3] = write_data[31:24];
		end else begin //default is byte
			memory[address] = write_data[7:0];
		end
		$writememb("../Resources/data_memory.list", memory);
	end else if (memRead == 1'b1) begin
		if(word == 1'b1) begin
			readData = {memory[address + 3], memory[address + 2],  memory[address + 1], memory[address]};
		end else begin 
			readData = memory[address];
		end
	end
end

endmodule