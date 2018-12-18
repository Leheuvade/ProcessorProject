`include "stages/exec/components/alu.v"
`include "stages/exec/components/forwardUnit.v"
`include "stages/exec/components/adderBranch.v"
`include "genericComponents/mux32Bits3To1.v"

module exec(readData2, 
	address, 
	ctrlAluSrc, 
	readData1, 
	rs_IDEX, 
	rt_IDEX,
	rd_EXMEM,
	rd_MEMWB, 
	regWrite_EXMEM, 
	regWrite_MEMWB,
	result_EXMEM, 
	valueToWB,
	aluCtrl, 
	branch, 
	pcIncr, 
	result, 
	resultBranch, 
	flushPrevInstr,
	pcSrc
);

input [31:0]readData2, address, readData1, result_EXMEM, valueToWB, pcIncr;
input ctrlAluSrc, regWrite_MEMWB, regWrite_EXMEM, branch;
input [4:0]rs_IDEX, rt_IDEX, rd_EXMEM, rd_MEMWB;
input [1:0]aluCtrl;
output [31:0]result, resultBranch;
output pcSrc, flushPrevInstr;

wire zero;
wire [31:0]aluSrc, op1, op2;
wire [1:0]forwardA, forwardB;

assign pcSrc = zero && branch;
assign flushPrevInstr = zero && branch;

mux32 getAluSrc(.in1(readData2), 
	.in2(address), 
	.ctrl(ctrlAluSrc), 
	.out(aluSrc)
);
forwardUnit forwardUnit(rs_IDEX, 
	rt_IDEX, 
	rd_EXMEM, 
	rd_MEMWB, 
	regWrite_EXMEM, 
	regWrite_MEMWB, 
	forwardA, 
	forwardB
);
mux32Bits3To1 getOp1(.in1(readData1), 
	.in2(valueToWB), 
	.in3(result_EXMEM), 
	.ctrl(forwardA), 
	.out(op1)
);
mux32Bits3To1 getOp2(.in1(aluSrc), 
	.in2(valueToWB), 
	.in3(result_EXMEM), 
	.ctrl(forwardB), 
	.out(op2)
);
alu alu(.op1(op1), 
	.op2(op2), 
	.aluCtrl(aluCtrl), 
	.zero(zero), 
	.result(result)
);
adderBranch adder(.address(address), 
	.pcIncr(pcIncr), 
	.result(resultBranch)
);
endmodule