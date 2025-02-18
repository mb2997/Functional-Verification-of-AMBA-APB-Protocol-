`ifndef APB_MASTER_TRANS
`define APB_MASTER_TRANS

class apb_master_trans extends uvm_sequence_item;

    static int current_trans_m = 1;

    //random write signals for APB Master
    rand bit PWRITE;
    bit PRESETn = 1;
    rand bit PENABLE;
    rand bit PSEL;
    randc bit [`ADDR_WIDTH-1:0] PADDR;
    randc bit [`DATA_WIDTH-1:0] PWDATA;

    //local signals
    bit PREADY;
    bit [`DATA_WIDTH-1:0] PRDATA;
    bit PSLVERR;
    static bit [`ADDR_WIDTH-1:0] prev_addr;
    static bit b = 0;
    static rand bit conti_wr_conti_rd;  //1=continous write or continous read operation, 0=one write and one read

    //constraint for randomization
    //constraint PADDR_C {PADDR < 3;}
    //constraint PENABLE_C {PENABLE == 1;}
    //constraint PSEL_C {PSEL == 1;}
    constraint DIFF_ADDR_C {
                                if(conti_wr_conti_rd)
                                {
                                    if(b)
                                        PADDR != prev_addr;
                                }
                                else if(!conti_wr_conti_rd)
                                {
                                    if(!b)
                                        PADDR != prev_addr;
                                    else
                                        PADDR == prev_addr;
                                }
                            }
	
    //Factory registration & Data field registration
    `uvm_object_utils_begin(apb_master_trans)

        `uvm_field_int(PWRITE, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PRESETn, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PENABLE, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PSEL, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PWDATA, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PADDR, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PREADY, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(PRDATA, UVM_ALL_ON | UVM_HEX)

    `uvm_object_utils_end

    function new(string name = "apb_master_trans");
        super.new(name);
    endfunction 

    function void post_randomize();
        prev_addr = PADDR;
        if(!b)
            b++;
        else if(!conti_wr_conti_rd)
            b = ~b;
    endfunction

endclass : apb_master_trans

`endif