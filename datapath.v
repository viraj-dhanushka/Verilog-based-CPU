`timescale  1ns/100ps
module datapath(ALURESULT, REGOUT1, BranchSel, BRANCHNEQ, BRANCH, TARGET, TARGET_OFFSET, IMMEDIATE, ALUOP, RfOutSel, AluInSel, READREG1, READREG2, WRITEREG, WRITEENABLE, AluOutSel, READDATA, CLK, RESET, BUSYWAIT);

input CLK;
input RESET;
input BUSYWAIT; 

input [7:0] IMMEDIATE;
input [3:0] ALUOP;
input RfOutSel;     //register file out put mux selector
input AluInSel;     //Alu input mux selector
input [2:0] READREG1;     //reading register 1 address in rf
input [2:0] READREG2;     //reading register 2 address in rf
input [2:0] WRITEREG;     //writing register address in rf
input WRITEENABLE;     //signal to register write

input AluOutSel;     //signal to select READDATA or ALURESULT
input [7:0] READDATA;    //Data value read from the memory

output wire [7:0] REGOUT1;    //reading reg in reg file
wire [7:0] REGOUT2;    //reading reg in reg file


wire [7:0] REGOUT2_COMPLEMENT;    //output from regout2 through twos complement module 
wire [7:0] REGOUT2_RfOutMux;    //output from regout2 through mux 
wire [7:0] OPERAND2;        //alu OPERAND2 / DATA2
output wire [7:0] ALURESULT;        // ALURESULT 

wire [7:0] RegFileIn;        // result to write reg in reg file

input BRANCHNEQ;   //branch not equal selecting signal
input BRANCH;   //branch selecting signal
wire ZERO;      //ALU output - ZERO
output wire BranchSel;     //PC selecting signal
input [7:0] TARGET_OFFSET;
output wire [31:0] TARGET;


branchCheck BSELECT(BranchSel, BRANCH, BRANCHNEQ, ZERO); //(branch & zero) / (branchneq & ~zero)

reg_file RegFile(RegFileIn, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET, BUSYWAIT);
twos_complement SubVal(REGOUT2_COMPLEMENT, REGOUT2);
alu Alu(REGOUT1, OPERAND2, ALURESULT, ALUOP, ZERO);

signextend Signextend(TARGET, TARGET_OFFSET);      //sign extend immediate value

mux RfOutMux(RfOutSel,REGOUT2,REGOUT2_COMPLEMENT,REGOUT2_RfOutMux); //MUX select sub or not
mux AluInMux(AluInSel,IMMEDIATE,REGOUT2_RfOutMux,OPERAND2); //MUX select sub or not
mux RfInMux(AluOutSel,ALURESULT,READDATA,RegFileIn);  //MUX select READDATA or ALURESULT


endmodule
