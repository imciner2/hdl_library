onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /countedges_tb/clock
add wave -noupdate /countedges_tb/reset
add wave -noupdate -radix unsigned /countedges_tb/time_max
add wave -noupdate /countedges_tb/sense_edge
add wave -noupdate -expand -group {Count Output} -radix unsigned /countedges_tb/cnt
add wave -noupdate -expand -group {Count Output} /countedges_tb/newCntFlag
add wave -noupdate -divider UUT
add wave -noupdate /countedges_tb/UUT/CLK
add wave -noupdate /countedges_tb/UUT/RST
add wave -noupdate -expand -group {UUT Timer} -radix unsigned /countedges_tb/UUT/TIME_END
add wave -noupdate -expand -group {UUT Timer} -radix unsigned /countedges_tb/UUT/timer
add wave -noupdate /countedges_tb/UUT/SENSE_EDGE
add wave -noupdate /countedges_tb/UUT/reset_regs
add wave -noupdate -expand -group {UUT Counter} -radix unsigned /countedges_tb/UUT/counter
add wave -noupdate -expand -group {UUT Counter} -radix unsigned /countedges_tb/UUT/cnt_out_n
add wave -noupdate -expand -group {UUT Counter} -radix unsigned /countedges_tb/UUT/cnt_out_c
add wave -noupdate -expand -group {UUT Counter} /countedges_tb/UUT/cnt_new_n
add wave -noupdate -expand -group {UUT Counter} /countedges_tb/UUT/cnt_new_c
add wave -noupdate -expand -group {UUT Out} /countedges_tb/UUT/NEW_CNT
add wave -noupdate -expand -group {UUT Out} -radix unsigned /countedges_tb/UUT/COUNT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 265
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1155 ps}
