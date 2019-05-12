module IF_ID(
	clk_i,
	start_i,
	pc_i,
	inst_i,
	hazard_i,
	flush_i,
	pcIm_i,
	pcIm_o,
	pc_o,
	inst_o,
);

input	clk_i, hazard_i, flush_i, start_i;
input	[31:0]	inst_i, pc_i;
input 	[11:0]	pcIm_i;
output 	[11:0]	pcIm_o;
output	[31:0]	pc_o, inst_o;

reg [31:0]	pc_o, inst_o;
reg [11:0] 	pcIm_o;

always@(posedge clk_i) begin
	if(~start_i) begin
		pc_o <= 32'b0;
		inst_o <= 32'b0;
		pcIm_o <= 12'b0;
	end
	else if(flush_i) begin
		pc_o <= pc_i;
		inst_o <= 32'b0;
		pcIm_o <= 12'b0;
	end
	else if(hazard_i) begin
		pc_o <= pc_i;
		inst_o <= inst_o;
		pcIm_o <= pcIm_i;
	end
	else begin
		pc_o <= pc_i;
		inst_o <= inst_i;
		pcIm_o <= pcIm_i;
	end
end

endmodule

