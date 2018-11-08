
# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create vsync
adi_ip_files vsync [list \
  "reset_synchronizer.v" \
  "vsync.v"]

adi_ip_properties_lite vsync
adi_ip_constraints vsync [list \
  "vsync_ooc.xdc" \
]

ipx::save_core [ipx::current_core]

