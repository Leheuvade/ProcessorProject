`include "stages/exec/components/alu.v"
`include "stages/exec/components/forwardUnit.v"
`include "stages/exec/components/adderBranch.v"
`include "genericComponents/mux32Bits3To1.v"

module exec;

wire zero, pcSrc, flushPrevInstr;
wire [31:0]aluSrc, op1, op2, result, resultBranch;
wire [1:0]forwardA, forwardB;

assign pcSrc = zero && id_ex.branch;
assign flushPrevInstr = zero && id_ex.branch;

mux32 getAluSrc(.in1(id_ex.readData2), 
	.in2(id_ex.address), 
	.ctrl(id_ex.aluSrc), 
	.out(aluSrc)
);
forwardUnit forwardUnit();
mux32Bits3To1 getOp1(.in1(id_ex.readData1), 
	.in2(wb.valueToWB), 
	.in3(ex_mem.result), 
	.ctrl(forwardUnit.forwardA), 
	.out(op1)
);
mux32Bits3To1 getOp2(.in1(aluSrc), 
	.in2(wb.valueToWB), 
	.in3(ex_mem.result), 
	.ctrl(forwardUnit.forwardB), 
	.out(op2)
);
alu alu(.op1(op1), 
	.op2(op2), 
	.aluCtrl(id_ex.aluCtrl), 
	.zero(zero), 
	.result(result)
);
adderBranch adder(.address(id_ex.address), 
	.pcIncr(id_ex.pc), 
	.result(resultBranch)
);
endmodule