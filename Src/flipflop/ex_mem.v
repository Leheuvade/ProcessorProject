module ex_mem(inZero, inResult, clock, outZero, outResult);

input inZero;
input [31:0]inResult; 
input clock;
output outZero;
output [31:0]outResult;

wire clock;
wire inZero;
wire inResult;
reg outZero;
reg outResult;

always @ (posedge clock) begin
  outResult <= inResult;
  outZero <= inZero;
end

endmodule