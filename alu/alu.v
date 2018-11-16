module alu (op1, op2, ctrl, zero, result);

input [31:0]op1, op2;
input [1:0]ctrl;

output zero;
output [31:0]result;

reg zero, result;
wire op1, op2, ctrl;


always @ (ctrl or op1 or op2) begin
	zero <=0;
	if (op1 == op2) begin
	zero <= 1;
	end 

	case(ctrl)
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
	              $display("Alu default case ctrl = %b", ctrl);
	            end
	endcase
end

endmodule
