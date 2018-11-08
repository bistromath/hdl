set_property -dict [list CONFIG.c_s_axis_s2mm_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {1}] $axi_hdmi_dma

#video capture
#set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7

#TODO get rid of video timing block, reencapsulate your vsync as IP
create_bd_port -dir I -from 7 -to 0 video_data
create_bd_port -dir I video_clk
create_bd_port -dir I video_frame_valid
create_bd_port -dir I video_line_valid

create_bd_port -dir I video_rx
create_bd_port -dir O video_tx

set_property -dict [list CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART0_UART0_IO {emio}] $sys_ps7

ad_connect sys_ps7/UART0_TX video_tx
ad_connect sys_ps7/UART0_RX video_rx

set video_timing [create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 video_timing]
set_property -dict [list CONFIG.HAS_AXI4_LITE {1}] $video_timing
set_property -dict [list CONFIG.HAS_INTC_IF {0}] $video_timing
set_property -dict [list CONFIG.INTERLACE_EN {0}] $video_timing
set_property -dict [list CONFIG.max_clocks_per_line {1024}] $video_timing
set_property -dict [list CONFIG.max_lines_per_frame {1024}] $video_timing
set_property -dict [list CONFIG.frame_syncs {1}] $video_timing
set_property -dict [list CONFIG.enable_detection {1}] $video_timing
set_property -dict [list CONFIG.enable_generation {1}] $video_timing
set_property -dict [list CONFIG.horizontal_sync_detection {0}] $video_timing
set_property -dict [list CONFIG.horizontal_blank_detection {1}] $video_timing
set_property -dict [list CONFIG.vertical_sync_detection {0}] $video_timing
set_property -dict [list CONFIG.vertical_blank_detection {1}] $video_timing
set_property -dict [list CONFIG.active_video_detection {1}] $video_timing
set_property -dict [list CONFIG.active_chroma_detection {0}] $video_timing
set_property -dict [list CONFIG.active_video_generation {1}] $video_timing
set_property -dict [list CONFIG.active_chroma_generation {0}] $video_timing
set_property -dict [list CONFIG.horizontal_sync_generation {0}] $video_timing
set_property -dict [list CONFIG.horizontal_blank_generation {0}] $video_timing
set_property -dict [list CONFIG.vertical_sync_detection {0}] $video_timing
set_property -dict [list CONFIG.vertical_sync_generation {0}] $video_timing
set_property -dict [list CONFIG.GEN_FIELDID_EN {0}] $video_timing
set_property -dict [list CONFIG.DET_FIELDID_EN {0}] $video_timing

set video_in [create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 video_in]
set_property -dict [list CONFIG.C_PIXELS_PER_CLOCK {1}] $video_in
set_property -dict [list CONFIG.C_NATIVE_COMPONENT_WIDTH {8}] $video_in
set_property -dict [list CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8}] $video_in
set_property -dict [list CONFIG.C_M_AXIS_VIDEO_FORMAT {12}] $video_in
set_property -dict [list CONFIG.C_HAS_ASYNC_CLK {1}] $video_in
set_property -dict [list CONFIG.C_ADDR_WIDTH {10}] $video_in

ad_connect sys_cpu_clk video_timing/s_axi_aclk
ad_connect sys_cpu_resetn video_timing/s_axi_aresetn

ad_connect video_in/vtiming_out video_timing/vtiming_in
set consthi [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 consthi]
ad_connect consthi/dout video_in/axis_enable
ad_connect consthi/dout video_in/vid_io_in_ce
ad_connect consthi/dout video_in/aclken
ad_connect consthi/dout video_timing/s_axi_aclken
ad_connect consthi/dout video_timing/clken
ad_connect consthi/dout video_timing/det_clken
ad_connect consthi/dout video_timing/gen_clken
ad_connect consthi/dout video_timing/resetn

ad_connect sys_cpu_resetn video_in/aresetn
ad_connect sys_cpu_clk video_in/aclk

set frame_inv [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 frame_inv]
set_property -dict [list CONFIG.C_OPERATION {not}] $frame_inv
set_property -dict [list CONFIG.C_SIZE {1}] $frame_inv
set line_inv [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 line_inv]
set_property -dict [list CONFIG.C_OPERATION {not}] $line_inv
set_property -dict [list CONFIG.C_SIZE {1}] $line_inv
set active_and [create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 active_and]
set_property -dict [list CONFIG.C_OPERATION {and}] $active_and
set_property -dict [list CONFIG.C_SIZE {1}] $active_and

ad_connect video_data video_in/vid_data
ad_connect video_clk video_in/vid_io_in_clk
ad_connect video_clk video_timing/clk

ad_connect video_line_valid line_inv/Op1
ad_connect video_frame_valid frame_inv/Op1
ad_connect line_inv/Res video_in/vid_hblank
ad_connect frame_inv/Res video_in/vid_vblank

ad_connect video_line_valid active_and/Op1
ad_connect video_frame_valid active_and/Op2
ad_connect active_and/Res video_in/vid_active_video

ad_connect video_in/video_out axi_hdmi_dma/S_AXIS_S2MM
ad_connect sys_cpu_clk axi_hdmi_dma/s_axis_s2mm_aclk
# processor interconnects

ad_cpu_interconnect 0x43C00000 video_timing

ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_S2MM

# interrupts
ad_cpu_interrupt ps-13 mb-0 axi_hdmi_dma/s2mm_introut

