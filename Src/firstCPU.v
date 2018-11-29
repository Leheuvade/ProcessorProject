`include "fetch/fetch.v"
`include "decode/decode.v"
`include "alu/alu.v"
`include "./flipflop/if_id.v"
`include "./file_register/write_file_register.v"
`include "./file_register/read_file_register.v"
`include "./flipflop/id_ex.v"
`include "./flipflop/ex_mem.v"
`include "./flipflop/mem_wb.v"
`include "./composant/mux32Bits.v"
`include "./dataMemory/data_memory.v"

module firstCPU;

reg clock;
wire [31:0]instruction, instruction_IFID;
wire [31:0]readRegister1, readRegister1_IDEX, readRegister2, readRegister2_IDEX, readRegister2_EXMEM;
wire [31:0]op2;
wire [1:0]aluCtrl, aluCtrl_IDEX;
wire zero, zero_EXMEM;
wire [31:0]result, result_EXMEM, result_MEMWB;
wire [31:0]address, address_IDEX;
wire [9:0]controlBits, controlBits_IDEX;
wire memRead_EXMEM, memWrite_EXMEM, byte_EXMEM, word_EXMEM;
wire [31:0]dataMemory, readData_MEMWB;

initial begin
  $dumpfile("firstCPU.vcd");
  $dumpvars(0, firstCPU);
  $monitor ("%g\t clock=%b instruction=%h controlBits=%b read1=%h read2=%h address=%h result=%h zero=%h read2=%h readData=%h", 
  	$time, clock, instruction_IFID, controlBits_IDEX, readRegister1_IDEX, readRegister2_IDEX, address_IDEX, result_EXMEM, zero_EXMEM, readRegister2_EXMEM, readData_MEMWB);
  clock = 0;
  #18 $finish;
end

// Clock generator
always begin
  #2 clock = ~clock;
end

fetch fetch(.instruction(instruction));
if_id if_id(.in(instruction), .clock(clock), .out(instruction_IFID));
decode decode(.instruction(instruction_IFID), .readRegister1(readRegister1), .readRegister2(readRegister2), .address(address), .aluCtrl(aluCtrl), .controlBits(controlBits));
id_ex id_ex(.inR1(readRegister1), .inR2(readRegister2), .inAluCtrl(aluCtrl), .inAddress(address), .inControlBits(controlBits), .clock(clock), .outR1(readRegister1_IDEX), .outR2(readRegister2_IDEX), .outAluCtrl(aluCtrl_IDEX), .outAddress(address_IDEX), .outControlBits(controlBits_IDEX));
mux32 mux(.in1(readRegister2_IDEX), .in2(address_IDEX), .ctrl(controlBits_IDEX[0]), .out(op2));
alu alu(.op1(readRegister1_IDEX), .op2(op2), .aluCtrl(aluCtrl_IDEX), .zero(zero), .result(result));
ex_mem ex_mem(.inZero(zero), 
	.inResult(result), 
	.inReadRegister2(readRegister2_IDEX), 
	.inMemRead(controlBits_IDEX[7]), 
	.inMemWrite(controlBits_IDEX[5]),
	.inByte(controlBits_IDEX[1]),
	.inWord(controlBits_IDEX[0]), 
	.clock(clock), 
	.outZero(zero_EXMEM), 
	.outResult(result_EXMEM), 
	.outReadRegister2(readRegister2_EXMEM), 
	.outMemRead(memRead_EXMEM), 
	.outMemWrite(memWrite_EXMEM),
	.outByte(byte_EXMEM),
	.outWord(word_EXMEM),
);
data_memory data_memory(.address(result_EXMEM), .write_data(readRegister2_EXMEM), .memRead(memRead_EXMEM), .memWrite(memWrite_EXMEM), .byte(byte_EXMEM) , .word(word_EXMEM), .read_data(dataMemory));
mem_wb mem_wb(.inResult(result_EXMEM), .inReadData(dataMemory), .clock(clock), .outResult(result_MEMWB), .outReadData(readData_MEMWB));
endmodule