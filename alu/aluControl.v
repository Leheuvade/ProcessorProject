module aluControl (aluOp, aluCtrl);

input [6:0]aluOp;
output [1:0]aluCtrl;

reg aluCtrl;
wire aluOp;


always @ (aluOp) 
case(aluOp)
  7'h0 : begin // Opcode 0x0 - ADD
            aluCtrl <= 2'b00; //ADD
            end
  default : begin
              $display("AluControl default case %b", aluOp);
            end
endcase

endmodule
