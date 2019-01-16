// `include "../preprocessor_directives.v"

module dataLineSelector(offset, line, data);

input [$clog2(`LINE_NB_BYTES) - 1:0]offset;
input [`LINE_WIDTH - 1:0]line;
output [`INSTRUCTION_LENGTH - 1:0]data;

// reg [$clog2(`LINE_NB_BYTES) - 1:0]offset;
// reg [`LINE_WIDTH - 1:0]line;

// initial begin 
//   $dumpfile("dataLineSelector.vcd");
//   $dumpvars(0, dataLineSelector);
//   offset = 4;
//   data = 0;
//   #8 line = 5;
//   #2 offset = 12;
//   #50 $finish;
// end

reg data;

always @ (offset or line) begin
data = line[31:0];
// case(offset)
//   0 : begin // Opcode 0x0 - ADD
//         data = line[0 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:0 * `INSTRUCTION_LENGTH];
//             end
//   4 : begin // Opcode 0x1 - SUB
//         data = line[1 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:1 * `INSTRUCTION_LENGTH];
//             end
//   8 : begin // Opcode 0x1 - MUL
//         data = line[2 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:2 * `INSTRUCTION_LENGTH];
//             end
//   12 : begin // LDB -> ADD
//         data = line[3 * `INSTRUCTION_LENGTH + `INSTRUCTION_LENGTH - 1:3 * `INSTRUCTION_LENGTH];
//         end
//   default : begin
//       $display("offset doesn't match any case", offset);
//   end
// endcase	
end


endmodule