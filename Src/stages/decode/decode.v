`include "genericComponents/mux5Bits.v"
`include "stages/decode/components/control.v"
`include "stages/decode/components/aluControl.v"
`include "stages/decode/components/file_register.v"
`include "stages/decode/components/hazardDetectionUnit.v"

module decode(
	rd_WB, 
	writeData, 
	regWrite
);

input [31:0]writeData;
input [4:0]rd_WB;
input regWrite;

wire [0:8]outControlBits;
wire [1:0]aluCtrl;
wire [31:0]readData1, readData2, address;
wire[4:0]rd, rs, rt;


assign address = {16'b0, if_id.instruction[15:0]};
assign rs = if_id.instruction[25:21];
assign rt = if_id.instruction[20:16];
wire regDst = controlBits[0];
wire branch = controlBits[1];
wire [0:8]controlBits;

assign outControlBits = flush_CtrlBits ? 0 : controlBits;

control control(.opcode(if_id.instruction[31:26]), .controlBits(controlBits));
mux5 mux(.in1(if_id.instruction[20:16]), .in2(if_id.instruction[15:11]), .ctrl(regDst), .out(rd));
hazardDetectionUnit detectHazard(.rs_IFID(rs), 
	.rt_IFID(rt), 
	.rt_IDEX(id_ex.rt), 
	.memRead_IDEX(id_ex.memRead), 
	.flush_CtrlBits(flush_CtrlBits), 
	.write_PC(pc.we), 
	.write_IFID(if_id.we)
);
file_register file_register(.readRegister1(if_id.instruction[25:21]), 
	.readRegister2(if_id.instruction[20:16]), 
	.writeRegister(rd_WB), 
	.writeData(writeData), 
	.regWrite(regWrite), 
	.readData1(readData1), 
	.readData2(readData2));
aluControl aluControl(.aluOp(if_id.instruction[31:26]), .aluCtrl(aluCtrl));

endmodule
