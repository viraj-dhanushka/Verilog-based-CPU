//or gate 
`timescale  1ns/100ps

module orGate(OUT, InA, InB);

input InA, InB;
output OUT;

assign OUT = InA | InB;

endmodule
