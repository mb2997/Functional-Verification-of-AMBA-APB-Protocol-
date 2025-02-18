`ifndef APB_MASTER_AGENT
`define APB_MASTER_AGENT

class apb_master_agent extends uvm_agent;

    //Factory registration
    `uvm_component_utils(apb_master_agent)

    //Required instance of class & interface
    apb_master_seqr seqr_hm;
    apb_master_drv drv_hm;
    apb_master_mon mon_hm;
    apb_master_config config_hm;
    virtual apb_inf vif;

    function new(string name = "apb_master_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        $display("------- Executing Build-Phase in Agent ---------");
        super.build_phase(phase);
        //config_db get method for master_config class
        if(!uvm_config_db #(apb_master_config) :: get(this,"","apb_master_config",config_hm))
            `uvm_fatal(get_type_name(), "Failed to get apb_config... Have you set it ?")
        //config_db get method for interface
        if(!uvm_config_db #(virtual apb_inf) :: get(this,"","apb_inf",vif))
            `uvm_fatal(get_type_name(), "Failed to get vif... Have you set it ?")
        
        //create method for monitor
        mon_hm = apb_master_mon :: type_id :: create("mon_hm",this);

        //If I want to create active agent then & then I will create driver & sequencer
        //if(config_hm.is_active == UVM_ACTIVE)
        begin
            drv_hm = apb_master_drv :: type_id :: create("drv_hm",this);
            seqr_hm = apb_master_seqr :: type_id :: create("seqr_hm",this);
        end
        $display("------ Execution Done Build-Phase in Agent -------");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("------- Executing Connect-Phase in Agent ---------");
        
        //Pointing this local virtual interface to actual interface
        //mon_hm.vif = vif;
        
        /*
        If I want to create active agent then & then I will point driver virtual interface to actual interface &
        I connect driver and sequencer
        */
        //if(config_hm.is_active == UVM_ACTIVE)
        begin
            drv_hm.seq_item_port.connect(seqr_hm.seq_item_export);
            //drv_hm.vif = vif;
        end
        $display("------- Execution Completed of Connect-Phase in Agent ---------");
    endfunction

endclass : apb_master_agent

`endif