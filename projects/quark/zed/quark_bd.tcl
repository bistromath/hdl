set_property -dict [list CONFIG.c_include_s2mm {1}] $axi_hdmi_dma

#video capture
#set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1}] $sys_ps7

set vsync [create_bd_cell -type ip -vlnv analog.com:user:vsync:1.0 vsync]


#TODO! set TKEEP to 0b0001 on axi_hdmi_dma to excise the high bits
#make me a video FIFO
#phew that's a lotta shit
set video_fifo [create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.1 video_fifo]
set_property -dict [list CONFIG.Clock_Type_AXI {Independent_Clock}] $video_fifo
set_property -dict [list CONFIG.Enable_TLAST {true}] $video_fifo
set_property -dict [list CONFIG.Fifo_Implementation_axis {Independent_Clocks_Block_RAM}] $video_fifo
set_property -dict [list CONFIG.Fifo_Implementation_rach {Independent_Clocks_Distributed_RAM}] $video_fifo
set_property -dict [list CONFIG.Fifo_Implementation_rdch {Independent_Clocks_Block_RAM}] $video_fifo
set_property -dict [list CONFIG.Fifo_Implementation_wach {Independent_Clocks_Distributed_RAM}] $video_fifo
set_property -dict [list CONFIG.Fifo_Implementation_wdch {Independent_Clocks_Block_RAM}] $video_fifo
set_property -dict [list CONFIG.Fifo_Implementation_wrch {Independent_Clocks_Distributed_RAM}] $video_fifo
set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM}] $video_fifo
set_property -dict [list CONFIG.Overflow_Flag_AXI {true}] $video_fifo
set_property -dict [list CONFIG.TUSER_WIDTH {1}] $video_fifo

create_bd_port -dir I -from 7 -to 0 video_data
create_bd_port -dir I video_clk
create_bd_port -dir I video_frame_valid
create_bd_port -dir I video_line_valid

create_bd_port -dir I video_rx
create_bd_port -dir O video_tx

ad_connect video_clk vsync/vclk
ad_connect video_data vsync/data
ad_connect video_frame_valid vsync/framevalid
ad_connect video_line_valid vsync/linevalid
ad_connect sys_rstgen/peripheral_reset vsync/reset
ad_connect vsync/m_axis_data_tdata video_fifo/s_axis_tdata
ad_connect vsync/m_axis_data_tlast video_fifo/s_axis_tlast
ad_connect vsync/m_axis_data_tuser video_fifo/s_axis_tuser
ad_connect vsync/m_axis_data_tvalid video_fifo/s_axis_tvalid
ad_connect video_clk video_fifo/s_aclk
ad_connect sys_cpu_clk video_fifo/m_aclk
ad_connect sys_cpu_resetn video_fifo/s_aresetn
ad_connect video_fifo/m_axis_tdata axi_hdmi_dma/s_axis_s2mm_tdata
ad_connect video_fifo/m_axis_tlast axi_hdmi_dma/s_axis_s2mm_tlast
ad_connect video_fifo/m_axis_tuser axi_hdmi_dma/s_axis_s2mm_tuser
ad_connect video_fifo/m_axis_tready axi_hdmi_dma/s_axis_s2mm_tready
ad_connect video_fifo/m_axis_tvalid axi_hdmi_dma/s_axis_s2mm_tvalid

set_property -dict [list CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1}] $sys_ps7
set_property -dict [list CONFIG.PCW_UART0_UART0_IO {emio}] $sys_ps7

ad_connect sys_ps7/UART0_TX video_tx
ad_connect sys_ps7/UART0_RX video_rx

# processor interconnects

#ad_cpu_interconnect 0x43C00000 video_timing
ad_mem_hp0_interconnect sys_cpu_clk axi_hdmi_dma/M_AXI_S2MM
ad_connect sys_cpu_clk axi_hdmi_dma/s_axis_s2mm_aclk

# interrupts
ad_cpu_interrupt ps-13 mb-0 axi_hdmi_dma/s2mm_introut

