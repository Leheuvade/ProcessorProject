`ifndef _preprocessor_directives
`define _preprocessor_directives

`define None 0
`define ALWAYS_TRUE 1

`define READ 0
`define WRITE 1

`define WORD_SIZE 32
`define BYTE_SIZE 8

`define LINE_WIDTH 128
`define LINE_ADDR_START_INDEX ($clog2(`LINE_WIDTH) - 3)
`define PHYS_MEM_SIZE 20
`define PHYS_ADDR_SIZE (`PHYS_MEM_SIZE - 3)

`define CERR(Error) begin $write("[ERROR] "); $display(Error); end
`define COUT(Info) begin $write("[Info] "); $display(Info); end
`define WARNING(Warning) begin $write("[Warning] "); $display(Warning); end
  
`endif
