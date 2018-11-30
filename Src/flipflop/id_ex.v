module id_ex(inR1, inR2, inAddress, inAluCtrl, inControlBits, inWriteRegister, inPc, clock, outR1, outR2, outAluCtrl, outAddress, outControlBits, outWriteRegister, outPc);

input [31:0]inR1, inR2, inAddress, inPc;
input [7:0]inControlBits; 
input [1:0]inAluCtrl;
input [4:0]inWriteRegister;
input clock;
output [31:0]outR1, outR2, outAddress, outPc;
output [7:0]outControlBits;
output [1:0]outAluCtrl;
output [4:0]outWriteRegister;


wire clock;
wire inR1, inR2, inAddress, inPc; 
wire inControlBits;
wire inAluCtrl;
wire inWriteRegister;
reg outR1, outR2, outAddress, outPc;
reg outControlBits;
reg outWriteRegister;
reg outAluCtrl;

always @ (posedge clock) begin
  outR1 <= inR1;
  outR2 <= inR2;
  outAluCtrl <= inAluCtrl;
  outAddress <= inAddress;
  outControlBits <= inControlBits;
  outWriteRegister <= inWriteRegister;
  outPc <= inPc;
end

endmodule