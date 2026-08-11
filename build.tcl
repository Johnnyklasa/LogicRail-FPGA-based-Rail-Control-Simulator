#*****************************************************************************************
# Vivado (TM) v2025.2 (64-bit)
#
# build.tcl: Tcl script for re-creating project 'LogicRail'
#*****************************************************************************************

proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/code/rtl/MouseControl/MouseCtl.vhd"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawMouse.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/MouseDisplay.vhd"]"\
 "[file normalize "$origin_dir/code/rtl/DataPackages/vga_pkg.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawSemafor.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/VgaTiming.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/vga_if.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/TopVga.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawPlatforms.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawInternalTracks.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawEntryTracks.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawTurnouts.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/MapRenderer.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/ClickDetector.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/LED_Serializer.sv"]"\
 "[file normalize "$origin_dir/code/rtl/DataPackages/SRK_pkg.sv"]"\
 "[file normalize "$origin_dir/code/rtl/DataPackages/Map_pkg.sv"]"\
 "[file normalize "$origin_dir/code/rtl/SRK_Modules/Semafor.sv"]"\
 "[file normalize "$origin_dir/code/rtl/SRK_Modules/LedMapper.sv"]"\
 "[file normalize "$origin_dir/code/fpga/rtl/LedTestTop.sv"]"\
 "[file normalize "$origin_dir/code/fpga/rtl/LedTestSwitches.sv"]"\
 "[file normalize "$origin_dir/code/fpga/constrains/basys3.xdc"]"\
 "[file normalize "$origin_dir/code/sim/ClickDetectorTB.sv"]"\
 "[file normalize "$origin_dir/code/sim/SemaforTB.sv"]"\
 "[file normalize "$origin_dir/code/sim/TopVgaMapTB.sv"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find remote file $ifile "
      set status false
    }
  }
  return $status
}

set origin_dir "."
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}
set _xil_proj_name_ "LogicRail"
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}
variable script_file
set script_file "build.tcl"

set orig_proj_dir "[file normalize "$origin_dir/LogicRail"]"
set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a35tcpg236-1
set proj_dir [get_property directory [current_project]]

set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "part" -value "xc7a35tcpg236-1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj

if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/code/rtl/MouseControl/MouseCtl.vhd"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawMouse.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/MouseDisplay.vhd"] \
 [file normalize "${origin_dir}/code/rtl/DataPackages/vga_pkg.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawSemafor.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/VgaTiming.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/vga_if.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/TopVga.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawPlatforms.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawInternalTracks.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawEntryTracks.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawTurnouts.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/MapRenderer.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/ClickDetector.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/LED_Serializer.sv"] \
 [file normalize "${origin_dir}/code/rtl/DataPackages/SRK_pkg.sv"] \
 [file normalize "${origin_dir}/code/rtl/DataPackages/Map_pkg.sv"] \
 [file normalize "${origin_dir}/code/rtl/SRK_Modules/Semafor.sv"] \
 [file normalize "${origin_dir}/code/rtl/SRK_Modules/LedMapper.sv"] \
 [file normalize "${origin_dir}/code/fpga/rtl/LedTestTop.sv"] \
 [file normalize "${origin_dir}/code/fpga/rtl/LedTestSwitches.sv"] \
]
add_files -norecurse -fileset $obj $files

foreach file_path $files {
    set file_obj [get_files -of_objects [get_filesets sources_1] [list "*[file tail $file_path]"]]
    if {[string match "*.vhd" $file_path]} {
        set_property -name "file_type" -value "VHDL" -objects $file_obj
    } elseif {[string match "*.sv" $file_path]} {
        set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
    }
}

set obj [get_filesets sources_1]
set_property -name "top" -value "LedTestSwitches" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
set obj [get_filesets constrs_1]
set file "[file normalize "$origin_dir/code/fpga/constrains/basys3.xdc"]"
add_files -norecurse -fileset $obj [list $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*basys3.xdc"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "target_part" -value "xc7a35tcpg236-1" -objects $obj

if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
set obj [get_filesets sim_1]
set files [list \
 [file normalize "${origin_dir}/code/sim/ClickDetectorTB.sv"] \
 [file normalize "${origin_dir}/code/sim/SemaforTB.sv"] \
 [file normalize "${origin_dir}/code/sim/TopVgaMapTB.sv"] \
]
add_files -norecurse -fileset $obj $files

foreach file_path $files {
    set file_obj [get_files -of_objects [get_filesets sim_1] [list "*[file tail $file_path]"]]
    set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
}

set obj [get_filesets sim_1]
set_property -name "sim_wrapper_top" -value "1" -objects $obj
set_property -name "top" -value "TopVgaMapTB" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

puts "INFO: Project recreated successfully."