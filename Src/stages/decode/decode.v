`include "genericComponents/mux5Bits.v"
`include "stages/decode/components/control.v"
`include "stages/decode/components/aluControl.v"
`include "stages/decode/components/file_register.v"
`include "stages/decode/components/hazardDetectionUnit.v"

module decode(instruction, 
	rd_WB, 
	writeData, 
	regWrite,
	rt_IDEX, 
	memRead_IDEX, 
	address, 
	aluCtrl, 
	outControlBits, 
	readData1, 
	readData2, 
	rdRegister, 
	rsRegister, 
	rtRegister, 
	write_PC, 
	write_IFID
);

input [31:0]instruction, writeData;
input [4:0]rd_WB, rt_IDEX;
input regWrite, memRead_IDEX;
output [31:0]readData1, readData2, address;
output [0:8]outControlBits;
output [1:0]aluCtrl;
output[4:0]rdRegister, rsRegister, rtRegister;
output write_PC, write_IFID, flush_IDEX;

assign address = {16'b0, instruction[15:0]};
assign rsRegister = instruction[25:21];
assign rtRegister = instruction[20:16];
wire regDst = controlBits[0];
wire branch = controlBits[1];
wire [0:8]controlBits;

assign outControlBits = flush_CtrlBits ? 0 : controlBits;

control control(.opcode(instruction[31:26]), .controlBits(controlBits));
mux5 mux(.in1(instruction[20:16]), .in2(instruction[15:11]), .ctrl(regDst), .out(rdRegister));
hazardDetectionUnit detectHazard(.rs_IFID(rsRegister), 
	.rt_IFID(rtRegister), 
	.rt_IDEX(rt_IDEX), 
	.memRead_IDEX(memRead_IDEX), 
	.flush_CtrlBits(flush_CtrlBits), 
	.write_PC(write_PC), 
	.write_IFID(write_IFID)
);
file_register file_register(.readRegister1(instruction[25:21]), 
	.readRegister2(instruction[20:16]), 
	.writeRegister(rd_WB), 
	.writeData(writeData), 
	.regWrite(regWrite), 
	.readData1(readData1), 
	.readData2(readData2));
aluControl aluControl(.aluOp(instruction[31:26]), .aluCtrl(aluCtrl));

endmodule
