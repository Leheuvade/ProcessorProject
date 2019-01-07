module control;

reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, jump, word;
wire [5:0]opcode = if_id.instruction[31:26];

always @ (opcode) begin
if (decode.flush_CtrlBits) begin // TODO : remove ce flush car ça équivaut à une bubble
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b0;
      jump = 1'b0;
      word = 1'b0;
end else begin
case(opcode)
  6'b0 : begin // Opcode 0x0 - ADD
      regDst = 1'b1; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b1;
      jump = 1'b0;
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
      word = 1'b0;
            end
  6'b010000 : begin // Opcode 0x10 - LDB: //To sign Extend, to 32 bits in register 
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b1;
      memToReg = 1'b1;
      memWrite = 1'b0; 
      aluSrc = 1'b1;
      regWrite = 1'b1;
      jump = 1'b0;
      word = 1'b0;
    end
  6'b010001 : begin // Opcode 0x11 - LDW
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b1;
      memToReg = 1'b1;
      memWrite = 1'b0; 
      aluSrc = 1'b1;
      regWrite = 1'b1;
      jump = 1'b0;
      word = 1'b1;
            end
  6'b010010 : begin // Opcode 0x12 - STB
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b1; 
      aluSrc = 1'b1;
      regWrite = 1'b0;
      jump = 1'b0;
      word = 1'b0;
    end
  6'b010011 : begin // Opcode 0x13 - STW
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b1; 
      aluSrc = 1'b1;
      regWrite = 1'b0;
      jump = 1'b0;
      word = 1'b1;
    end
//PC 
  6'b110000 : begin // Opcode 0x30 - BEQ
      regDst = 1'b0; 
      branch = 1'b1;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b0;
      jump = 1'b0;
      word = 1'b0;
    end
  6'b110001 : begin // Opcode 0x31 - JUMP 
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b0;
      jump = 1'b1;
      word = 1'b0;
    end
  default : begin
              $display("@%0dns default is selected, opcode %b",$time,opcode);
      regDst = 1'b0; 
      branch = 1'b0;
      memRead = 1'b0;
      memToReg = 1'b0;
      memWrite = 1'b0; 
      aluSrc = 1'b0;
      regWrite = 1'b0;
      jump = 1'b0;
      word = 1'b0;
            end
endcase
end
end

endmodule
