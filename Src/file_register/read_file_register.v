
module  read_file_register(index, value);

input [4:0]index;
output [31:0]value; 

wire index;
reg value;
reg [31:0] registers [0:31];

always @(index) begin
	$readmemh("../Resources/file_register.list", registers);
	value = registers[index];
end

endmodule