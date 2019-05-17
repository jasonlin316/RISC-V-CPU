module Instruction_Memory
(
    clk,
    reset,
    addr_i, 
    instr_i,
    instr_o
);
integer i;
// Interface
input               clk;
input               reset;
input   [31:0]      addr_i;
input   [7:0]       instr_i;
output  [31:0]      instr_o;

// Instruction memory
reg     [31:0]     memory  [0:63];
reg     [1:0]      quad,quad_d1;
reg     [7:0]      instr_read;
reg     [5:0]      address_read;
reg                flag,flag_next;
reg     [1:0]      counter,counter_next;
reg     [5:0]      instr_wr_address,instr_wr_address_next;

assign  instr_o = memory[addr_i>>2];  

always@(*)begin
    if(instr_i == 8'b1111_1110)flag_next = 1;
    else if (instr_i == 8'b1111_1111)flag_next = 0;
    else flag_next = flag;

    if(flag)counter_next = counter + 2'd1;
    else counter_next = counter;

    if(counter == 2'b11)instr_wr_address_next = instr_wr_address + 6'd1;
    else instr_wr_address_next = instr_wr_address;
end

always@(posedge clk or posedge reset)begin
    if(reset)begin
        for(i=0;i<63;i=i+1)begin
            memory[i] <= 0;
        end
        counter         <= 0;
        quad            <= 0;
        instr_read      <= 0;
        flag            <= 0;
        address_read    <= 0;
        instr_wr_address<=0;
    end
    else begin
        flag             <= flag_next;
        counter          <= counter_next;
        quad             <= (2'b11-counter);
        quad_d1          <= quad;
        instr_wr_address <= instr_wr_address_next;
        address_read     <= instr_wr_address;
        instr_read       <= instr_i;
        
        
        if(flag)begin
            case(quad)
            2'b00: memory[address_read][7:0]   <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b01: memory[address_read][15:8]  <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b10: memory[address_read][23:16] <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b11: memory[address_read][31:24] <= (instr_read == 8'b1111_1111)?0:instr_read;
            default: memory[address_read][7:0] <= (instr_read == 8'b1111_1111)?0:instr_read;
            endcase
        end
    end
end
endmodule
