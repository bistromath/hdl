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
set_property -dict {PACKAGE_PIN V9  IOSTANDARD LVCMOS33} [get_ports video_rx]
set_property -dict {PACKAGE_PIN V8  IOSTANDARD LVCMOS33} [get_ports video_tx]

create_clock -period 40.000 -name video_clk [get_ports video_clk]


