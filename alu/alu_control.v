module alu_control (aluOp, aluCtrl);

input [7:0]aluOp;
output [1:0]aluCtrl;

reg aluCtrl;
wire aluOp;


always @ (aluOp) 
case(aluOp)
  8'h0 : begin 
   			$display("aluop = %h", aluOp);
            aluCtrl <= 2'b00;
            end
  default : begin
              $display("AluControl default case %b", aluOp);
            end
endcase

endmodule
