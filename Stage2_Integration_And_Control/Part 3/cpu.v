//module to the the negative value of the operand2
module complimenter(DATA, COMPLIMENT);
    input[7:0] DATA;
    output[7:0] COMPLIMENT;
    assign #1 COMPLIMENT = ~DATA + 1;	//negative value is assigned with time delay of 1 unit
endmodule

//module to implement the muxes
module mux(DATA1, DATA2, OUTPUT, SELECT);
    input[7:0] DATA1, DATA2;
    input SELECT;
    output reg[7:0] OUTPUT;
    always @ (SELECT) begin	
        if (SELECT == 1'b0)				//if select is 0 choose DATA1 as the output
            OUTPUT = DATA1;
        else
            OUTPUT = DATA2;				//otherwise select DATA2 as the output
    end
endmodule

//module to implement the cpu 
module cpu(PC, INSTRUCTION, CLK, RESET);
    input[31:0] INSTRUCTION;	//input from the instruction memory
    input CLK, RESET;			//clock and reset signals for cpu
    output reg[9:0] PC;			//program counter to point to the next instruction in the instruction memory

    wire[7:0] IN, OUT1, OUT2, COMPLIMENT, OUTPUT1, OUTPUT2;			//declaring wires for connecting the corresponding modules
    
    reg[7:0] IMMEDIATE;			//register to store the immediate value in the insruction word
    reg[2:0] READREG2, READREG1, WRITEREG, ALUOP;		//registers for handling the registerfile and alu
    reg WRITEENABLE, SELECT1, SELECT2;			//registers for the write signals and selection of the muxes

    reg[7:0] OPCODE;		//register to store the opcode of the instruction
    reg[9:0] PCREG;			//register to store the next pc register value
    
    always @ (INSTRUCTION) begin			//this always block is sensitive to the instruction from the insruction memory
        #2 IMMEDIATE = INSTRUCTION[7:0];	//IMMEDIATE value is taken from the least 8 bits of the instruction	
        READREG2 = INSTRUCTION[2:0];		//reding register 2 select from the last three bits of the insruction
        READREG1 = INSTRUCTION[10:8];		//reading register 2 select from the 8 to 8 bits in the instruction
        WRITEREG = INSTRUCTION[18:16];		//destination register is taken as the bit from 16 to 18
        OPCODE = INSTRUCTION[26:24];		//opcode is taken as the 24 to 26 bits in the insruction
    end					//instruction reading is done in 2 delay time 
    
	always @ (OPCODE) begin
        #1 WRITEENABLE = 1;				
        if (OPCODE == 3'b001) //opcode 1 is considered for the sub instruction
            SELECT1 = 1;	//handling the mux 1
        else
            SELECT1 = 0;	
        if (OPCODE == 3'b111) //opcode 7 is considered for loadi insruction
            SELECT2 = 1;	//handling the mux 
        else
            SELECT2 = 0;
        case (OPCODE)		//case sructure for the opcode
            3'b000: ALUOP = 3'b001; //add instruction
            3'b001: ALUOP = 3'b001; //sub	instruction
            3'b010: ALUOP = 3'b010; //and	instruction
            3'b011: ALUOP = 3'b011; //or	instruction
            3'b110: ALUOP = 3'b000; //mov	instruction
            3'b111: ALUOP = 3'b000; //loadi	instruction
            default: ALUOP = 111;
        endcase
    end
    always @ (posedge CLK) begin		//handling the reset signal
        if (RESET == 1)
            #1 PCREG = 0;
        else
            #1 PCREG = PC;
    end
    always @ (PCREG)
        PC = PCREG + 4;
    
    reg_file rf(IN, OUT1, OUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
    alu al(OUT1, OUTPUT2, IN, ALUOP);
    complimenter c(OUT2, COMPLIMENT);
    mux m1(COMPLIMENT, OUT2, OUTPUT1, SELECT1);
    mux m2(IMMEDIATE, OUTPUT1, OUTPUT2, SELECT2);
endmodule

module tb;
    reg[31:0] INSTRUCTION;
    reg CLK, RESET;
    wire[9:0] PC;
    
    cpu c(PC, INSTRUCTION, CLK, RESET);

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0,c);
        $monitor("\t\t%g\t%b %b %b %b", $time, PC, INSTRUCTION, CLK, RESET);
           RESET = 1;  CLK = 1;
        #1 INSTRUCTION = 32'b00000000_00000000_00000000_00000001; RESET = 0;
        #8 INSTRUCTION = 32'b00000000_00000001_00000000_00000010;   //loadi 1 #2
        #8 INSTRUCTION = 32'b00000000_00000010_00000000_00000011;   //loadi 2 #3
        #8 INSTRUCTION = 32'b00000010_00000101_00000001_00000000;   //add 5 1 0 (r5=3)
        #8 INSTRUCTION = 32'b00000011_00000100_00000010_00000001;   //sub 4 2 1 (r4=1)
        #8 INSTRUCTION = 32'b00000100_00000110_00000000_00000010;   //and 6 2 0(r6=3)
        #8 INSTRUCTION = 32'b00000101_00000011_00000011_00000001;   //or 3 3 1  (r3=2)  
        #8 INSTRUCTION = 32'b00000001_00000111_00000000_00000010;
        #8 $finish;
    end
    always
        #4 CLK = ~CLK;
endmodule