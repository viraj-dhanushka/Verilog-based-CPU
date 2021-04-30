//2 to 1 mux 
`timescale  1ns/100ps
module mux(SELECT, InA, InB, OUT);

    parameter BIT_NUMBER = 8;      //set default parameter value to 8 

    input SELECT;
    input [BIT_NUMBER-1 : 0] InA; 
    input [(BIT_NUMBER-1) : 0]  InB;
    output [BIT_NUMBER-1 : 0] OUT;

    assign OUT=(SELECT==0)?InA:InB;

endmodule