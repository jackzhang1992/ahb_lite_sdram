
vlib work

set p0 -vlog01compat
set p1 +define+den512Mb
set p2 +define+sg75
set p3 +define+x16
set p4 +define+SIMULATION

set i0 +incdir+../../src/ahb_lite_sdram
set i1 +incdir+../../src/testbench
set i2 +incdir+../../src/testbench/sdr_sdram

set s0 ../../src/ahb_lite_sdram/*.v
set s1 ../../src/testbench/*.v
set s2 ../../src/testbench/sdr_sdram/*.v

vlog $p0 $p1 $p2 $p3 $p4  $i0 $i1 $i2  $s0 $s1 $s2

vsim work.test_ahb_lite_sdram
add wave -height 32 -radix hex sim:/test_ahb_lite_sdram/HCLK  	
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HTRANS	    
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HADDR 
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HWRITE 
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HBURST 
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HSIZE 
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HREADY 
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HWDATA 
add wave -height 32	-radix hex sim:/test_ahb_lite_sdram/HRDATA 
add wave -divider

add wave -radix hex sim:/test_ahb_lite_sdram/*
add wave -radix unsigned sim:/test_ahb_lite_sdram/mem/State
run -all
wave zoom full