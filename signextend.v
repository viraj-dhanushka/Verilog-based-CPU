`timescale  1ns/100ps

module signextend(TARGET, TARGET_OFFSET) ;
    output [31 : 0]  TARGET;
    input [7 : 0]  TARGET_OFFSET ;
    assign TARGET ={{24 {TARGET_OFFSET [ 7 ]}},TARGET_OFFSET}; //repeat 7 th bit 24 times and concatenate  
endmodule