`ifndef _preprocessor_directives
`define _preprocessor_directives

`define LATENCY 5
`define MEM_SIZE (`MEM_LINES * `LINE_WIDTH)
`define MEM_LINES 100
`define LINE_WIDTH 128
`define LINE_NB_BYTES 16
`define CACHE_LINES 4

`define INSTRUCTION_LENGTH 32
`define OFFSET_ADDR_SIZE $clog2(`LINE_NB_BYTES)
`define INDEX_ADDR_SIZE $clog2(`CACHE_LINES)
`define TAG_ADDR_SIZE (`INSTRUCTION_LENGTH - `INDEX_ADDR_SIZE - `OFFSET_ADDR_SIZE)

`define CERR(Error) begin $display ("[ERROR] "); $display Error; end
`define COUT(Info) begin $display ("[INFO] "); $display Info; end
`define WARNING(Warning) begin $display ("[WARNING] "); $display Warning; end
  
`endif