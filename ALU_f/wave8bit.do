onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_alu/A1
add wave -noupdate -radix hexadecimal /tb_alu/B1
add wave -noupdate -radix hexadecimal /tb_alu/OP1
add wave -noupdate -radix hexadecimal /tb_alu/clk
add wave -noupdate -radix hexadecimal /tb_alu/valid1
add wave -noupdate -radix hexadecimal /tb_alu/HI1
add wave -noupdate -radix hexadecimal /tb_alu/LO1
add wave -noupdate -radix hexadecimal /tb_alu/status1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2166593 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 372
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
WaveRestoreZoom {0 ps} {787693 ps}
