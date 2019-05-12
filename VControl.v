module Control(
    Op_i       ,
    RegDst_o   ,
    ALUOp_o    ,
    ALUSrc_o   ,
    RegWrite_o ,
    MemRd_o,
    MemWr_o,
    VMemWr_o, //NEW
    Branch_o,
    MemToReg_o,
    immSelect_o
);

//ports

input [6:0]     Op_i;
output reg         RegDst_o;
output reg[1:0]     ALUOp_o;
output  reg      ALUSrc_o,immSelect_o;
output  reg    RegWrite_o ,MemRd_o,MemWr_o,Branch_o,MemToReg_o, VMemWr_o; //NEW




always@(*)begin

  case(Op_i)

  7'b0010011 : begin //addi
  ALUOp_o = 2'b11;
  ALUSrc_o = 1'b1;
  RegWrite_o = 1'b1;
  Branch_o = 1'b0;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  RegDst_o = 1'b1;
  immSelect_o = 1'b0;
  end
  
  7'b0110011 : begin //others
  ALUOp_o = 2'b10;
  ALUSrc_o = 1'b0;
  RegWrite_o = 1'b1;
  Branch_o = 1'b0;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  RegDst_o = 1'b1;
  immSelect_o = 1'b0;
  end

  7'b1100011 : begin //beq
  ALUOp_o = 2'b01;
  ALUSrc_o = 1'b1;
  Branch_o = 1'b1;
  RegWrite_o = 1'b0;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  RegDst_o = 1'b0;
  immSelect_o = 1'b0;
  end

  7'b0000011 : begin //lw
  ALUOp_o = 2'b00;
  ALUSrc_o = 1'b1;
  MemRd_o = 1'b1;
  MemToReg_o = 1'b1;
  RegWrite_o = 1'b1;
  Branch_o = 1'b0;
  MemWr_o = 1'b0;
  RegDst_o = 1'b0;
  immSelect_o = 1'b0;
  end

  7'b0100011 : begin //sw
  ALUOp_o = 2'b00;
  ALUSrc_o = 1'b1;
  MemWr_o = 1'b1;
  RegWrite_o = 1'b0;
  Branch_o = 1'b0;
  MemRd_o = 1'b0;
  MemToReg_o = 1'b0;
  RegDst_o = 1'b0;
  immSelect_o = 1'b1;
  end

  //---------NEW-----------
  7'b1010111: begin //vector
  ALUOp_o = 2'b00; //useless
  ALUSrc_o = 1'b0;
  RegWrite_o = 1'b1;
  Branch_o = 1'b0;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  RegDst_o = 1'b1;
  immSelect_o = 1'b0;
  end
  //---------NEW-----------

  default : begin
  ALUOp_o = 2'b11;
  ALUSrc_o = 1'b1;
  RegWrite_o = 1'b1;
  Branch_o = 1'b0;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  RegDst_o = 1'b1;
  immSelect_o = 1'b0;
  end
  endcase
end
endmodule