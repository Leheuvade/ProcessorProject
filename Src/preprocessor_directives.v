`ifndef _preprocessor_directives
`define _preprocessor_directives

//MEMORY MISSION
`define READDATA 0
`define READINST 1
`define WRITEDATA 2

`define LATENCY 5
`define MEM_SIZE (`MEM_LINES * `LINE_WIDTH)
`define MEM_LINES 100
`define LINE_WIDTH 128
`define LINE_NB_BYTES 16
`define CACHE_LINES 4
// Should change name : this is for the virtual to memory page translation
`define OFFSET 12 
`define PHYS_ADDR_SIZE 20
`define BOOT_ADDR (32'h1000)
`define EXCEPTIONS_ADDR (32'h2000)

`define INSTRUCTION_LENGTH 20
`define OFFSET_ADDR_SIZE $clog2(`LINE_NB_BYTES)
`define INDEX_ADDR_SIZE $clog2(`CACHE_LINES)
`define TAG_ADDR_SIZE (`INSTRUCTION_LENGTH - `INDEX_ADDR_SIZE - `OFFSET_ADDR_SIZE)

`define CERR(Error) begin $display ("[ERROR] "); $display Error; end
`define COUT(Info) begin $display ("[INFO] "); $display Info; end
`define WARNING(Warning) begin $display ("[WARNING] "); $display Warning; end
  
`endif
