/*
Module  : 256x8-bit data memory 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	:

This file presents a primitive data memory module for CO224 Lab 6 - Part 1
This memory allows data to be read and written as 1-Byte words
*/

module data_memory(
	clock,
    reset,
    read,
    write,
    address,
    writedata,
    readdata,
    busywait
);
input           clock;
input           reset;
input           read;
input           write;
input[7:0]      address;
input[7:0]      writedata;
output reg [7:0]readdata;
output reg      busywait;

//Declare memory array 256x8-bits 
reg [7:0] memory_array [255:0];

//Detecting an incoming memory access
reg readaccess, writeaccess;
always @(read, write)
begin
	busywait = (read || write)? 1 : 0;
	readaccess = (read && !write)? 1 : 0;
	writeaccess = (!read && write)? 1 : 0;
end

//Reading & writing
always @(posedge clock)
begin
    if(readaccess)
    begin
        readdata = #40 memory_array[address];
        busywait = 0;
		readaccess = 0;
    end
    if(writeaccess)
	begin
        memory_array[address] = #40 writedata;
        busywait = 0;
		writeaccess = 0;
    end
end

integer i;

//Reset memory
always @(posedge reset)
begin
    if (reset)
    begin
        for (i=0;i<256; i=i+1)
            memory_array[i] = 0;
        
        busywait = 0;
		readaccess = 0;
		writeaccess = 0;
    end
end

//uncomment this block and comment inside the initial block in the registerfile to see the content in the data memory 
/*
initial
begin
	$display("\t\t\t  0\t1\t2\t3");
	$monitor($time,"\t%d\t%d\t%d\t%d\n",memory_array[0],memory_array[1],memory_array[2],memory_array[3]);
end*/

endmodule