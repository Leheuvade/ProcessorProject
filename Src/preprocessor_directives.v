`ifndef _preprocessor_directives
`define _preprocessor_directives

`define NONE 0
`define ALWAYS_TRUE 1

`define READ 0
`define WRITE 1

`define WORD_SIZE 32
`define BYTE_SIZE 8

`define INSTRUCTION_LENGTH 32

`define LINE_WIDTH 128
`define LINE_ADDR_START_INDEX 4 //($clog2(`LINE_WIDTH) - 3)    
`define PHYS_MEM_SIZE 20
`define PHYS_ADDR_SIZE (`PHYS_MEM_SIZE - 3)

`define CERR(Error) begin $display ("[ERROR] "); $display Error; end
`define COUT(Info) begin $display ("[INFO] "); $display Info; end
`define WARNING(Warning) begin $display ("[WARNING] "); $display Warning; end
  
`endif
