proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/Turnout.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/LEDSerializer.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/LedMapper.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/RealClock.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/RouteFSM.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/Track.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/TurnoutHW.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/UartController.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/UartRx.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/rtl/Station_B/UartTx.sv"]"\
 "[file normalize "$origin_dir/../../../Stacja_Panel/Stacja_Panel.srcs/sources_1/imports/LogicRail-FPGA-based-Rail-Control-Simulator/fpga/Station_B/rtl/TopPanel.sv"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find local file $ifile "
      set status false
    }
  }

  set files [list \
 "[file normalize "$origin_dir/../../../rtl/Station_B/ClickDetector.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/Turnout.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/LEDSerializer.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/LedMapper.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/RealClock.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/RouteFSM.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/Track.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/TrainSpawnerFromUART.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/TurnoutHW.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/UartController.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/UartRx.sv"]"\
 "[file normalize "$origin_dir/../../../rtl/Station_B/UartTx.sv"]"\
 "[file normalize "$origin_dir/../rtl/TopPanel.sv"]"\
 "[file normalize "$origin_dir/../constrains/basys3.xdc"]"\
 "[file normalize "$origin_dir/../../../sim/TopPanelTB.sv"]"\
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

set _xil_proj_name_ "Stacja_Panel"
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "build.tcl"

set orig_proj_dir "[file normalize "$origin_dir/../../../Stacja_Panel"]"

set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a35tcpg236-1 -force
set proj_dir [get_property directory [current_project]]

set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "part" -value "xc7a35tcpg236-1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj

if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/../../../rtl/Station_B/ClickDetector.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/Turnout.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/LEDSerializer.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/LedMapper.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/RealClock.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/RouteFSM.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/Track.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/TrainSpawnerFromUART.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/TurnoutHW.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/UartController.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/UartRx.sv"] \
 [file normalize "${origin_dir}/../../../rtl/Station_B/UartTx.sv"] \
 [file normalize "${origin_dir}/../rtl/TopPanel.sv"] \
]
add_files -norecurse -fileset $obj $files

foreach file_path $files {
    set file_obj [get_files -of_objects [get_filesets sources_1] [list "*[file tail $file_path]"]]
    set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
}

set obj [get_filesets sources_1]
set_property -name "top" -value "TopPanel" -objects $obj

if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

set obj [get_filesets constrs_1]
set file "[file normalize "$origin_dir/../constrains/basys3.xdc"]"
add_files -norecurse -fileset $obj [list $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*basys3.xdc"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "target_part" -value "xc7a35tcpg236-1" -objects $obj

if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

set obj [get_filesets sim_1]
set files [list \
 [file normalize "${origin_dir}/../../../sim/TopPanelTB.sv"] \
]
add_files -norecurse -fileset $obj $files

set file_obj [get_files -of_objects [get_filesets sim_1] [list "*TopPanelTB.sv"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set obj [get_filesets sim_1]
set_property -name "sim_wrapper_top" -value "1" -objects $obj
set_property -name "top" -value "TopPanelTB" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

puts "INFO: Project created successfully."