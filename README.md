RISC-V CPU (Tape-Out with U18 Technology)
==================
This is a 32-bit 5-stage pipelined RISC-V CPU that supports basic instructions and some vector arithmetic.  
In order to tape out, gate level synthesis and APR are done as well.  
The simulation was done by NC-verilog and synthesised by Desgin Compiler.  
This chip has been tested on Dec.2 2019, and all functions work correctly.

## Usage
To run this work, you will need a verilog compiler such as ncverilog.  
_$ ncverilog testbench.v CPU.v_ to run RTL simulation.  
_$ ncverilog testbench.v WIN.v +define+SDF_ to run gate level simulation.  
_$ ncverilog testbench.v core_APR.v +define+SDF_ to run APR simulation.  
Note that you need to decompress the file in APR_files.zip and put those file in the src folder to run APR simulation.  
 

To run your own RISC-V program, change line 57 in the testbench to the file you want.  
The first line of the file must be 11111110 and the last line must be 11111111 in order to indicate the CPU to start and end respectively.  
Your instructions has to be breakdown into 8-bits.  
>For example:  
>11111110_00000000_00000000_00000010_00010011 //addi $a0, $r0, 0  
>will be convert into:  
>00000000  
00000000  
00000010  
00010011  
in the instruction file
## Block Diagram
![Block Diagram](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/block_diagram.png)

## Supported Instructions

* Basic Instructions
	* and 
	* or
	* add 
	* sub 
	* mul 
	* addi 
	* lw
	* sw
	* beq 
* Vector Arithmetic
	* VSUM (vector sum)
	* VSUB (vecotr subtraction)
	* VSM  (vector scalar multiplication)
	* VDP  (vector dot product)
![Instruction Desgin](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/InstructionType.png)
  
 ## Hazard Detection Supported
 ![Hazard Detection](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/hazard.png)
 Our work supports data forwarding to prevent data hazard. Forwarding works in most case but branch jump, to deal with it our design supportd hazard detection as well.
  
  ## I/O Port
  ![I/O figure](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/IO.png)
  
* Input Ports
	* Instr_i : Reads in instructions 8-bit at a time. It will take 4 cycles to read in one instruction.
	* D/R : If = 0, output value saved in DataMemory, else output value saved in register.
 	* addr: Address that you want to access, this input is 5-bit since size of both DataMemory and Register are 32.
 	* value_o_addr : The value saved in the memories are 32-bit, but our CPU can only ouput 8-bit at a time. Thus, we need to decide which 8-bit are to be read. For example, if value_o_addr = 0, the CPU will output the most signficant 8-bit in the address we assigned.
* Output Ports
	* value_o : Output value.
  	* is_positive : This is for handling overflow cases when doing vector sum.  When two 7-bit value are added together, it produces a 8-bit value and the value will be interpret as a negative value. When is_positive = 1, the 8-bit output should be interpret as a 8-bit positive value instead of a negative value.
## Schematic
![CPU](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/CPU.png)
![Pipelined]( https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/IFID.png)
![Forward](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/EX.png)
![Vector](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/VALU.png)

## Layout
![Chip](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/ic_photo.png)
![APR result](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/APR.png)
![Virtuoso](https://github.com/jasonlin316/RISC-V-CPU/blob/master/pic/layout.png)

## Design Specification

|  Spec    |   Value  |
|-----------|---|
| Frequency | 100MHz  |
| Chip size |  1456.84*1462.96 µm^2  |
|  Power    |  67.9428 mW |
|  Techonlogy | UMC 180nm |
| PADs | 38 |

## Background
This is originally a course project of Integrated Circuits Design Laboratory at National Taiwan University,  
lectured by Prof. [Tzi-Dar Chiueh](http://www.ee.ntu.edu.tw/profile?id=33)  
This work has been taped-out at TSRI (Taiwan Semiconductor Research Institute.) and received on Oct.30 2019.

## Reference 
David A. Patterson and John L. Hennessy. 2017. Computer Organization and Design RISC-V Edition: The Hardware Software Interface (1st ed.). Morgan Kaufmann Publishers Inc., San Francisco, CA, USA.
