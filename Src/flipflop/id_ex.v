module id_ex(inR1, 
	inR2, 
	inAddress, 
	inAluCtrl, 
	inControlBits,
	inRd, 
	inPc, 
	inRs, 
	inRt, 
	flush, 
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
	outRt, 
	outBranch
);

input [31:0]inR1, inR2, inAddress, inPc;
input [0:8]inControlBits; 
input [1:0]inAluCtrl;
input [4:0]inRd, inRs, inRt;
input clock, flush;
output [31:0]outR1, outR2, outAddress, outPc;
output [0:8]outControlBits;
output [1:0]outAluCtrl;
output [4:0]outRd, outRs, outRt;
output outAluSrc, outMemRead, outBranch;

reg outR1, outR2, outAddress, outPc;
reg outControlBits;
reg outRt, outRs, outRd;
reg outAluCtrl;
reg outAluSrc, outMemRead, outBranch;

always @ (posedge clock) begin
	if (flush) begin
		outControlBits <= 0;
		outAluSrc <= 0;
		outMemRead <= 0;
		outBranch <= 0;
	end else begin 
		outControlBits <= inControlBits;
		outAluSrc <= inControlBits[5];
		outMemRead <= inControlBits[2];
		outBranch <= inControlBits[1];
	end
	outR1 <= inR1;
	outR2 <= inR2;
	outAddress <= inAddress;
	outAluCtrl <= inAluCtrl;
	outRd <= inRd;
	outPc <= inPc;
	outRs <= inRs;
	outRt <= inRt;
end

endmodule