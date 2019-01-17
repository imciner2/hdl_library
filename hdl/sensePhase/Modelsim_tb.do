onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /sensephase_tb/clock
add wave -noupdate /sensephase_tb/reset
add wave -noupdate -expand -group {Sense Edges} /sensephase_tb/sense_A_rising
add wave -noupdate -expand -group {Sense Edges} /sensephase_tb/sense_A_falling
add wave -noupdate -expand -group {Sense Edges} /sensephase_tb/sense_B_rising
add wave -noupdate -expand -group {Sense Edges} /sensephase_tb/sense_B_falling
add wave -noupdate /sensephase_tb/relPhase
add wave -noupdate /sensephase_tb/newPhase
add wave -noupdate -divider UUT
add wave -noupdate /sensephase_tb/UUT/CLK
add wave -noupdate /sensephase_tb/UUT/RST
add wave -noupdate -expand -group {Sense Edge Inputs} /sensephase_tb/UUT/SENSE_A_RISING_EDGE
add wave -noupdate -expand -group {Sense Edge Inputs} /sensephase_tb/UUT/SENSE_A_FALLING_EDGE
add wave -noupdate -expand -group {Sense Edge Inputs} /sensephase_tb/UUT/SENSE_B_RISING_EDGE
add wave -noupdate -expand -group {Sense Edge Inputs} /sensephase_tb/UUT/SENSE_B_FALLING_EDGE
add wave -noupdate /sensephase_tb/UUT/REL_PHASE
add wave -noupdate /sensephase_tb/UUT/NEW_PHASE
add wave -noupdate -expand -group {Phase Register} /sensephase_tb/UUT/phase_n
add wave -noupdate -expand -group {Phase Register} /sensephase_tb/UUT/phase_c
add wave -noupdate -expand -group {Phase Update Register} /sensephase_tb/UUT/phase_update_n
add wave -noupdate -expand -group {Phase Update Register} /sensephase_tb/UUT/phase_update_c
add wave -noupdate -expand -group {State Machine} /sensephase_tb/UUT/machine_ns
add wave -noupdate -expand -group {State Machine} /sensephase_tb/UUT/machine_cs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1247 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 293
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {3780 ps}
