`ifndef APB_BASE_TEST
`define APB_BASE_TEST

class apb_base_test extends uvm_test;
    
    //Factory registration
    `uvm_component_utils(apb_base_test)

    //Required instance of class
    apb_env env_hm;
    apb_master_seqs seqs_hm;
    apb_slave_seqs seqs_hs;
    apb_master_config config_hm;
    apb_slave_config config_hs;

    function new(string name = "apb_base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    //function to set all the required configuration
    function void set_all_configuration();
        config_hm.is_active = UVM_ACTIVE;
        config_hs.is_active = UVM_ACTIVE;

        //set method of config_db
        uvm_config_db #(apb_master_config) :: set(this,"*","apb_master_config",config_hm);
        uvm_config_db #(apb_slave_config) :: set(this,"*","apb_slave_config",config_hs);
        get_vif_in_pkg();
    endfunction

    //Function to create all components required at test component level
    function void create_all_component();
        config_hm = apb_master_config :: type_id :: create("config_hm");
        config_hs = apb_slave_config :: type_id :: create("config_hs");
        env_hm = apb_env :: type_id :: create("env_hm",this);
        seqs_hm = apb_master_seqs :: type_id :: create("seqs_hm",this);
        seqs_hs = apb_slave_seqs :: type_id :: create("seqs_hs",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        create_all_component();
        set_all_configuration();
        $display("------ Execution Done Build-Phase in Test -------");
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
        $display("------ Execution Done End-of_ELB in Test -------");
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        if(config_hm.is_active == UVM_ACTIVE)
        fork
            seqs_hm.start(env_hm.agent_hm.seqr_hm);
            seqs_hs.start(env_hm.agent_hs.seqr_hs);
        join_any
        if(config_hm.is_active == UVM_PASSIVE)
        begin
            #3000;
        end
        phase.drop_objection(this);
        $display("------ Execution Done Run-Phase in Test -------");
    endtask

endclass : apb_base_test

`endif