`include "stages/exec/components/alu.v"
`include "stages/exec/components/forwardUnit.v"
`include "stages/exec/components/adderBranch.v"
`include "genericComponents/mux32Bits3To1.v"
`include "TLB/preprocessor_directives.v"

module exec(output wire enable_tlb_write_o,
	    output wire [31-`OFFSET:0] virtual_page_o,
	    output wire [31-`OFFSET:0] phys_page_o);

wire zero, pcSrc, flushPrevInstr;
   wire [31:0] aluSrc;
   wire [31:0] op1;
   wire [31:0] op2;
   wire [31:0] result;
   wire [31:0] resultBranch;
   wire [1:0]forwardA, forwardB;
   wire      ignore_op2;

assign pcSrc = zero && id_ex.branch;
assign flushPrevInstr = zero && id_ex.branch;
   assign ignore_op2 = id_ex.ignore_op2;
   assign enable_tlb_write_o = id_ex.tlb_write;
   assign virtual_page_o = id_ex.readData1[31:`OFFSET];
   assign phys_page_o = id_ex.readData2[31:`OFFSET];
		   
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
	.ignore_op2(ignore_op2),
	.aluCtrl(id_ex.aluCtrl), 
	.zero(zero), 
	.result(result)
);
adderBranch adder(.address(id_ex.address), 
	.pcIncr(id_ex.pc), 
	.result(resultBranch)
);
endmodule
