//Group 21(E/17/027,E/17/219)
//Uncomment below section to test the AND module

/*module testbench;										//initializing the testbench for testing the alu
	reg [7:0] OPERAND1,OPERAND2;						//initializing the registers to test the output
	reg [2:0] ALUOP;
	wire [7:0] ALURESULT; 								//initializing a wire to hold the output

	alu myalu(OPERAND1,OPERAND2,ALURESULT,ALUOP);		//instantiating the alu module

	initial 											//testing the outputs with intervals of #5
	begin
		OPERAND1 = 25;
		OPERAND2 = 41;
		ALUOP = 3'b000;
		#10
		OPERAND1 = 152;
		OPERAND2 = 23; 
		ALUOP = 3'b000;
		#10 
		OPERAND1 = 27;
		OPERAND2 = 74;
		ALUOP = 3'b001;
		#10 
		OPERAND1 = 96;
		OPERAND2 = 4;
		ALUOP = 3'b010;
		#10 
		OPERAND1 = 14;
		OPERAND2 = 14;
		ALUOP = 3'b011;
		#10 ALUOP = 3'b100;
		#10 ALUOP = 3'b101;
		#10 OPERAND1 = 53;
		OPERAND2 = 64;
		#10 ALUOP = 3'b000;
		#10 ALUOP = 3'b001;
		#10 ALUOP = 3'b010;
		#10 ALUOP = 3'b011;
		#10 ALUOP = 3'b001;
		#10 OPERAND2 = 22;
		#10 OPERAND1 = 222;
	end

	initial												//opeining the initial block for displaying outputs with corresponding inputs
	begin	
		$display("|\tTime\t|\t    DATA1  \t|\t    DATA2\t|\t    SELECTION\t|\t    OUTPUT\t|");
		$display("-----------------------------------------------------------------------------------------------------------------");
		//monitoring the values
		$monitor("|\t%g\t|\t%b (%d)\t|\t%b (%d)\t|\t      %b\t|\t%b (%d)\t|",$time,OPERAND1,OPERAND1,OPERAND2,OPERAND2,ALUOP,ALURESULT,ALURESULT);
		//$dumpfile ("wavedata.vcd"); 					//uncomment if wavedata is needed
    	//$dumpvars(0,myalu);							//uncomment if wavedata is needed
		#150 $finish;									//finish at time units 100
		
	end
	
endmodule*/

//including other modules in the directory
`include "FORWARD.v"
`include "ADD.v"
`include "AND.v"
`include "OR.v"

//this module contains the design of the alu unit
module alu(DATA1, DATA2, RESULT,ZERO, SELECT);		//declaring the name and the terminals of the unit

	input [7:0] DATA1,DATA2;					//DATA1 and DATA2 are 8 bit inputs 
	input [2:0] SELECT;							//SELECT is 3 bit input
	output reg [7:0] RESULT;					//output(RESULT) is a 8 bit number
	output reg ZERO;							//output ZERO is a one bit value(if RESULT==0 ZERO=1,otherwise ZERO=0)
	wire [7:0] FWwire,ADDwire,ANDwire,ORwire;	//declaring 4 wires to send the signals to the mux

	FORWARD_Module myFORWARD(DATA2,FWwire);		//instantiating the forwarding module of the alu
	ADD_Module myADD(DATA1,DATA2,ADDwire);		//instantiating the adder of the alu
	AND_Module myAND(DATA1,DATA2,ANDwire);		//instantiating the anding module of the alu
	OR_Module myOR(DATA1,DATA2,ORwire);			//instantiating the oring module of the alu
	
	always @ (*)								//declaring the always block.since this is a case statement,sensitivity list is not defined
	begin
		case(SELECT)							//declaring the case statement based on the SELECT signal
			0:RESULT=FWwire;					//if SELECT==3'b000 choose the output of the forwarding unit as the output of the alu
			1:RESULT=ADDwire;					//if SELECT==3'b001 choose the output of the adder unit as the output of the alu
			2:RESULT=ANDwire;					//if SELECT==3'b010 choose the output of the ANDing unit as the output of the alu
			3:RESULT=ORwire;					//if SELECT==3'b000 choose the output of the ORing unit as the output of the alu
												//notice that default case is not defined here.therefor whenever the SELECT>=4 output stays at the last value
		endcase
	
	end
	
	always @ (RESULT)							//this always block produces the corresponding output for the ZERO output
	begin
	
			ZERO = ~(RESULT[0]|RESULT[1]|RESULT[2]|RESULT[3]|RESULT[4]|RESULT[5]|RESULT[6]|RESULT[7]);
	
	end
	
	
endmodule