//4 to 1 mux 
`timescale  1ns/100ps
module mux_read_instcache(  
    signal,            // signal (read) 
    a,                 // 32-bit input called a
    b,                 // 32-bit input called b
    c,                 // 32-bit input called c
    d,                 // 32-bit input called d
    sel,               // input sel used to sel between a,b,c,d
    out                // 32-bit output based on input sel 
    );         

    input signal; 
    input [31:0] a;                 
    input [31:0] b;                 
    input [31:0] c;                 
    input [31:0] d;                 
    input [1:0] sel;   

    output [31:0] out;

   // based on value in sel and signal, output is assigned to either a/b/c/d asynchronously.

    assign #1 out = ( sel == 2'b00 && signal )? a : 
                      ( sel == 2'b01 && signal )? b : 
                        ( sel == 2'b10 && signal )? c : 
                            ( sel == 2'b11 && signal )? d : 32'dX;

endmodule
 