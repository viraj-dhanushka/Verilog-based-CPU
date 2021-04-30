//4 to 1 mux 
`timescale  1ns/100ps
module mux_readdata(  
    signal,            // signal (read) 
    a,                 // (BIT_NUMBER)-bit input called a
    b,                 // (BIT_NUMBER)-bit input called b
    c,                 // (BIT_NUMBER)-bit input called c
    d,                 // (BIT_NUMBER)-bit input called d
    sel,               // input sel used to sel between a,b,c,d
    out                // (BIT_NUMBER)-bit output based on input sel 
    );         

    input signal; 
    input [7:0] a;                 
    input [7:0] b;                 
    input [7:0] c;                 
    input [7:0] d;                 
    input [1:0] sel;   

    output wire [7:0] out;


   // based on value in sel and signal, output is assigned to either a/b/c/d asynchronously.
   assign #1 out = ( sel == 2'b00 && signal )? a : ( sel == 2'b01 && signal )? b : ( sel == 2'b10 && signal )? c : ( sel == 2'b11 && signal )? d : 8'bXXXX_XXXX;


endmodule
 