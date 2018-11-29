module ex_mem(inZero, inResult, inReadRegister2, inMemRead, inMemWrite, inByte, inWord, clock, outZero, outResult, outReadRegister2, outMemRead, outMemWrite, outByte, outWord);

input inZero, inMemRead, inMemWrite, inByte, inWord;
input [31:0]inResult, inReadRegister2; 
input clock;
output outZero, outMemRead, outMemWrite, outByte, outWord;
output [31:0]outResult, outReadRegister2;

wire clock;
wire inZero, inMemWrite, inMemRead, inByte, inWord;
wire inResult, inReadRegister2;
reg outZero, outMemWrite, outMemRead, outByte, outWord;
reg outResult, outReadRegister2;

always @ (posedge clock) begin
  outResult <= inResult;
  outZero <= inZero;
  outReadRegister2 <= inReadRegister2;
  outMemRead <= inMemRead;
  outMemWrite <= inMemWrite;
  outByte <= inByte;
  outWord <= inWord;
end

endmodule