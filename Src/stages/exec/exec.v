`include "./stages/exec/components/alu.v"
`include "./genericComponents/mux32Bits3To1.v"
`include "./forwardUnit/forwardUnit.v"

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
	zero, 
	result
);

input [31:0]readData2, address, readData1, result_EXMEM, valueToWB;
input ctrlAluSrc, regWrite_MEMWB, regWrite_EXMEM;
input [4:0]rs_IDEX, rt_IDEX, rd_EXMEM, rd_MEMWB;
input [1:0]aluCtrl;
output zero;
output [31:0]result;

wire [31:0]aluSrc, op1, op2;
wire [1:0]forwardA, forwardB;

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

endmodule