module control (
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

input [7:0]opcode;
output [7:0]aluOp;
output regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite;

wire opcode;
reg regDst, branch, memRead, memToReg, aluOp, memWrite, aluSrc, regWrite;

always @ (opcode)
case(opcode)
  8'h1 : begin // Don't care about lower 2:1 bit, bit 0 match with x
              regDst = 1'b1; 
              branch = 1'b0;
              memRead = 1'b0;
              memToReg = 1'b0;
              memWrite = 1'b0; 
              aluSrc = 1'b0;
              regWrite = 1'b1;
              aluOp = opcode;
            end
  default : begin
              $display("@%0dns default is selected, opcode %b",$time,opcode);
            end
endcase

endmodule
