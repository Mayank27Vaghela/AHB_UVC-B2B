`ifndef AHB_UVC_SEQ_PKG_SV
`define AHB_UVC_SEQ_PKG_SV

package AHB_UVC_seq_package;
   
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "AHB_UVC_defines.sv"
  `include "AHB_UVC_common_defines.sv"
  import AHB_UVC_master_package::*;
  import AHB_UVC_slave_package::*;

  /** Base sequence file*/
  `include "AHB_UVC_master_base_sequence.sv"
  `include "AHB_UVC_slave_base_sequence.sv"

  /** Other sequences*/
  `include "AHB_UVC_master_wr_seq.sv"
  `include "AHB_UVC_master_b2b_wr_seq.sv"
  `include "AHB_UVC_master_reset_seq.sv"
  `include "AHB_UVC_master_busy_seq.sv"
  `include "AHB_UVC_master_single_burst_seq.sv"
  `include "AHB_UVC_master_wrap_burst_seq.sv"
  `include "AHB_UVC_master_incr_burst_seq.sv"
  `include "AHB_UVC_master_hsize_err_seq.sv"
  `include "AHB_UVC_master_hburst_err_seq.sv"
  `include "AHB_UVC_master_x_signal_err_seq.sv"
  `include "AHB_UVC_master_1kb_boundary_seq.sv"
  `include "AHB_UVC_base_slv_seq.sv"
  `include "AHB_UVC_slv_seq.sv"
endpackage : AHB_UVC_seq_package
`endif /** AHB_UVC_SEQ_PKG*/

