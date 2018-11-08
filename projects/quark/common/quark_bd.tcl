
# video

create_bd_port -dir O hdmi_out_clk
create_bd_port -dir O hdmi_16_hsync
create_bd_port -dir O hdmi_16_vsync
create_bd_port -dir O hdmi_16_data_e
create_bd_port -dir O -from 15 -to 0 hdmi_16_data
create_bd_port -dir O hdmi_24_hsync
create_bd_port -dir O hdmi_24_vsync
create_bd_port -dir O hdmi_24_data_e
create_bd_port -dir O -from 23 -to 0 hdmi_24_data
create_bd_port -dir O hdmi_36_hsync
create_bd_port -dir O hdmi_36_vsync
create_bd_port -dir O hdmi_36_data_e
create_bd_port -dir O -from 35 -to 0 hdmi_36_data

# spdif audio

#create_bd_port -dir O spdif

# hdmi peripherals

set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]
set axi_hdmi_core [create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_core]

set axi_hdmi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_hdmi_dma]
set_property -dict [list CONFIG.c_m_axis_mm2s_tdata_width {64}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_use_mm2s_fsync {1}] $axi_hdmi_dma
set_property -dict [list CONFIG.c_include_s2mm {1}] $axi_hdmi_dma

# hdmi

ad_connect  sys_200m_clk axi_hdmi_clkgen/clk
ad_connect  sys_cpu_clk axi_hdmi_core/vdma_clk
ad_connect  sys_cpu_clk axi_hdmi_dma/m_axis_mm2s_aclk
ad_connect  axi_hdmi_core/hdmi_clk axi_hdmi_clkgen/clk_0
ad_connect  axi_hdmi_core/hdmi_out_clk hdmi_out_clk
ad_connect  axi_hdmi_core/hdmi_16_hsync hdmi_16_hsync
ad_connect  axi_hdmi_core/hdmi_16_vsync hdmi_16_vsync
ad_connect  axi_hdmi_core/hdmi_16_data_e hdmi_16_data_e
ad_connect  axi_hdmi_core/hdmi_16_data hdmi_16_data
ad_connect  axi_hdmi_core/hdmi_24_hsync hdmi_24_hsync
ad_connect  axi_hdmi_core/hdmi_24_vsync hdmi_24_vsync
ad_connect  axi_hdmi_core/hdmi_24_data_e hdmi_24_data_e
ad_connect  axi_hdmi_core/hdmi_24_data hdmi_24_data
ad_connect  axi_hdmi_core/hdmi_36_hsync hdmi_36_hsync
ad_connect  axi_hdmi_core/hdmi_36_vsync hdmi_36_vsync
ad_connect  axi_hdmi_core/hdmi_36_data_e hdmi_36_data_e
ad_connect  axi_hdmi_core/hdmi_36_data hdmi_36_data
ad_connect  axi_hdmi_core/vdma_valid axi_hdmi_dma/m_axis_mm2s_tvalid
ad_connect  axi_hdmi_core/vdma_data axi_hdmi_dma/m_axis_mm2s_tdata
ad_connect  axi_hdmi_core/vdma_ready axi_hdmi_dma/m_axis_mm2s_tready
ad_connect  axi_hdmi_core/vdma_fs axi_hdmi_dma/mm2s_fsync
ad_connect  axi_hdmi_core/vdma_fs axi_hdmi_core/vdma_fs_ret

#video capture
#set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7

create_bd_port -dir I -from 7 -to 0 video_data
create_bd_port -dir I video_clk
create_bd_port -dir I video_frame_valid
create_bd_port -dir I video_line_valid

#TODO replace video timing and AXI4S blocks with your capture block.

set video_timing [create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 video_timing]
set_property -dict [list CONFIG.C_HAS_AXI4_LITE {1}] $video_timing
set_property -dict [list CONFIG.C_HAS_INTC_IF {0}] $video_timing
set_property -dict [list CONFIG.C_INTERLACE_EN {0}] $video_timing
set_property -dict [list CONFIG.C_NUM_FSYNCS {1}] $video_timing
set_property -dict [list CONFIG.C_MAX_LINES {1024}] $video_timing
set_property -dict [list CONFIG.C_MAX_PIXELS {1024}] $video_timing
set_property -dict [list CONFIG.C_SYNC_EN {0}] $video_timing
set_property -dict [list CONFIG.C_DETECT_EN {1}] $video_timing
set_property -dict [list CONFIG.C_GENERATE_EN {1}] $video_timing
set_property -dict [list CONFIG.C_DET_HSYNC_EN {0}] $video_timing
set_property -dict [list CONFIG.C_DET_HBLANK_EN {1}] $video_timing
set_property -dict [list CONFIG.C_DET_VSYNC_EN {0}] $video_timing
set_property -dict [list CONFIG.C_DET_VBLANK_EN {1}] $video_timing
set_property -dict [list CONFIG.C_DET_AVIDEO_EN {1}] $video_timing
set_property -dict [list CONFIG.C_DET_ACHROMA_EN {0}] $video_timing
set_property -dict [list CONFIG.C_GEN_HSYNC_EN {0}] $video_timing
set_property -dict [list CONFIG.C_GEN_HBLANK_EN {0}] $video_timing
set_property -dict [list CONFIG.C_GEN_VSYNC_EN {0}] $video_timing
set_property -dict [list CONFIG.C_GEN_VBLANK_EN {0}] $video_timing
set_property -dict [list CONFIG.C_GEN_AVIDEO_EN {1}] $video_timing
set_property -dict [list CONFIG.C_GEN_ACHROMA_EN {0}] $video_timing
set_property -dict [list CONFIG.C_GEN_FIELDID_EN {0}] $video_timing
set_property -dict [list CONFIG.C_DET_FIELDID_EN {0}] $video_timing

set video_in [create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 video_in]
set_property -dict [list CONFIG.C_PIXELS_PER_CLOCK {1}] $video_in
set_property -dict [list CONFIG.C_COMPONENTS_PER_PIXEL {1}] $video_in
set_property -dict [list CONFIG.C_M_AXIS_COMPONENT_WIDTH {8}] $video_in
set_property -dict [list CONFIG.C_NATIVE_COMPONENT_WIDTH {8}] $video_in
set_property -dict [list CONFIG.C_NATIVE_DATA_WIDTH {8}] $video_in
set_property -dict [list CONFIG.C_M_AXIS_TDATA_WIDTH {8}] $video_in
set_property -dict [list CONFIG.C_HAS_ASYNC_CLK {1}] $video_in
set_property -dict [list CONFIG.C_ADDR_WIDTH {10}] $video_in

ad_connect sys_cpu_clk video_timing/s_axi_aclk
ad_connect sys_cpu_resetn video_timing/s_axi_aresetn
ad_connect video_in/vtiming_out video_timing/vtiming_in
ad_connect video_timing/active_video_out video_in/axis_enable
#TODO figure out how to set something hi/low

ad_connect video_data video_in/vid_data
ad_connect video_clk video_in/vid_io_in_clk
ad_connect video_clk video_timing/clk
ad_connect video_line_valid video_in/vid_hblank
ad_connect video_frame_valid video_in/vid_vblank

ad_connect video_in/video_out axi_hdmi_dma/S_AXIS_S2MM
ad_connect sys_cpu_clk axi_hdmi_dma/m_axis_s2mm_aclk
# processor interconnects

ad_cpu_interconnect 0x79000000 axi_hdmi_clkgen
ad_cpu_interconnect 0x70e00000 axi_hdmi_core
ad_cpu_interconnect 0x43000000 axi_hdmi_dma
ad_cpu_interconnect 0x43C00000 video_timing

# memory interconnects
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_MM2S
#ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_S2MM

# interrupts

ad_cpu_interrupt ps-0 mb-8  axi_hdmi_dma/mm2s_introut
ad_cpu_interrupt ps-0 mb-7 video_in/s2mm_introut

