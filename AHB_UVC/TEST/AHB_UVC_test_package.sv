`ifndef AHB_UVC_TEST_PKG_SV
`define AHB_UVC_TEST_PKG_SV

package AHB_UVC_test_package;
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import AHB_UVC_master_package::*;
  import AHB_UVC_slave_package::*;
  import AHB_UVC_seq_package::*;
  import AHB_UVC_env_package::*;

  /** Testcases*/  
  `include "AHB_UVC_base_test.sv"
  `include "AHB_UVC_sanity_test.sv"

endpackage : AHB_UVC_test_package
`endif /** AHB_UVC_TEST_PKG*/

