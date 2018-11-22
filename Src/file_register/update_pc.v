module  update_pc(clock);

input clock; 

reg [31:0] registers [0:31];

always @(posedge clock) begin
	$readmemh("../Resources/file_register.list", registers);
	registers[0] = registers[0] + 3'b100;
	$writememh("../Resources/file_register.list", registers);
end

endmodule