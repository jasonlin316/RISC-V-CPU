###################################################################

# Created by write_sdc on Fri May 17 16:54:20 2019

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max WCCOM -max_library                               \
fsa0m_a_generic_core_ss1p62v125c\
                         -min BCCOM -min_library                               \
fsa0m_a_generic_core_ff1p98vm40c
set_wire_load_model -name G200K -library fsa0m_a_generic_core_tt1p8v25c
set_max_fanout 6 [current_design]
set_max_area 0
set_load -pin_load 1 [get_ports {value_o[7]}]
set_load -pin_load 1 [get_ports {value_o[6]}]
set_load -pin_load 1 [get_ports {value_o[5]}]
set_load -pin_load 1 [get_ports {value_o[4]}]
set_load -pin_load 1 [get_ports {value_o[3]}]
set_load -pin_load 1 [get_ports {value_o[2]}]
set_load -pin_load 1 [get_ports {value_o[1]}]
set_load -pin_load 1 [get_ports {value_o[0]}]
set_load -pin_load 1 [get_ports is_positive]
set_load -pin_load 1 [get_ports {easter_egg[2]}]
set_load -pin_load 1 [get_ports {easter_egg[1]}]
set_load -pin_load 1 [get_ports {easter_egg[0]}]
create_clock [get_ports clk_i]  -period 10  -waveform {0 5}
set_clock_latency 0.5  [get_clocks clk_i]
set_clock_uncertainty 0.1  [get_clocks clk_i]
set_input_delay -clock clk_i  -max 1  [get_ports clk_i]
set_input_delay -clock clk_i  -max 1  [get_ports DataOrReg]
set_input_delay -clock clk_i  -max 1  [get_ports {address[4]}]
set_input_delay -clock clk_i  -max 1  [get_ports {address[3]}]
set_input_delay -clock clk_i  -max 1  [get_ports {address[2]}]
set_input_delay -clock clk_i  -max 1  [get_ports {address[1]}]
set_input_delay -clock clk_i  -max 1  [get_ports {address[0]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[7]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[6]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[5]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[4]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[3]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[2]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[1]}]
set_input_delay -clock clk_i  -max 1  [get_ports {instr_i[0]}]
set_input_delay -clock clk_i  -max 1  [get_ports reset]
set_input_delay -clock clk_i  -max 1  [get_ports {vout_addr[1]}]
set_input_delay -clock clk_i  -max 1  [get_ports {vout_addr[0]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[7]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[6]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[5]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[4]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[3]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[2]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[1]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {value_o[0]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports is_positive]
set_output_delay -clock clk_i  -min 0.5  [get_ports {easter_egg[2]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {easter_egg[1]}]
set_output_delay -clock clk_i  -min 0.5  [get_ports {easter_egg[0]}]
set_drive 1  [get_ports clk_i]
set_drive 1  [get_ports DataOrReg]
set_drive 1  [get_ports {address[4]}]
set_drive 1  [get_ports {address[3]}]
set_drive 1  [get_ports {address[2]}]
set_drive 1  [get_ports {address[1]}]
set_drive 1  [get_ports {address[0]}]
set_drive 1  [get_ports {instr_i[7]}]
set_drive 1  [get_ports {instr_i[6]}]
set_drive 1  [get_ports {instr_i[5]}]
set_drive 1  [get_ports {instr_i[4]}]
set_drive 1  [get_ports {instr_i[3]}]
set_drive 1  [get_ports {instr_i[2]}]
set_drive 1  [get_ports {instr_i[1]}]
set_drive 1  [get_ports {instr_i[0]}]
set_drive 1  [get_ports reset]
set_drive 1  [get_ports {vout_addr[1]}]
set_drive 1  [get_ports {vout_addr[0]}]
