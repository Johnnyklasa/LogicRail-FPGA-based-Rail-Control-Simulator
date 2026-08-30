#*****************************************************************************************
# Vivado (TM) v2025.2 (64-bit)
#
# build.tcl: Tcl script for re-creating project 'LogicRail'
#*****************************************************************************************

# Set the reference directory for source file relative paths to the ROOT of the repository
# Since this script is in fpga/Station_A/scripts, we go up 3 levels
set origin_dir [file normalize "[file dirname [info script]]/../../../"]

# Check file required for this script exists
proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/rtl/Station_A/vga/vga_if.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/Others/UartController.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawPlatforms.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/SRK_Modules/Semafor.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawTurnouts.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/MapRenderer.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/RomMemory/font_rom.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/TrainSpawnerFromUART.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawInternalTracks.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/TrainGenerator.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawSemafor.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawEntryTracks.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/Others/ClickDetector.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/Others/UartRx.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/TimetableRAM.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/TrainExporter.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/BootFSM.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/TimetableRom.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawClock.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawMouse.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/SRK_Modules/Track.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/RandomNumber.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/TopVga.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/SRK_Modules/Turnout.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/VgaTiming.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/Others/UartTx.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/TrainSimulation/RouteFSM.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/Others/RealClock.sv"]"\
 "[file normalize "$origin_dir/fpga/Station_A/rtl/top_fpga.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/DrawTimetable.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/DataPackages/vga_pkg.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/DataPackages/Map_pkg.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/MouseControl/MouseCtl.vhd"]"\
 "[file normalize "$origin_dir/rtl/Station_A/DataPackages/SRK_pkg.sv"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/MouseDisplay.vhd"]"\
 "[file normalize "$origin_dir/rtl/Station_A/vga/Ps2Interface.vhd"]"\
 "[file normalize "$origin_dir/rtl/Station_A/DataPackages/Timetable_pkg.sv"]"\
 "[file normalize "$origin_dir/fpga/Station_A/constrains/basys3.xdc"]"\
 "[file normalize "$origin_dir/code/sim/ClickDetectorTB.sv"]"\
 "[file normalize "$origin_dir/code/sim/SemaforTB.sv"]"\
 "[file normalize "$origin_dir/code/sim/TopVgaTB.sv"]"\
 "[file normalize "$origin_dir/code/sim/TrainGenTB.sv"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find remote file $ifile "
      set status false
    }
  }

  return $status
}

# Set the project name
set _xil_proj_name_ "LogicRail"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "build.tcl"

# Check for paths and files needed for project creation
set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a35tcpg236-1

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xc7a35tcpg236-1" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "sim_compile_state" -value "1" -objects $obj
set_property -name "source_mgmt_mode" -value "DisplayOnly" -objects $obj
set_property -name "use_inline_hdl_ip" -value "1" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/rtl/Station_A/vga/vga_if.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/Others/UartController.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawPlatforms.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/SRK_Modules/Semafor.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawTurnouts.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/MapRenderer.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/RomMemory/font_rom.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/TrainSpawnerFromUART.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawInternalTracks.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/TrainGenerator.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawSemafor.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawEntryTracks.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/Others/ClickDetector.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/Others/UartRx.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/TimetableRAM.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/TrainExporter.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/BootFSM.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/TimetableRom.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawClock.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawMouse.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/SRK_Modules/Track.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/RandomNumber.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/TopVga.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/SRK_Modules/Turnout.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/VgaTiming.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/Others/UartTx.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/TrainSimulation/RouteFSM.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/Others/RealClock.sv"] \
 [file normalize "${origin_dir}/fpga/Station_A/rtl/top_fpga.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/DrawTimetable.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/DataPackages/vga_pkg.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/DataPackages/Map_pkg.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/MouseControl/MouseCtl.vhd"] \
 [file normalize "${origin_dir}/rtl/Station_A/DataPackages/SRK_pkg.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/MouseDisplay.vhd"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/Ps2Interface.vhd"] \
 [file normalize "${origin_dir}/rtl/Station_A/DataPackages/Timetable_pkg.sv"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/rtl/Station_A/vga/vga_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/Others/UartController.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawPlatforms.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/SRK_Modules/Semafor.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawTurnouts.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/MapRenderer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/RomMemory/font_rom.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/TrainSpawnerFromUART.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawInternalTracks.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/TrainGenerator.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawSemafor.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawEntryTracks.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/Others/ClickDetector.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/Others/UartRx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/TimetableRAM.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/TrainExporter.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/BootFSM.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/TimetableRom.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawClock.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawMouse.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/SRK_Modules/Track.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/RandomNumber.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/TopVga.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/SRK_Modules/Turnout.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/VgaTiming.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/Others/UartTx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/TrainSimulation/RouteFSM.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/Others/RealClock.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/fpga/Station_A/rtl/top_fpga.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/DrawTimetable.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/DataPackages/vga_pkg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/DataPackages/Map_pkg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/MouseControl/MouseCtl.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/rtl/Station_A/DataPackages/SRK_pkg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/MouseDisplay.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/rtl/Station_A/vga/Ps2Interface.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/rtl/Station_A/DataPackages/Timetable_pkg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "dataflow_viewer_settings" -value "min_width=16" -objects $obj
set_property -name "top" -value "top_vga_basys3" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/fpga/Station_A/constrains/basys3.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/fpga/Station_A/constrains/basys3.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_part" -value "xc7a35tcpg236-1" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 [file normalize "${origin_dir}/code/sim/ClickDetectorTB.sv"] \
 [file normalize "${origin_dir}/code/sim/SemaforTB.sv"] \
 [file normalize "${origin_dir}/code/sim/TopVgaTB.sv"] \
 [file normalize "${origin_dir}/code/sim/TrainGenTB.sv"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_1' fileset file properties for remote files
set file "$origin_dir/code/sim/ClickDetectorTB.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/code/sim/SemaforTB.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/code/sim/TopVgaTB.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/code/sim/TrainGenTB.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "sim_wrapper_top" -value "1" -objects $obj
set_property -name "top" -value "top_vga_basys3" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7a35tcpg236-1 -flow {Vivado Synthesis 2025} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2025" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
set_property -name "part" -value "xc7a35tcpg236-1" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7a35tcpg236-1 -flow {Vivado Implementation 2025} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2025" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
set_property -name "part" -value "xc7a35tcpg236-1" -objects $obj
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]
puts "INFO: Project created:${_xil_proj_name_}"
