//Group 21(E/17/027,E/17/219)
//this module takes a 32 bit inputs  and produces the output depending on the select signal
//supports 32 bit numbers

module pcmux(DATA0,DATA1,SELECT,OUT);
	
	input [31:0] DATA0,DATA1;
	input SELECT;
	output reg [31:0] OUT;
	
	always @ (DATA0,DATA1,SELECT)
	begin
		if(SELECT==1'b0)begin
			OUT<=DATA0;
		end
		else begin
			OUT<=DATA1;
		end
	end
	
endmodule