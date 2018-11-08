


source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project_create quark_zed
adi_project_files quark_zed [list \
  "system_top.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "quark_bd.xdc" \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v"]

adi_project_run quark_zed


