wire [31:0] VALU_v_o, EX_MEM_VALUResult_o, aluToDM_data_o;

VALU VALU(
    .v1_i(ForwardToData1_data_o),
    .v2_i(MUX_ALUSrc_data_o),
    //.s_i(),
    .VALUCtrl_i(VALU_Control_VALUCtrl_o),
    .v_o(VALU_v_o)
);

VALU_ctrl VALU_Control(
    .vfunct_i(ALUfunct_in),
    .VALUCtrl_o(VALU_Control_VALUCtrl_o)
);

EX_MEM EX_MEM(
    .clk_i  (clk_i),
    .start_i    (start_i),
    .pc_i   (ID_EX_pc_o),
    .zero_i (ALU_Zero_o),
    .ALUResult_i    (ALU_data_o),
    .VALUResult_i (VALU_v_o), //NEW
    .RDData_i   (ForwardToData2_data_o),//Reg read data2
    .RDaddr_i   (ID_EX_RegDst_o),//from IF_ID.inst_o[11:7]
    .RegWrite_i (ID_EX_RegWrite_o),
    .MemToReg_i (ID_EX_MemToReg_o),
    .MemRead_i  (ID_EX_MemRead_o),
    .MemWrite_i (ID_EX_MemWrite_o),
    .pc_o   (),
    .zero_o (),
    .ALUResult_o    (EX_MEM_ALUResult_o),         //to MEM_WB.ALUResult_i
    .VALUResult_o (EX_MEM_VALUResult_o), //NEW
    .RDData_o   (EX_MEM_RDData_o),             //to MEM_WB.RDData_i
    .RDaddr_o   (EX_MEM_RDaddr_o),             //to MEM_WB.RDaddr_i 
    .RegWrite_o (EX_MEM_RegWrite_o),             //to MEM_WB.RegWrite_i
    .MemToReg_o (EX_MEM_MemToReg_o),             //to MEM_WB.MemToReg_i
    .MemRead_o  (EX_MEM_MemRead_o),             //to Data_Memory.MemRead_i
    .MemWrite_o (EX_MEM_MemWrite_o)              //to Data_Memory.MemWrite_i
);

MUX32 aluToDM( //NEW module: to decide if addr_i in Data_Memory comes from ALU or VALU
    .data1_i(EX_MEM_ALUResult_o),
    .data2_i(EX_MEM_VALUResult_o),
    .select_i(ALUfunct_in[3]), //NEW, no change in MUX32.v
    .data_o(aluToDM_data_o)
);

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .addr_i     (aluToDM_data_o), //NEW, no change in DataMemory.v
    .data_i     (EX_MEM_RDData_o),
    .MemWrite_i (EX_MEM_MemWrite_o),
    .MemRead_i  (EX_MEM_MemRead_o),
    .data_o     (Data_Memory_data_o)
);