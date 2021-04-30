/*
Program	: 256x8-bit data memory (16-Byte blocks)
Author	: Isuru Nawinne
Date	: 10/06/2020

Description	:

This program presents a primitive instruction memory module for CO224 Lab 6 - Part 3
This memory allows instructions to be read as 16-Byte blocks
*/

`timescale  1ns/100ps
module instruction_memory(
    clock,
    read,
    address,
    readdata,
    busywait
);
input               clock;
input               read;
input[5:0]          address;
output reg [127:0]  readdata;
output reg          busywait;

reg readaccess;

//Declare memory array 1024x8-bits 
reg [7:0] memory_array [1023:0];

//Initialize instruction memory
initial
begin
    busywait = 0;
    readaccess = 0;

    // Sample program given below. You may hardcode your software program here, or load it from a file:
       
        {memory_array[10'd3], memory_array[10'd2], memory_array[10'd1], memory_array[10'd0]} =     32'b00000000000000010000000000001111; //loadi 1 0x0F (15)
        {memory_array[10'd7], memory_array[10'd6], memory_array[10'd5], memory_array[10'd4]} =     32'b00000000000000100000000000001100; //loadi 2 0x0C (12)
        {memory_array[10'd11], memory_array[10'd10], memory_array[10'd9], memory_array[10'd8]} =   32'b00000000000000110000000000000001; //loadi 3 0x01 (1)
        {memory_array[10'd15], memory_array[10'd14], memory_array[10'd13], memory_array[10'd12]} = 32'b00000011000000010000000100000011; //sub 1 1 3
        {memory_array[10'd19], memory_array[10'd18], memory_array[10'd17], memory_array[10'd16]} = 32'b00000111000000010000000100000010; //beq 0x01 1 2
        {memory_array[10'd23], memory_array[10'd22], memory_array[10'd21], memory_array[10'd20]} = 32'b00000110000000010000000000000000; //j 0x01 / jump 1 instruction fwd
        {memory_array[10'd27], memory_array[10'd26], memory_array[10'd25], memory_array[10'd24]} = 32'b00000101000001100000000100000011; //or 6 1 3
        {memory_array[10'd31], memory_array[10'd30], memory_array[10'd29], memory_array[10'd28]} = 32'b00000000000000100000000000000010; //loadi 2 0x02
        {memory_array[10'd35], memory_array[10'd34], memory_array[10'd33], memory_array[10'd32]} = 32'b00000000000001000000000001000000; //loadi 4 0x40 
        {memory_array[10'd39], memory_array[10'd38], memory_array[10'd37], memory_array[10'd36]} = 32'b00010000000000000000010000000010; //swd 4 2 / 64 should be store in data_mem[2]
        {memory_array[10'd43], memory_array[10'd42], memory_array[10'd41], memory_array[10'd40]} = 32'b00010001000000000000001000000011; //swi 2 0x03 / 2 should be store in data_mem[3]
        {memory_array[10'd47], memory_array[10'd46], memory_array[10'd45], memory_array[10'd44]} = 32'b00001110000000010000000000000010; //lwd 1 2 / value in reg 1 should be 64
        {memory_array[10'd51], memory_array[10'd50], memory_array[10'd49], memory_array[10'd48]} = 32'b00001111000001000000000000000010; //lwi 4 0x02 / value writing to reg 4 should be 64
        {memory_array[10'd55], memory_array[10'd54], memory_array[10'd53], memory_array[10'd52]} = 32'b00001111000001100000000000000010; //lwi 6 0x02 / value writing to reg 6 should be 64
        {memory_array[10'd59], memory_array[10'd58], memory_array[10'd57], memory_array[10'd56]} = 32'b00001111000001100000000000100010; //lwi 6 0x22
        {memory_array[10'd63], memory_array[10'd62], memory_array[10'd61], memory_array[10'd60]} = 32'b00000000000000110000000000000011; //loadi 3 0x03 
        {memory_array[10'd67], memory_array[10'd66], memory_array[10'd65], memory_array[10'd64]} = 32'b00001111000001100000000000100010; //lwi 6 0x22  
        {memory_array[10'd71], memory_array[10'd70], memory_array[10'd69], memory_array[10'd68]} = 32'b00010000000000000000010000000011; //swd 4 3   
end

//Detecting an incoming memory access
always @(read)
begin
    busywait = (read)? 1 : 0;
    readaccess = (read)? 1 : 0;
end

//Reading
always @(posedge clock)
begin
    if(readaccess)
    begin
        readdata[7:0]     = #40 memory_array[{address,4'b0000}];
        readdata[15:8]    = #40 memory_array[{address,4'b0001}];
        readdata[23:16]   = #40 memory_array[{address,4'b0010}];
        readdata[31:24]   = #40 memory_array[{address,4'b0011}];
        readdata[39:32]   = #40 memory_array[{address,4'b0100}];
        readdata[47:40]   = #40 memory_array[{address,4'b0101}];
        readdata[55:48]   = #40 memory_array[{address,4'b0110}];
        readdata[63:56]   = #40 memory_array[{address,4'b0111}];
        readdata[71:64]   = #40 memory_array[{address,4'b1000}];
        readdata[79:72]   = #40 memory_array[{address,4'b1001}];
        readdata[87:80]   = #40 memory_array[{address,4'b1010}];
        readdata[95:88]   = #40 memory_array[{address,4'b1011}];
        readdata[103:96]  = #40 memory_array[{address,4'b1100}];
        readdata[111:104] = #40 memory_array[{address,4'b1101}];
        readdata[119:112] = #40 memory_array[{address,4'b1110}];
        readdata[127:120] = #40 memory_array[{address,4'b1111}];
        busywait = 0;
        readaccess = 0;
    end
end
 
endmodule