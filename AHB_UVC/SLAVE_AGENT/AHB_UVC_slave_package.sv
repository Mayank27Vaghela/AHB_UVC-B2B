`ifndef AHB_UVC_SLAVE_PKG_SV
`define AHB_UVC_SLAVE_PKG_SV
package AHB_UVC_slave_package;
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  /** AHB defines files*/
  `include "AHB_UVC_defines.sv"
  `include "AHB_UVC_common_defines.sv"
  //import AHB_UVC_master_package::*;
  /** Slave files*/
  `include "AHB_UVC_slave_transaction.sv"
  `include "AHB_UVC_slave_config.sv"
  `include "AHB_UVC_slave_sequencer.sv"
  `include "AHB_UVC_slave_driver.sv"
  `include "AHB_UVC_slave_monitor.sv"
  `include "AHB_UVC_slave_memory.sv"
  `include "AHB_UVC_slave_coverage.sv"
  `include "AHB_UVC_slave_agent.sv"

endpackage : AHB_UVC_slave_package
`endif /** AHB_UVC_SLAVE_PKG*/

