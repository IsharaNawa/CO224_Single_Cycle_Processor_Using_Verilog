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
        #2  
        OUT1 = register[OUT1ADDRESS]; //A delay of 2ns before the loading the values from registers
        OUT2 = register[OUT2ADDRESS];
    end

    always @ (posedge CLK) begin
        /*  The block to write values to the register, and to reset the registers. 
            Both of the processes are synchronous therefore the block gets activated at a positive clock edge.
            Both of the processes have a delay of 1ns*/
            
        if (RESET == 1) //The RESET input has to be high
            #1  for (i = 0; i < 8; i = i + 1) //For each register out of the 8
                    register[i] = 0;

        else if (WRITE == 1) //The WRITE input has to be high
            register[INADDRESS] = #1 IN; //The value IN is placed in the relevent register
    end
endmodule

//The testbench for the reg_file module
/*module tb;
        
    reg [7:0] WRITEDATA;
    reg [2:0] WRITEREG, READREG1, READREG2;
    reg CLK, RESET, WRITEENABLE; 
    wire [7:0] REGOUT1, REGOUT2;
    
    reg_file myregfile(WRITEDATA, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
       
    initial
    begin
        CLK = 1'b1;
        
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg.vcd");
		$dumpvars(0, tb);
        
        // assign values with time to input signals to see output 
        RESET = 1'b0;
        WRITEENABLE = 1'b0;
        
        #5
        RESET = 1'b1;
        READREG1 = 3'd0;
        READREG2 = 3'd4;
        
        #7
        RESET = 1'b0;
        
        #3
        WRITEREG = 3'd2;
        WRITEDATA = 8'd95;
        WRITEENABLE = 1'b1;
        
        #9
        WRITEENABLE = 1'b0;
        
        #1
        READREG1 = 3'd2;
        
        #9
        WRITEREG = 3'd1;
        WRITEDATA = 8'd28;
        WRITEENABLE = 1'b1;
        READREG1 = 3'd1;
        
        #10
        WRITEENABLE = 1'b0;
        
        #10
        WRITEREG = 3'd4;
        WRITEDATA = 8'd6;
        WRITEENABLE = 1'b1;
        
        #10
        WRITEDATA = 8'd15;
        WRITEENABLE = 1'b1;
        
        #10
        WRITEENABLE = 1'b0;
        
        #6
        WRITEREG = 3'd1;
        WRITEDATA = 8'd50;
        WRITEENABLE = 1'b1;
        
        #5
        WRITEENABLE = 1'b0;
        
        #10
        $finish;
    end
    
    // clock signal generation
    always
        #5 CLK = ~CLK;
        

endmodule*/