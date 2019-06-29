module Sign_Extend(
    select_i,
    data0_i,
    data1_i,
    data_o     
);
input [11:0] data0_i,data1_i;
input select_i;
output[31:0] data_o;

assign data_o = (select_i)? {{20{data1_i[11]}},data1_i} : {{20{data0_i[11]}},data0_i} ; 

endmodule