module wb(result, readData, memToReg, valueToWB);

input [31:0]result, readData; 
input memToReg;
output [31:0]valueToWB; 

mux32 getValueToWB(.in1(result), 
	.in2(readData), 
	.ctrl(memToReg), 
	.out(valueToWB)
);

endmodule