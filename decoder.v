`timescale  1ns/100ps
module decoder(BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE, INSTRUCTION, PC);

input [31:0] INSTRUCTION;
input [31:0] PC;

output reg BRANCHNEQ;		//branch not equal selecting signal
output reg BRANCH;		//branch selecting signal
output reg JUMP;		//jump selecting signal
output reg [3:0] ALUOP;		//function selecting signal for alu
output reg RfOutSel;     //register file out put mux selector
output reg AluInSel;     //Alu input mux selector
output reg WRITEENABLE;     //signal to register write

output reg AluOutSel;     //signal to select READDATA or ALURESULT
output reg READ;     //signal to memory READ
output reg WRITE;     //signal to memory WRITE

reg [7:0] OPCODE;        //OPCODE

always @(INSTRUCTION) begin

	READ = 1'b0; 	//set read signal to 0
	WRITE = 1'b0;	//set write signal to 0	
	OPCODE = INSTRUCTION[31:24];		//extracting the opcode

	case (OPCODE)
		8'b00000010: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0001_0_1_1_0_0_0; //add
		8'b00000011: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0001_1_1_1_0_0_0; //sub
		8'b00000001: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0000_0_1_1_0_0_0; //mov / Ignore SOURCE 1
		8'b00000000: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0000_X_0_1_0_0_0; //loadi / Ignore SOURCE 1
		8'b00000100: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0010_0_1_1_0_0_0; //and
		8'b00000101: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0011_0_1_1_0_0_0; //or
		8'b00000111: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_1_0_0001_1_1_0_0_0_0; //beq
		8'b00000110: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_1_XXXX_X_X_0_0_0_0; //j

		8'b00001000: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0100_0_1_1_0_0_0; //mult
		8'b00001001: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0101_0_0_1_0_0_0; //sll
		8'b00001010: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0110_0_0_1_0_0_0; //srl
		8'b00001011: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0111_0_0_1_0_0_0; //sra
		8'b00001100: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_1000_0_0_1_0_0_0; //ror
		8'b00001101: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b1_0_0_0001_1_1_0_0_0_0; //bne

		8'b00001110: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0000_0_1_1_1_1_0; //lwd
		8'b00001111: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0000_X_0_1_1_1_0; //lwi
		8'b00010000: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b0_0_0_0000_0_1_0_X_0_1; //swd
		8'b00010001: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'b1_0_0_0000_X_0_0_X_0_1; //swi

		default: #1 {BRANCHNEQ, BRANCH, JUMP, ALUOP, RfOutSel, AluInSel, WRITEENABLE, AluOutSel, READ, WRITE} = 13'bX_X_X_XXXX_X_X_0_X_0_0;
	endcase
end

endmodule

