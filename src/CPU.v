`include "MUX32.v"
`include "PC.v"
`include "Adder.v"
`include "Instruction_Memory.v"
`include "ALU.v"
`include "shift2.v"
`include "Sign_Extend.v"
`include "IF_ID.v"
`include "Control.v"
`include "Registers.v"
`include "ID_EX.v"
`include "ALU_Control.v"
`include "HazardDetect.v"
`include "MUX_Control.v"
`include "ForwardingUnit.v"
`include "ForwardingMUX.v"
`include "EX_MEM.v"
`include "DataMemory.v"
`include "MEM_WB.v"
`include "VALU.v" //NEW
`include "VALU_ctrl.v" //NEW

module CPU
(
    clk_i, 
    DataOrReg,
    address,
    instr_i,
    reset,
    vout_addr,
    value_o,
    is_positive,
    easter_egg
);

//------------------------- I/O Ports -------------------------------//

input               clk_i;
input               DataOrReg;
input [4:0]         address;
input  [7:0]        instr_i;
input               reset;
input [1:0]        vout_addr;//00:ouput 8,i.e. [7:0] LSB; 01: [15:8] 
output reg[7:0]        value_o;
output  is_positive;
output  reg[2:0] easter_egg;

//------------------------- Wire&Reg -------------------------------//

wire [3:0] vector_signed_bits;
wire [31:0] op_selection;
wire [31:0] inst_addr,inst,addPC,aluData,RSD,RTD,signExData,MUXop;
wire [9:0] ALUfunct_in;
wire [2:0] alu_ctrl_wire;
wire [11:0] pcIm,swIm;
wire isBranch;
wire rst;
wire [31:0] AddSum_data_o;
wire [31:0] pcSelect_data_o;
wire        HazradDetect_Hazard_o;
wire [31:0] IF_ID_pc_o;
wire [31:0] shiftLeft_data_o;
wire [11:0] IF_ID_pcIm_o;
wire [31:0] IF_ID_inst_o;
wire [4:0]  MEM_WB_RDaddr_o;
wire [31:0] memToReg_data_o;
wire        MEM_WB_RegWrite_o;
wire        Control_immSelect_o;
wire [31:0] PCImmExtend_data_o;
wire [31:0] Registers_RSdata_o;
wire [31:0] Registers_RTdata_o;
wire [31:0] Sign_Extend_data_o;
wire [4:0]  MUX_Control_RegDst_o;
wire [1:0]  MUX_Control_ALUOp_o;
wire        MUX_Control_ALUSrc_o;
wire        MUX_Control_RegWrite_o;
wire        MUX_Control_MemToReg_o;
wire        MUX_Control_MemRead_o;
wire        MUX_Control_MemWrite_o;
wire [31:0] ForwardToData2_data_o;
wire [31:0] ID_EX_SignExtended_o;
wire        ID_EX_ALUSrc_o;
wire [1:0]  ID_EX_ALUOp_o;
wire [31:0] ForwardToData1_data_o;
wire [31:0] MUX_ALUSrc_data_o;
wire [2:0]  ALU_Control_ALUCtrl_o;
wire        ID_EX_MemRead_o;
wire [1:0]  Control_ALUOp_o;
wire        Control_ALUSrc_o;
wire        Control_RegWrite_o;
wire        Control_MemToReg_o;
wire        Control_MemRd_o;
wire        Control_MemWr_o;
wire        EX_MEM_RegWrite_o;
wire [4:0]  EX_MEM_RDaddr_o;
wire [4:0]  ID_EX_RSaddr_o;
wire [4:0]  ID_EX_RTaddr_o;
wire [1:0]  ForwardingUnit_ForwardA_o;
wire [31:0] ID_EX_RDData0_o;
wire [31:0] ID_EX_inst_o;
wire [31:0] EX_MEM_instr_o;
wire [31:0] EX_MEM_ALUResult_o;
wire [1:0]  ForwardingUnit_ForwardB_o;
wire [31:0] ID_EX_RDData1_o;
wire [31:0] ID_EX_pc_o;
wire        ALU_Zero_o;
wire [31:0] ALU_data_o;
wire [4:0]  ID_EX_RegDst_o;
wire        ID_EX_RegWrite_o;
wire        ID_EX_MemToReg_o;
wire        ID_EX_MemWrite_o;
wire [31:0] EX_MEM_RDData_o;
wire        EX_MEM_MemWrite_o;
wire        EX_MEM_MemRead_o;
wire        EX_MEM_MemToReg_o;
wire [31:0] MEM_WB_ALUResult_o;
wire [31:0] MEM_WB_DataMemReadData_o;
wire        MEM_WB_MemToReg_o;
wire [31:0] Data_Memory_data_o;
wire [31:0] data_mem_o,reg_o;
wire RegEqual;
wire PC_Branch_Select;//in IF stage
wire [31:0] VALU_v_o, EX_MEM_VALUResult_o, aluToDM_data_o; //NEW
wire toDataMemory; //NEW: used in MUX32 aluToDM
wire [2:0] VALU_Control_VALUCtrl_o;
wire [3:0] is_positive_line;

reg               flag;
reg               start_i;
reg [3:0] vector_signed [0:2];
reg easter_flag,easter_flag_next;
reg [7:0] egg1,egg2,egg3;
reg [2:0] easter_counter,easter_counter_next;
//------------------------- continuous assginment -------------------------------//

assign RegEqual = (Registers_RSdata_o == Registers_RTdata_o);
assign PC_Branch_Select = RegEqual & isBranch;
assign isBranch = (IF_ID_inst_o[6:0]==7'b1100011)? 1'b1:1'b0;
assign ALUfunct_in = {ID_EX_inst_o[31:25],ID_EX_inst_o[14:12]};
assign pcIm = {inst[31],inst[7],inst[30:25],inst[11:8]};
assign swIm = {inst[31:25],inst[11:7]};
assign rst = reset;
//assign op_selection = (DataOrReg)? reg_o : data_mem_o;//May28 removed.
assign toDataMemory = (EX_MEM_instr_o[6:0] == 7'b1010111)? 1 : 0; //NEW
assign is_positive = is_positive_line[vout_addr];

//------------------------- Sequentail Part -------------------------------//

always@(posedge clk_i or posedge reset )begin
    if(reset)begin
        flag    <= 0;
        start_i <= 0;
        vector_signed[0] <= 0;
        vector_signed[1] <= 0;
        egg1             <= 8'b0000_1101;//013
        egg2             <= 8'b0011_0110;//054
        egg3             <= 8'b1001_1010;//154
    end
    else begin
        vector_signed[0] <= vector_signed_bits;
        vector_signed[1] <= vector_signed[0];
        egg1             <= 8'b0000_1101;//013
        egg2             <= 8'b0011_0110;//054
        egg3             <= 8'b1001_1010;//154
       if(flag)begin
            if(instr_i == 8'b1111_1111)begin
                flag    <= 0;
                start_i <= 1;
            end
            else begin
                flag    <= flag;
                start_i <= start_i;
            end
        end
        else begin
            if(instr_i == 8'b1111_1110)flag <= 1;//start reading in instr
            else flag <= flag;
            start_i <= start_i;
            
        end
    end
end

always@(posedge clk_i or posedge reset )begin
    if(reset)begin
        easter_flag    <= 0;
        easter_counter <= 0;
    end
    else begin
        easter_flag <= easter_flag_next;
        easter_counter <= easter_counter_next;
        if(easter_flag)begin
            easter_egg[0] <= egg1[(3'd7 - easter_counter)];
            easter_egg[1] <= egg2[(3'd7 - easter_counter)];
            easter_egg[2] <= egg3[(3'd7 - easter_counter)];
        end
        else begin
            easter_egg[0] <= 0;
            easter_egg[1] <= 0;
            easter_egg[2] <= 0;
        end
    end
end


//------------------------- Combinational Part -------------------------------//
always@(*)begin
    if(instr_i == 8'b1010_1010)easter_flag_next <= 1;
    else if(easter_counter == 3'd7)easter_flag_next <= 0;
         else                      easter_flag_next <= easter_flag;

    if(easter_flag)easter_counter_next = easter_counter + 3'd1;
    else easter_counter_next = easter_counter;
end

always@(*)begin
    case(vout_addr)
        2'b00:value_o   = (DataOrReg)? reg_o[7:0]   : data_mem_o[7:0];
        2'b01:value_o   = (DataOrReg)? reg_o[15:8]  : data_mem_o[15:8];
        2'b10:value_o   = (DataOrReg)? reg_o[23:16] : data_mem_o[23:16];
        2'b11:value_o   = (DataOrReg)? reg_o[31:24] : data_mem_o[31:24];
    endcase
end

MUX32 pcSelect(
    .data1_i    (addPC),
    .data2_i    (AddSum_data_o),//branch value
    .select_i   (isBranch),
    .data_o     (pcSelect_data_o)
);

PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .pc_i       (pcSelect_data_o),
    .hazardpc_i (HazradDetect_Hazard_o),
    .pc_o       (inst_addr)
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (addPC)              //to IF_ID.pc_i
);


Instruction_Memory Instruction_Memory(
    .clk        (clk_i),
    .reset      (rst),
    .addr_i     (inst_addr), 
    .instr_i    (instr_i),
    .instr_o    (inst)          //to IF_ID.inst_i
);

//AddSum was in EX stage initally, but moved to IF stage.
ALU AddSum(
    .data1_i    (IF_ID_pc_o),
    .data2_i    (shiftLeft_data_o),
    .ALUCtrl_i  (3'b001),
    .data_o     (AddSum_data_o),
    .Zero_o     ()
);

//the following two function is for branch judgement
Shift1 shiftLeft(
    .data_i (PCImmExtend_data_o),
    .data_o(shiftLeft_data_o)
);

Sign_Extend PCImmExtend(
    .select_i   (1'b0),
    .data0_i     (IF_ID_pcIm_o),
    .data1_i     (12'b0),
    .data_o     (PCImmExtend_data_o)  //to ID_EX.pcEx_i
);
//

IF_ID IF_ID(
    .clk_i  (clk_i),
    .start_i    (start_i),
    .pc_i   (inst_addr),
    .inst_i (inst), 
    .hazard_i   (HazradDetect_Hazard_o),
    .flush_i    (PC_Branch_Select),
    .pcIm_i (pcIm),
    .pcIm_o (IF_ID_pcIm_o),
    .pc_o   (IF_ID_pc_o),     //to ID_EX.pc_i
    .inst_o (IF_ID_inst_o)      //to ID_EX.inst_i
);

Control Control(
    .Op_i       (IF_ID_inst_o[6:0]),
    .ALUOp_o    (Control_ALUOp_o),             //to ID_EX.ALUOp_i
    .ALUSrc_o   (Control_ALUSrc_o),             //to ID_EX.ALUSrc_i
    .RegWrite_o (Control_RegWrite_o),             //to ID_EX.RegWrite_i
    .MemRd_o    (Control_MemRd_o),             //to ID_EX.MemRead_i
    .MemWr_o    (Control_MemWr_o),             //to ID_EX.MemWrite_i
    .MemToReg_o   (Control_MemToReg_o),              //to ID_EX.MemToReg_i
    .immSelect_o  (Control_immSelect_o)             //to Sign_Extend.select_i
);

Registers Registers(
    .clk_i      (clk_i),
    .reset      (rst),
    .op_address (address),
    .RSaddr_i   (IF_ID_inst_o[19:15]),     
    .RTaddr_i   (IF_ID_inst_o[24:20]),     
    .RDaddr_i   (MEM_WB_RDaddr_o), 
    .RDdata_i   (memToReg_data_o),
    .RegWrite_i (MEM_WB_RegWrite_o), 
    .is_pos_i   (vector_signed[1]),
    .RSdata_o   (Registers_RSdata_o),                  //to ID_EX.RDData0_i
    .RTdata_o   (Registers_RTdata_o),                  //to ID_EX.RDData1_i
    .reg_o      (reg_o),
    .pos_o      (is_positive_line)
);


Sign_Extend Sign_Extend(
    .select_i   (Control_immSelect_o), //select=1 for sw,0 for others
    .data0_i     (IF_ID_inst_o[31:20]),
    .data1_i     ({IF_ID_inst_o[31:25],IF_ID_inst_o[11:7]}),
    .data_o     (Sign_Extend_data_o)   // to ID_EX.SignExtended_i
);

ID_EX ID_EX(
    .clk_i  (clk_i),
    .start_i    (start_i),
    .inst_i (IF_ID_inst_o),
    .pc_i   (IF_ID_pc_o),
    .pcEx_i(PCImmExtend_data_o),//useless for now
    .RDData0_i  (Registers_RSdata_o),
    .RDData1_i  (Registers_RTdata_o),
    .SignExtended_i (Sign_Extend_data_o),
    .RegDst_i   (MUX_Control_RegDst_o),
    .ALUOp_i    (MUX_Control_ALUOp_o),
    .ALUSrc_i   (MUX_Control_ALUSrc_o),
    .RegWrite_i (MUX_Control_RegWrite_o),
    .MemToReg_i (MUX_Control_MemToReg_o),
    .MemRead_i  (MUX_Control_MemRead_o),
    .MemWrite_i  (MUX_Control_MemWrite_o),
    .PC_branch_select_i (PC_Branch_Select),//useless
    .RSaddr_i   (IF_ID_inst_o[19:15]),     
    .RTaddr_i   (IF_ID_inst_o[24:20]),
    .inst_o (ID_EX_inst_o),     
    .pc_o   (ID_EX_pc_o),             //to EX_MEM.pc_i
    .pcEx_o (),             //to shiftLeft.data_i
    .RDData0_o  (ID_EX_RDData0_o),         //to ALU.data1_i
    .RDData1_o  (ID_EX_RDData1_o),         //to EX_MEM.RDData_i
    .SignExtended_o (ID_EX_SignExtended_o),     //to MEX_ALUSrc.data2_i
    .RegDst_o   (ID_EX_RegDst_o),         //to EX_MEM.RDaddr_i
    .ALUOp_o    (ID_EX_ALUOp_o),         //to ALU_Control.ALUOp_i
    .ALUSrc_o   (ID_EX_ALUSrc_o),         //to ALUSrc.select_i
    .RegWrite_o (ID_EX_RegWrite_o),         //to EX_MEM.RegWrite_i
    .MemToReg_o (ID_EX_MemToReg_o),         //to EX_MEM.MemToReg_i
    .MemRead_o  (ID_EX_MemRead_o),         //to EX_MEM..MemRead_i
    .MemWrite_o (ID_EX_MemWrite_o),         //to EX_MEM.MemWrite_i
    .PC_branch_select_o (),
    .RSaddr_o(ID_EX_RSaddr_o),
    .RTaddr_o(ID_EX_RTaddr_o)
);

MUX32 MUX_ALUSrc(
    .data1_i    (ForwardToData2_data_o),
    .data2_i    (ID_EX_SignExtended_o),
    .select_i   (ID_EX_ALUSrc_o),
    .data_o     (MUX_ALUSrc_data_o)
);

ALU_Control ALU_Control(
    .funct_i    (ALUfunct_in),
    .ALUOp_i    (ID_EX_ALUOp_o),
    .ALUCtrl_o  (ALU_Control_ALUCtrl_o)
);

ALU ALU(
    .data1_i    (ForwardToData1_data_o),
    .data2_i    (MUX_ALUSrc_data_o),
    .ALUCtrl_i  (ALU_Control_ALUCtrl_o),
    .data_o     (ALU_data_o),         //to EX_MEM.ALUResult_i    &    EX_MEM.RDaddr_i
    .Zero_o     (ALU_Zero_o)          //to EX_MEM.zero_i
);

HazradDetect HazradDetect(
    .IF_IDrs1_i  (IF_ID_inst_o[24:20]),
    .IF_IDrs2_i  (IF_ID_inst_o[19:15]),
    .ID_EXrd_i  (IF_ID_inst_o[19:15]),
    .ID_EX_MemRead_i    (ID_EX_MemRead_o),
    .Hazard_o   (HazradDetect_Hazard_o)
);

MUX_Control MUX_Control(
    .Hazard_i   (HazradDetect_Hazard_o), 
    .RegDst_i   (IF_ID_inst_o[11:7]),  
    .ALUOp_i    (Control_ALUOp_o), 
    .ALUSrc_i   (Control_ALUSrc_o),  
    .RegWrite_i (Control_RegWrite_o), 
    .MemToReg_i     (Control_MemToReg_o), 
    .MemRead_i  (Control_MemRd_o),
    .MemWrite_i     (Control_MemWr_o),
    .RegDst_o   (MUX_Control_RegDst_o),  
    .ALUOp_o    (MUX_Control_ALUOp_o), 
    .ALUSrc_o   (MUX_Control_ALUSrc_o),  
    .RegWrite_o     (MUX_Control_RegWrite_o), 
    .MemToReg_o     (MUX_Control_MemToReg_o),  
    .MemRead_o  (MUX_Control_MemRead_o),
    .MemWrite_o     (MUX_Control_MemWrite_o)  
);

ForwardingUnit ForwardingUnit(
    .EX_MEM_RegWrite_i (EX_MEM_RegWrite_o),
    .EX_MEM_RD_i       (EX_MEM_RDaddr_o),
    .ID_EX_RS_i        (ID_EX_RSaddr_o),
    .ID_EX_RT_i        (ID_EX_RTaddr_o),
    .MEM_WB_RegWrite_i (MEM_WB_RegWrite_o),
    .MEM_WB_RD_i       (MEM_WB_RDaddr_o),
    .ForwardA_o        (ForwardingUnit_ForwardA_o),
    .ForwardB_o        (ForwardingUnit_ForwardB_o)
);

ForwardingMUX ForwardToData1(
    .select_i (ForwardingUnit_ForwardA_o),
    .data_i   (ID_EX_RDData0_o),
    .EX_MEM_i (EX_MEM_ALUResult_o),
    .MEM_WB_i (memToReg_data_o),
    .data_o   (ForwardToData1_data_o)
);

ForwardingMUX ForwardToData2(
    .select_i (ForwardingUnit_ForwardB_o),
    .data_i   (ID_EX_RDData1_o),
    .EX_MEM_i (EX_MEM_ALUResult_o),
    .MEM_WB_i (memToReg_data_o),
    .data_o   (ForwardToData2_data_o)
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
    .instr_i(ID_EX_inst_o),
    .instr_o(EX_MEM_instr_o),
    .pc_o   (),
    .zero_o (),
    .ALUResult_o    (EX_MEM_ALUResult_o),
    .VALUResult_o (EX_MEM_VALUResult_o), //NEW         //to MEM_WB.ALUResult_i
    .RDData_o   (EX_MEM_RDData_o),             //to MEM_WB.RDData_i
    .RDaddr_o   (EX_MEM_RDaddr_o),             //to MEM_WB.RDaddr_i 
    .RegWrite_o (EX_MEM_RegWrite_o),             //to MEM_WB.RegWrite_i
    .MemToReg_o (EX_MEM_MemToReg_o),             //to MEM_WB.MemToReg_i
    .MemRead_o  (EX_MEM_MemRead_o),             //to Data_Memory.MemRead_i
    .MemWrite_o (EX_MEM_MemWrite_o)              //to Data_Memory.MemWrite_i
);

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .reset      (rst),
    .op_addr    (address),
    .addr_i     (aluToDM_data_o),
    .data_i     (EX_MEM_RDData_o),
    .MemWrite_i (EX_MEM_MemWrite_o),
    .MemRead_i  (EX_MEM_MemRead_o),
    .data_o     (Data_Memory_data_o),
    .data_mem_o (data_mem_o)
);

MEM_WB MEM_WB(
    .clk_i  (clk_i),
    .start_i    (start_i),
    //.ALUResult_i    (EX_MEM_ALUResult_o),
    .ALUResult_i    (aluToDM_data_o),
    .RDData_i   (EX_MEM_RDData_o),
    .RDaddr_i   (EX_MEM_RDaddr_o),
    .RegWrite_i (EX_MEM_RegWrite_o),
    .MemToReg_i (EX_MEM_MemToReg_o),
    .DataMemReadData_i(Data_Memory_data_o),
    .ALUResult_o    (MEM_WB_ALUResult_o),
    .RDData_o   (),         //to memToReg.data1_i
    .RDaddr_o   (MEM_WB_RDaddr_o),         
    .RegWrite_o (MEM_WB_RegWrite_o),         //to Registera.RegWrite_i
    .MemToReg_o (MEM_WB_MemToReg_o),          //to memToReg.select_i
    .DataMemReadData_o(MEM_WB_DataMemReadData_o)
);

MUX32 memToReg(
    .data1_i    (MEM_WB_ALUResult_o),
    .data2_i    (MEM_WB_DataMemReadData_o),
    .select_i   (MEM_WB_MemToReg_o),//MemToReg control
    .data_o     (memToReg_data_o)
);

MUX32 aluToDM( //NEW module: to decide if addr_i in Data_Memory comes from ALU or VALU
    .data1_i(EX_MEM_ALUResult_o),
    .data2_i(EX_MEM_VALUResult_o),
    .select_i(toDataMemory), //NEW, no change in MUX32.v
    .data_o(aluToDM_data_o) //to Data_Memory Data_Memory
);

VALU VALU( //NEW module
    .v1_i(ForwardToData1_data_o),
    .v2_i(MUX_ALUSrc_data_o),
    .VALUCtrl_i(VALU_Control_VALUCtrl_o),
    .v_o(VALU_v_o),
    .over(vector_signed_bits)
);

VALU_ctrl VALU_Control( //NEW module
    .vfunct_i(ALUfunct_in),
    .VALUCtrl_o(VALU_Control_VALUCtrl_o)
);

endmodule

