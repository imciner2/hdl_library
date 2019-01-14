onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /timeedges_tb/clock
add wave -noupdate /timeedges_tb/reset
add wave -noupdate -expand -group {Edge Selectors} /timeedges_tb/stopEdgeType
add wave -noupdate -expand -group {Edge Selectors} /timeedges_tb/startEdgeType
add wave -noupdate -expand -group {Edge Signals} /timeedges_tb/sense_risingEdge
add wave -noupdate -expand -group {Edge Signals} /timeedges_tb/sense_fallingEdge
add wave -noupdate -expand -group Counter /timeedges_tb/newCntFlag
add wave -noupdate -expand -group Counter -radix unsigned /timeedges_tb/cnt
add wave -noupdate -divider UUT
add wave -noupdate /timeedges_tb/UUT/CLK
add wave -noupdate /timeedges_tb/UUT/RST
add wave -noupdate -expand -group {UUT Edge Selectors} /timeedges_tb/UUT/START_EDGE
add wave -noupdate -expand -group {UUT Edge Selectors} /timeedges_tb/UUT/STOP_EDGE
add wave -noupdate -expand -group {Input Edge Signals} /timeedges_tb/UUT/SENSE_RISE
add wave -noupdate -expand -group {Input Edge Signals} /timeedges_tb/UUT/SENSE_FALL
add wave -noupdate -expand -group {Input Edge Signals} /timeedges_tb/UUT/e_start
add wave -noupdate -expand -group {Input Edge Signals} /timeedges_tb/UUT/e_stop
add wave -noupdate -expand -group {UUT Counter} -radix unsigned /timeedges_tb/UUT/COUNT
add wave -noupdate -expand -group {UUT Counter} -radix unsigned /timeedges_tb/UUT/counter_out
add wave -noupdate -expand -group {UUT Counter} -radix unsigned /timeedges_tb/UUT/counter
add wave -noupdate -expand -group {UUT Counter} /timeedges_tb/UUT/NEW_CNT
add wave -noupdate -expand -group {UUT Counter} /timeedges_tb/UUT/cnt_new_c
add wave -noupdate -expand -group {UUT Counter} /timeedges_tb/UUT/cnt_new_n
add wave -noupdate -expand -group {Timer Control Signals} /timeedges_tb/UUT/timer_ps
add wave -noupdate -expand -group {Timer Control Signals} /timeedges_tb/UUT/timer_ns
add wave -noupdate -expand -group {Timer Control Signals} /timeedges_tb/UUT/cnt_run
add wave -noupdate -expand -group {Timer Control Signals} /timeedges_tb/UUT/cnt_rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 282
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
WaveRestoreZoom {0 ps} {20750 ps}
