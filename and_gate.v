`timescale  1ns/100ps
module andGate(OUT, InA, InB);
//and module (branch & zero)
input InA, InB;
output OUT;

assign OUT = InA & InB;

endmodule
