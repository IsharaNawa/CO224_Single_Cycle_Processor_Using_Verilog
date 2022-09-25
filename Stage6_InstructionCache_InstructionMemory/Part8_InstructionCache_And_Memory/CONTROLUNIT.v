//Group 21(E/17/027,E/17/219)
//this module generates the control flow signals

module controlunit(INSTRUCTION,SELECT1,SELECT2,ALUOP,WRITEENABLE,BEQSIGNAL,JSIGNAL,BNESIGNAL,READ,WRITE,SELECT4,BUSYWAIT);

	//declaring I/O of the module
	input [31:0] INSTRUCTION;
	output reg SELECT1,SELECT2,WRITEENABLE,BEQSIGNAL,JSIGNAL,BNESIGNAL,READ,WRITE,SELECT4;
	output reg [2:0] ALUOP;
	input BUSYWAIT;
	
	//this always block de-assert the READ and WRITE signals when BUSYWAIT de-asserts from the data memory
	always @(negedge BUSYWAIT)
	begin
		
		READ=0;
		WRITE=0;
	
	end
	
	always @ (INSTRUCTION)//this always block will generate corresponding control signal
	begin
		#1;
		begin
		case(INSTRUCTION[31:24])
			
			0://add instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b001; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
			
			1://sub instruction should be executed
				begin SELECT1=1;
				SELECT2=1;
				ALUOP=3'b001; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
			
			2://and instruction should be executed
				begin  SELECT1=0;
				SELECT2=1;
				ALUOP=3'b010; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			
			3://or instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b011; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
			
			4://j instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b000; 
				WRITEENABLE=1'b0;
				BEQSIGNAL=0;
				JSIGNAL=1;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
			
			
			5://beq instruction should be executed
				begin SELECT1=1;
				SELECT2=1;
				ALUOP=3'b001; 
				WRITEENABLE=1'b0;
				BEQSIGNAL=1;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
				
			6://mov instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b000; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			7://loadi instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b000; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			8://bne instruction should be executed
				begin SELECT1=1;
				SELECT2=1;
				ALUOP=3'b001; 
				WRITEENABLE=1'b0;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=1;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			9://left shifter instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b100; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			10://right shifter instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b101; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			11://arithmatic shifter instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b110; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			12://rotate instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b111; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=0;
				SELECT4=0;end
				
			13://lwd instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b000; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=1;
				WRITE=0;
				SELECT4=1;end
			
			14://lwi instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b000; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=1;
				WRITE=0;
				SELECT4=1;end
			
			15://swd instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b000; 
				WRITEENABLE=1'b0;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=1;
				SELECT4=1;end
			
			16://swi instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b000; 
				WRITEENABLE=1'b0;
				BEQSIGNAL=0;
				JSIGNAL=0;
				BNESIGNAL=0;
				READ=0;
				WRITE=1;
				SELECT4=1;end
												
		endcase
		
		end
		
	end
	
endmodule

