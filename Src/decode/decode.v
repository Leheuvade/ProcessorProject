`include "./decode/control.v"
`include "./composant/mux5Bits.v"
`include "./alu/aluControl.v"

module decode(instruction, readRegister1, readRegister2, address, aluCtrl, controlBits);

input [31:0]instruction;
output [31:0]readRegister1, readRegister2, address;
output [7:0]controlBits;
output [1:0]aluCtrl;

wire [31:0]instruction;
wire readRegister1, readRegister2;
wire address = {16'b0, instruction[15:0]};
wire aluCtrl;
wire [7:0]controlBits;
wire [4:0]writeRegister;

control control(.opcode(instruction[31:26]), .controlBits(controlBits));
read_file_register readFR1(.index(instruction[25:21]), .value(readRegister1));
read_file_register readFR2(.index(instruction[20:16]), .value(readRegister2));
mux5 mux(.in1(instruction[20:16]), .in2(instruction[15:11]), .ctrl(controlBits[0]), .out(writeRegister));
write_file_register writeFR(.index(5'b1), .value({27'b0, writeRegister}));// To improve/ to understand
aluControl aluControl(.aluOp(instruction[31:26]), .aluCtrl(aluCtrl));
endmodule
