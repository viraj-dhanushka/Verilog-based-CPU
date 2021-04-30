// Computer Architecture (CO224) - Lab 05
// Design: Register File of Simple Processor
`timescale  1ns/100ps

module reg_file (IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET, BUSYWAIT);

    input WRITE, CLK, RESET, BUSYWAIT;
    input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;    //source and destination registers
    input [7:0] IN;
    output [7:0] OUT1, OUT2;
    integer i;  //integer for increment in the loop

    reg [7:0] regFile[7:0];     //create a reg array
    
    //reading data from registers and assign the value to output ports
     assign #2 OUT1 = regFile[OUT1ADDRESS];
     assign #2 OUT2 = regFile[OUT2ADDRESS];

    always @ (posedge CLK)     //execute the code for positive edge
        begin
            #1 
            if(WRITE && !BUSYWAIT) begin
               regFile[INADDRESS] <=  IN;     //write data to the register with latency of 1
                
            end
        end

    always @ (RESET)     //execute the code when reset is changing 
        begin
            if(RESET) begin
                for(i=0; i<8; i = i + 1) begin
                    regFile[i] <= 0;        //set all registers to 0
                end
                #2;     //latency of resetting registers
            end
        end           

endmodule
