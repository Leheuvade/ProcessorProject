`include "./stages/exec/components/alu.v"

module exec(readData2, address, ctrlOp2, readData1, aluCtrl, zero, result);

input [31:0]readData2, address, readData1;
input ctrlOp2;
input [1:0]aluCtrl;
output zero;
output [31:0]result;

wire [31:0]op2;

mux32 getOp2ALU(.in1(readData2), 
	.in2(address), 
	.ctrl(ctrlOp2), 
	.out(op2)
);
alu alu(.op1(readData1), 
	.op2(op2), 
	.aluCtrl(aluCtrl), 
	.zero(zero), 
	.result(result)
);

endmodule