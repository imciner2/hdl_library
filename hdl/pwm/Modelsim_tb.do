onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /pwm_tb/clock
add wave -noupdate /pwm_tb/reset
add wave -noupdate /pwm_tb/enable
add wave -noupdate /pwm_tb/pwm
add wave -noupdate -radix unsigned /pwm_tb/period
add wave -noupdate -radix unsigned /pwm_tb/duty
add wave -noupdate /pwm_tb/T
add wave -noupdate -divider {PWM Core}
add wave -noupdate /pwm_tb/UUT/clk
add wave -noupdate /pwm_tb/UUT/en
add wave -noupdate /pwm_tb/UUT/rst
add wave -noupdate /pwm_tb/UUT/pwm_o
add wave -noupdate -radix decimal /pwm_tb/UUT/pwm_duty
add wave -noupdate -radix unsigned /pwm_tb/UUT/duty
add wave -noupdate -radix decimal /pwm_tb/UUT/pwm_period
add wave -noupdate -radix unsigned /pwm_tb/UUT/period
add wave -noupdate -radix unsigned /pwm_tb/UUT/cnt
add wave -noupdate /pwm_tb/UUT/gen_state_ps
add wave -noupdate /pwm_tb/UUT/gen_state_ns
add wave -noupdate /pwm_tb/UUT/runCnt
add wave -noupdate /pwm_tb/UUT/latchVal
add wave -noupdate /pwm_tb/UUT/reach_dty
add wave -noupdate /pwm_tb/UUT/reach_per
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {914 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 229
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
WaveRestoreZoom {0 ps} {2205 ps}
