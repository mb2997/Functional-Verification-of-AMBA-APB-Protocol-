import apb_pkg::*;

module apb_top();

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    bit clk;
    apb_inf inf();
    apb_base_test test_hm;

initial
begin
    uvm_config_db#(virtual apb_inf) :: set(null,"*","apb_inf",inf);
    run_test("apb_base_test");  
end

endmodule : apb_top