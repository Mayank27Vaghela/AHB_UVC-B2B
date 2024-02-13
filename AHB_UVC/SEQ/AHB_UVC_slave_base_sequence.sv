// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_base_sequence_c.sv
// Title        : AHB_UVC slave base sequence class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slave_base_sequence_c extends uvm_sequence#(AHB_UVC_slave_transaction_c);
  `uvm_object_utils(AHB_UVC_slave_base_sequence_c)

  // object constructor
  extern function new(string name = "AHB_UVC_slave_base_sequence_c");
endclass : AHB_UVC_slave_base_sequence_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_slave_base_sequence_c::new(string name = "AHB_UVC_slave_base_sequence_c");
    super.new(name);
endfunction : new
