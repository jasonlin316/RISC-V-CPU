           
`timescale 1ns/10ps
`define CYCLE_TIME 10.0          	  // Modify your clock period here
`define SDFFILE    "WIN.sdf"	  // Modify your sdf file name
`define End_CYCLE  300             // Modify cycle times once your design need more cycle times!


module testfixture;

`ifdef SDF
	initial $sdf_annotate(`SDFFILE, CPU);
`endif

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
integer j,k;
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
    instr_i = 0;
    for(k=0;k < (64*4+1) ;k=k+1) instr_store[k] = 0;
    // Load instructions into instruction memory
    $readmemb("../dat/instruction2.txt", instr_store);
    $readmemh("../dat/golden.dat",golden);
    // Open output file
    outfile = $fopen("../dat/output.txt") | 1;
    
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
   //$dumpfile("CPU.vcd");
   //$dumpvars; 
end

always@(posedge Clk) begin
    if(counter<256)begin
        #(`CYCLE_TIME/4)
        instr_i = instr_store[counter];
    end
    else instr_i = 0;
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
                 $display("pattern%d is wrong:output %h != expected %h",j,value_o,golden[j]);
            end
            else begin
                 $display("pattern%d is correct:output %h == expected %h",j,value_o,golden[j]);
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
    
    counter = counter + 1;
    
      
end

  
endmodule
