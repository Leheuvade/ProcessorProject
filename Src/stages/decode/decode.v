`include "genericComponents/mux5Bits.v"
`include "stages/decode/components/control.v"
`include "stages/decode/components/aluControl.v"
`include "stages/decode/components/file_register.v"
`include "stages/decode/components/hazardDetectionUnit.v"

module decode;

wire [0:8]outControlBits;
wire [1:0]aluCtrl;
wire [31:0]readData1, readData2, address;
wire[4:0]rd, rs, rt;


assign address = {16'b0, if_id.instruction[15:0]};
assign rs = if_id.instruction[25:21];
assign rt = if_id.instruction[20:16];
assign outControlBits = flush_CtrlBits ? 0 : control.controlBits;

control control();
mux5 mux(.in1(if_id.instruction[20:16]), .in2(if_id.instruction[15:11]), .ctrl(control.regDst), .out(rd));
hazardDetectionUnit detectHazard(
	.flush_CtrlBits(flush_CtrlBits)
);
file_register file_register(
	.readData1(readData1), 
	.readData2(readData2)
);
aluControl aluControl(.aluOp(if_id.instruction[31:26]), .aluCtrl(aluCtrl));

endmodule
