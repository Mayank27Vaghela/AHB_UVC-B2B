// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_driver_cb.sv
// Title        : AHB_UVC master driver class
// Project      : AHB_UVC 
// Created On   : 2024-02-18
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_change_htrans_inbet_err_cb extends AHB_UVC_master_driver_cb;
  `uvm_object_utils(AHB_UVC_master_change_htrans_inbet_err_cb);

  function new(string name = "AHB_UVC_master_driver_cb");
     super.new();
  endfunction

  virtual task change_burst_inbet_err(ref htrans_enum htrans_q[$]);
    htrans_q.insert(3,IDLE);
    $display($realtime,"---------***===***--------ERROR DRIVER");
    //$display($realtime,"CB DRIVER htrans_q = %p",htrans_q);    
    //req.htrans_type[3] = IDLE;
  endtask

  virtual task change_size_inbet_err(ref htrans_enum htrans_q[$]);
    
  endtask
endclass : AHB_UVC_master_change_htrans_inbet_err_cb
