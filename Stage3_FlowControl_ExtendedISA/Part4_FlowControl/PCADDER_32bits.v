//Group 21(E/17/027,E/17/219)

//this module gets operand 1 and 2 as inputs and output the addition of them
//all the I/O ports are 32 bits
module pcadder(DATA1,DATA2,INSTUCTION,RESULT);		//declaring the module name and terminal of the module

	input [31:0] DATA1,DATA2,INSTUCTION;			//inputs are 32 bit numbers
	output reg [31:0] RESULT;						//output is a 32 bit number
	
	always @ (INSTUCTION)							//initialig the always block.This always block is triggered when INSTUCTION changes
	begin
	
		#2 RESULT =  DATA1 + DATA2;					//make the output of the module equal to addition of DATA1 and DATA2 with 2 time unit delay
	
	end

endmodule