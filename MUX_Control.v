module MUX_Control(
    Hazard_i, 
    RegDst_i,  
    ALUOp_i, 
    ALUSrc_i,  
    RegWrite_i, 
    MemToReg_i, 
    MemRead_i,
    MemWrite_i,
    RegDst_o,  
    ALUOp_o, 
    ALUSrc_o,  
    RegWrite_o, 
    MemToReg_o, 
    MemRead_o,
    MemWrite_o,  
);

input	[1:0]	ALUOp_i;
input 	[4:0]	RegDst_i;
input	Hazard_i, ALUSrc_i, RegWrite_i, MemToReg_i, MemRead_i, MemWrite_i; 

output	reg [1:0]	ALUOp_o;
output 	reg [4:0]	RegDst_o;
output	reg ALUSrc_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o; 

always@(*)begin
    case(Hazard_i)
    1'b1 : begin
    RegDst_o <= 4'b0000;  
    ALUOp_o <= 2'b00;
    ALUSrc_o <= 1'b0; 
    RegWrite_o <= 1'b0;
    MemToReg_o <= 1'b0;
    MemRead_o <= 1'b0;
    MemWrite_o <= 1'b0;
    end

    1'b0 : begin
    RegDst_o <= RegDst_i;  
    ALUOp_o <= ALUOp_i;
    ALUSrc_o <= ALUSrc_i; 
    RegWrite_o <= RegWrite_i;
    MemToReg_o <= MemToReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    end

    default : begin
    RegDst_o <= RegDst_i;  
    ALUOp_o <= ALUOp_i;
    ALUSrc_o <= ALUSrc_i; 
    RegWrite_o <= RegWrite_i;
    MemToReg_o <= MemToReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    end

    endcase

end
endmodule