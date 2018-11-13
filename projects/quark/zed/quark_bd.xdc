#pin mapping for zedboard:
#pin (PMOD connector pin): tau/quark devboard pin
#video_data[0]    : pin Y11  (JA1), 38
#video_data[1]    : pin AA11 (JA2), 37
#video_data[2]    : pin Y10  (JA3), 40
#video_data[3]    : pin AA8  (JA10), 39
#video_data[4]    : pin AB11 (JA7), 42
#video_data[5]    : pin AB10 (JA8), 41
#video_data[6]    : pin AB9 (JA9), 44
#video_data[7]    : pin W12 (JB1), 43
#video_clk        : pin AA9 (JA4), 55
#video_frame_valid: pin W11 (JB2), 54
#video_line_valid : pin V10 (JB3), 53
#video_rx         : pin V9  (JB9), 16 (TX)
#video_tx         : pin V8  (JB10), 15 (RX)

set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33} [get_ports {video_data[0]}]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports {video_data[1]}]
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports {video_data[2]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports {video_data[3]}]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports {video_data[4]}]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports {video_data[5]}]
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS33} [get_ports {video_data[6]}]
set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS33} [get_ports {video_data[7]}]
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports video_clk]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports video_frame_valid]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports video_line_valid]
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports video_rx]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports video_tx]

create_clock -period 40.000 -name video_clk [get_ports video_clk]
set_input_delay -clock video_clk 10 [get_ports {video_data*}]
set_input_delay -clock video_clk 10 [get_ports {video_frame_valid}]
set_input_delay -clock video_clk 10 [get_ports {video_line_valid}]


