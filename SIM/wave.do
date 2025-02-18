onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hm/drv_hm/transfer_state
add wave -noupdate /uvm_root/uvm_test_top/env_hm/agent_hm/drv_hm/read_write
add wave -noupdate -divider {Interface Signals}
add wave -noupdate /apb_top/inf/PCLK
add wave -noupdate /apb_top/inf/PRESETn
add wave -noupdate /apb_top/inf/PSEL
add wave -noupdate /apb_top/inf/PENABLE
add wave -noupdate /apb_top/inf/PREADY
add wave -noupdate /apb_top/inf/PWRITE
add wave -noupdate /apb_top/inf/PADDR
add wave -noupdate /apb_top/inf/PWDATA
add wave -noupdate /apb_top/inf/PRDATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {273 ns}
