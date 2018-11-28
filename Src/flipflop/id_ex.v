module id_ex(inR1, inR2, inAddress, inAluCtrl, inControlBits, clock, outR1, outR2, outAluCtrl, outAddress, outControlBits);

input [31:0]inR1, inR2, inAddress;
input [9:0]inControlBits; 
input [1:0]inAluCtrl;
input clock;
output [31:0]outR1, outR2, outAddress;
output [9:0]outControlBits;
output [1:0]outAluCtrl;

wire clock;
wire inR1, inR2, inAddress, inControlBits;
wire inAluCtrl;
reg outR1, outR2, outAddress, outControlBits;
reg outAluCtrl;

always @ (posedge clock) begin
  outR1 <= inR1;
  outR2 <= inR2;
  outAluCtrl <= inAluCtrl;
  outAddress <= inAddress;
  outControlBits <= inControlBits;
end

endmodule