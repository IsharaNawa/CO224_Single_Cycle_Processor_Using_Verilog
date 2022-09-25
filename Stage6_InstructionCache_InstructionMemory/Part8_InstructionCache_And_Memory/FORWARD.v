//Group 21(E/17/027,E/17/219)
//Uncomment below section to test the module

/*
module _testbench;

	reg [7:0] DATA2;
	wire [7:0] RESULT;

	FORWARD_Module myFORWARD(DATA2,RESULT);
	
	initial
	begin
	
		DATA2=8'b0000_1001;
		
		#1 DATA2=8'b0000_0001;
		
		#1 DATA2=8'b0010_0001;
		
		#1 $finish;
	
	end
	
	initial
	begin
		$monitor($time," DATA2:%b RESULT:%b",DATA2,RESULT);
	end

endmodule
*/

//This module is supposed to forward the data in DATA2 without going through any kind of a calculation
module FORWARD_Module(DATA2,RESULT);	//declaring the module name and terminal of the module

	input [7:0] DATA2; 					//input is 8 bit number 
	output reg [7:0] RESULT;			//output is a 8 bit number
	
	always @ (DATA2)					//initialig the always block.This always block is triggered when DATA2 changes
	begin
	
		#1 RESULT =  DATA2;				//make the output of the module what is inside DATA2 bus with 1 time unit delay
	
	end
		
endmodule