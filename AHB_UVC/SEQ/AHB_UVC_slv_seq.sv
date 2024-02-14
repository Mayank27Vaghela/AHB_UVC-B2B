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

//  `uvm_info(get_type_name(),"INSIDE THE SEQUENCE BODY ",UVM_NONE)
   p_sequencer.slv_mem.item_fifo.get(req);
  `uvm_info(get_type_name(),"INSIDE THE SEQUENCE BODY after get method  ",UVM_NONE)
//   p_sequencer.slv_mem.item_fifo.get(req);
   //`uvm_info(get_name(),$sformatf("req : %0p ",req),UVM_NONE)
   req.print();
  `uvm_info(get_type_name(),"INSIDE THE SEQUENCE BODY ",UVM_NONE)
   write(req);
   read(req);   
    
    assert(req.randomize() with {hresp_type dist{OKAY:=10,ERROR:=0};});

  `uvm_send(req);
  end
    
endtask : body
