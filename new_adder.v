`timescale  1ns/100ps
module pcAdder(newPC, defaultPC, TARGET);

parameter P=32;     //p=32 since 32 bit reg is used

input [(P-1):0] defaultPC;    //default pc value
input [31:0] TARGET;


output reg [(P-1):0] newPC;    //reg to hold new pc value

always @(*) begin
    #2 newPC = defaultPC + {TARGET[29:0],2'b00};
end


endmodule
