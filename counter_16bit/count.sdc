# =============================================================================
#  count.sdc - simple timing constraints for the 16-bit up/down counter
#  Clock: clk, 10.000 ns period (100 MHz), positive edge triggered
# =============================================================================

# ---- clock: also the register-to-register constraint ------------------------
create_clock -name clk -period 10.000 [get_ports {clk}]
set_clock_uncertainty 0.250 [get_clocks {clk}]
set_clock_transition  0.150 [get_clocks {clk}]

# ---- input to reg -----------------------------------------------------------
set_input_delay -clock [get_clocks {clk}] -max 2.000 [get_ports {rst up_down parallel_load}]
set_input_delay -clock [get_clocks {clk}] -max 2.000 [get_ports {load[*]}]
set_input_transition 0.150 [get_ports {rst up_down parallel_load}]
set_input_transition 0.150 [get_ports {load[*]}]

# ---- reg to output ----------------------------------------------------------
set_output_delay -clock [get_clocks {clk}] -max 2.000 [get_ports {count[*]}]
set_load 0.033 [get_ports {count[*]}]

# ---- design rules -----------------------------------------------------------
set_max_fanout     10 [current_design]
set_max_transition 1.500 [current_design]
