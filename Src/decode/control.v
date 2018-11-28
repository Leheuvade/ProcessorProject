module control (opcode, controlBits);

input [5:0]opcode;
output [12:0]controlBits;

wire opcode;
reg controlBits;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, jump, byte, word;
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
      jump = 1'b0;
      byte = 1'b0;
      word = 1'b0;
            end
  6'b000001 : begin // Opcode 0x1 - SUB
      regDst = 1'b1; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b1;
      jump = 1'b0;
      byte = 1'b0;
      word = 1'b0;
            end
  6'b000010 : begin // Opcode 0x2 - MUL
      regDst = 1'b1; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b1;
      jump = 1'b0;
      byte = 1'b0;
      word = 1'b0;
            end
  6'b001010 : begin // Opcode 0x10 - LDB: //To sign Extend, to 32 bits in register 
      regDst = 1'b1; 
      branch = 1'b0;
      memRead = 1'b1;
      memToReg = 1'b1;
      memWrite = 1'b0; 
      aluSrc = 1'b1;
      regWrite = 1'b1;
      jump = 1'b0;
      byte = 1'b1;
      word = 1'b0;
    end

    //Optional?
  6'b001011 : begin // Opcode 0x11 - LDW
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b1;
      memToReg = 1'b1;
      memWrite = 1'b0; 
      aluSrc = 1'b1;
      regWrite = 1'b1;
      jump = 1'b0;
      byte = 1'b0;
      word = 1'b1;
            end
  6'b001100 : begin // Opcode 0x12 - STB
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b1; 
      aluSrc = 1'b1;
      regWrite = 1'b0;
      jump = 1'b0;
      byte = 1'b1;
      word = 1'b0;
    end

    //Optional?

  6'b001101 : begin // Opcode 0x13 - STW
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b1; 
      aluSrc = 1'b1;
      regWrite = 1'b0;
      jump = 1'b0;
      byte = 1'b0;
      word = 1'b1;
    end


//PC 
  6'b011110 : begin // Opcode 0x30 - BEQ
      regDst = 1'b0; 
      branch = 1'b1;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b0;
      jump = 1'b0;
      byte = 1'b0;
      word = 1'b0;
    end

  6'b011111 : begin // Opcode 0x31 - JUMP 
      regDst = 1'b1; 
      branch = 1'b1;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b0;
      jump = 1'b1;
      byte = 1'b0;
      word = 1'b0;
    end


  default : begin
              $display("@%0dns default is selected, opcode %b",$time,opcode);
            end
endcase
controlBits = {regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, opcode, jump, byte, word};
end

endmodule
