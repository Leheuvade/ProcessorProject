module file_register(readRegister1, readRegister2, writeRegister, writeData, regWrite, readData1, readData2);

input[4:0]readRegister1, readRegister2, writeRegister; 
input [31:0]writeData;
input regWrite;
output [31:0]readData1, readData2;

reg [31:0] registers [0:31];

assign readData1 = registers[readRegister1];
assign readData2 = registers[readRegister2];

always @(readRegister1 or readRegister2 or writeRegister or writeData) begin
	$readmemh("../Resources/file_register.list", registers);
	if(regWrite == 1'b1) begin 
		registers[writeRegister] = writeData;
		$writememh("../Resources/file_register.list", registers);
	end
end

endmodule