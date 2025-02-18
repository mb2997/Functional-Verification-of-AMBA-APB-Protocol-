`ifndef APB_SLAVE_MON
`define APB_SLAVE_MON

class apb_slave_mon extends uvm_monitor;

    //Factory registration
    `uvm_component_utils(apb_slave_mon)

    //Intance of class & interface
    virtual apb_inf vif;
    apb_slave_config config_hs;
    apb_slave_trans trans_hs;
    int num_of_slv_packets_sampled;

    //Analysis port for connection from monitor to scoreboard
    uvm_analysis_port #(apb_slave_trans) slv_mon_ap;

    function new(string name = "apb_slave_mon", uvm_component parent = null);
        super.new(name,parent);
        // new/create method
        slv_mon_ap = new("slv_mon_ap",this);
    endfunction

    function void build_phase(uvm_phase phase);
        //Get config_db to monitor class for required configuration
        if(!uvm_config_db #(virtual apb_inf) :: get(this,"","apb_inf",vif))
            `uvm_fatal(get_type_name(),"Failed to get apb_inf... Have you set it ?") 
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        forever
        begin
            data_from_inf();
        end
    endtask

    task data_from_inf();
        trans_hs = apb_slave_trans::type_id::create("trans_hs");

        @(vif.PSEL or vif.PWRITE or vif.PENABLE or vif.PREADY or vif.PRDATA);


        wait(vif.PENABLE == 1);
        trans_hs.PENABLE = vif.PENABLE;
        
        wait(vif.PREADY == 1);
        trans_hs.PRESETn= vif.PRESETn;
        trans_hs.PADDR	= vif.PADDR;
        trans_hs.PWDATA	= vif.PWDATA;
        trans_hs.PWRITE	= vif.PWRITE;
        trans_hs.PREADY	= vif.PREADY;
        trans_hs.PRDATA	= vif.PRDATA;
        trans_hs.PSEL	= vif.PSEL;

        if(trans_hs.PREADY == 1)
            begin
                if(trans_hs.PWRITE == 1)
                `uvm_info(get_type_name(),$sformatf("Write Transaction Received at SLAVE-MONITOR from MASTER-DRIVER = \n%p",trans_hs.sprint()),UVM_MEDIUM)
                else if(trans_hs.PWRITE == 0)
                `uvm_info(get_type_name(),$sformatf("Read Transaction Received at SLAVE-MONITOR from MASTER-DRIVER = \n%p",trans_hs.sprint()),UVM_MEDIUM)
                slv_mon_ap.write(trans_hs);
                `uvm_info(get_type_name(),$sformatf("Data Sent from SLAVE-MONITOR to SCOREBOARD = \n%p",trans_hs.sprint()),UVM_MEDIUM)
                num_of_slv_packets_sampled++;
            end
    endtask

endclass : apb_slave_mon

`endif