vlog ../TEST/apb_pkg.sv ../TOP/apb_top.sv +incdir+../ENV +incdir+../TEST
vsim -vopt apb_top
run 0ns
log -r /uvm_root/*
do wave.do
run -all