`include "genericComponents/mux5Bits.v"
`include "stages/decode/components/control.v"
`include "stages/decode/components/aluControl.v"
`include "stages/decode/components/file_register.v"
`include "stages/decode/components/hazardDetectionUnit.v"

module decode;

wire [31:0]address;
wire[4:0]rd, rs, rt;

assign address = {16'b0, if_id.instruction[15:0]};
assign rs = if_id.instruction[25:21];
assign rt = if_id.instruction[20:16];
assign regDst = control.regDst;
assign branch = control.branch;
assign memRead = control.memRead;
assign memToReg = control.memToReg;
assign memWrite = control.memWrite;
assign aluSrc = control.aluSrc;
assign regWrite = control.regWrite;
assign jump = control.jump;
assign word = control.word;
   assign file_register.move_rm1 = control.ignore_op2;

control control();
mux5 mux(.in1(if_id.instruction[20:16]), .in2(if_id.instruction[15:11]), .ctrl(control.regDst), .out(rd));
hazardDetectionUnit detectHazard(
	.flush_CtrlBits(flush_CtrlBits)
);
file_register file_register();
aluControl aluControl();

endmodule
