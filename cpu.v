//top-level cpu module
`timescale  1ns/100ps    
module cpu(ALURESULT, REGOUT1, READ, WRITE, PC,  INSTRUCTION, CLK, RESET, BUSYWAIT, READDATA);

input [31:0] INSTRUCTION;
input CLK;
input RESET;
input BUSYWAIT; 
input [7:0] READDATA;    //Data value read from the memory

output wire [31:0] PC;
output wire READ;     //signal to memory READ
output wire WRITE;     //signal to memory WRITE
output wire [7:0] REGOUT1;    //reading reg in reg file
output wire [7:0] ALURESULT; 

// wire [7:0] OPCODE;
wire [7:0] IMMEDIATE;
wire [3:0] ALUOP;
wire RfOutSel;     //register file out put mux selector
wire AluInSel;     //Alu input mux selector
wire [2:0] READREG1;     //reading register 1 address in rf
wire [2:0] READREG2;     //reading register 2 address in rf
wire [2:0] WRITEREG;     //writing register address in rf
wire WRITEENABLE;     //signal to register write

wire AluOutSel;     //signal to select READDATA or ALURESULT

wire BRANCHNEQ;   //branch not equal selecting signal
wire BRANCH;   //branch selecting signal
wire BranchSel;     //PC selecting signal

wire [31:0] TARGET;     //sign extended target offset
wire [7:0] TARGET_OFFSET;   // jump or branch target offset

control_unit Control(PC, BRANCHNEQ, BRANCH, TARGET_OFFSET, IMMEDIATE, ALUOP, RfOutSel, AluInSel, READREG1, READREG2, WRITEREG, WRITEENABLE, AluOutSel, READ, WRITE, INSTRUCTION, CLK, RESET, BranchSel, TARGET, BUSYWAIT); 

datapath Datapath(ALURESULT, REGOUT1, BranchSel, BRANCHNEQ, BRANCH, TARGET, TARGET_OFFSET, IMMEDIATE, ALUOP, RfOutSel, AluInSel, READREG1, READREG2, WRITEREG, WRITEENABLE, AluOutSel, READDATA, CLK, RESET, BUSYWAIT);


endmodule
