module alu (op1, op2, aluCtrl, zero, result);

input [31:0]op1, op2;
input [1:0]aluCtrl;
output zero;
output [31:0]result;

reg zero, result;
wire op1, op2;
wire [1:0]aluCtrl;

always @ (op1 or op2 or aluCtrl) begin
	if (op1 == op2) begin
	  zero = 1;
	end else begin
		zero = 0;
	end

	case(aluCtrl)
	  2'b0 : begin 
	            result = op1 + op2;
	            end
	  2'b10 : begin
	            result = op1  - op2;
	            end
	  2'b01 : begin
	            result = op1  * op2;
	            end
	  default : begin
	              $display("Alu default case ctrl = %b", aluCtrl);
	            end
	endcase
end

endmodule
