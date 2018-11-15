// Testbench Code Goes here
module control_tb;

reg [7:0]opcode;
wire [7:0]aluOp;
wire regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite;

initial begin
  $dumpfile("control.vcd");
  $dumpvars(0, control_tb);
  $monitor ("regDst=%b,branch=%b,memRead=%b,memToReg=%b,aluOp=%b,memWrite=%b,aluSrc=%b,regWrite=%b"
    , regDst, branch, memRead, memToReg, aluOp, memWrite, aluSrc, regWrite);
  opcode = 8'h1;
  #4 $finish;
end

control U0 (
opcode,
regDst, 
branch,
memRead, 
memToReg, 
aluOp, 
memWrite, 
aluSrc, 
regWrite
);

endmodule