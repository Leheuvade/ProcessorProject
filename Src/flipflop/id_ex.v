module id_ex(inOp1, inOp2, inAluCtrl, clock, outOp1, outOp2, outAluCtrl);

input [31:0]inOp1, inOp2; 
input [1:0]inAluCtrl;
input clock;
output [31:0]outOp1, outOp2;
output [1:0]outAluCtrl;

wire clock;
wire inOp1, inOp2;
wire inAluCtrl;
reg outOp1, outOp2;
reg outAluCtrl;

always @ (posedge clock) begin
  outOp1 <= inOp1;
  outOp2 <= inOp2;
  outAluCtrl <= inAluCtrl;
end

endmodule