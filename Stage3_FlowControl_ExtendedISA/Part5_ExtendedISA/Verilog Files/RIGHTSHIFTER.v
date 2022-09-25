//Group 21(E/17/027,E/17/219)
//In this module the right shifting module is implemented for the alu
//uncomment the module tb to test the functionality
//used gate level modeling
//used bottom up modeling technique
//refer the documentation for more details

//Note that the logical right shift,arithmatic right shift and rotating is implemented in this module

//defining the leaf cell for the left shifter(level 1)
//refer to the documentation to get the diagram
module one_(OUT, IN0, IN1, S);
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

//defing another leverl 1 module
module two(OUT, A, C, S, X0, X1, X2);
	//declaring I/O
    input A, C, S, X0, X1, X2;
    output OUT;
	
	//declaring the wires to connect
    wire WIRE1, WIRE2, WIRE3;
	
	//connecting wires to each gate
    and and1(WIRE1, S, C, X0);
    and and2(WIRE2, S, ~C, A, X1);
    and and3(WIRE3, ~S, X2);
    or or1(OUT, WIRE1, WIRE2, WIRE3);
endmodule

//definig level 2 module
module one_BITSHIFT_1(A, C, S, X, Y);
	//declaring I/O
    input A, C, S;
    input[7:0] X;
    output[7:0] Y;
    
	//connecting wires
    two bit7(Y[7], A, C, S, X[0], X[7], X[7]);
    one_ bit6(Y[6], X[6], X[7], S);
    one_ bit5(Y[5], X[5], X[6], S);
    one_ bit4(Y[4], X[4], X[5], S);
    one_ bit3(Y[3], X[3], X[4], S);
    one_ bit2(Y[2], X[2], X[3], S);
    one_ bit1(Y[1], X[1], X[2], S);
    one_ bit0(Y[0], X[0], X[1], S);
endmodule

//definig level 2 module
module one_BITSHIFT_2(A, C, S, X, Y);
	//declaring I/O
    input A, C, S;
    input[7:0] X;
    output[7:0] Y;
    
    two bit7(Y[7], A, C, S, X[1], X[7], X[7]);
    two bit6(Y[6], A, C, S, X[0], X[7], X[6]);
    one_ bit5(Y[5], X[5], X[7], S);
    one_ bit4(Y[4], X[4], X[6], S);
    one_ bit3(Y[3], X[3], X[5], S);
    one_ bit2(Y[2], X[2], X[4], S);
    one_ bit1(Y[1], X[1], X[3], S);
    one_ bit0(Y[0], X[0], X[2], S);
endmodule

//definig level 2 module
module one_BITSHIFT_3(A, C, S, X, Y);
	//declaring I/O
    input A, C, S;
    input[7:0] X;
    output[7:0] Y;
    
    two bit7(Y[7], A, C, S, X[3], X[7], X[7]);
    two bit6(Y[6], A, C, S, X[2], X[7], X[6]);
    two bit5(Y[5], A, C, S, X[1], X[7], X[5]);
    two bit4(Y[4], A, C, S, X[0], X[7], X[4]);
    one_ bit3(Y[3], X[3], X[7], S);
    one_ bit2(Y[2], X[2], X[6], S);
    one_ bit1(Y[1], X[1], X[5], S);
    one_ bit0(Y[0], X[0], X[4], S);
endmodule

//definig the top level module
//note that the left shift register has the delay of 1 time unit
module RIGHTSHIFTER(A, C, S, DATA, OUT);
	//declaring I/O
    input A, C;
    input[2:0] S;
    input[7:0] DATA;
    output reg [7:0] OUT;
	
	//declaring the wires to connect
    wire[7:0]  WIRE1, WIRE2,WIRE3;
	
	//instantiating the modules
	
	//when A=C=0 logical right shifting is activated
	//when A=1,C=0 arithmatic right shifting is activated
	//when A=1,C=1 rotating is activated
    one_BITSHIFT_1 shift0_(A, C, S[0], DATA, WIRE1);
	one_BITSHIFT_2 shift1_(A, C, S[1], WIRE1, WIRE2);
	one_BITSHIFT_3 shift2_(A, C, S[2], WIRE2, WIRE3);
	
	always @ (A,C,S,DATA)
	begin
	
		#1 OUT =  WIRE3;
	
	end
	
endmodule

/*
module tb;
    reg[7:0] DATA;
    reg [2:0] S;
    reg A, C;
    wire[7:0] OUT;
    EIGHTBITSHIFT shift(A, C, S, DATA, OUT);
    initial begin
        $monitor("\t%g\t\t%b\t%b\t%b",$time, S, DATA, OUT);
        DATA = 8'b0101_0001; S = 0; A = 1; C = 1;
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