`include "./genericComponents/mux5Bits.v"
`include "./stages/decode/components/control.v"
`include "./stages/decode/components/aluControl.v"
`include "./stages/decode/components/file_register.v"

module decode(instruction,  writeRegisterWB, writeData, regWrite, address, aluCtrl, controlBits, readData1, readData2, writeRegisterID);

input [31:0]instruction, writeData;
input [4:0]writeRegisterWB;
input regWrite;
output [31:0]readData1, readData2, address;
output [0:8]controlBits;
output [1:0]aluCtrl;
output[4:0]writeRegisterID;

wire [31:0]instruction;
wire readData1, readData2;
wire address = {16'b0, instruction[15:0]};
wire aluCtrl;
wire regWrite;
wire [0:8]controlBits;
wire writeRegisterID, writeRegisterWB;

control control(.opcode(instruction[31:26]), .controlBits(controlBits));
mux5 mux(.in1(instruction[20:16]), .in2(instruction[15:11]), .ctrl(controlBits[0]), .out(writeRegisterID));
file_register file_register(.readRegister1(instruction[25:21]), 
	.readRegister2(instruction[20:16]), 
	.writeRegister(writeRegisterWB), 
	.writeData(writeData), 
	.regWrite(regWrite), 
	.readData1(readData1), 
	.readData2(readData2));
aluControl aluControl(.aluOp(instruction[31:26]), .aluCtrl(aluCtrl));

endmodule
