module if_id(inInstr, inPc, clock, outInstr, outPc);

input [31:0]inInstr, inPc; 
input clock;
output [31:0]outInstr, outPc;

wire clock;
wire inInstr, inPc;
reg outInstr, outPc;

always @ (posedge clock) begin
  outInstr <= inInstr;
  outPc <= inPc;
end

endmodule