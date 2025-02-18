`define ADDR_WIDTH 8
`define DATA_WIDTH 8

`ifndef APB_INF
`define APB_INF

interface apb_inf();

    logic PCLK;
    logic PRESETn;
    logic PSEL;

    logic PENABLE;                          //1=Enable Write/Read operation
    logic PWRITE;                           //1=Write transfer, 0=Read transfer
    logic [`ADDR_WIDTH-1:0] PADDR;          //Value of Write/Read Address - can be upto 32-bits wide
    logic [`DATA_WIDTH-1:0] PWDATA;         //Value of Write Data - can be upto 32-bits wide

    logic PREADY;                           //1=Slave is ready to receive transaction, 0=Slave is busy in previous transaction
    logic [`DATA_WIDTH-1:0] PRDATA;         //Value of read back data
    logic PSLVERR;                          //Error signal
    
/*
    clocking mas_drv_cb@(posedge PCLK);
        default input #1 output #0;
        output PWRITE;
        output PRESETn;
        output PENABLE;
        output PSEL;
        output PWDATA;
        output PADDR;

        input PREADY;
        input PRDATA;
    endclocking

    clocking mas_mon_cb@(posedge PCLK);
        default input #1 output #0;
        input PWRITE;
        input PRESETn;
        input PENABLE;
        input PSEL;
        input PWDATA;
        input PADDR;

        input PREADY;
        input PRDATA;
        input PSLVERR;
    endclocking

    clocking slv_drv_cb@(posedge PCLK);
        default input #1 output #0;
        input PWRITE;
        input PRESETn;
        input PENABLE;
        input PSEL;
        input PWDATA;
        input PADDR;

        output PREADY;
        output PRDATA;
        output PSLVERR;
    endclocking

    clocking slv_mon_cb@(posedge PCLK);
        default input #1 output #0;
        input PWRITE;
        input PRESETn;
        input PENABLE;
        input PSEL;
        input PWDATA;
        input PADDR;

        input PREADY;
        input PRDATA;
    endclocking

    modport MAS_DRV_MP(clocking mas_drv_cb);
    modport MAS_MON_MP(clocking mas_mon_cb);
    modport SLV_DRV_MP(clocking slv_drv_cb);
    modport SLV_MON_MP(clocking slv_mon_cb);
*/

endinterface : apb_inf

`endif