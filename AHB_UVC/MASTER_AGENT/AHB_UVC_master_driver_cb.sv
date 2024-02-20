// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_driver_cb.sv
// Title        : AHB_UVC master driver class
// Project      : AHB_UVC 
// Created On   : 2024-02-18
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_driver_cb extends uvm_callback;
  `uvm_object_utils(AHB_UVC_master_driver_cb);

  //Instance of the AHB interface
  virtual AHB_UVC_interface uvc_if;

  function new(string name = "AHB_UVC_master_driver_cb");
     super.new();
  endfunction

  virtual task change_burst_inbet_err(ref htrans_enum htrans_q[$]);
    
  endtask

endclass : AHB_UVC_master_driver_cb
