
set origin_dir [file normalize "[file dirname [info script]]/../../../"]
set _xil_proj_name_ "LogicRail"


create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a35tcpg236-1 -force

set proj_dir [get_property directory [current_project]]
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "part" -value "xc7a35tcpg236-1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj


if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
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
 [file normalize "${origin_dir}/rtl/Station_A/DataPackages/SRK_pkg.sv"] \
 [file normalize "${origin_dir}/rtl/Station_A/DataPackages/Timetable_pkg.sv"] \
]
add_files -norecurse -fileset $obj $files


set vhdl_files [list \
 [file normalize "${origin_dir}/rtl/Station_A/MouseControl/MouseCtl.vhd"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/MouseDisplay.vhd"] \
 [file normalize "${origin_dir}/rtl/Station_A/vga/Ps2Interface.vhd"] \
]
add_files -norecurse -fileset $obj $vhdl_files


set file "[file normalize "${origin_dir}/fpga/Station_A/rtl/clk_wiz_0.xci"]"
if { [file exists $file] } {
    add_files -norecurse -fileset $obj [list $file]
} else {
    puts "CRITICAL WARNING: Nie znaleziono pliku PLL clk_wiz_0.xci"
}

set_property -name "top" -value "top_vga_basys3" -objects $obj

if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
set obj [get_filesets constrs_1]
set file "[file normalize "$origin_dir/fpga/Station_A/constrains/basys3.xdc"]"
add_files -norecurse -fileset $obj [list $file]


if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
set obj [get_filesets sim_1]
set files [list \
 [file normalize "${origin_dir}/code/sim/ClickDetectorTB.sv"] \
 [file normalize "${origin_dir}/code/sim/SemaforTB.sv"] \
 [file normalize "${origin_dir}/code/sim/TopVgaTB.sv"] \
 [file normalize "${origin_dir}/code/sim/TrainGenTB.sv"] \
]
add_files -norecurse -fileset $obj $files
set_property -name "top" -value "top_vga_basys3" -objects $obj

puts "INFO: Projekt Stacji A wygenerowany poprawnie!"