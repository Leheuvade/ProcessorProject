module decode (clock, instruction, address, rs, rt, rd, controlBits);

input [31:0]instruction;
input clock;
output [12:0]controlBits;
output[4:0]rs, rt, rd;
output [14:0]address;

wire [31:0]instruction;
wire clock;
reg [5:0]opcode;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite;
reg rs, rt, rd;
reg controlBits;

always @ (posedge clock) begin
opcode = instruction[31:26];
case(opcode) //Update with the reals values
  6'b0 : begin // Opcode 0x0 - ADD
              regDst = 1'b1; 
              branch = 1'b0;
              memRead = 1'b0;
              memToReg = 1'b0;
              memWrite = 1'b0; 
              aluSrc = 1'b0;
              regWrite = 1'b1;
              rs = instruction[25:21];
              rt = instruction[20:16];
              rd = instruction[15:11];
            end
  6'b111111 : begin // Opcode 0x0 - ADD
      regDst = 1'b1; 
      branch = 1'b1;
      memRead = 1'b1;
      memToReg = 1'b1;
      memWrite = 1'b1; 
      aluSrc = 1'b1;
      regWrite = 1'b1;
      rs = instruction[25:21];
      rt = instruction[20:16];
      rd = instruction[15:11];
    end
  default : begin
              $display("@%0dns default is selected, opcode %b",$time,opcode);
            end
endcase
controlBits = {regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, opcode};
end

endmodule
