module decode (opcode, y, clock);

input [6:0]opcode;
input clock;
output [13:0]y;

wire opcode, clock;
reg [6:0] aluOp;
reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite;
reg y;

always @ (posedge clock) begin
case(opcode)
  8'h0 : begin // Don't care about lower 2:1 bit, bit 0 match with x
              regDst = 1'b1; 
              branch = 1'b0;
              memRead = 1'b0;
              memToReg = 1'b0;
              memWrite = 1'b0; 
              aluSrc = 1'b0;
              regWrite = 1'b1;
              aluOp = opcode;
              y <= {regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite, aluOp};
            end
  8'h2 : begin // Carefull it's not the correct values just copy paste for a test !!!!!
              regDst <= 1'b0; 
              branch <= 1'b0;
              memRead <= 1'b0;
              memToReg <= 1'b0;
              memWrite <= 1'b0; 
              aluSrc <= 1'b0;
              regWrite <= 1'b0;
              aluOp <= 8'b0;
            end
  default : begin
              $display("@%0dns default is selected, opcode %b",$time,opcode);
            end
endcase
end

endmodule
