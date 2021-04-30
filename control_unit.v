`timescale  1ns/100ps
module control_unit(PC, BRANCHNEQ, BRANCH, TARGET_OFFSET, IMMEDIATE, ALUOP, RfOutSel, AluInSel, READREG1, READREG2, WRITEREG, WRITEENABLE, AluOutSel, READ, WRITE, INSTRUCTION, CLK, RESET, BranchSel, TARGET, BUSYWAIT);

input CLK;
input RESET;
input [31:0] INSTRUCTION;
input BranchSel;
input BUSYWAIT; 

// output reg [7:0] OPCODE;        //OPCODE
output reg [7:0] IMMEDIATE;     //immediate value for loadi
output reg [2:0] READREG1;     //reading register 1 address in rf
output reg [2:0] READREG2;     //reading register 2 address in rf
output reg [2:0] WRITEREG;     //writing register address in rf

output wire [31:0] PC;

output wire BRANCHNEQ;		//branch not equal selecting signal
output wire BRANCH;		//branch selecting signal
wire JUMP;		//jump selecting signal
output wire [3:0] ALUOP;    //operation selecting signal for alu
output wire RfOutSel;     //register file out put mux selector
output wire AluInSel;     //Alu input mux selector
output wire WRITEENABLE;     //signal to register write

output wire AluOutSel;     //signal to select READDATA or ALURESULT
output wire READ;     //signal to memory READ
output wire WRITE;     //signal to memory WRITE

output reg [7:0] TARGET_OFFSET;	// jump or branch target offset
input [31:0] TARGET;		//sign extended target offset


always@(INSTRUCTION)begin

	IMMEDIATE <= INSTRUCTION[7:0];    //extracting the immediate (loadi)

	READREG1 <= INSTRUCTION[15:8];     //extracting the read reg 1
	READREG2 <= INSTRUCTION[7:0];	//extracting the read reg2
	WRITEREG <= INSTRUCTION[23:16];		//extracting the wite reg 

	TARGET_OFFSET <= INSTRUCTION[23:16];		
	
end

pc_unit PCounter(PC, BranchSel, JUMP, TARGET, CLK, RESET, BUSYWAIT);
decoder Decoder(BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE, INSTRUCTION, PC);

endmodule
