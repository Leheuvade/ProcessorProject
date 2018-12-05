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

reg clock;

//Control Bits pc FF
wire pcWrite;
reg pcRst;

//Output PC FF
wire [31:0]pc_PC;

//Variables used in Fetch stage
wire [31:0]pcIncr;
wire [31:0]instruction;

//Control Bits IFID FF
reg if_idRst;
wire if_idWrite;

//Output IFID FF
wire [31:0]pc_IFID; 
wire [31:0]instruction_IFID;

//Variables used in Decode stage
wire [31:0]readData1, readData2, address; 
wire [4:0]rdRegister, rsRegister, rtRegister;
wire [1:0]aluCtrl;
wire [0:8]controlBits;
wire zero;

//Control Bits IDEX FF
wire id_exRst;

//Output IDEX FF
wire [0:8]controlBits_IDEX;
wire branch_IDEX, aluSrc_IDEX;
wire [1:0]aluCtrl_IDEX;
wire memRead_IDEX;
wire [31:0]readData1_IDEX, readData2_IDEX, address_IDEX, pc_IDEX;
wire [4:0]rd_IDEX, rs_IDEX, rt_IDEX;


//Variables used in Exec stage
wire [31:0]result;

//Output EXMEM FF
wire [0:8]controlBits_EXMEM;
wire memRead_EXMEM, memWrite_EXMEM, word_EXMEM, regWrite_EXMEM;
wire [31:0]readData2_EXMEM, result_EXMEM;
wire [4:0]rd_EXMEM; 

//Variables used in Mem stage
wire [31:0]readDataM;

//Output MEMWB FF
wire memToReg_MEMWB, regWrite_MEMWB;
wire [31:0]result_MEMWB, readDataM_MEMWB;
wire [4:0]rd_MEMWB;
 
//Variables used in WB stage
wire [31:0]valueToWB;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  // $monitor ("%g\t clock=%b", $time, clock);
  clock = 0;
  pcRst = 1;
  if_idRst = 1;
  #6 pcRst = 0;if_idRst = 0;
  #28 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

//Flip Flop PC 
pc pc(.inPC(pcIncr), 
	.rst(pcRst), 
	.write(pcWrite),
	.clock(clock), 
	.outPC(pc_PC)
);

//Fetch stage 
fetch fetch(.pc(pc_PC), .instruction(instruction), .newPc(pcIncr));

//Flip Flop IF_ID
if_id if_id(.inInstr(instruction), 
	.inPc(pcIncr), 
	.write(if_idWrite),
	.rst(if_idRst),
	.clock(clock), 
	.outInstr(instruction_IFID), 
	.outPc(pc_IFID)
);

//Decode stage 
decode decode(.instruction(instruction_IFID), 
	.rd_WB(rd_MEMWB), 
	.writeData(valueToWB), 
	.regWrite(regWrite_MEMWB),
	.rt_IDEX(rt_IDEX), 
	.memRead_IDEX(memRead_IDEX),
	.address(address),  
	.aluCtrl(aluCtrl), 
	.controlBits(controlBits), 
	.readData1(readData1), 
	.readData2(readData2),
	.rdRegister(rdRegister), 
	.rsRegister(rsRegister),
	.rtRegister(rtRegister), 
	.pcWrite(pcWrite), 
	.if_idWrite(if_idWrite), 
	.rstIDEX(id_exRst)
);

//Flip Flop ID_EX
id_ex id_ex(.inR1(readData1), 
	.inR2(readData2), 
	.inAddress(address), 
	.inAluCtrl(aluCtrl), 
	.inControlBits(controlBits), 
	.inRd(rdRegister), 
	.inPc(pc_IFID),
	.inRs(rsRegister), 
	.inRt(rtRegister),
	.rst(id_exRst),
	.clock(clock), 
	.outR1(readData1_IDEX), 
	.outR2(readData2_IDEX), 
	.outAluCtrl(aluCtrl_IDEX), 
	.outAddress(address_IDEX), 
	.outControlBits(controlBits_IDEX), 
	.outAluSrc(aluSrc_IDEX),
	.outMemRead(memRead_IDEX),
	.outRd(rd_IDEX), 
	.outPc(pc_IDEX), 
	.outRs(rs_IDEX),
	.outRt(rt_IDEX)
	//Add branch_IDEX
);

//Exec stage
exec exec(.readData2(readData2_IDEX), 
	.address(address_IDEX), 
	.ctrlAluSrc(aluSrc_IDEX), 
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
	.result(result)
);

//Flip Flop EX_MEM
ex_mem ex_mem(.inResult(result), 
	.inReadRegister2(readData2_IDEX), 
	.inControlBits_IDEX(controlBits_IDEX),
	.inRd(rd_IDEX),
	.clock(clock), 
	.outResult(result_EXMEM), 
	.outReadRegister2(readData2_EXMEM), 
	.outMemRead(memRead_EXMEM), 
	.outControlBits_EXMEM(controlBits_EXMEM),
	.outMemWrite(memWrite_EXMEM),
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
	.read_data(readDataM)
);

//Flip Flop MEM_WB
mem_wb mem_wb(.inResult(result_EXMEM), 
	.inReadData(readDataM), 
	.inRd(rd_EXMEM), 
	.inControlBits_EXMEM(controlBits_EXMEM),
	.clock(clock), 
	.outResult(result_MEMWB), 
	.outReadData(readDataM_MEMWB), 
	.outRd(rd_MEMWB), 
	.outMemToReg(memToReg_MEMWB),
	.outRegWrite(regWrite_MEMWB)
);

//Write Back stage
wb wb(.result(result_MEMWB), 
	.readData(readDataM_MEMWB), 
	.memToReg(memToReg_MEMWB), 
	.valueToWB(valueToWB)
);
endmodule