//Group 21
//E/17/027(S.M.P.C. Bandara)
//E/17/219(K.G.I.S. Nawarathana)
//CO224-Lab 06 part 2

module dcache (clk, reset, read, write, mem_busywait, address, writedata, mem_readdata,
                mem_read, mem_write, busywait, mem_address, readdata, mem_writedata);
    
    //declaring inputs of the module
	input read,write,mem_busywait,clk,reset;
    input [7:0] writedata,address;
    input [31:0] mem_readdata;

    //declaring outputs of the module
    output reg mem_write,mem_read,busywait;
    output reg [31:0] mem_writedata;
    output reg [5:0] mem_address;
    output reg [7:0] readdata;
    
    // Memory elements
    reg [31:0] cache [7:0];         //declaring cache with 8 datablocks
    reg [7:0] dirtybits,validbits;  //corresponding data and valid bit for each block
    reg [2:0] tags [7:0];           //corresponding tag for each block
    
    //tag is used for store the tag given by address which the address of the word cpu want to access
    //index is used for store the index given by address which the address of the word cpu want to access
    //tag_of_block is used to store the corresponding tag of cache entry which is selected by the index 
    wire [2:0] tag,index;
    reg [2:0] tag_of_block;
    //offset is used for store the offset given by address which the address of the word cpu want to access
    wire [1:0] offset;
    //cache control signals
    reg dirty,valid,hit,update,writetocache,readfromcache,checkhit;
  	//this 4 of 8-bit arrays are used to extract data in a cache entry selected by the index
  	reg [7:0] datablock [3:0];
  	
  	
  	//Splitting the address into offset,tag and index
	//new registers are declared for assigning the corresponding values
    assign	index = address [4:2];	//tag is given by 4-2 bits of the address
	assign	tag = address [7:5];	//first 3 bit of the address is index
	assign	offset = address[1:0];	//last 2 bits of the address is offset	
    		
    	
    		
    	//when a read or write detected busywait signal is set to high
    	always @(posedge read,posedge write) begin
    		busywait=1;
    	    #1	readfromcache = (read && !write) ? 1:0;
    		writetocache = (!read && write) ? 1:0;
    	end
    	
    	always @(validbits,tag[index],index,posedge readfromcache,posedge writetocache,dirtybits)begin
    		//extracting data from cache
     		if(readfromcache || writetocache) begin
     			#1 tag_of_block = tags[index];		//extracting corresponding tag of the cache entry selected by index 
  	 	   	    valid = validbits[index];		//extracting corresponding valid bit of the cache entry selected by index 
    	 	   	dirty = dirtybits[index];		//extracting corresponding dirty bit of the cache entry selected by index 
    		   	checkhit = 1;				//signal to indicate that need to check for a hit
    		end
    	end
    	
    	//extracting data words from the cache
    	//cache entry is selected based on the index 
    	always @(posedge readfromcache,cache[index],index,offset)begin
     	    #1	case(offset)
    		2'b00: readdata= cache[index][7:0];
    		2'b01: readdata= cache[index][15:8];
    		2'b10: readdata= cache[index][23:16];
    		2'b11: readdata= cache[index][31:24];
    		endcase
    	end
    
     	
     	//once a read or write detected or there is a change in tag of a cache entry or valid bit of a cache entry
     	//generating hit signal
    	always @(tag_of_block,valid,tag,posedge checkhit) begin
    	   	//if valid and tags are matching it is a hit
    	   	checkhit=0;	//make checkhit signal zero
    	   	if((valid && (tag==tag_of_block))) begin	
    			#0.9 hit=1;		//making hit signal high		    
    			     busywait=0;	//no need to stall the cpu, making busywait 0
    			     
    			     readfromcache=0;	//if the operation is a writing one, this signal is used to indicate there is somthing to write at the end
    			     			//since write signal of the cpu is deasserting with the busywait, this signal is used	   
    	   	end
    	   	else if((!valid || (tag!=tag_of_block))) begin
    	     		#0.9 hit=0;		//if not valid or tags are not matching it is a miss, making hit 0
    	   	end 		
    	end
    	
    	
  	    //assign values to readdata output, based on the offset
    	//assign #1 readdata = datablock[offset];	 
    	
    	//writing data to cache at the positive clock edge
    	always @(posedge clk)begin
    		if(hit && writetocache) begin	//writing only if the hit signal and writetocache is high 
    	     		//correct cache entry is selected by the index
    	     		//correct position to be written is selected by the offset
    	     		#1 case(offset)
    				2'b00: cache[index][7:0]=writedata;
    				2'b01: cache[index][15:8]=writedata;
    				2'b10: cache[index][23:16]=writedata;
    				2'b11: cache[index][31:24]=writedata;
    			endcase
    			//making writetocache signal 0 after writting
    			writetocache=0;
    			//setting dirty bit of cache entry high after a write operation
    			//to indecate data in the cache inconsistent with the memory  
    			dirtybits[index] = 1;
    		end
    	end
    	
    	//update signal is used in FSM to indicate that the cache to be updated
    	//when update signal changing from 1 to 0 cache is updating
    	always @(negedge update) begin
    	     	#1 cache[index]=mem_readdata;	//writing readed data from the memory to correct cache entry
             	   validbits[index] = 1;	//setting valid bit high
             	   dirtybits[index] = 0;	//cache data is consistant with memory, make dirtybit low
             	   tags [index] = tag;		//updating tag of cache entry
             	   
    	end
   
    
    	/* Cache Controller FSM Start */

    	parameter IDLE = 3'b000, MEM_READ = 3'b001,MEM_WRITE=3'b010;
    	reg [2:0] state, next_state;

    	// combinational next state logic
    	always @(read,write,dirty,hit,mem_busywait) begin
        	case (state)
            		IDLE:
            			//read or write and data in cache entry is consistent and a miss directly reading from memory
                		if ((read || write) && !dirty && !hit) 		 
                   			next_state = MEM_READ;	//change state to memory read			
                		//read or write and data in cache entry is inconsistent and a miss need to write data into memory
                		else if ((read || write) && dirty && !hit)	
                    			next_state = MEM_WRITE;	//change next state to memory read	
                		else
                    			next_state = IDLE;	//while there is no miss,stay in IDLE state
            
            		MEM_READ:
                		//after finish reading from the memory go to IDLE state, mem_busywait gose low means reading is finished
                		if (!mem_busywait)
                    			next_state = IDLE;
                    		//while reading from the memory stay in state memory read	
                		else    
                    			next_state = MEM_READ;
            		MEM_WRITE:
            			//after finish writing to the memory go to read memory state, mem_busywait gose low means writing is finished
            			if(!mem_busywait)
            	    			next_state = MEM_READ;	//change next state to memory read
            			else
            	    			next_state = MEM_WRITE;
        	endcase
    	end

    	// combinational output logic
    	always @(state) begin
        	case(state)
            		IDLE:
            			begin	//initialy all control signals are zero
                			mem_read = 0;
                			mem_write = 0;
                			mem_address = 6'dx;
                			mem_writedata = 32'dx;
                			busywait = 0;
                			update=0;			//make update signal low
            			end
            		MEM_READ: 
           			begin
                			mem_read = 1;			//set read signal high to read from memory
                			mem_write = 0;			//not writing
                			mem_address = {tag, index};	//sending address of the block to be readed(address of data block want to extract)
                			mem_writedata = 32'dx;		//no writing data
                			busywait = 1;			//busywait is high to stall the CPU
                			update=1;			//after reading cache to be updated
            			end
                     	MEM_WRITE:
            			begin
            				mem_read = 0;			//no reading
                			mem_write = 1;			//writing to memory
                			mem_address = {tag_of_block,index};	//sending block address to be written(address of existing cache entry)
                			mem_writedata = cache [index];	//data in the cache entry is written to the memory
                			busywait = 1;			//set busywait high to stall the CPU
            			end
        	endcase
    	end
	

    // Resetting the data cache
	//making valid bit ,dirty bit and addressTag 0
    always @(posedge clk, reset) begin
        if(reset) begin
            state = IDLE;		
            validbits=8'b0000_0000;
            dirtybits=8'b0000_0000;
        end
        else
        state = next_state;	//at the positive edge of the clock changing the state of FSM
   	end
endmodule