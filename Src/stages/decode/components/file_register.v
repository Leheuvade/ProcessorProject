module file_register(readData1, readData2);

output [31:0]readData1, readData2;

reg [31:0] registers [0:31];
wire [4:0]readRegister1 = if_id.instruction[25:21];
wire [4:0]readRegister2 = if_id.instruction[20:16];
wire [4:0]writeRegister = mem_wb.rd;
wire [31:0]writeData = wb.valueToWB;

assign readData1 = registers[readRegister1];
assign readData2 = registers[readRegister2];

always @(readRegister1 or readRegister2 or writeRegister or writeData) begin
	$readmemh("../Resources/file_register.list", registers);
	if(mem_wb.regWrite == 1'b1) begin 
		registers[writeRegister] = writeData;
		$writememh("../Resources/file_register.list", registers);
	end
end

endmodule