module Shift1 (
  input [31:0] data_i,
  output [31:0] data_o
);

assign data_o = {data_i[30:0],1'b0};

endmodule