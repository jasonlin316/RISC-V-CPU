module ID_EX(
	clk_i,
	start_i,
	inst_i,
	pc_i,
	pcEx_i,
	RDData0_i,
	RDData1_i,
	SignExtended_i,
	RegDst_i,
	ALUOp_i,
	ALUSrc_i,
	RegWrite_i,
	MemToReg_i,
	MemRead_i,
	MemWrite_i,
	inst_o,
	PC_branch_select_i,
	RSaddr_i,     
    RTaddr_i,
	pc_o,
	pcEx_o,
	RDData0_o,
	RDData1_o,
	SignExtended_o,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o,
	MemToReg_o,
	MemRead_o,
	MemWrite_o,
	PC_branch_select_o,
	RSaddr_o,
	RTaddr_o
);

input	clk_i, ALUSrc_i, RegWrite_i, MemToReg_i, MemRead_i, MemWrite_i, start_i; 
input	[31:0]	inst_i, pc_i, RDData0_i, RDData1_i, SignExtended_i;
input	[1:0]	ALUOp_i;
input 	[4:0]	RegDst_i,RSaddr_i,RTaddr_i;
input  [31:0] pcEx_i;
input PC_branch_select_i;
output	ALUSrc_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o;  
output	[31:0]	inst_o, pc_o, RDData0_o, RDData1_o, SignExtended_o;
output	[1:0]	ALUOp_o;
output 	[4:0]	RegDst_o,RSaddr_o,RTaddr_o;
output  [31:0] pcEx_o;
output reg PC_branch_select_o;
reg	ALUSrc_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o;  
reg	[31:0]	inst_o, pc_o, RDData0_o, RDData1_o, SignExtended_o,pcEx_o;
reg	[1:0]	ALUOp_o;
reg [4:0]	RegDst_o,RSaddr_o,RTaddr_o;

always@(posedge clk_i or negedge start_i) begin
	if(~start_i) begin
		inst_o <= 0;
		pc_o <= 0 ;
		RDData0_o <= 0;
		RDData1_o <= 0;
		SignExtended_o <= 0;
		RegDst_o <= 0;
		ALUOp_o <= 0;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		MemToReg_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		pcEx_o <= 0;
		PC_branch_select_o <=0;
		RSaddr_o <= 0;
		RTaddr_o <= 0;
	end
	else begin
		inst_o <= inst_i;
		pc_o <= pc_i ;
		RDData0_o <= RDData0_i;
		RDData1_o <= RDData1_i;
		SignExtended_o <= SignExtended_i;
		RegDst_o <= RegDst_i;
		ALUOp_o <= ALUOp_i;
		ALUSrc_o <= ALUSrc_i;
		RegWrite_o <= RegWrite_i;
		MemToReg_o <= MemToReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		pcEx_o <= pcEx_i;
		PC_branch_select_o <= PC_branch_select_i;
		RSaddr_o <= RSaddr_i;
		RTaddr_o <= RTaddr_i;
	end
end

endmodule



