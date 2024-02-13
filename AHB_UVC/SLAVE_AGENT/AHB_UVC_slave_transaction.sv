// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_transaction.sv
// Title        : AHB_UVC slave_transaction class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slave_transaction_c extends uvm_sequence_item;
    `uvm_object_utils(AHB_UVC_slave_transaction_c)

    // object constructor
    extern function new(string name = "AHB_UVC_slave_transaction_c");

    rand bit [(`HADDR_WIDTH -1):0] haddr;
    rand hburst_enum          hburst_type;
    rand hsize_enum            hsize_type;
    rand bit                       hwrite;
    rand bit [(`HWDATA_WIDTH -1):0]    slv_hwdata;
    bit[(`HRDATA_WIDTH -1):0]            hrdata;
    hresp_enum                 hresp_type;
    rand int                    incr_size;

    rand bit [(`HBURST_WIDTH-1):0] beat_cnt;
    rand htrans_enum         htrans_type;
         bit hready_out;
         bit hready_in; 
endclass : AHB_UVC_slave_transaction_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_slave_transaction_c::new(string name = "AHB_UVC_slave_transaction_c");
    super.new(name);
endfunction : new
