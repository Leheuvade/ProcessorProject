module dataLineSelector(offset, line, data);

input [$clog2(`LINE_NB_BYTES) - 1:0]offset;
input [`LINE_WIDTH - 1:0]line;
output [`INSTRUCTION_LENGTH - 1:0]data;

reg data;

always @ (offset or line) begin
  	$display("lines : %b", line);
case(offset)
  0 : begin // Opcode 0x0 - ADD
  	$display("0 data = %b", data);
        data = line[0 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:0 * `INSTRUCTION_LENGTH];
            end
  4 : begin // Opcode 0x1 - SUB
  	$display("1 data = %b", data);
        data = line[1 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:1 * `INSTRUCTION_LENGTH];
            end
  8 : begin // Opcode 0x1 - MUL
  	$display("2 data = %b", data);
        data = line[2 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:2 * `INSTRUCTION_LENGTH];
            end
  12 : begin // LDB -> ADD
  	$display("3 data = %b", data);
        data = line[3 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:3 * `INSTRUCTION_LENGTH];
        end
  default : begin
      $display("offset doesn't match any case", offset);
  end
endcase	
end


endmodule