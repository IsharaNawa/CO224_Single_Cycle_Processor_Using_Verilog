// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Kisaru Liyanage

`include "CPU.v"

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    reg [7:0] instr_mem[1023:0];
	assign #2 INSTRUCTION = {instr_mem[PC[9:0]+10'd3],instr_mem[PC[9:0]+10'd2],instr_mem[PC[9:0]+10'd1],instr_mem[PC[9:0]]};
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
    
    initial
    begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem
		
		//opcodes
		/*
			add 0
			sub 1
			and 2
			or 3
			j 4 
			beq 5
			mov 6
			loadi 7
			bne 8
			left shit 9
			right shift 10
			arithmatic shit 11
			rotate 12
			
			
		*/
		
		//please uncomment each section where you want to test the cpu
		 
		 //bne instruction
        /*{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b0000_0111_0000_0100_0000_0000_0000_0101;	//loadi 4 5
		{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b0000_0111_0000_0101_0000_0000_0000_0100;	//loadi 5 4
		{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]}=	32'b0000_1000_0000_0001_0000_0100_0000_0101; //bne 1 4 5
		{instr_mem[10'd15], instr_mem[10'd14], instr_mem[10'd13], instr_mem[10'd12]} =32'b0000_0111_0000_0111_0000_0000_0000_0001; //loadi 7 1
		{instr_mem[10'd19], instr_mem[10'd18], instr_mem[10'd17], instr_mem[10'd16]} =32'b0000_0111_0000_0111_0000_0000_0000_0010; //loadi 7 2*/
		
		//left shift
		/*{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b0000_0111_0000_0100_0000_0000_0000_0101;	//loadi 4 5
		{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b0000_1001_0000_0101_0000_0100_0000_0011;	//sll 5 4 0x03*/
		
		//right shift
		/*
		{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b0000_0111_0000_0100_0000_0000_1001_1010;	//loadi 4 154
		{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b0000_1010_0000_0101_0000_0100_0000_0101;	//srl 5 4 0x05*/
		
		//arithmatic shift right
		/*{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b0000_0111_0000_0100_0000_0000_1001_1010;	//loadi 4 154
		{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b0000_1011_0000_0101_0000_0100_0000_0100;	//sra 5 4 0x04*/
		
		//rotate
		{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b0000_0111_0000_0100_0000_0000_0111_1000;	//loadi 4 120
		{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b0000_1100_0000_0101_0000_0100_0000_0010;	//ror 5 4 0x02
		

        // METHOD 2: loading instr_mem content from instr_mem.mem file
        //$readmemb("instr_mem.mem", instr_mem);
    end
    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b1;
		#5 RESET = 1'b0;
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        
        // finish simulation after some time
        #300
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule