`ifndef AHB_UVC_ENV_PKG_SV
`define AHB_UVC_ENV_PKG_SV

package AHB_UVC_env_package;
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  /** AHB defines files*/
  `include "AHB_UVC_defines.sv"
  `include "AHB_UVC_common_defines.sv"

  import AHB_UVC_master_package::*;
  import AHB_UVC_slave_package::*;

  `include "AHB_UVC_scoreboard.sv"
  
  /** Environment files*/
  `include "AHB_UVC_env_config.sv"
  `include "AHB_UVC_environment.sv"
  `include "AHB_UVC_main_environment.sv"

endpackage : AHB_UVC_env_package
`endif /** AHB_UVC_ENV_PKG*/

