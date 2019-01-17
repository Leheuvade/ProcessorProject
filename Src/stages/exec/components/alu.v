module alu (
	    input [31:0]      op1,
	    input [31:0]      op2,
	    input wire 	      ignore_op2,
	    input [1:0]       aluCtrl,
	    output 	      zero,
	    output reg [31:0] result);
   
   reg 			      op2_if_not_ignored;
   assign zero = op1 == op2;
   always@(*) op2_if_not_ignored = (ignore_op2) ? 0 : op2;

   always @ (*) begin
	case(aluCtrl)
	  2'b0 : begin 
	            result = op1 + op2_if_not_ignored;
	            end
	  2'b10 : begin
	            result = op1  - op2_if_not_ignored;
	            end
	  2'b01 : begin
	            result = op1  * op2_if_not_ignored;
	            end
	  default : begin
	              $display("Alu default case ctrl = %b", aluCtrl);
	            end
	endcase
end

endmodule
