module onebit_(OUT, IN0, IN1, S);
    input IN0, IN1, S;
    output OUT;
    wire AND1OUT, AND2OUT;
    and and1(AND1OUT, ~S, IN0);
    and and2(AND2OUT, S, IN1);
    or or1(OUT, AND1OUT, AND2OUT);
endmodule

module twobit_(OUT, A, C, S, X0, X1);
    input A, C, S, X0, X1;
    output OUT;
    wire WIRE1, WIRE2, WIRE3;
    and and1(WIRE1, S, C, X0);
    and and2(WIRE2, S, ~C, A, X1);
    and and3(WIRE3, ~S, X1);
    or or1(OUT, WIRE1, WIRE2, WIRE3);
endmodule

module onebit_BITSHIFT(A, C, S, X, Y);
    input A, C, S;
    input[7:0] X;
    output[7:0] Y;
    
    twobit_ bit7(Y[7], A, C, S, X[0], X[7]);
    onebit_ bit6(Y[6], X[6], X[7], S);
    onebit_ bit5(Y[5], X[5], X[6], S);
    onebit_ bit4(Y[4], X[4], X[5], S);
    onebit_ bit3(Y[3], X[3], X[4], S);
    onebit_ bit2(Y[2], X[2], X[3], S);
    onebit_ bit1(Y[1], X[1], X[2], S);
    onebit_ bit0(Y[0], X[0], X[1], S);
endmodule

module onebit_BITSHIFT_2(A, C, S, X, Y);
    input A, C, S;
    input[7:0] X;
    output[7:0] Y;
    
    twobit_ bit7(Y[7], A, C, S, X[1], X[7]);
    twobit_ bit6(Y[6], A, C, S, X[0], X[6]);
    onebit_ bit5(Y[5], X[5], X[7], S);
    onebit_ bit4(Y[4], X[4], X[6], S);
    onebit_ bit3(Y[3], X[3], X[5], S);
    onebit_ bit2(Y[2], X[2], X[4], S);
    onebit_ bit1(Y[1], X[1], X[3], S);
    onebit_ bit0(Y[0], X[0], X[2], S);
endmodule

module onebit_BITSHIFT_3(A, C, S, X, Y);
    input A, C, S;
    input[7:0] X;
    output[7:0] Y;
    
    twobit_ bit7(Y[7], A, C, S, X[3], X[7]);
    twobit_ bit6(Y[6], A, C, S, X[2], X[6]);
    twobit_ bit5(Y[5], A, C, S, X[1], X[5]);
    twobit_ bit4(Y[4], A, C, S, X[0], X[4]);
    onebit_ bit3(Y[3], X[3], X[7], S);
    onebit_ bit2(Y[2], X[2], X[6], S);
    onebit_ bit1(Y[1], X[1], X[5], S);
    onebit_ bit0(Y[0], X[0], X[4], S);
endmodule

module EIGHTBITSHIFT_RO(A, C, S, DATA, OUT);
    input A, C;
    input[2:0] S;
    input[7:0] DATA;
    output reg[7:0] OUT;
    wire[7:0]  WIRE1, WIRE2,WIRE3;
    onebit_BITSHIFT shift0(A, C, S[0], DATA, WIRE1);
	onebit_BITSHIFT_2 shift1(A, C, S[1], WIRE1, WIRE2);
	onebit_BITSHIFT_3 shift2(A, C, S[2], WIRE2, WIRE3);
	
	always @ (A,C,S,DATA)
	begin
	
		#1 OUT = WIRE3;
	
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