module wb(valueToWB);

output [31:0]valueToWB; 

mux32 getValueToWB(.in1(mem_wb.result), 
	.in2(mem_wb.readData), 
	.ctrl(mem_wb.memToReg), 
	.out(valueToWB)
);

endmodule