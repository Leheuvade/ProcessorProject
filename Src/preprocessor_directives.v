'ifndef _preprocessor_directives
'define _preprocessor_directives

'define READ 0
'define WRITE 1

'define LINE_WIDTH 128
'define PHYS_MEM_SIZE 20
'define PHYS_ADDR_SIZE ('PHYS_MEM_SIZE - 3)

'define CERR(Error) begin $write("[ERROR] "); $display(Error); end
'define COUT(Info) begin $write("[Info] "); $display(Info); end
'define WARNING(Warning)begin $write("[Warning] "); $display(Warning); end
  
'endif
