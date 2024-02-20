// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_reset_seq_c.sv
// Title        : AHB_UVC master write followed by read sequence class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_reset_seq_c extends AHB_UVC_master_base_sequence_c;
  `uvm_object_utils(AHB_UVC_master_reset_seq_c)

  //AHB transaction class handle
  AHB_UVC_master_transaction_c trans_h;

  `uvm_declare_p_sequencer(AHB_UVC_master_sequencer_c)
  
  // object constructor
  extern function new(string name = "AHB_UVC_master_reset_seq_c");

  //Task body
  extern task body();
endclass : AHB_UVC_master_reset_seq_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_reset_seq_c::new(string name = "AHB_UVC_master_reset_seq_c");
    super.new(name);
endfunction : new

task AHB_UVC_master_reset_seq_c::body();
  
  fork
    begin 
      trans_h = AHB_UVC_master_transaction_c::type_id::create("trans_h");
      start_item(trans_h);
      if(!trans_h.randomize() with{haddr == 32'h38;hburst_type ==WRAP4;hsize_type ==WORD;hwrite == 1;})begin
        `uvm_error(get_type_name(),"Sequence Randomization failed");
      end
      //trans_h.print();
      finish_item(trans_h);
    end

    begin
      p_sequencer.uvc_if.reset(55,1);
    end
  join
  
  trans_h = AHB_UVC_master_transaction_c::type_id::create("trans_h");
  start_item(trans_h);
  `uvm_info(get_name,"inside sequence after 1 transaction =========================>>>>>>>>>>>>>>>>>>.",UVM_NONE)
  if(!trans_h.randomize() with{haddr == 32'h38;hburst_type ==INCR4;hsize_type ==WORD;hwrite == 0;})begin
     `uvm_error(get_type_name(),"Sequence Randomization failed");
  end
  //trans_h.print();
  finish_item(trans_h);
endtask : body
