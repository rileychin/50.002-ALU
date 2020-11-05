set projDir "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/vivado"
set projName "alu_checkoff"
set topName top
set device xc7a35tftg256-1
if {[file exists "$projDir/$projName"]} { file delete -force "$projDir/$projName" }
create_project $projName "$projDir/$projName" -part $device
set_property design_mode RTL [get_filesets sources_1]
set verilogSources [list "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/au_top_0.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/sixteen_bit_adder_1.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/sixteen_bit_boolean_2.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/comparator_3.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/shifter_4.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/multiplier_5.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/reset_conditioner_6.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/button_conditioner_7.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/edge_detector_8.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/multi_seven_seg_9.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/manual_tester_10.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/auto_tester_11.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/error_checker_12.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/adder_13.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/boolean_14.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/pipeline_15.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/counter_16.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/seven_seg_17.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/decoder_18.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/counter_19.v" "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/verilog/edge_detector_20.v" ]
import_files -fileset [get_filesets sources_1] -force -norecurse $verilogSources
set xdcSources [list "C:/Users/hazel/Desktop/__sutd_term4/50.002\ Comp\ Struct/50.002-ALU/work/constraint/custom.xdc" "C:/Program\ Files/Alchitry/Alchitry\ Labs/library/components/au.xdc" ]
read_xdc $xdcSources
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
update_compile_order -fileset sources_1
launch_runs -runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
