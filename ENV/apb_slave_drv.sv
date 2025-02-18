`ifndef APB_SLAVE_DRV
`define APB_SLAVE_DRV

class apb_slave_drv extends uvm_driver #(apb_slave_trans);

    //Factory registration
    `uvm_component_utils(apb_slave_drv)
    virtual apb_inf vif;

    function new(string name = "apb_slave_drv", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual apb_inf)::get(this,"","apb_inf",vif))
            `uvm_fatal(get_type_name(),"Failed to get apb_inf... Have you set it ?") 
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        vif.PREADY = 1;
        forever
            begin
                seq_item_port.get_next_item(req);
                `uvm_info(get_type_name(),$sformatf("Data Received at SLAVE-DRIVER = \n%s",req.sprint()),UVM_MEDIUM)
                drive_to_inf();
                seq_item_port.item_done();
                `uvm_info(get_type_name(),$sformatf("Data Sent from SLAVE-DRIVER to INTERFACE = \n%s",req.sprint()),UVM_MEDIUM)
            end
    endtask

    task drive_to_inf();
        @(vif.PADDR or vif.PWRITE);

		wait(vif.PSEL);

		if(vif.PWRITE == 1)
			begin
				repeat(req.no_of_wait_cycles)
                begin 
					@(vif.PCLK);
					vif.PREADY <= 'b0;
				end
				mem_model[vif.PADDR] = vif.PWDATA;
				vif.PREADY <= 'b1;
			end
		else if(vif.PWRITE == 0) 
            begin				
				repeat(req.no_of_wait_cycles)
                begin
					@(vif.PCLK);
					vif.PREADY <= 'b0;
				end
								
				if(mem_model.exists(vif.PADDR))
					vif.PRDATA <= mem_model[vif.PADDR];
				else
                    vif.PRDATA <= 'hz; // no data in slave with that address
					
				vif.PREADY <= 'b1;
			end
    endtask

    function void report_phase(uvm_phase phase);
        foreach(mem_model[i])
        begin
            if(mem_model.exists(i))
                $display("mem_model[%0d] = %0h",i,mem_model[i]);
        end
    endfunction

endclass : apb_slave_drv

`endif