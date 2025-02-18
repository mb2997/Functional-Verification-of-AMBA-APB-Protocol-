`ifndef APB_ENV
`define APB_ENV

class apb_env extends uvm_env;

    //Factory registration
    `uvm_component_utils(apb_env)

    //Required instance of class
    apb_master_agent agent_hm;
    apb_slave_agent agent_hs;
    apb_sb sb_h;

    function new(string name = "apb_env", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //creating two agent and scoreboard directly available in environment
        agent_hm = apb_master_agent :: type_id :: create("agent_hm",this);
        agent_hs = apb_slave_agent :: type_id :: create("agent_hs",this);
        sb_h = apb_sb :: type_id :: create("sb_h",this);
        $display("------ Execution Done Build-Phase in ENV -------");
    endfunction

    function void connect_phase(uvm_phase phase);
        //connection of master-monitor to scoreboard FIFO
        agent_hm.mon_hm.mas_mon_ap.connect(sb_h.mas_mon_fifo_h.analysis_export);
        //connection of slave-monitor to scoreboard FIFO
        agent_hs.mon_hs.slv_mon_ap.connect(sb_h.slv_mon_fifo_h.analysis_export);
    endfunction

endclass : apb_env

`endif