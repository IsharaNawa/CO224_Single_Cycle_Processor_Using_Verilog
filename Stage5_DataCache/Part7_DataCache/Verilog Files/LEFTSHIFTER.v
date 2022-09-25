//Group 21(E/17/027,E/17/219)
//In this module the left shifting module is implemented for the alu
//uncomment the module tb to test the functionality
//used gate level modeling
//used bottom up modeling technique
//refer the documentation for more details

//defining the leaf cell for the left shifter(level 1)
//refer to the documentation to get the diagram
module one(OUT, IN0, IN1, S);
	//declaring I/O
    input IN0, IN1, S;
    output OUT;
	
	//declaring the wires to connect
    wire AND1OUT, AND2OUT;
	
	//connecting wires to each gate 
    and and1(AND1OUT, ~S, IN0);
    and and2(AND2OUT, S, IN1);
    or or1(OUT, AND1OUT, AND2OUT);
endmodule

//definig level 2 module
module ONEBITSHIFT_1(S, X, Y);
	//declaring I/O
    input S;
    input[7:0] X;
    output[7:0] Y;
	
	//conncting wires
    one bit7(Y[7], X[7], X[6], S);
    one bit6(Y[6], X[6], X[5], S);
    one bit5(Y[5], X[5], X[4], S);
    one bit4(Y[4], X[4], X[3], S);
    one bit3(Y[3], X[3], X[2], S);
    one bit2(Y[2], X[2], X[1], S);
    one bit1(Y[1], X[1], X[0], S);
    one bit0(Y[0], X[0], 1'b0, S);
endmodule

//definig another level 2 module
module ONEBITSHIFT_2(S, X, Y);
	//declaring I/O
    input S;
    input[7:0] X;
    output[7:0] Y;
	
	//connecting wires
    one bit7(Y[7], X[7], X[5], S);
    one bit6(Y[6], X[6], X[4], S);
    one bit5(Y[5], X[5], X[3], S);
    one bit4(Y[4], X[4], X[2], S);
    one bit3(Y[3], X[3], X[1], S);
    one bit2(Y[2], X[2], X[0], S);
    one bit1(Y[1], X[1], 1'b0, S);
    one bit0(Y[0], X[0], 1'b0, S);
endmodule

//definig another level 2 module
module ONEBITSHIFT_3(S, X, Y);
	//declaring I/O
    input S;
    input[7:0] X;
    output[7:0] Y;
	
	//connecting wires
    one bit7(Y[7], X[7], X[3], S);
    one bit6(Y[6], X[6], X[2], S);
    one bit5(Y[5], X[5], X[1], S);
    one bit4(Y[4], X[4], X[0], S);
    one bit3(Y[3], X[3], 1'b0, S);
    one bit2(Y[2], X[2], 1'b0, S);
    one bit1(Y[1], X[1], 1'b0, S);
    one bit0(Y[0], X[0], 1'b0, S);
endmodule

//definig the top level module
//note that the this module has the delay of 1 time unit
module LEFTLOGICSHIFT(S, DATA, OUT);

	//declaring I/O
    input[2:0] S;
    input[7:0] DATA;
    output reg [7:0] OUT;
    wire[7:0]  WIRE1, WIRE2;
	wire [7:0] OUT1;
	
	//connecting wires
    ONEBITSHIFT_1 shift0(S[0], DATA, WIRE1);
	ONEBITSHIFT_2 shift1(S[1], WIRE1, WIRE2);
	ONEBITSHIFT_3 shift2(S[2], WIRE2, OUT1);

	//placing 1 unit time delay
	always @ (S,DATA)
	begin
	
		#1 OUT=OUT1;
	
	end
	
	
endmodule


/*
module tb;
    reg[7:0] DATA;
    reg [2:0] S;
    wire[7:0] OUT;
    EIGHTBITSHIFT shift(S, DATA, OUT);
    initial begin
        $monitor("\t%g\t\t%b\t%b\t%b",$time, S, DATA, OUT);
        DATA = 8'b1010_1001; S = 3'b0;
        #5 S = 1;
		#5 S = 2;
		#5 S = 3;
		#5 S = 4;
		#5 S = 5;
		#5 S = 6;
		#5 S = 7;
        
    end
endmodule
*/





