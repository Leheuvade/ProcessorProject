module  data_memory(address, write_data, memRead, memWrite, byte, word, read_data);

input [31:0]address;
input [31:0]write_data;
input memWrite; //Conrol bits: =1 -> The current adr is passed to read data 
input memRead; //Control bits 
input byte; //LDB, SDB
input word; //LDW, SDW
output [31:0]read_data; //Data read from memory to be written in register 

wire address;
wire write_data;
wire memWrite;
wire memRead;
wire byte;
wire word;  
reg read_data;
reg [7:0] memory [0:18];


initial begin
 $readmemb("../Resources/data_memory.list", memory);
end 

always @(address or memRead or memWrite or write_data) begin 
	if(memWrite == 1'b1) begin
	//defult is byte
			if(byte == 1'b1) begin
				memory[address] = write_data;
			end
			else if (word == 1'b1) begin 
				//memory[address] = write_data;
				{memory[address], memory[address + 1],  memory[address + 2], memory[address + 3]} = write_data;
			end
	end 


	
	else if (memRead == 1'b1) begin
			if(byte == 1'b1) begin
				read_data = memory[address];
			end
			else if (word == 1'b1) begin 
			// something like this: 
				read_data = {memory[address], memory[address + 1],  memory[address + 2], memory[address + 3]};
			end

	end

end
endmodule