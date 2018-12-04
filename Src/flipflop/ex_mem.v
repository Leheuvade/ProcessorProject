module ex_mem(inResult, inReadRegister2, inMemRead, inMemWrite, inMemToReg, inRegWrite, inRd, inWord, clock, outResult, outReadRegister2, outMemRead, outMemWrite, outMemToReg, outRegWrite, outRd, outWord);

input inMemRead, inMemWrite, inMemToReg, inRegWrite, inWord;
input [31:0]inResult, inReadRegister2; 
input clock;
input [4:0]inRd;
output outMemRead, outMemWrite, outMemToReg, outRegWrite, outWord;
output [31:0]outResult, outReadRegister2;
output [4:0]outRd;

wire clock;
wire inRd;
wire inMemWrite, inMemRead, inMemToReg, inRegWrite, inWord;
wire inResult, inReadRegister2;
reg outMemWrite, outMemRead, outMemToReg, outRegWrite, outWord;
reg outResult, outReadRegister2;
reg outRd;

always @ (posedge clock) begin
  outResult <= inResult;
  outReadRegister2 <= inReadRegister2;
  outMemRead <= inMemRead;
  outMemWrite <= inMemWrite;
  outRd <= inRd;
  outMemToReg <= inMemToReg;
  outRegWrite <= inRegWrite;
  outWord <= inWord;
end

endmodule