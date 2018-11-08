####################################################################################
####################################################################################
## Copyright 2011(c) Analog Devices, Inc.
## Auto-generated, do not modify!
####################################################################################
####################################################################################

M_DEPS += ../../scripts/adi_env.tcl
M_DEPS += ../../scripts/adi_ip.tcl
M_DEPS += reset_synchronizer.v
M_DEPS += vsync.v
M_DEPS += vsync_ooc.xdc

M_VIVADO := vivado -mode batch -source

M_FLIST := *.cache
M_FLIST += *.data
M_FLIST += *.xpr
M_FLIST += *.log
M_FLIST += component.xml
M_FLIST += *.jou
M_FLIST +=  xgui
M_FLIST += *.ip_user_files
M_FLIST += *.srcs
M_FLIST += *.hw
M_FLIST += *.sim
M_FLIST += .Xil



.PHONY: all clean clean-all
all: vsync.xpr


clean:clean-all


clean-all:
	rm -rf $(M_FLIST)


vsync.xpr: $(M_DEPS)
	-rm -rf $(M_FLIST)
	$(M_VIVADO) vsync_ip.tcl  >> vsync_ip.log 2>&1

####################################################################################
####################################################################################
