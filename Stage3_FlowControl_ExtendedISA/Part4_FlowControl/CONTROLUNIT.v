//Group 21(E/17/027,E/17/219)
//this module generates the control flow signals that controls 2 muxes and other regfile control signals , and beq and j signals

module controlunit(OPCODE,SELECT1,SELECT2,ALUOP,WRITEENABLE,BEQSIGNAL,JSIGNAL);

	//declaring I/O of the module
	input [7:0] OPCODE;
	output reg SELECT1,SELECT2,WRITEENABLE,BEQSIGNAL,JSIGNAL;
	output reg [2:0] ALUOP;
	
	always @ (OPCODE)		//this always block will generate corresponding control signal
	begin
		#1;
		begin
		case(OPCODE)
			
			0://add instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b001; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;end
			
			1://sub instruction should be executed
				begin SELECT1=1;
				SELECT2=1;
				ALUOP=3'b001; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;end
			
			2://and instruction should be executed
				begin  SELECT1=0;
				SELECT2=1;
				ALUOP=3'b010; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;end
				
			
			3://or instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b011; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;end
			
			4://j instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b000; 
				WRITEENABLE=1'b0;
				BEQSIGNAL=0;
				JSIGNAL=1;end
			
			
			5://beq instruction should be executed
				begin SELECT1=1;
				SELECT2=1;
				ALUOP=3'b001; 
				WRITEENABLE=1'b0;
				BEQSIGNAL=1;
				JSIGNAL=0;end
				
				
			6://mov instruction should be executed
				begin SELECT1=0;
				SELECT2=1;
				ALUOP=3'b000; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;end
				
			7://loadi instruction should be executed
				begin SELECT1=0;
				SELECT2=0;
				ALUOP=3'b000; 
				WRITEENABLE=1'b1;
				BEQSIGNAL=0;
				JSIGNAL=0;end
												
		endcase
		
		end
		
	end

endmodule