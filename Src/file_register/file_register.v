module  read_file_register(clock, index, value);

input [4:0]index;
input clock;
output [31:0]value; 

wire index;
reg value;
reg [31:0] registers [0:31];

always @(negedge clock) begin
	$readmemh("../Resources/file_register.list", registers);
	value = registers[0];
end

endmodule