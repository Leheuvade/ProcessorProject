module  data_memory(address, write_data, memRead, memWrite, read_data);

input [31:0]address;
input [31:0]write_data;
input memWrite; //Conrol bits: =1 -> The current adr is passed to read data 
input memRead; //Control bits 
output [31:0]read_data; //Data read from memory to be written in register 

wire address;
wire write_data;
wire memWrite;
wire memRead; 
reg read_data;
reg [7:0] memory [0:18];


initial begin
 $readmemb("../Resources/data_memory.list", memory);
end 

always @(address or memRead or memWrite or write_data) begin 
	if(memWrite == 1'b1) begin
		memory[address] = write_data;
		$writememb("../Resources/data_memory.list", memory);
	end else if (memRead == 1'b1) begin
		read_data = memory[address];
	end
end
endmodule