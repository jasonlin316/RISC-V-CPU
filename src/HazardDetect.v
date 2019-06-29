module HazradDetect(
    IF_IDrs1_i,
    IF_IDrs2_i,
    ID_EXrd_i,
    ID_EX_MemRead_i,
    Hazard_o,
);

input ID_EX_MemRead_i;
input [4:0] IF_IDrs1_i, IF_IDrs2_i, ID_EXrd_i;
output Hazard_o;

assign Hazard_o = ((ID_EX_MemRead_i && (ID_EXrd_i == IF_IDrs1_i || ID_EXrd_i == IF_IDrs2_i))? 1'b1 : 1'b0);

endmodule
