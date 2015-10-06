set outputDir ./vivado
file mkdir $outputDir
read_verilog ./multipumped_memory.v
read_verilog ../ram/dual_port_block_ram.v
#synth_design -no_iobuf -include_dirs ../. -top std_fifo -part xc7v2000t
#synth_design -include_dirs ../. -top multipumped_memory -part xc7v2000t
synth_design -include_dirs ../. -top multipumped_memory -part xc7a200t
create_clock -period 2.50 clk
#synth_design -top multipumped_memory -part xc7a200t
write_checkpoint -force $outputDir/post_synth.dcp
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_utilization -file $outputDir/post_synth_util.rpt
opt_design
place_design
route_design
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_utilization -file $outputDir/post_route_util.rpt
