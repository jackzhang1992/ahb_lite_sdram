
vlib work

set p0 -vlog01compat
set p1 +define+den512Mb
set p2 +define+sg75
set p3 +define+x16
set p4 +define+SIMULATION

set i0 +incdir+../../src/ahb_lite_sdram
set i1 +incdir+../../src/testbench
set i2 +incdir+../../src/testbench/sdr_sdram
set i3 +incdir+../../src/debug

set s0 ../../src/ahb_lite_sdram/*.v
set s1 ../../src/testbench/*.v
set s2 ../../src/testbench/sdr_sdram/*.v
set s3 ../../src/debug/*.v

vlog $p0 $p1 $p2 $p3 $p4  $i0 $i1 $i2 $i3  $s0 $s1 $s2 $s3

vsim work.test_ahb_lite_rw_master
add wave -height 32 -radix hex sim:/test_ahb_lite_rw_master/HCLK  	
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HTRANS	    
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HADDR 
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HWRITE 
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HBURST 
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HSIZE 
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HREADY 
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HWDATA 
add wave -height 32	-radix hex sim:/test_ahb_lite_rw_master/HRDATA 
add wave -divider

add wave -radix hex sim:/test_ahb_lite_rw_master/*


add wave -radix unsigned sim:/test_ahb_lite_rw_master/mem/State
add wave -radix unsigned sim:/test_ahb_lite_rw_master/master/State
run -all
wave zoom full