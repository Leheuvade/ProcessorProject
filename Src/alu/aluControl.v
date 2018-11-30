module aluControl (aluOp, aluCtrl);

input [5:0]aluOp;
output [1:0]aluCtrl;

reg aluCtrl;
wire aluOp;

always @ (aluOp) //ToFINISH
case(aluOp)
  6'b0 : begin // Opcode 0x0 - ADD
        aluCtrl <= 2'b00; //ADD
            end
  6'b010000 : begin // LDB -> ADD
        aluCtrl <= 2'b00;
        end
  6'b010001 : begin // LDW -> ADD
  			aluCtrl <= 2'b00;
  			end
  6'b010010 : begin // STB -> ADD
        aluCtrl <= 2'b00;
        end
  6'b010011 : begin //STW -> ADD
        aluCtrl <= 2'b00;
        end
  default : begin
              $display("AluControl default case %b", aluOp);
            end
endcase

endmodule
