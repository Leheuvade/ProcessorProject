module mem_wb(inResult, inReadData, inWriteRegister, inMemToReg, inRegWrite, clock, outResult, outReadData, outWriteRegister, outMemToReg, outRegWrite);

input [31:0]inResult, inReadData; 
input [4:0]inWriteRegister;
input inMemToReg, inRegWrite;
input clock;
output [31:0]outResult, outReadData;
output [4:0]outWriteRegister;
output outMemToReg, outRegWrite;

wire clock;
wire inResult, inReadData;
wire inWriteRegister;
wire inMemToReg, inRegWrite;
reg outResult, outReadData;
reg outWriteRegister;
reg outMemToReg, outRegWrite;

always @ (posedge clock)begin 
  outResult <= inResult;
  outReadData <= inReadData;
  outWriteRegister <= inWriteRegister;
  outMemToReg <= inMemToReg;
  outRegWrite <= inRegWrite;
 end

endmodule