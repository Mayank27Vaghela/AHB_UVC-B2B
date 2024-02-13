// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_transaction.sv
// Title        : AHB_UVC slave_transaction class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slave_transaction_c extends uvm_sequence_item;

    // object constructor
    extern function new(string name = "AHB_UVC_slave_transaction_c");

    bit [(`HADDR_WIDTH -1):0] haddr;
    hburst_enum          hburst_type;
    hsize_enum            hsize_type;
    bit                       hwrite;
    bit [(`HWDATA_WIDTH -1):0]    slv_hwdata;
    bit[(`HRDATA_WIDTH -1):0]            hrdata;
    rand hresp_enum                 hresp_type;
    rand int                    incr_size;

   // rand bit [(`HBURST_WIDTH-1):0] beat_cnt;
    htrans_enum         htrans_type;
    bit hready_out;
   // bit hready_in;


      `uvm_object_utils_begin(AHB_UVC_slave_transaction_c)
        `uvm_field_int(haddr,UVM_ALL_ON)
        `uvm_field_int(hwrite,UVM_ALL_ON)
        `uvm_field_int(slv_hwdata,UVM_ALL_ON)
        `uvm_field_int(hrdata,UVM_ALL_ON)
        `uvm_field_enum(hburst_enum,hburst_type,UVM_ALL_ON)
        `uvm_field_enum(hsize_enum,hsize_type,UVM_ALL_ON)
        `uvm_field_enum(htrans_enum,htrans_type,UVM_ALL_ON)
        `uvm_field_enum(hresp_enum,hresp_type,UVM_ALL_ON)
    `uvm_object_utils_end


    
 
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
