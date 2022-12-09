set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

set_property PACKAGE_PIN N5 [get_ports rx]
set_property PACKAGE_PIN P17 [get_ports sys_clk]
set_property PACKAGE_PIN R15 [get_ports rst]
set_property PACKAGE_PIN T4 [get_ports tx]

set_property PACKAGE_PIN H4 [get_ports front_detector]
set_property PACKAGE_PIN J3 [get_ports back_detector]
set_property PACKAGE_PIN J2 [get_ports left_detector]
set_property PACKAGE_PIN K2 [get_ports right_detector]
#??
set_property PACKAGE_PIN P4 [get_ports move_backward_signal]
set_property PACKAGE_PIN T5 [get_ports move_forward_signal]
#
set_property PACKAGE_PIN V1 [get_ports turn_left_signal]
set_property PACKAGE_PIN R11 [get_ports turn_right_signal]

set_property IOSTANDARD LVCMOS33 [get_ports turn_left_signal]
set_property IOSTANDARD LVCMOS33 [get_ports turn_right_signal]
set_property IOSTANDARD LVCMOS33 [get_ports back_detector]
set_property IOSTANDARD LVCMOS33 [get_ports front_detector]
set_property IOSTANDARD LVCMOS33 [get_ports left_detector]
set_property IOSTANDARD LVCMOS33 [get_ports move_backward_signal]
set_property IOSTANDARD LVCMOS33 [get_ports move_forward_signal]
set_property IOSTANDARD LVCMOS33 [get_ports right_detector]

set_property PACKAGE_PIN R3 [get_ports place_barrier_signal]
set_property IOSTANDARD LVCMOS33 [get_ports place_barrier_signal]

set_property PACKAGE_PIN P2 [get_ports destroy_barrier_signal]
set_property IOSTANDARD LVCMOS33 [get_ports destroy_barrier_signal]


#new
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports power_on_signal]
set_property IOSTANDARD LVCMOS33 [get_ports power_off_signal]
set_property IOSTANDARD LVCMOS33 [get_ports manual_driving_signal]
set_property IOSTANDARD LVCMOS33 [get_ports throttle_signal]
set_property IOSTANDARD LVCMOS33 [get_ports clutch_signal]

set_property IOSTANDARD LVCMOS33 [get_ports state_led]

set_property PACKAGE_PIN P5 [get_ports rst_n]
set_property PACKAGE_PIN U4 [get_ports power_on_signal]
set_property PACKAGE_PIN R17 [get_ports power_off_signal]
set_property PACKAGE_PIN U3 [get_ports manual_driving_signal]
set_property PACKAGE_PIN R2 [get_ports throttle_signal]
set_property PACKAGE_PIN R1 [get_ports clutch_signal]

set_property PACKAGE_PIN K1 [get_ports state_led[3]]
set_property PACKAGE_PIN H6 [get_ports state_led[2]]
set_property PACKAGE_PIN H5 [get_ports state_led[1]]
set_property PACKAGE_PIN J5 [get_ports state_led[0]]
