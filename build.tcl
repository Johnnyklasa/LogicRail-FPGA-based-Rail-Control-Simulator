proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/LogicRail.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find local file $ifile "
      set status false
    }
  }

  set files [list \
 "[file normalize "$origin_dir/code/rtl/SRK_Modules/Rozjazd.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/ClickDetector.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/RealClock.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/UartTx.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/UartRx.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/UartController.sv"]"\
 "[file normalize "$origin_dir/code/rtl/Others/LED_Serializer.sv"]"\
 "[file normalize "$origin_dir/code/rtl/DataPackages/vga_pkg.sv"]"\
 "[file normalize "$origin_dir/code/rtl/DataPackages/SRK_pkg.sv"]"\
 "[file normalize "$origin_dir/code/rtl/DataPackages/Map_pkg.sv"]"\
 "[file normalize "$origin_dir/code/rtl/DataPackages/Timetable_pkg.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawEntryTracks.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawInternalTracks.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawMouse.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawPlatforms.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawSemafor.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/DrawTurnouts.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/MapRenderer.sv"]"\
 "[file normalize "$origin_dir/code/rtl/SRK_Modules/Semafor.sv"]"\
 "[file normalize "$origin_dir/code/rtl/SRK_Modules/LedMapper.sv"]"\
 "[file normalize "$origin_dir/code/rtl/TrainSimulation/TrainSpawnerFromUART.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/TopVga.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/VgaTiming.sv"]"\
 "[file normalize "$origin_dir/code/rtl/vga/vga_if.sv"]"\
 "[file normalize "$origin_dir/code/rtl/MouseControl/MouseCtl.vhd"]"\
 "[file normalize "$origin_dir/code/rtl/vga/MouseDisplay.vhd"]"\
 "[file normalize "$origin_dir/code/rtl/vga/Ps2Interface.vhd"]"\
 "[file normalize "$origin_dir/code/fpga/rtl/top_fpga.sv"]"\
 "[file normalize "$origin_dir/code/fpga/constrains/basys3.xdc"]"\
 "[file normalize "$origin_dir/code/sim/top_fpga_TB.sv"]"\
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
if { [info exists ::origin_dir_loc] } { set origin_dir $::origin_dir_loc }
set _xil_proj_name_ "LogicRail"
if { [info exists ::user_project_name] } { set _xil_proj_name_ $::user_project_name }

create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a35tcpg236-1 -force
set proj_dir [get_property directory [current_project]]

set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "part" -value "xc7a35tcpg236-1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj

if {[string equal [get_filesets -quiet sources_1] ""]} { create_fileset -srcset sources_1 }
set obj [get_filesets sources_1]

set files [list \
 [file normalize "${origin_dir}/code/rtl/SRK_Modules/Rozjazd.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/ClickDetector.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/RealClock.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/UartTx.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/UartRx.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/UartController.sv"] \
 [file normalize "${origin_dir}/code/rtl/Others/LED_Serializer.sv"] \
 [file normalize "${origin_dir}/code/rtl/DataPackages/vga_pkg.sv"] \
 [file normalize "${origin_dir}/code/rtl/DataPackages/SRK_pkg.sv"] \
 [file normalize "${origin_dir}/code/rtl/DataPackages/Map_pkg.sv"] \
 [file normalize "${origin_dir}/code/rtl/DataPackages/Timetable_pkg.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawEntryTracks.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawInternalTracks.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawMouse.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawPlatforms.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawSemafor.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/DrawTurnouts.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/MapRenderer.sv"] \
 [file normalize "${origin_dir}/code/rtl/SRK_Modules/Semafor.sv"] \
 [file normalize "${origin_dir}/code/rtl/SRK_Modules/LedMapper.sv"] \
 [file normalize "${origin_dir}/code/rtl/TrainSimulation/TrainSpawnerFromUART.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/TopVga.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/VgaTiming.sv"] \
 [file normalize "${origin_dir}/code/rtl/vga/vga_if.sv"] \
 [file normalize "${origin_dir}/code/rtl/MouseControl/MouseCtl.vhd"] \
 [file normalize "${origin_dir}/code/rtl/vga/MouseDisplay.vhd"] \
 [file normalize "${origin_dir}/code/rtl/vga/Ps2Interface.vhd"] \
 [file normalize "${origin_dir}/code/fpga/rtl/top_fpga.sv"] \
]
add_files -norecurse -fileset $obj $files

if {[file exists "${origin_dir}/LogicRail.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci"]} {
    import_files -fileset sources_1 [file normalize "${origin_dir}/LogicRail.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci"]
}

foreach f $files {
    set file_obj [get_files -of_objects [get_filesets sources_1] [list "*[file tail $f]"]]
    if {[string match "*.vhd" $f]} {
        set_property -name "file_type" -value "VHDL" -objects $file_obj
    } elseif {[string match "*.sv" $f]} {
        set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
    }
}

set_property -name "top" -value "top_vga_basys3" -objects [get_filesets sources_1]

if {[string equal [get_filesets -quiet constrs_1] ""]} { create_fileset -constrset constrs_1 }
set obj [get_filesets constrs_1]
set file "[file normalize "$origin_dir/code/fpga/constrains/basys3.xdc"]"
add_files -norecurse -fileset $obj [list $file]
set_property -name "file_type" -value "XDC" -objects [get_files -of_objects $obj [list "*basys3.xdc"]]

if {[string equal [get_filesets -quiet sim_1] ""]} { create_fileset -simset sim_1 }
set obj [get_filesets sim_1]
set file "[file normalize "$origin_dir/code/sim/top_fpga_TB.sv"]"
add_files -norecurse -fileset $obj [list $file]
set_property -name "file_type" -value "SystemVerilog" -objects [get_files -of_objects $obj [list "*top_fpga_TB.sv"]]
set_property -name "top" -value "top_fpga_TB" -objects $obj

puts "INFO: Projekt LogicRail utworzony pomyslnie."