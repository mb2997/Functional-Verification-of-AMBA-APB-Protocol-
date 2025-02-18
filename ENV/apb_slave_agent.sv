`ifndef APB_SLAVE_AGENT
`define APB_SLAVE_AGENT

class apb_slave_agent extends uvm_agent;

    //Factory registration
    `uvm_component_utils(apb_slave_agent)

    //Required instance of class & interface
    apb_slave_seqr seqr_hs; 
    apb_slave_drv drv_hs;
    apb_slave_mon mon_hs;
    apb_slave_config config_hs;
    virtual apb_inf vif;

    function new(string name = "apb_slave_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        $display("------- Executing Build-Phase in Agent ---------");
        super.build_phase(phase);
        //config_db get method for slave_config class
        if(!uvm_config_db #(apb_slave_config) :: get(this,"","apb_slave_config",config_hs))
            `uvm_fatal(get_type_name(), "Failed to get apb_config... Have you set it ?")
        //config_db get method for interface
        if(!uvm_config_db #(virtual apb_inf) :: get(this,"","apb_inf",vif))
            `uvm_fatal(get_type_name(), "Failed to get vif... Have you set it ?")
        
        //create method for monitor
        mon_hs = apb_slave_mon :: type_id :: create("mon_hs",this);
        
        //If I want to create active agent then & then I will create driver & sequencer
        if(config_hs.is_active == UVM_ACTIVE)
        begin
            drv_hs = apb_slave_drv :: type_id :: create("drv_hs",this);
            seqr_hs = apb_slave_seqr :: type_id :: create("seqr_hs",this);
        end
        $display("------ Execution Done Build-Phase in Agent -------");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("------- Executing Connect-Phase in Agent ---------");

        //Pointing this local virtual interface to actual interface
        mon_hs.vif = vif;

        /*
        If I want to create active agent then & then I will point driver virtual interface to actual interface &
        I connect driver and sequencer
        */
        if(config_hs.is_active == UVM_ACTIVE)
        begin
            drv_hs.seq_item_port.connect(seqr_hs.seq_item_export);
            drv_hs.vif = vif;    
        end
        $display("------- Execution Completed of Connect-Phase in Agent ---------");
    endfunction

endclass : apb_slave_agent

`endif