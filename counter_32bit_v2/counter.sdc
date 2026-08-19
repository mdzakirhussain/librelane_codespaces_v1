# =============================================================================
#  counter.sdc - timing constraints for the 32-bit up/down counter (v2)
#  Single direction control port: up_down
#  Clock: clk, 10.000 ns period (100 MHz), positive edge triggered
# =============================================================================

set CLK_PERIOD   10.000
set CLK_PORT     [get_ports {clk}]

# -----------------------------------------------------------------------------
#  REG TO REG
#  The clock definition IS the register-to-register constraint: every flop-to-
#  flop path in the counter must close within one period, minus uncertainty.
# -----------------------------------------------------------------------------
create_clock -name clk -period $CLK_PERIOD $CLK_PORT

# Jitter + skew margin applied to every reg-to-reg path (setup and hold).
set_clock_uncertainty -setup 0.250 [get_clocks {clk}]
set_clock_uncertainty -hold  0.100 [get_clocks {clk}]

# Slew seen at the clock pins of the flops before CTS builds a real tree.
set_clock_transition 0.150 [get_clocks {clk}]

# -----------------------------------------------------------------------------
#  INPUT TO REG
#  External launch delay on every input that feeds a flop: rst, the three
#  control signals, and the 32-bit parallel load bus.
# -----------------------------------------------------------------------------
set_input_delay -clock [get_clocks {clk}] -max 2.000 [get_ports {rst up_down load en}]
set_input_delay -clock [get_clocks {clk}] -min 0.500 [get_ports {rst up_down load en}]

set_input_delay -clock [get_clocks {clk}] -max 2.000 [get_ports {data_in[*]}]
set_input_delay -clock [get_clocks {clk}] -min 0.500 [get_ports {data_in[*]}]

# Drive strength of the upstream driver, expressed as an input slew.
set_input_transition 0.150 [get_ports {rst up_down load en}]
set_input_transition 0.150 [get_ports {data_in[*]}]

# -----------------------------------------------------------------------------
#  REG TO OUTPUT
#  Capture requirement at the downstream device for the counter outputs.
# -----------------------------------------------------------------------------
set_output_delay -clock [get_clocks {clk}] -max 2.000 [get_ports {count[*]}]
set_output_delay -clock [get_clocks {clk}] -min 0.500 [get_ports {count[*]}]

# External capacitive load hung on each output pin.
set_load 0.033 [get_ports {count[*]}]

# -----------------------------------------------------------------------------
#  DESIGN RULE CONSTRAINTS (apply to all of the above path groups)
# -----------------------------------------------------------------------------
set_max_fanout    10 [current_design]
set_max_transition 1.500 [current_design]
