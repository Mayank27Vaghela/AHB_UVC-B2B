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
  `include "AHB_UVC_master_wait_test.sv"
  `include "AHB_UVC_single_burst_test.sv"
  `include "AHB_UVC_incr_burst_test.sv"
  `include "AHB_UVC_wrap_burst_test.sv"
  `include "AHB_UVC_reset_test.sv"
  `include "AHB_UVC_hsize_err_test.sv"
  `include "AHB_UVC_htrans_err_test.sv"
  `include "AHB_UVC_hburst_err_test.sv"
  `include "AHB_UVC_x_value_signal_err_test.sv"
  `include "AHB_UVC_1k_boundary_test.sv"
endpackage : AHB_UVC_test_package
`endif /** AHB_UVC_TEST_PKG*/

