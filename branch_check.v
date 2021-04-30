`timescale  1ns/100ps
module branchCheck(BranchSel, BRANCH, BRANCHNEQ, ZERO);
//and module (branchneq & ~zero)
input BRANCH, BRANCHNEQ, ZERO;
// output reg BranchSel;
output BranchSel;

wire branch_eq;
wire branch_neq;

assign branch_eq = BRANCH & ZERO;
assign branch_neq = BRANCHNEQ & (~ZERO);

assign BranchSel = branch_eq | branch_neq;

endmodule
