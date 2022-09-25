`include "CPU.v"
`include "DATAMEMORYv2.v"
`include "DATACACHE.v"

module system(INSTRUCTION,PC,CLK,RESET);
    input [31:0] INSTRUCTION;
	input CLK, RESET;
	output [31:0] PC;
	
    wire BUSYWAIT, WRITE, READ;
    wire [7:0] READDATA, ADDRESS, WRITEDATA;
    cpu c(PC, INSTRUCTION, CLK, RESET, BUSYWAIT, READDATA, WRITE, READ, ADDRESS, WRITEDATA);

    wire mem_busywait; 
    wire mem_read, mem_write;
    wire[5:0] mem_address;
    wire[31:0] mem_writedata;
    wire[31:0] mem_readdata;
    dcache dc(CLK, RESET, READ, WRITE, mem_busywait, ADDRESS, WRITEDATA, mem_readdata, mem_read, mem_write, BUSYWAIT, mem_address, READDATA, mem_writedata);

    data_memory d(CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);
endmodule