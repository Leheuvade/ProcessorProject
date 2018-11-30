module pc(inPC, rst, clock, outPC);

input [31:0]inPC; 
input clock, rst;
output [31:0]outPC;

wire clock, rst;
wire inPC;
reg outPC;

always @ (posedge clock)
if (rst) begin
  outPC <= 0;
end else  begin
  outPC <= inPC;
end

endmodule