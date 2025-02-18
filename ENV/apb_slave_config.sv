`ifndef APB_SLAVE_CONFIG
`define APB_SLAVE_CONFIG

class apb_slave_config extends uvm_object;

    //Factory registration
    `uvm_object_utils(apb_slave_config)

    //Slave agent selection :- ACTIVE or PASSIVE
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    static int trans_sent_from_slave_drv = 0;
    static int trans_rcvd_to_slave_mon = 0;

    function new(string name = "apb_slave_config");
        super.new(name);
    endfunction

endclass : apb_slave_config

`endif