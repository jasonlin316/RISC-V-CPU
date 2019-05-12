module Instruction_Memory
(
    clk,
    reset,
    addr_i, 
    instr_wr_address,
    instr_i,
    counter,
    instr_o
);
integer i;
// Interface
input               clk;
input               reset;
input   [31:0]      addr_i;
input   [5:0]       instr_wr_address;
input   [7:0]       instr_i;
input   [1:0]       counter;
output  [31:0]      instr_o;

// Instruction memory
reg     [31:0]     memory  [0:63];
reg     [1:0]      quad;
reg     [7:0]      instr_read;
reg     [5:0]      address_read;
assign  instr_o = memory[addr_i>>2];  
reg     flag,flag_next;
always@(*)begin
    if(instr_i == 8'b1111_1110)flag_next = 1;
    else if (instr_read == 8'b1111_1111)flag_next = 0;
    else flag_next = flag;
end

always@(posedge clk or posedge reset)begin
    if(reset)begin
        for(i=0;i<63;i=i+1)begin
            memory[i] <= 0;
        end
        quad <= 0;
        instr_read <= 0;
        flag       <= 0;
        address_read<=0;
    end
    else begin
        flag    <= flag_next;
        if(flag_next) quad  <= (2'b11-counter);
        else quad <= 0;
        instr_read <= instr_i;
        address_read<= instr_wr_address;
        if(flag)begin
            case(quad)
            2'b00: memory[address_read][7:0]   <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b01: memory[address_read][15:8]  <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b10: memory[address_read][23:16] <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b11: memory[address_read][31:24] <= (instr_read == 8'b1111_1111)?0:instr_read;
            default: memory[address_read][7:0]   <= (instr_read == 8'b1111_1111)?0:instr_read;
            endcase
        end
    end
end
endmodule
