`define CYCLE_TIME 10            
`timescale 1ns/10ps

module TestBench;

reg                Clk;
reg                Start;
reg                DataOrReg;
reg [4:0]          address;
reg [7:0]          instr_i;
reg                reset;//used to initalize memorys and registers
reg [7:0]          instr_store[0:(64*4+1)];
reg [1:0]             vout_addr;
wire[7:0]               value_o;
wire          is_positive;
wire [2:0]        easter_egg;
integer            i, outfile, counter;
integer            stall, flush,idx;
integer j;
integer err;
reg  [7:0] golden [0:63];

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .DataOrReg(DataOrReg),
    .address(address),
    .instr_i(instr_i),
    .reset(reset),
    .vout_addr(vout_addr),
    .value_o(value_o),
    .is_positive(is_positive),
    .easter_egg(easter_egg)
);
  
initial begin
    counter = 0;
    stall = 0;
    flush = 0;
    idx = 0;
    DataOrReg = 1;
    address = 5'd8;
    vout_addr = 2'b11;
    err = 0;
    // Load instructions into instruction memory
    $readmemb("instruction2.txt", instr_store);
    $readmemh("golden.dat",golden);
    // Open output file
    outfile = $fopen("output.txt") | 1;
    // Set Input n into data memory at 0x00
    //CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    //CPU.VALU.v1_i = 32'b0000_0001_0000_0110_0000_0011_1111_1100;
    //CPU.VALU.v2_i = 32'b0000_0101_0000_0010_1111_1001_1111_1100;
    
    Clk = 1;

    reset = 0;
    reset = 1;
    #(`CYCLE_TIME)
    reset = 0; 
end

initial begin
	$fsdbDumpfile("CPU.fsdb");
	$fsdbDumpvars;
    $fsdbDumpMDA;
   $dumpfile("CPU.vcd");
   $dumpvars; 
end

always@(posedge Clk) begin
    if(counter<256)begin
        instr_i = instr_store[counter];
    end
end
//8'b1111_1110 = start
//8'b1111_1111 = end
initial begin
    j =0 ;
     $display("--------------------------- [ Simulation Starts !! ] ---------------------------");
        #(`CYCLE_TIME*234);
        for(j=0;j<64;j=j+1)begin
            if((j%4==0)&&(j!=0))address = address + 5'd1;
            @(posedge Clk);
            vout_addr = vout_addr - 2'b1;
            if(value_o !== golden[j])begin
                 err = err + 1;
                 $display("pattern%d is wrong:output %d != expected %h",j,value_o,golden[j]);
            end
            else begin
                 $display("pattern%d is correct:output %d == expected %h",j,value_o,golden[j]);
            end
        end
        #(`CYCLE_TIME*2); 
     $display("--------------------------- Simulation Stops !!---------------------------");
     if (err) begin 
     	$display("============================================================================");
		$display("             ▄▄▄▄▄▄▄ "); 
		$display("         ▄▀▀▀       ▀▄"); 
		$display("       ▄▀            ▀▄ 		ERROR FOUND!!"); 
		$display("      ▄▀          ▄▀▀▄▀▄"); 
		$display("    ▄▀          ▄▀  ██▄▀▄"); 
		$display("   ▄▀  ▄▀▀▀▄    █   ▀▀ █▀▄ 	There are"); 
		$display("   █  █▄▄   █   ▀▄     ▐ █  %d errors in total.", err); 
		$display("  ▐▌  █▀▀  ▄▀     ▀▄▄▄▄▀  █ "); 
		$display("  ▐▌  █   ▄▀              █"); 
		$display("  ▐▌   ▀▀▀                ▐▌"); 
		$display("  ▐▌               ▄      ▐▌ "); 
		$display("  ▐▌         ▄     █      ▐▌ "); 
		$display("   █         ▀█▄  ▄█      ▐▌ "); 
		$display("   ▐▌          ▀▀▀▀       ▐▌ "); 
		$display("    █                     █ "); 
		$display("    ▐▌▀▄                 ▐▌"); 
		$display("     █  ▀                ▀ "); 
        $display("============================================================================");
	end
     else begin 
        $display("============================================================================");
        $display("/ \033[1;33m##########\                                  #########\033[m");
        $display("//\033[1;33m############/                           #############\033[m");
        $display("  \033[1;33m  (#############       /            ##################\033[m");
        $display("  \033[1;33m  ################################################ \033[m ");
        $display("  \033[1;33m     /###########################################  \033[m   ");
        $display(" \033[1;33m         //(#####################################(  \033[m    ");
        $display("   \033[1;33m        (##################################(/     \033[m    ");
		$display("   \033[1;33m     /####################################(     \033[m    ");
		$display("   \033[1;33m   #####(   /###############(    ########(   \033[m     ");
		$display("   \033[1;33m (#####       ##############     (########  \033[m	   ");
		$display(".  \033[1;33m  #######(  (################   (#########( \033[m	   ");
		$display(".   \033[1;33m/###############/  (######################/	\033[m   ");
		$display("\033[1;35m    . /////\033[m\033[1;33m############################\033[m\033[1;35m/ ///(\033\033[1;33m###( \033[m	   ");
		$display("\033[1;35m  .//////(\033[m\033[1;33m##########################\033[m\033[1;35m///////\033\033[1;33m######  \033[m	   ");
		$display("\033[1;35m   . /////\033[m \033[1;33m#########(       /#########\033[m\033[1;35m(//////\033\033[1;33m####( \033[m    ");
		$display("\033[1;35m   (#((\033[m\033[1;33m###########(        (#########\033[m\033[1;35m(((((\033\033[1;33m######/  \033[m  ");
		$display("  \033[1;33m /###############(      /(####################( \033[m   ");
		$display("   \033[1;33m/#################(  (#######################  \033[m  ");
		$display("\033[1;33m   (###########################################(  \033[m ");
		$display("\033[1;36m	^o^		WOOOOOW  YOU  PASSED!!!\033[m");
        $display("\n");
        $display("============================================================================");
        $finish;
	end
$finish;
 
end
  
always@(posedge Clk) begin
    if(counter == 300)    // stop after 240 cycles
        $finish;


    // print PC
    //$fdisplay(outfile, "cycle = %h, Start = %h, Stall = %h, Flush = %h\nPC = %h", counter, Start, stall, flush, CPU.PC.pc_o);
    
    // print Registers
    /*
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %h, R8 (t0) = %h, R16(s0) = %h, R24(t8) = %h", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %h, R9 (t1) = %h, R17(s1) = %h, R25(t9) = %h", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %h, R10(t2) = %h, R18(s2) = %h, R26(k0) = %h", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %h, R11(t3) = %h, R19(s3) = %h, R27(k1) = %h", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %h, R12(t4) = %h, R20(s4) = %h, R28(gp) = %h", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %h, R13(t5) = %h, R21(s5) = %h, R29(sp) = %h", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %h, R14(t6) = %h, R22(s6) = %h, R30(s8) = %h", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %h, R15(t7) = %h, R23(s7) = %h, R31(ra) = %h", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);
    */
    // print Data Memory
    //$fdisplay(outfile, "Data Memory: 0x00 = %h", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    //$fdisplay(outfile, "Data Memory: 0x04 = %h", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    //$fdisplay(outfile, "Data Memory: 0x08 = %h", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    //$fdisplay(outfile, "Data Memory: 0x0c = %h", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    //$fdisplay(outfile, "Data Memory: 0x10 = %h", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    //$fdisplay(outfile, "Data Memory: 0x14 = %h", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    //$fdisplay(outfile, "Data Memory: 0x18 = %h", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    //$fdisplay(outfile, "Data Memory: 0x1c = %h", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    //$fdisplay(outfile, "\n");
    
    counter = counter + 1;
    
      
end

  
endmodule
