`include "./alu/aluControl.v"

module alu (op1, op2, aluOp, zero, result, clock);

input [31:0]op1, op2;
input [6:0]aluOp;
input clock; 

output zero;
output [31:0]result;

reg zero, result;
wire op1, op2, ctrl, clock;
wire [1:0]aluCtrl;

aluControl aluControl(.aluOp(aluOp), .aluCtrl(aluCtrl));

always @ (posedge clock) begin
	zero <= 0;
	if (op1 == op2) begin
	  zero <= 1;
	end

	case(aluCtrl)
	  2'b0 : begin 
	            result <= op1 + op2;
	            end
	  2'b10 : begin
	            result <= op1  - op2;
	            end
	  2'b01 : begin
	            result <= op1  * op2;
	            end
	  default : begin
	              $display("Alu default case ctrl = %b", aluCtrl);
	            end
	endcase
end

endmodule
