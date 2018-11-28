module mem_wb(inResult, inReadData, clock, outResult, outReadData);

input [31:0]inResult, inReadData; 
input clock;
output [31:0]outResult, outReadData;

wire clock;
wire inResult, inReadData;
reg outResult, outReadData;

always @ (posedge clock)begin 
  outResult <= inResult;
  outReadData <= inReadData;
 end

endmodule