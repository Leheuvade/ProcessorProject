`include "fetch/fetch.v"
`include "decode/decode.v"
`include "alu/alu.v"
`include "./flipflop/if_id.v"
`include "./flipflop/id_ex.v"
`include "./flipflop/ex_mem.v"
`include "./flipflop/mem_wb.v"
`include "./flipflop/pc.v"
`include "./composant/mux32Bits.v"
`include "./dataMemory/data_memory.v"

module firstCPU;

reg clock, rstPc;
wire [31:0]newPc;
wire [31:0]instruction, instruction_IFID;
wire [31:0]readData1, readData1_IDEX, readData2, readData2_IDEX, readData2_EXMEM;
wire [4:0]writeRegister, writeRegister_IDEX, writeRegister_EXMEM, writeRegister_MEMWB;
wire [31:0]op2;
wire [1:0]aluCtrl, aluCtrl_IDEX;
wire zero;
wire [31:0]result, result_EXMEM, result_MEMWB;
wire [31:0]address, address_IDEX;
wire [0:8]controlBits, controlBits_IDEX;
wire memRead_EXMEM, memWrite_EXMEM, memToReg_EXMEM, memToReg_MEMWB, regWrite_EXMEM, regWrite_MEMWB, word_EXMEM;
wire [31:0]dataMemory, readData_MEMWB;
wire [31:0]valueToWB;
wire [31:0]currentPc, pcIncr, pc_IFID, pc_IDEX;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  $monitor ("%g\t clock=%b", 
  	$time, clock);
  clock = 0;
  rstPc = 1;
  #6 rstPc = 0;
  #18 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

pc pc(.inPC(pcIncr), .rst(rstPc), .clock(clock), .outPC(currentPc));
fetch fetch(.pc(currentPc), .instruction(instruction), .newPc(pcIncr));
if_id if_id(.inInstr(instruction), 
	.inPc(pcIncr), 
	.clock(clock), 
	.outInstr(instruction_IFID), 
	.outPc(pc_IFID)
);
decode decode(.instruction(instruction_IFID), 
	.writeRegisterWB(writeRegister_MEMWB), 
	.writeData(valueToWB), 
	.regWrite(regWrite_MEMWB),
	.address(address),  
	.aluCtrl(aluCtrl), 
	.controlBits(controlBits), 
	.readData1(readData1), 
	.readData2(readData2),
	.writeRegisterID(writeRegister)
);
id_ex id_ex(.inR1(readData1), 
	.inR2(readData2), 
	.inAluCtrl(aluCtrl), 
	.inAddress(address), 
	.inControlBits(controlBits), 
	.inWriteRegister(writeRegister), 
	.inPc(pc_IFID),
	.clock(clock), 
	.outR1(readData1_IDEX), 
	.outR2(readData2_IDEX), 
	.outAluCtrl(aluCtrl_IDEX), 
	.outAddress(address_IDEX), 
	.outControlBits(controlBits_IDEX), 
	.outWriteRegister(writeRegister_IDEX), 
	.outPc(pc_IDEX)
);
mux32 getOp2ALU(.in1(readData2_IDEX), 
	.in2(address_IDEX), 
	.ctrl(controlBits_IDEX[5]), 
	.out(op2)
);
alu alu(.op1(readData1_IDEX), 
	.op2(op2), 
	.aluCtrl(aluCtrl_IDEX), 
	.zero(zero), 
	.result(result)
);
ex_mem ex_mem(.inResult(result), 
	.inReadRegister2(readData2_IDEX), 
	.inMemRead(controlBits_IDEX[2]), 
	.inMemWrite(controlBits_IDEX[4]), 
	.inMemToReg(controlBits_IDEX[3]),
	.inRegWrite(controlBits_IDEX[6]),
	.inWord(controlBits_IDEX[8]),
	.inWriteRegister(writeRegister_IDEX),
	.clock(clock), 
	.outResult(result_EXMEM), 
	.outReadRegister2(readData2_EXMEM), 
	.outMemRead(memRead_EXMEM), 
	.outMemWrite(memWrite_EXMEM),
	.outMemToReg(memToReg_EXMEM),
	.outRegWrite(regWrite_EXMEM),
	.outWord(word_EXMEM),
	.outWriteRegister(writeRegister_EXMEM)
);
data_memory data_memory(.address(result_EXMEM), 
	.write_data(readData2_EXMEM), 
	.memRead(memRead_EXMEM), 
	.memWrite(memWrite_EXMEM), 
	.word(word_EXMEM),
	.read_data(dataMemory)
);
mem_wb mem_wb(.inResult(result_EXMEM), 
	.inReadData(dataMemory), 
	.inWriteRegister(writeRegister_EXMEM), 
	.inMemToReg(memToReg_EXMEM), 
	.inRegWrite(regWrite_EXMEM),
	.clock(clock), 
	.outResult(result_MEMWB), 
	.outReadData(readData_MEMWB), 
	.outWriteRegister(writeRegister_MEMWB), 
	.outMemToReg(memToReg_MEMWB),
	.outRegWrite(regWrite_MEMWB)
);
mux32 getValueToWB(.in1(result_MEMWB), 
	.in2(readData_MEMWB), 
	.ctrl(memToReg_MEMWB), 
	.out(valueToWB)
);
endmodule