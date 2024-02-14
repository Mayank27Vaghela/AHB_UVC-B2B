// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_wrap4_burst_seq.sv
// Title        : AHB_UVC master write followed by read sequence class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_wrap4_burst_seq extends AHB_UVC_master_base_sequence_c;
  `uvm_object_utils(AHB_UVC_wrap4_burst_seq)

  //AHB transaction class handle
  AHB_UVC_master_transaction_c trans_h;

  // object constructor
  extern function new(string name = "AHB_UVC_wrap4_burst_seq");

  //Task body
  extern task body();
endclass : AHB_UVC_wrap4_burst_seq

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_wrap4_burst_seq::new(string name = "AHB_UVC_wrap4_burst_seq");
    super.new(name);
endfunction : new

task AHB_UVC_wrap4_burst_seq::body();
  repeat(10)begin
    trans_h = AHB_UVC_master_transaction_c::type_id::create("trans_h");
    start_item(trans_h);
    if(!trans_h.randomize() with{haddr == 32'h38;hburst_type ==WRAP4;hsize_type ==WORD;hwrite == 1;})begin
      `uvm_error(get_type_name(),"Sequence Randomization failed");
     end
     finish_item(trans_h);

     trans_h = AHB_UVC_master_transaction_c::type_id::create("trans_h");
     start_item(trans_h);
     if(!trans_h.randomize() with{haddr == 32'h38;hburst_type ==WRAP4;hsize_type ==WORD;hwrite == 0;})begin
       `uvm_error(get_type_name(),"Sequence Randomization failed");
     end
     finish_item(trans_h);
  end
endtask : body
