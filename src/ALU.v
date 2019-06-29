module ALU (data1_i, data2_i, ALUCtrl_i, data_o,Zero_o);

input [31:0] data1_i, data2_i;
input [2:0] ALUCtrl_i;
output reg[31:0] data_o;
output reg Zero_o;

parameter SUM = 3'b001;
parameter SUB = 3'b010;
parameter AND = 3'b011;
parameter OR  = 3'b100;
parameter XOR = 3'b101;
parameter MUL = 3'b110;


/* implement here */
always@(*)begin
Zero_o   = (data1_i - data2_i)?0:1;
case(ALUCtrl_i)

  SUM : begin
    data_o = data1_i + data2_i;
  end
  SUB : begin
    data_o = data1_i - data2_i;
  end
  AND : begin
    data_o = data1_i & data2_i;
  end
  OR : begin
    data_o = data1_i | data2_i;
  end
  XOR : begin
    data_o = data1_i ^ data2_i;
  end
  MUL : begin
    data_o = data1_i * data2_i;
  end
  default : begin
    data_o = data1_i;
  end

endcase

end

endmodule
