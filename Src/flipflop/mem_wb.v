module mem_wb(inResult, inReadData, inRd, inMemToReg, inRegWrite, clock, outResult, outReadData, outRd, outMemToReg, outRegWrite);

input [31:0]inResult, inReadData; 
input [4:0]inRd;
input inMemToReg, inRegWrite;
input clock;
output [31:0]outResult, outReadData;
output [4:0]outRd;
output outMemToReg, outRegWrite;

wire clock;
wire inResult, inReadData;
wire inRd;
wire inMemToReg, inRegWrite;
reg outResult, outReadData;
reg outRd;
reg outMemToReg, outRegWrite;

always @ (posedge clock)begin 
  outResult <= inResult;
  outReadData <= inReadData;
  outRd <= inRd;
  outMemToReg <= inMemToReg;
  outRegWrite <= inRegWrite;
 end

endmodule