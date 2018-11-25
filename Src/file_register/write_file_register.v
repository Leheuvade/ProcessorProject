module  write_file_register(index, value);

input [4:0]index;
input clock;
input [31:0]value; 

wire index;
wire value;
reg [31:0] registers [0:31];

always @(posedge clock) begin
	$display("value to rigth=%h at ", value, index);
	$readmemh("../Resources/file_register.list", registers);
	registers[index] = value;
	$writememh("../Resources/file_register.list", registers);
end

endmodule