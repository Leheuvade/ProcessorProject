module control (opcode, controlBits);

input [5:0]opcode;
output [12:0]controlBits;

wire opcode;
reg controlBits;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite;
always @ (opcode) begin
case(opcode) //Update with the reals values
  6'b0 : begin // Opcode 0x0 - ADD
      regDst = 1'b1; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b1;
            end
  6'b111111 : begin
      regDst = 1'b1; 
      branch = 1'b1;
      memRead = 1'b1;
      memToReg = 1'b1;
      memWrite = 1'b1; 
      aluSrc = 1'b1;
      regWrite = 1'b1;
    end
  default : begin
              $display("@%0dns default is selected, opcode %b",$time,opcode);
            end
endcase
controlBits = {regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, opcode};
end

endmodule
