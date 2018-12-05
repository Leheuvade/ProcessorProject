module id_ex(inR1, 
	inR2, 
	inAddress, 
	inAluCtrl, 
	inControlBits,
	inRd, 
	inPc, 
	inRs, 
	inRt, 
	rst, 
	clock, 
	outR1, 
	outR2, 
	outAluCtrl, 
	outAddress, 
	outControlBits, 
	outAluSrc, 
	outMemRead,
	outRd,
	outPc, 
	outRs, 
	outRt
);

input [31:0]inR1, inR2, inAddress, inPc;
input [0:8]inControlBits; 
input [1:0]inAluCtrl;
input [4:0]inRd, inRs, inRt;
input clock, rst;
output [31:0]outR1, outR2, outAddress, outPc;
output [0:8]outControlBits;
output [1:0]outAluCtrl;
output [4:0]outRd, outRs, outRt;
output outAluSrc, outMemRead;

reg outR1, outR2, outAddress, outPc;
reg outControlBits;
reg outRt, outRs, outRd;
reg outAluCtrl;
reg outAluSrc, outMemRead;

always @ (posedge clock) begin
	if (rst) begin
		outR1 <= 0;
	  	outR2 <= 0;
	  	outAluCtrl <= 0;
		outAddress <= 0;
		outControlBits <= 0;
		outAluSrc <= 0;
		outRd <= 0;
		outPc <= 0;
		outRs <= 0;
		outRt <= 0;
	end else begin 
		outR1 <= inR1;
		outR2 <= inR2;
		outAluCtrl <= inAluCtrl;
		outAddress <= inAddress;
		outControlBits <= inControlBits;
		outAluSrc <= inControlBits[5];
		outMemRead <= inControlBits[2];
		outRd <= inRd;
		outPc <= inPc;
		outRs <= inRs;
		outRt <= inRt;

	end
end

endmodule