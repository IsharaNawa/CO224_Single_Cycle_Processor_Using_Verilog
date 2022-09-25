`include "CPU.v"
`include "DATAMEMORYv2.v"
`include "DATACACHE.v"
`include "INST_CACHE.v"
`include "IMEM.v"

module system;
    reg CLK, RESET;
    wire[31:0] PC;
	
    wire BUSYWAIT, WRITE, READ;
    wire [7:0] READDATA, ADDRESS, WRITEDATA;
    wire[31:0] INSTRUCTION;
    cpu c(PC, INSTRUCTION, CLK, RESET, BUSYWAIT, IMEMBUSYWAIT, READDATA, WRITE, READ, ADDRESS, WRITEDATA);

    wire mem_busywait; 
    wire mem_read, mem_write;
    wire[5:0] mem_address;
    wire[31:0] mem_writedata;
    wire[31:0] mem_readdata;
    dcache dc(CLK, RESET, READ, WRITE, mem_busywait, ADDRESS, WRITEDATA, mem_readdata, mem_read, mem_write, BUSYWAIT, mem_address, READDATA, mem_writedata);

    data_memory d(CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);

    wire IBUSYWAIT, IREAD;
    wire[5:0] OUTADDRESS;
    wire[127:0] IREADDATA;
    icache ic(CLK, IBUSYWAIT, PC, IREADDATA, IREAD, IMEMBUSYWAIT, OUTADDRESS, INSTRUCTION);

    instruction_memory im(CLK, IREAD, OUTADDRESS, IREADDATA, IBUSYWAIT);

    ////////////////////////////////////////////////////////////////////////////////////

    initial begin
        $dumpfile("sys_wavedata.vcd");
		$dumpvars(0, system);
		//$monitor($time,"\t%d\t%d\t%d", CLK, PC, RESET);
        CLK = 0; RESET = 1;
        #5 RESET = 0;
    #4000 $finish;
	end
    always
        #4 CLK = ~CLK;
endmodule