`timescale  1ns/100ps

module twos_complement(REGOUT2_COMPLEMENT, REGOUT2);

input [7:0] REGOUT2;     
output [7:0] REGOUT2_COMPLEMENT; 
//Add a #1 time unit latency to the Two’s Complement unit
assign #1 REGOUT2_COMPLEMENT = ~REGOUT2 + 8'b0000_0001;    //negate the value 

endmodule