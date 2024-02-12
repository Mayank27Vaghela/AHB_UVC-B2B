// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_salve_config_c.sv
// Title        : AHB_UVC salve configuration class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

`ifndef AHB_UVC_SLAVE_CONFIG_C_SV
`define AHB_UVC_SLAVE_CONFIG_C_SV
class AHB_UVC_slave_config_c extends uvm_object;
  `uvm_object_utils(AHB_UVC_slave_config_c);
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  bit slv_coverage = 1;

  // component constructor
  extern function new(string name = "AHB_UVC_slave_config_c");
endclass : AHB_UVC_slave_config_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_slave_config_c::new(string name = "AHB_UVC_slave_config_c");
  super.new(name);
endfunction : new 
`endif
