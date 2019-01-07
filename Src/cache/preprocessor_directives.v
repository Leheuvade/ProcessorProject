`ifndef _cache_preprocessor_directives
`define _cache_preprocessor_directives
`include "preprocessor_directives.v"

`define CACHE_LINES 4
`define LINE_ADDR_SIZE ($clog2(`CACHE_LINES))
`define CACHE_ADDR_RANGE (`LINE_ADDR_START_INDEX+`LINE_ADDR_SIZE-1:`LINE_ADDR_START_INDEX)
`define TAG_SIZE (`PHYS_ADDR_SIZE - `LINE_ADDR_SIZE - `LINE_ADDR_START_INDEX)
  
`endif
