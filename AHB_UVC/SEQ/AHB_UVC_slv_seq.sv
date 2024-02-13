// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slv_seq_c.sv
// Title        : AHB_UVC master write followed by read sequence class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slv_seq_c extends AHB_UVC_base_slv_seq;
  `uvm_object_utils(AHB_UVC_slv_seq_c)

  //AHB transaction class handle
  AHB_UVC_slave_transaction_c trans_h;

  // object constructor
  extern function new(string name = "AHB_UVC_slv_seq_c");

  //Task body
  extern task body();
endclass : AHB_UVC_slv_seq_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_slv_seq_c::new(string name = "AHB_UVC_slv_seq_c");
    super.new(name);
endfunction : new

task AHB_UVC_slv_seq_c::body();
  
  forever begin
   p_sequencer.slv_mem.item_fifo.get(req);
   p_sequencer.slv_mem.item_fifo.get(req);
   read(req);   
    
    assert(req.randomize() with {hresp_type dist{OKAY:=5,ERROR:=5};});

  `uvm_send(req);
  end
    
endtask : body
