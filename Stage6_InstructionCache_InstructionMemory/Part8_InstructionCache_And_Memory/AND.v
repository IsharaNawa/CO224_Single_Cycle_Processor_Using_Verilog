//Group 21(E/17/027,E/17/219)
//Uncomment below section to test the module

/*
module testbench;

	reg [7:0] DATA1,DATA2;
	wire [7:0] RESULT;

	AND_Module myAND(DATA1,DATA2,RESULT);

	initial 
	begin
		$monitor($time," DATA1:%b DATA2:%b RESULT:%b",DATA1,DATA2,RESULT);
	end
	
	initial
	begin
		
		DATA1 = 8'b0000_0111;
		DATA2 = 8'b0000_0100;
		
		#1;
		
		DATA2 = 8'b0000_0101;
		
		#1;
		
		DATA1 = 8'b0000_1000;
		DATA2 = 8'b0000_1100;
		
		
	end

endmodule
*/

//this module is supposed to get operand 1 and 2 as inputs and output the bitwise AND value of them
module AND_Module(DATA1,DATA2,RESULT);			//declaring the module name and terminal of the module

	input [7:0] DATA1,DATA2;					//inputs are 8 bit numbers
	output reg [7:0] RESULT;					//output is a 8 bit number
	
	always @ (DATA1,DATA2)						//initialig the always block.This always block is triggered when DATA1 and DATA2 change
	begin
	
		#1 RESULT =  DATA1 & DATA2;				//make the output of the module equal to bitwise and of DATA1 and DATA2 with 1 time unit delay
	
	end

endmodule