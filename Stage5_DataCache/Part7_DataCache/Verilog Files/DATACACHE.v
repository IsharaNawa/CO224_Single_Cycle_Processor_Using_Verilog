//Group 21
//E/17/027(S.M.P.C. Bandara)
//E/17/219(K.G.I.S. Nawarathana)
//CO224-Lab 06 part 2

module dcache (clock, reset, read, write, mem_busywait, address, writedata, mem_readdata,
                mem_read, mem_write, busywait, mem_address, readdata, mem_writedata);
    
	//declaring inputs of the module
    input clock, reset, read, write, mem_busywait; 
    input[7:0] address, writedata;
    input[31:0] mem_readdata;

	//declaring outputs of the module
    output reg mem_read, mem_write, busywait;
    output reg[5:0] mem_address;
    output reg[7:0] readdata;
    output reg[31:0] mem_writedata;

    // Combinational part for indexing, tag comparison for hit deciding, etc.

    // Memory elements
    reg[31:0] CACHE_MEM[7:0];	//declaring cache with 8 datablocks
    reg[2:0] ADDRESSTAG[7:0];	//corresponding tag for each block
    reg VALID[7:0];				//corresponding valid bit for each block
    reg DIRTY[7:0];				//corresponding data bit for each block


    // Resetting the data cache
	//making valid bit ,dirty bit and addressTag 0
    integer INDEX;
    reg readaccess, writeaccess;
	always @ (posedge clock, reset)
        if (reset) begin
            for (INDEX = 0; INDEX < 8; INDEX++) begin
                VALID[INDEX] = 1'b0;
                DIRTY[INDEX] = 1'b0;
                ADDRESSTAG[INDEX] = 3'b0;
                
            end
			//making internal registers of the cache equal to 0
            busywait = 1'b0;
		    readaccess = 1'b0;
		    writeaccess = 1'b0;
        end


    //Splitting the address into offset,tag and index
	//new registers are declared for assigning the corresponding values
    reg[1:0] offset;
    reg[2:0] tag, index;
    always @ (address) begin
        offset = address[1:0];
        index = address[4:2];
        tag = address[7:5];
    end
	

	reg[7:0] dataword;		//corresponding word of the datablock
	//getting the correct word from the corresponding datablock
    always @ (datablock, offset)
		case(offset)
			2'b00 : 
                #1 dataword = datablock[7:0];
			2'b01 : 
                #1 dataword = datablock[15:8];
			2'b10 : 
                #1 dataword = datablock[23:16];
			2'b11 : 
                #1 dataword = datablock[31:24];
		endcase
		
		
	// Getting the index of the corresponding data block
	//new registers are declared for assigning the dirty bit , valid bit and datablock 
	//of the cache for the current instruction
    reg dirty, valid;
    reg[31:0] datablock;
    always @ (*) begin
        #1
        dirty = DIRTY[index];
        valid = VALID[index];
        datablock = CACHE_MEM[index];
    end


    //deciding if the instruction is a hit or miss
	//a new register is declared for storing the hit status
	//if the tag in the cache and tag in the address is same
	//and valid bit is 1, then the instruction is a hit
    reg hit;		
    always @ (*)
        #0.9
        if (ADDRESSTAG[index] == tag && valid == 1'b1)
            hit = 1'b1;
        else 
            hit = 1'b0;

	
	//to assert and de-assert the busywait signal
    always @ (read, write) begin
		busywait = (read || write)? 1 : 0;
	end

	
    always @ (*) begin
		//handling the read hit situation
        if (read == 1'b1 && hit == 1'b1) begin
            readdata = dataword;	//outputting the corresponding dataword for the cpu			
		    busywait= 1'b0;			//making the busywait low
        end
		//handling the write hit situation
        if (write == 1'b1 && hit == 1'b1) begin
            busywait = 1'b0;		//making the busywait low
			//writing to the correct data word in the cache depending on the offset
            case (offset)
                2'b00:
                    #1 CACHE_MEM[index][7:0] = writedata;
                2'b01:
                    #1 CACHE_MEM[index][15:8] = writedata;
                2'b10:
                    #1 CACHE_MEM[index][23:16] = writedata;
                2'b11:
                    #1 CACHE_MEM[index][31:24] = writedata;
            endcase
			//making valid bit , dirty bit low in the corresponding valid,dirty bits 
            VALID[index] = 1'b1;
            DIRTY[index] = 1'b1;
        end
    end

	
    /* Cache Controller FSM Start */

	//introducing two new states
    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010, CACHE_WRITE = 3'b011; 
    reg [2:0] state, next_state;	//declaring register for storing the current and the next state 

    // combinational next state logic
	//behaviour of the FSM
    always @(*)
    begin
        case (state)
			//if the current state is idle,
            IDLE:
				//handling the next state according to the FSM
                if ((read || write) && !dirty && !hit)  
                    next_state = MEM_READ;
                else if ((read || write) && dirty && !hit) 
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
			//if the current state is memory reading
            MEM_READ:
				//handling the next state according to the FSM
                if (!mem_busywait)
                    next_state = CACHE_WRITE; 
                else    
                    next_state = MEM_READ;
            
			//if the current state is memory writing
            MEM_WRITE: 
				//handling the next state according to the FSM
                if (!mem_busywait)
                    next_state = MEM_READ;
                else    
                    next_state = MEM_WRITE;
			
			//if the current state is cache writing
            CACHE_WRITE:
				//handling the next state according to the FSM
                next_state = IDLE;
        endcase
    end

    // combinational output logic
	//generating the control signals according to the current state
    always @(*)
    begin
        case(state)
            IDLE:
			//if the state is idle 
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 32'dx;
            end
         
            MEM_READ:
			//if the state is memory read
            begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {tag, index};
                mem_writedata = 32'dx;
            end
            
            MEM_WRITE:
			//if the state is memory write
            begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {tag, index};
                mem_writedata = CACHE_MEM[index];
            end

            CACHE_WRITE:
			//if the state is cache write
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 32'dx;

                #1	//delay is for writing to the cache 
				CACHE_MEM[index] = mem_readdata;
				ADDRESSTAG[index] = tag;
				DIRTY[index]= 0;
				VALID[index] = 1;
            end
        endcase
    end

    // sequential logic for state transitioning 
	//changing the state in the positive edge
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end

    /* Cache Controller FSM End */

endmodule