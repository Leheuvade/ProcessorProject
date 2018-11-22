module decode (opcode, y, clock);

input [6:0]opcode;
input clock;
output [13:0]y;

wire opcode, clock;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite;
reg y;

always @ (posedge clock) begin
case(opcode)
  8'h0 : begin // Opcode 0x0 - ADD
              regDst = 1'b1; 
              branch = 1'b0;
              memRead = 1'b0;
              memToReg = 1'b0;
              memWrite = 1'b0; 
              aluSrc = 1'b0;
              regWrite = 1'b1;
            end
  default : begin
              $display("@%0dns default is selected, opcode %b",$time,opcode);
            end
endcase
y <= {regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, opcode};
end

endmodule
