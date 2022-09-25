//The module for the Register File of the Processor
module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);

    input[7:0] IN; //8-bit input from the ALU
    input[2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS; //3-bit addresses of the registers
    input WRITE, CLK, RESET; //Single nit inpits for the WRITE ENABLE, CLOCK PULSE and REGISTER RESET
    output reg[7:0] OUT1, OUT2; //8-bit output values of the relevent registers
    integer i; //Integer declaration for the for loop

    reg[7:0] register[7:0]; //The declaration of the array of 8 X 8 Registers

    always @ (OUT1ADDRESS, OUT2ADDRESS, register[OUT1ADDRESS], register[OUT2ADDRESS]) begin
        /*  The block to load values from the registers asynchronously. Also it has to be sensitive for new updates of
            the registers*/

        #2  OUT1 = register[OUT1ADDRESS]; //A delay of 2ns before the loading the values from registers
            OUT2 = register[OUT2ADDRESS];
    end

    always @ (posedge CLK) begin
        /*  The block to write values to the register, and to reset the registers. 
            Both of the processes are synchronous therefore the block gets activated at a positive clock edge.
            Both of the processes have a delay of 1ns*/

        if (RESET == 1) begin//The RESET input has to be high
            for (i = 0; i < 8; i = i + 1) begin//For each register out of the 8
                register[i] <= #1 0;
            end
        end
        else if (WRITE == 1) begin//The WRITE input has to be high
            register[INADDRESS] <= #1 IN; //The value IN is placed in the relevent register
        end
    end
endmodule

//The testbench for the reg_file module
module tb;
    //Input/Output declaration
    reg [7:0] IN;
    reg [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
    reg WRITE, CLK, RESET;
    wire [7:0] OUT1, OUT2;
    reg_file rf(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);

    initial begin //Initial values
        CLK = 0;
        RESET = 0;
        WRITE = 1;
    end

    always //Clock will change the value within every 10ns (Clock cycle is 20ns)
        #10 CLK = !CLK;

    initial begin //Code to generate the vcd file
        $dumpfile("reg.vcd"); 
        $dumpvars(0, rf);
        $display("\t\ttime \tC W R\tIN\tOut1\tOut2"); //Displays the parameters
        $monitor("%d    %b %b %b %b %b %b",$time , CLK, WRITE, RESET, IN, OUT1, OUT2);
        #60 $finish; //Program terminates in 60ns
    end
    
    initial begin
        //The testcases
            OUT1ADDRESS = 3'b000; OUT2ADDRESS = 3'b001; INADDRESS = 3'b000;
        #3  IN = 8'b1111_0000; 
        #15 OUT1ADDRESS = 3'b010; OUT2ADDRESS = 3'b000; INADDRESS = 3'b000;
        #13  IN = 8'b0000_1111;
        #15  RESET = 1;
    end 

endmodule