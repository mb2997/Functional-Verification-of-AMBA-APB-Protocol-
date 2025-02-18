`ifndef APB_SLAVE_TRANS
`define APB_SLAVE_TRANS

class apb_slave_trans extends uvm_sequence_item;

    static int current_trans_s = 1;

    //local variable
    bit [`DATA_WIDTH-1:0] PRDATA;
    bit PSEL;
    bit PRESETn;
    bit PWRITE;
    bit PENABLE;
    bit [`ADDR_WIDTH-1:0] PADDR;
    bit [`DATA_WIDTH-1:0] PWDATA;
    bit PREADY = 1;
    
    //rand variables
    rand int no_of_wait_cycles;       //For which PREADY Kept-off
    rand bit wait_enable;

    //constraint for randomization
    constraint WAIT_C {
                        if(wait_enable)
                            soft no_of_wait_cycles > 0 && no_of_wait_cycles < 5;
                        else
                            soft no_of_wait_cycles == 0;
                      }

    //Factory registration & Data field registration
    `uvm_object_utils_begin(apb_slave_trans)

        `uvm_field_int(PRESETn, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PRDATA, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PREADY, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PSEL, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PWRITE, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PENABLE, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PADDR, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PWDATA, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(no_of_wait_cycles, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(wait_enable, UVM_ALL_ON | UVM_HEX)

    `uvm_object_utils_end

    function new(string name = "apb_slave_trans");
        super.new(name);
    endfunction 

endclass : apb_slave_trans

`endif