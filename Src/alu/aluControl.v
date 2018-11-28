module aluControl (aluOp, aluCtrl);

input [5:0]aluOp;
output [1:0]aluCtrl;

reg aluCtrl;
wire aluOp;


always @ (aluOp) 
case(aluOp)
  6'b0 : begin // Opcode 0x0 - ADD
            aluCtrl <= 2'b00; //ADD
            end
  6'b001011 : begin
  			aluCtrl <= 2'b00;
  end
  default : begin
              $display("AluControl default case %b", aluOp);
            end
endcase

endmodule
