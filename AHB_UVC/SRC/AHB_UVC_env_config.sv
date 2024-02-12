// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_env_config.sv
// Title        : AHB_UVC env configuration class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

`ifndef AHB_UVC_ENV_CONFIG_C_SV
`define AHB_UVC_ENV_CONFIG_C_SV
typedef enum {SLV,MSTR} mode;
class AHB_UVC_env_config_c extends uvm_object;
  `uvm_object_utils(AHB_UVC_env_config_c);
  
  // component constructor
  extern function new(string name = "AHB_UVC_env_config_c");

  // UVC master slave mode switch
  mode mstr_slv_mode;
endclass : AHB_UVC_env_config_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_env_config_c::new(string name = "AHB_UVC_env_config_c");
  super.new(name);
endfunction : new 
`endif

