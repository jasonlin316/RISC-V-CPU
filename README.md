RISC-V CPU
==================
This is a 32-bit RISC-V CPU that supports basic instructions and some vector arithmetic.  
Gate level synthesised and APR are done as well.

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
  
  ![Instruction Desgin]()
  
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
