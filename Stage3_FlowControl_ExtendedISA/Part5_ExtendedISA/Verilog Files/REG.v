//Group 21(E/17/027,E/17/219)
//Uncomment below section to test the module

/*
//this testbench was implemented by the instructor of CO224
module reg_file_tb;
    
    reg [7:0] WRITEDATA;
    reg [2:0] WRITEREG, READREG1, READREG2;
    reg CLK, RESET, WRITEENABLE; 
    wire [7:0] REGOUT1, REGOUT2;
    
    reg_file myregfile(WRITEDATA, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
       
    initial
    begin
        CLK = 1'b1;
        
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg_file_wavedata.vcd");
		$dumpvars(0, reg_file_tb);
        
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

module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET);		//declaring the I/O of the registerfile

	input [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS;					//declaring register number inputs
	input [7:0] IN;													//declaring the destination register data(alu output)
	input WRITE,CLK,RESET;											//declaring clock,reset,and writeenable signals
	output reg [7:0] OUT1,OUT2;										//declaring the source register numbers

	reg [7:0] registerfile [7:0];									//declaring the registerfile array
	integer counter;												//declaring a counter

	//asynchronously getting the required data from the registerfile
	always @ (OUT1ADDRESS,OUT2ADDRESS,registerfile[OUT1ADDRESS], registerfile[OUT2ADDRESS])		//registerfile module is sensitive to these ports																		
	begin	
		#2;											//data is taken with a time delay of 2
		OUT1 =  registerfile[OUT1ADDRESS];			//getting data from the source register 1
		OUT2 =  registerfile[OUT2ADDRESS];			//getting data from the source register 2
	
	end
	
	always @ (posedge CLK)						//this always block is synchronous to the positive edge of the clock pulse
	begin
	
		if(RESET==1'b1) begin					//if reset signal is high make all the values in the registers 0 with a time delay of 1
			#1;
			
			for(counter=0;counter<8;counter++)begin
				registerfile[counter]=0;
			end
		end
		
		else begin								//if the reset is low look for the writeenable signal
		
			if(WRITE==1'b1)begin				//if writeenable is high then write to the destination register
				#1 registerfile[INADDRESS]= IN;
			end
			
		end
	
	end
	
	initial					//this initial block is used to display values in the registers in the registerfile in the corresponding times
	begin
	
		#5;
		$display("\t\ttime\treg0\treg1\treg2\treg3\treg4\treg5\treg6\treg7");
		$display("\t\t=====================================================================");
		$monitor($time,"\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d",registerfile[0],registerfile[1],registerfile[2],
				registerfile[3],registerfile[4],registerfile[5],registerfile[6],registerfile[7]);
		
	end
	
endmodule


