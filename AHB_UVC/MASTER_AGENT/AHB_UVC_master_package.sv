`ifndef AHB_UVC_MASTER_PKG_SV
`define AHB_UVC_MASTER_PKG_SV
package AHB_UVC_master_package;
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  /** AHB defines files*/
  `include "AHB_UVC_defines.sv"
  `include "AHB_UVC_common_defines.sv"

  `include "AHB_UVC_master_transaction.sv"  

  /** Agent configuration file*/
  `include "AHB_UVC_master_config.sv"

  //callbacks
  `include "AHB_UVC_master_driver_cb.sv"

  /** Master files*/
  `include "AHB_UVC_master_sequencer.sv"
  `include "AHB_UVC_master_driver.sv"
  `include "AHB_UVC_master_monitor.sv"
  `include "AHB_UVC_master_coverage.sv"
  `include "AHB_UVC_master_agent.sv"
   
  `include "AHB_UVC_master_change_htrans_inbet_err_cb.sv"
endpackage : AHB_UVC_master_package
`endif /** AHB__UVC_MASTER_PACKAGE*/

