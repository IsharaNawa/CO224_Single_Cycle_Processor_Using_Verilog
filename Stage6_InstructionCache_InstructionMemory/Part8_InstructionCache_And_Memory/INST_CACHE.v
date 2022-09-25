module icache(CLK, MEM_BUSYWAIT, PC, READDATA, READ, BUSYWAIT, OUTADDRESS, INSTRUCTION);

    // DECLARING TERMINALS AS INPUTS AND OUTPUTS
    input CLK, MEM_BUSYWAIT;
    input[31:0] PC;
    input[127:0] READDATA;
    output reg READ, BUSYWAIT;
    output reg[5:0] OUTADDRESS;
    output reg[31:0] INSTRUCTION;

    // INST_MEM = 1024 * 8 bits, 256 INSTRUCTIONS
    // 256 INSTRUCTIONS TO 32 (8 BLOCKS TO 1)
    reg[127:0] CACHE_MEM[7:0]; // 16 BYTES (4 INSRUCTIONS) IN 1 BLOCK

    reg[2:0] ADDRESSTAG[7:0]; // STORES THE TAG OF THE CORRESPONDING BLOCK
    reg VALIDBIT[7:0]; // STORES THE VALID BIT OF THE CORRESPONDING BLOCK

    // MEMORY ELEMENT RESET
    // THIS BLOCK INIALLY SET THE VALID BIT AND TAG ARRAYS TO ZERO
    integer i;
    initial
        for (i = 0; i < 8; i++) begin
                VALIDBIT[i] = 1'b0;
                ADDRESSTAG[i] = 3'b0;
            end

    // ADDRESS DECODING
    // SPITTING THE PC INTO TAG, INDEX, OFFSET AND OUTADDRESS
    reg[1:0] OFFSET;
    reg[2:0] INDEX, TAG;
    always @ (PC) begin // 2 LSBs OF THE PC ARE 0
        OFFSET = PC[3:2];
        INDEX = PC[6:4];
        TAG = PC[9:7];
        OUTADDRESS = PC[9:4];
    end

    // INDEXING
    // CHOSING THE CORRESPONDING DATABLOCK, TAG AND VALID BIT FOR THE CURRENT PC VALUE
    reg[127:0] DATABLOCK;
    reg[2:0] CACHETAG;
    reg VALID;
    always @ (*) begin
        #1
        DATABLOCK = CACHE_MEM[INDEX];
        CACHETAG = ADDRESSTAG[INDEX];
        VALID = VALIDBIT[INDEX];
    end

    // TAG COMPARISON
    // DETERMINE WHETHER THE CURRENT STATE IS A HIT OR A MISS
    reg HIT;
    always @ (*)
        #0.9
        if (CACHETAG == TAG && VALID == 1'b1) begin
            HIT = 1'b1;
        end
        else begin
            HIT = 1'b0;
            BUSYWAIT = 1'b1;
        end

    // READ HIT

    // CACHE READ
    // SELECTING THE CORRECT INSTRUCTION FROM THE DATABLOCK ACCORDING TO THE OFFSET
    always @ (*)
            case(OFFSET)
                2'b00 : 
                    #1 INSTRUCTION = DATABLOCK[31:0];
                2'b01 : 
                    #1 INSTRUCTION = DATABLOCK[63:32];
                2'b10 : 
                    #1 INSTRUCTION = DATABLOCK[95:64];
                2'b11 : 
                    #1 INSTRUCTION = DATABLOCK[127:96];
            endcase

    // READ MISS

    // READ SIGNAL GENERATION FOR THE INSTRUCTION MEMORY
    always @ (posedge CLK)
        if (HIT == 1'b0)
            READ = 1'b1;

    // CACHE WRITE
    // CACHE WRITING WHEN AFTER READING FROM THE INSTRUCTION MEMORY
    always @ (negedge MEM_BUSYWAIT) begin
        #1 
        CACHE_MEM[INDEX] = READDATA;
        READ = 1'b0;
        ADDRESSTAG[INDEX] = TAG;
        VALIDBIT[INDEX] = 1'b1;
        BUSYWAIT = 1'b0;
    end

endmodule