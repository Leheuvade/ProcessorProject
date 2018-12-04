module id_ex(inR1, inR2, inAddress, inAluCtrl, inControlBits, inRd, inPc, inRs, inRt, clock, outR1, outR2, outAluCtrl, outAddress, outControlBits, outRd, outPc, outRs, outRt);

input [31:0]inR1, inR2, inAddress, inPc;
input [0:8]inControlBits; 
input [1:0]inAluCtrl;
input [4:0]inRd, inRs, inRt;
input clock;
output [31:0]outR1, outR2, outAddress, outPc;
output [0:8]outControlBits;
output [1:0]outAluCtrl;
output [4:0]outRd, outRs, outRt;


wire clock;
wire inR1, inR2, inAddress, inPc; 
wire inControlBits;
wire inAluCtrl;
wire inRd, inRs, inRt;
reg outR1, outR2, outAddress, outPc;
reg outControlBits;
reg outRt, outRs, outRd;
reg outAluCtrl;

always @ (posedge clock) begin
  outR1 <= inR1;
  outR2 <= inR2;
  outAluCtrl <= inAluCtrl;
  outAddress <= inAddress;
  outControlBits <= inControlBits;
  outRd <= inRd;
  outPc <= inPc;
  outRs <= inRs;
  outRt <= inRt;
end

endmodule