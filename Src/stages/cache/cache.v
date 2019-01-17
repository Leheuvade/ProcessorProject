`include "stages/cache/components/dataCache.v"

module cache;

reg [31:0]readData;
reg waitData, writeData;
wire [31:0]address = ex_mem.result;
wire [31:0]write_data = ex_mem.readData2;
wire memRead = ex_mem.memRead;
wire memWrite = ex_mem.memWrite;
wire word = ex_mem.word;

initial begin
	waitData = 0;
	writeData = 0;
end 

dataCache dataCache(.address(address), .miss(miss));

always @(miss or dataCache.data or memRead or memWrite or write_data or dataCache.dirtyEvict) begin 
	if(memRead || memWrite) begin
		if(writeData == 0) begin
			if (dataCache.dirtyEvict == 1) begin
				arb.reqW = 1;
				arb.writeAddr = address;
				arb.writeData = dataCache.lineToSaveToMem;
				pc.we = 0;
				if_id.we = 0;
				id_ex.we = 0;
				ex_mem.we = 0;
				mem_wb.clear = 1;
				writeData = 1;
			end
		end else begin
			pc.we = 0;
			if_id.we = 0;
			id_ex.we = 0;
			ex_mem.we = 0;
			mem_wb.clear = 1;
		end

		if (waitData == 0) begin
			if (miss == 0) begin
				readData = dataCache.data; //Voir pour LDWByte
			end else begin
				arb.reqD = 1;
				arb.reqAddrD = address;
				pc.we = 0;
				if_id.we = 0;
				id_ex.we = 0;
				ex_mem.we = 0;
				mem_wb.clear = 1;
				waitData = 1;
			end
		end else begin
			pc.we = 0;
			if_id.we = 0;
			id_ex.we = 0;
			ex_mem.we = 0;
			mem_wb.clear = 1;
		end
	end
end

endmodule 