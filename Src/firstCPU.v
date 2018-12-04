//Include stages modules
`include "./stages/fetch/fetch.v"
`include "./stages/decode/decode.v"
`include "./stages/exec/exec.v"
`include "./stages/memory/memory.v"
`include "./stages/wb/wb.v"
//Include flip flop modules
`include "./flipflop/pc.v"
`include "./flipflop/if_id.v"
`include "./flipflop/id_ex.v"
`include "./flipflop/ex_mem.v"
`include "./flipflop/mem_wb.v"
//Include genericComponents
`include "./genericComponents/mux32Bits.v"

module firstCPU;

reg clock, rstPc;
wire [31:0]newPc;
wire [31:0]instruction, instruction_IFID;
wire [31:0]readData1, readData1_IDEX, readData2, readData2_IDEX, readData2_EXMEM;
wire [4:0]rdRegister, rd_IDEX, rd_EXMEM, rd_MEMWB;
wire [4:0]rsRegister, rtRegister, rs_IDEX, rt_IDEX;
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
  #22 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

//Flip Flop PC 
pc pc(.inPC(pcIncr), 
	.rst(rstPc), 
	.clock(clock), 
	.outPC(currentPc)
);

//Fetch stage 
fetch fetch(.pc(currentPc), .instruction(instruction), .newPc(pcIncr));

//Flip Flop IF_ID
if_id if_id(.inInstr(instruction), 
	.inPc(pcIncr), 
	.clock(clock), 
	.outInstr(instruction_IFID), 
	.outPc(pc_IFID)
);

//Decode stage 
decode decode(.instruction(instruction_IFID), 
	.rd_WB(rd_MEMWB), 
	.writeData(valueToWB), 
	.regWrite(regWrite_MEMWB),
	.address(address),  
	.aluCtrl(aluCtrl), 
	.controlBits(controlBits), 
	.readData1(readData1), 
	.readData2(readData2),
	.rdRegister(rdRegister), 
	.rsRegister(rsRegister),
	.rtRegister(rtRegister)
);

//Flip Flop ID_EX
id_ex id_ex(.inR1(readData1), 
	.inR2(readData2), 
	.inAluCtrl(aluCtrl), 
	.inAddress(address), 
	.inControlBits(controlBits), 
	.inRd(rdRegister), 
	.inPc(pc_IFID),
	.inRs(rsRegister), 
	.inRt(rtRegister),
	.clock(clock), 
	.outR1(readData1_IDEX), 
	.outR2(readData2_IDEX), 
	.outAluCtrl(aluCtrl_IDEX), 
	.outAddress(address_IDEX), 
	.outControlBits(controlBits_IDEX), 
	.outRd(rd_IDEX), 
	.outPc(pc_IDEX), 
	.outRs(rs_IDEX),
	.outRt(rt_IDEX)
);

//Exec stage
exec exec(.readData2(readData2_IDEX), 
	.address(address_IDEX), 
	.ctrlAluSrc(controlBits_IDEX[5]), 
	.readData1(readData1_IDEX), 
	.rs_IDEX(rs_IDEX), 
	.rt_IDEX(rt_IDEX),
	.rd_EXMEM(rd_EXMEM),
	.rd_MEMWB(rd_MEMWB), 
	.regWrite_EXMEM(regWrite_EXMEM), 
	.regWrite_MEMWB(regWrite_MEMWB),
	.result_EXMEM(result_EXMEM), 
	.valueToWB(valueToWB),
	.aluCtrl(aluCtrl_IDEX), 
	.zero(zero), 
	.result(result)
);

//Flip Flop EX_MEM
ex_mem ex_mem(.inResult(result), 
	.inReadRegister2(readData2_IDEX), 
	.inMemRead(controlBits_IDEX[2]), 
	.inMemWrite(controlBits_IDEX[4]), 
	.inMemToReg(controlBits_IDEX[3]),
	.inRegWrite(controlBits_IDEX[6]),
	.inWord(controlBits_IDEX[8]),
	.inRd(rd_IDEX),
	.clock(clock), 
	.outResult(result_EXMEM), 
	.outReadRegister2(readData2_EXMEM), 
	.outMemRead(memRead_EXMEM), 
	.outMemWrite(memWrite_EXMEM),
	.outMemToReg(memToReg_EXMEM),
	.outRegWrite(regWrite_EXMEM),
	.outWord(word_EXMEM),
	.outRd(rd_EXMEM)
);

//Memory stage 
memory memory(.address(result_EXMEM), 
	.write_data(readData2_EXMEM), 
	.memRead(memRead_EXMEM), 
	.memWrite(memWrite_EXMEM), 
	.word(word_EXMEM),
	.read_data(dataMemory)
);

//Flip Flop MEM_WB
mem_wb mem_wb(.inResult(result_EXMEM), 
	.inReadData(dataMemory), 
	.inRd(rd_EXMEM), 
	.inMemToReg(memToReg_EXMEM), 
	.inRegWrite(regWrite_EXMEM),
	.clock(clock), 
	.outResult(result_MEMWB), 
	.outReadData(readData_MEMWB), 
	.outRd(rd_MEMWB), 
	.outMemToReg(memToReg_MEMWB),
	.outRegWrite(regWrite_MEMWB)
);

//Write Back stage
wb wb(.result(result_MEMWB), 
	.readData(readData_MEMWB), 
	.memToReg(memToReg_MEMWB), 
	.valueToWB(valueToWB)
);
endmodule