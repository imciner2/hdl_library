onerror {resume}
quietly virtual signal -install /debouncesignal_tb/UUT { (context /debouncesignal_tb/UUT )(SENSE_RISE & SENSE_FALL & SENSE_DB )} Output
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /debouncesignal_tb/reset
add wave -noupdate /debouncesignal_tb/enable
add wave -noupdate /debouncesignal_tb/clock
add wave -noupdate /debouncesignal_tb/senseLine
add wave -noupdate -expand -group {Debounce Output} /debouncesignal_tb/sense_debounced
add wave -noupdate -expand -group {Debounce Output} /debouncesignal_tb/sense_risingEdge
add wave -noupdate -expand -group {Debounce Output} /debouncesignal_tb/sense_fallingEdge
add wave -noupdate -divider Debouncer
add wave -noupdate /debouncesignal_tb/UUT/CLK
add wave -noupdate /debouncesignal_tb/UUT/RST
add wave -noupdate /debouncesignal_tb/UUT/ENABLE
add wave -noupdate -expand -group {State Machine} /debouncesignal_tb/UUT/sense_nl
add wave -noupdate -expand -group {State Machine} /debouncesignal_tb/UUT/sense_cl
add wave -noupdate /debouncesignal_tb/UUT/SENSE
add wave -noupdate /debouncesignal_tb/UUT/debounceReg
add wave -noupdate /debouncesignal_tb/UUT/Output
add wave -noupdate /debouncesignal_tb/UUT/SENSE_RISE
add wave -noupdate /debouncesignal_tb/UUT/SENSE_FALL
add wave -noupdate /debouncesignal_tb/UUT/SENSE_DB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 321
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
WaveRestoreZoom {0 ps} {9037 ps}
