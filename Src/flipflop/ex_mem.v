module ex_mem(inResult, inReadRegister2, inMemRead, inMemWrite, inMemToReg, inRegWrite, inWriteRegister, clock, outResult, outReadRegister2, outMemRead, outMemWrite, outMemToReg, outRegWrite, outWriteRegister);

input inMemRead, inMemWrite, inMemToReg, inRegWrite;
input [31:0]inResult, inReadRegister2; 
input clock;
input [4:0]inWriteRegister;
output outMemRead, outMemWrite, outMemToReg, outRegWrite;
output [31:0]outResult, outReadRegister2;
output [4:0]outWriteRegister;

wire clock;
wire inWriteRegister;
wire inMemWrite, inMemRead, inMemToReg, inRegWrite;
wire inResult, inReadRegister2;
reg outMemWrite, outMemRead, outMemToReg, outRegWrite;
reg outResult, outReadRegister2;
reg outWriteRegister;

always @ (posedge clock) begin
  outResult <= inResult;
  outReadRegister2 <= inReadRegister2;
  outMemRead <= inMemRead;
  outMemWrite <= inMemWrite;
  outWriteRegister <= inWriteRegister;
  outMemToReg <= inMemToReg;
  outRegWrite <= inRegWrite;
end

endmodule