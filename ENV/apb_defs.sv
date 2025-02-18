`define ADDR_WIDTH 8
`define DATA_WIDTH 8
`define CYCLE 10
`define PREADY_MAX_WAIT 15
typedef enum bit [1:0] {IDLE,SETUP,ACCESS} state_e;
typedef enum bit [1:0] {NONE,READ,WRITE} trans_kind_e;