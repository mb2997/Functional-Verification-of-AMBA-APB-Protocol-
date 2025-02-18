`ifndef APB_MASTER_DRV
`define APB_MASTER_DRV

class apb_master_drv extends uvm_driver #(apb_master_trans);

    //Factory registration
    `uvm_component_utils(apb_master_drv)
    
    //Required instance of class & interface
    virtual apb_inf vif;
	
    //for config-db get method - we need config class handle to store properties
    apb_master_config config_hm;
    apb_master_trans trans_hm;
    state_e transfer_state;
    trans_kind_e read_write;
    static int trans_cnt = 1;
    string trans;
    bit b;

    //Local variables
    bit clock_disable;

    //uvm_event
    uvm_event data_sent_from_mstr_drv;

    //Variables required to monitor in waveforms

    function new(string name = "apb_master_drv", uvm_component parent = null);
        super.new(name,parent);
        trans_hm = new("trans_hm");
        $cast(transfer_state,0);
    endfunction

    function void build_phase(uvm_phase phase);
        //get method of config_db to get config class property
        super.build_phase(phase);
        if(!uvm_config_db #(apb_master_config) :: get(this,"","apb_master_config",config_hm))
            `uvm_fatal(get_type_name(),"Failed to get apb_config... Have you set it ?") 
        if(!uvm_config_db #(virtual apb_inf) :: get(this,"","apb_inf",vif))
            `uvm_fatal(get_type_name(),"Failed to get apb_inf... Have you set it ?") 
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);

    //Just trigger a clock_generation task by using fork-join_none to start clock generation prior to starting transaction
    fork
        clock_generation();
    join_none

    initial_reset();

    forever
    begin

        //Request for a new transaction by get_next_item
        seq_item_port.get_next_item(req);
        trans = $sformatf("MASTER-TRANS - %0d",trans_cnt);
        if(req.PWRITE == 1)
            $cast(read_write,2);
        else if(req.PWRITE == 0)
            $cast(read_write,1);

        `uvm_info(get_type_name(),$sformatf("Data Received at MASTER-DRIVER = \n%s",req.sprint()),UVM_MEDIUM)
		
        //After getting new fresh randomized transaction we will drive it to slave through interface
        //drive_to_slave();
        drive_item(req);
		
        seq_item_port.item_done();
        `uvm_info(get_type_name(),$sformatf("Data Sent from MASTER-DRIVER to INTERFACE = \n%s",req.sprint()),UVM_MEDIUM)
        trans_cnt++;

    end
    $display("------ Execution Done Run-Phase in Driver -------");
    endtask

    task drive_item(apb_master_trans req);
        begin
            if(!b)
                begin
                    @(vif.PCLK);
                    b++;
                end
            
            $cast(transfer_state,1);
            
            fork : F1
                begin
                    while(!vif.PREADY)
                    @(vif.PCLK);
                end
                begin
                    repeat(`PREADY_MAX_WAIT)
                        @(vif.PCLK);
                    `uvm_warning("TIMEOUT_WARNING","PREADY was not being asserted from SLAVE")
                end
            join_any

            disable F1;

            vif.PRESETn <= req.PRESETn;
            vif.PADDR <= req.PADDR;
            vif.PWRITE <= req.PWRITE;
            vif.PSEL <= req.PSEL;
            vif.PWDATA <= req.PWDATA;
            vif.PENABLE <= 0;
            
            @(vif.PCLK);
            
            $cast(transfer_state,2);
            vif.PENABLE <= 1;

            if(req.PWRITE == 1)
                begin
                    fork : F2
                        begin
                            do
                                @(vif.PCLK);
                            while(!vif.PREADY);
                            vif.PSEL <= 0;
                            vif.PENABLE <= 0;
                        end
                        begin
                            repeat(`PREADY_MAX_WAIT)
                                @(vif.PCLK);
                            `uvm_warning("TIMEOUT_WARNING","PREADY was not being asserted from SLAVE")
                        end
                    join_any
                    disable F2;
                end
            else if(req.PWRITE == 0)
                begin
                    fork : F3
                        begin
                            @(vif.PCLK);
                            while(!vif.PREADY)
                                @(vif.PCLK);
                            vif.PSEL <= 0;
                            vif.PENABLE <= 0;
                        end
                        begin
                            repeat(`PREADY_MAX_WAIT)
                                @(vif.PCLK);
                            `uvm_warning("TIMEOUT_WARNING","PREADY was not being asserted from SLAVE")
                        end
                    join_any
                    disable F3;
                end
        end
    endtask

    task initial_reset();

        vif.PRESETn = 0;
        @(posedge vif.PCLK);
        vif.PRESETn = 1;

    endtask : initial_reset

    /*
    Drive to slave task
    */
    // task drive_to_slave();
    //     begin 

    //         check_for_idle_state();
    //         process_setup_access_state();

    //     end
    // endtask : drive_to_slave

    // task check_for_idle_state();
    //     begin
    //         PSEL <= vif.PSEL;
    //         if(PSEL == 0)
    //         begin
    //             $cast(transfer_state,0);
    //             @(posedge vif.PCLK);
    //         end
    //     end
    // endtask : check_for_idle_state

    // task process_setup_access_state();
    //     begin

    //         //SETUP Phase
    //         $cast(transfer_state,1);
    //         vif.PSEL <= req.PSEL;
    //         vif.PADDR <= req.PADDR;
    //         vif.PWRITE <= req.PWRITE;
    //         vif.PWDATA <= req.PWDATA;
    //         @(posedge vif.PCLK);

    //         //ACCESS Phase
    //         $cast(transfer_state,2);
    //         vif.PENABLE <= req.PENABLE;
    //         do
    //         begin
    //             @(posedge vif.PCLK);
    //         end
    //         while(vif.PREADY == 0);

    //     end
    // endtask
    
    task clock_generation();

        //Clock initial value
        vif.PCLK = 0;

        forever
            begin
                //Clock generation logic
                if(clock_disable == 0)
                    #(`CYCLE/2) vif.PCLK = ~vif.PCLK;
				else
					#(`CYCLE/2) vif.PCLK = vif.PCLK;
            end
    endtask

endclass : apb_master_drv

`endif