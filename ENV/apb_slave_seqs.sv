`ifndef APB_SLAVE_SEQS
`define APB_SLAVE_SEQS

class apb_slave_seqs extends uvm_sequence #(apb_slave_trans);

    `uvm_object_utils(apb_slave_seqs)

    apb_slave_trans trans_hs;
    
    function new(string name = "apb_slave_seqs");
        super.new(name);
    endfunction

    task body();
        forever
            begin
                trans_hs = apb_slave_trans :: type_id :: create("trans_hs");
                start_item(trans_hs);
                assert(trans_hs.randomize() with {wait_enable == 'b1;}); // with wait states
                finish_item(trans_hs);
            end
    endtask

endclass : apb_slave_seqs

`endif