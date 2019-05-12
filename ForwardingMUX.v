module ForwardingMUX(
    select_i,
    data_i,
    EX_MEM_i,
    MEM_WB_i,
    data_o
);

input	[1:0]		select_i;
input	[31:0]		data_i, EX_MEM_i, MEM_WB_i;
output reg[31:0]	data_o;


always @(*) begin
	case(select_i)
        2'b00: data_o = data_i;

        2'b01: data_o = MEM_WB_i;

		2'b10: data_o = EX_MEM_i;	

        default : data_o = data_i;
	endcase
end

endmodule