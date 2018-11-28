module ex_mem(inZero, inResult, inReadRegister2, inMemRead, inMemWrite, clock, outZero, outResult, outReadRegister2, outMemRead, outMemWrite);

input inZero, inMemRead, inMemWrite;
input [31:0]inResult, inReadRegister2; 
input clock;
output outZero, outMemRead, outMemWrite;
output [31:0]outResult, outReadRegister2;

wire clock;
wire inZero, inMemWrite, inMemRead;
wire inResult, inReadRegister2;
reg outZero, outMemWrite, outMemRead;
reg outResult, outReadRegister2;

always @ (posedge clock) begin
  outResult <= inResult;
  outZero <= inZero;
  outReadRegister2 <= inReadRegister2;
  outMemRead <= inMemRead;
  outMemWrite <= inMemWrite;
end

endmodule