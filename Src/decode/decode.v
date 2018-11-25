`include "./decode/control.v"
`include "./composant/mux.v"
`include "./alu/aluControl.v"

module decode(instruction, op1, op2, aluCtrl);

input [31:0]instruction;
output [31:0]op1, op2;
output [1:0]aluCtrl;

wire [31:0]instruction;
wire op1, op2;
wire aluCtrl;
wire [12:0]controlBits;
wire [4:0]writeRegister;

control control(.opcode(instruction[31:26]), .controlBits(controlBits));
read_file_register readFR1(.index(instruction[25:21]), .value(op1));
read_file_register readFR2(.index(instruction[20:16]), .value(op2));
mux mux(.in1(instruction[20:16]), .in2(instruction[15:11]), .ctrl(controlBits[0]), .out(writeRegister));
write_file_register writeFR(.index(5'b1), .value({27'b0, writeRegister}));
aluControl aluControl(.aluOp(instruction[31:26]), .aluCtrl(aluCtrl));
endmodule
