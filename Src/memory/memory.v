'include "./preprocessor_directives.v"

module memory(
	      // PORT 1 : READ ONLY
	      input wire [ADDR_SIZE-1:0]   p1_read_address,
	      input wire 		   p1_enable,
	      output wire [LINE_WIDTH-1:0] p1_out_data = 0,
	      output wire 		   p1_ready, 

	      // PORT 2 : READ OR WRITE
	      input wire [ADDR_SIZE-1:0]   p2_address,
	      input wire [LINE_WIDTH-1:0]  p2_in_data,
	      input wire 		   p2_write_or_read,
	      input wire 		   p2_enable,
	      output wire [LINE_WIDTH-1:0] p2_out_data = 0,
	      output wire 		   p2_ready, 

	      // RESET MEMORY CONTENTS
	      input wire 		   reset);
   
   parameter LINE_WIDTH = 'LINE_WIDTH;
   parameter ADDR_SIZE = 'PHYS_ADDR_SIZE;
   parameter LATENCY = 'MEMORY_LATENCY;
   parameter MEMORY_CONTENT = 'MEMORY_CONTENT;

   localparam MEM_SIZE = $pow(2, 'PHYS_MEM_SIZE);
   localparam LINES = MEM_SIZE / LINE_WIDTH;
   localparam LINE_ADDR_SIZE = $clog2(LINES);
   
   reg [LINE_WIDTH-1:0] memory [0:LINES-1];
   wire [LINE_ADDR_SIZE-1:0] p1_line_addr = p1_read_address[ADDR_SIZE-1:ADDR_SIZE-LINE_ADDR_SIZE];
   wire [LINE_ADDR_SIZE-1:0] p2_line_addr = p2_address[ADDR_SIZE-1:ADDR_SIZE-LINE_ADDR_SIZE];

   // PORT 1
   always@(*) begin
      if(p1_enable) begin
	 if (p1_line_addr >= LINES) 'CERR("[memory] [p1] Physical (byte) address %x does not exist", p1_read_address);
	 if (p2_enable && p2_write_or_read=='WRITE) begin
	    'WARNING("[memory] Port2 is writing the data that is being accessed by port 1");
	    p1_out_data = p2_in_data;
	 end else begin
	    p1_out_data = memory[p1_line_addr];
	 end
	 'COUT("[memory] [p1] Read from %x (current value %x) is being performed", p1_read_address, p1_out_data);
	 # LATENCY
	   if (!reset) p1_ready = 1;
	   else p1_ready = 0;
	 'COUT("[memory] [p1] Memory access completed");
      end else begin
	 p1_ready = 0;
	 p1_out_data = 0;
      end      
   end
   
   // PORT 2
   always@(*) begin
      if(p2_enable) begin
	 if (p2_line_addr >= LINES) 'CERR("[memory] [p2] Physical (byte) address %x does not exist", p2_address);
	 if(p2_write_or_read == 'WRITE) begin
	    memory[p2_line_addr] = p2_in_data;
	    p2_out_data = p2_in_data;
	    'COUT("[memory] [p2] Write %x to address %x is being performed", p2_in_data, p2_address);
	 end else begin
	    p2_out_data = memory[p2_line_addr];
	    'COUT("[memory] [p2] Read from %x (current value %x) is being performed", p2_address, p2_out_data);
	 end
	 # LATENCY
	   (if !reset) p2_ready = 1;
	   else p2_ready = 0;
	 'COUT("[memory] [p2] Memory access completed");
      end else begin
	 p2_ready = 0;
	 p2_out_data = 0;
      end      
   end

   always@(posedge reset) begin
      $readmemh(MEMORY_CONTENT, memory);
      p1_enable = 0;
      p2_enable = 0;
      p1_ready = 0;
      p2_ready = 0;
      p1_data_out = {LINE_WIDTH{1'b0}};
      p2_data_out = {LINE_WIDTH{1'b0}};
   end

endmodule
