`timescale  1ns/100ps

module pc_unit(PC, BranchSel, JUMP, TARGET, CLK, RESET, BUSYWAIT);

parameter P=32;     //p=32 since 32 bit reg is used

input RESET;
input CLK;
input [31:0] TARGET;
input BranchSel;
input JUMP;
input BUSYWAIT; 

output reg [(P-1):0] PC;    //reg to store pc value

wire [(P-1):0] newPC;    //wire having new pc value
reg [(P-1):0] defaultPC;    //reg to hold default pc value
reg [(P-1):0] finalPC;    //reg to hold final pc value

// initial begin
//     PC=32'b11111111111111111111111111111100;    //initially set pc value to -4
// end

always @(RESET) begin
	if (RESET==1) begin
        #2 PC=32'b11111111_11111111_11111111_11111100; // reset pc value to -4   
    end
end

always @(*) begin

    //increment pc value by 4 
    #1 defaultPC = PC + 32'b00000000_00000000_00000000_00000100;

    if (BranchSel == 1) begin   
        finalPC = newPC;        //add branch offset
    end
    else if (JUMP == 1) begin
        finalPC = newPC;        //add jump target 
    end 
    else begin
        finalPC = defaultPC;
    end
end


always @(posedge CLK) begin

	// if (RESET==1) begin
	// 	#2 PC = 32'b11111111_11111111_11111111_11111100;   // reset pc value to -4
    // end
    // else if(BUSYWAIT != 1) begin
    //     #1 PC = finalPC;    //update pc
    // end

    #1
    if(!RESET && !BUSYWAIT) PC = finalPC;

end

pcAdder newAdder(newPC, defaultPC, TARGET);

endmodule
