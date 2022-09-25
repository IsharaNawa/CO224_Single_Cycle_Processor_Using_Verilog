//Group 21(E/17/027,E/17/219)
//this module takes a 8 bit value and produces the negative value of that value

module complementer(data,complement);
	
	input [7:0] data;					//declaring I/O of the module
	output  reg [7:0] complement;
	
	always @ (data) begin complement = #1 ~data + 1;end

endmodule