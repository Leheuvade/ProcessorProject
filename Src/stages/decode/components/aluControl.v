`include "instruction_encoding.v"
module aluControl (aluOp, aluCtrl);

input [5:0]aluOp;
output [1:0]aluCtrl;

wire [5:0]aluOp = if_id.instruction[31:26];
reg aluCtrl;

always @ (aluOp) //ToFINISH
case(aluOp)
  6'b0 : begin // Opcode 0x0 - ADD
        aluCtrl = 2'b00; //ADD
            end
  6'b1 : begin // Opcode 0x1 - SUB
        aluCtrl = 2'b10;
            end
  6'b10 : begin // Opcode 0x1 - MUL
        aluCtrl = 2'b01;
            end
  6'b010000 : begin // LDB -> ADD
        aluCtrl = 2'b00;
        end
  6'b010001 : begin // LDW -> ADD
  			aluCtrl = 2'b00;
  			end
  6'b010010 : begin // STB -> ADD
        aluCtrl = 2'b00;
        end
  6'b010011 : begin //STW -> ADD
        aluCtrl = 2'b00;
  end
  `MOVRM1 : begin
     aluCtrl = 2'b00;
  end
  `TLBWRITE : begin
     aluCtrl = 2'b00;
  end
  `IRET : begin
     aluCtrl = 2'b00;
  end
  6'b110000 : begin //BEQ -> SUB
        aluCtrl = 2'b10;
      end
  default : begin
              $display("@%0dns AluControl default case %b", $time, aluOp);
            end
endcase

endmodule
