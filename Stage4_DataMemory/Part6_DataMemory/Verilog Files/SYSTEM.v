//this module make up the cpu and data memory systems together


//including the cpu and data memory
`include "CPU.v"
`include "DATAMEMORY.v"

//instatiating the system module 
module SYSTEM(INSTRUCTION,PC,CLK,RESET);
	
	//declaring I/O
	input [31:0] INSTRUCTION;
	input CLK,RESET;
	output [31:0] PC;
	
	//decaring wires to connect to CPU and the DATA MEMORY
	wire BUSYWAIT;
	wire [7:0]READDATA;
	wire WRITE,READ;
	wire [7:0]ADDRESS,WRITEDATA;
	
	//instatiating two modules
	data_memory mydatamem(CLK,RESET,READ,WRITE,ADDRESS,WRITEDATA,READDATA,BUSYWAIT);
	cpu mycpu(PC, INSTRUCTION, CLK, RESET,BUSYWAIT,READDATA,WRITE,READ,ADDRESS,WRITEDATA);

endmodule