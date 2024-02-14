// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_coverage_c.sv
// Title        : AHB_UVC master_coverage class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_coverage_c extends uvm_subscriber#(AHB_UVC_master_transaction_c);
  `uvm_component_utils(AHB_UVC_master_coverage_c)    

  AHB_UVC_master_transaction_c trans_h;

  // component constructor
  extern function new(string name = "AHB_UVC_master_coverage_c", uvm_component parent);
 
  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 

  // write method
  extern virtual function void write(AHB_UVC_master_transaction_c t); 

  covergroup mstr_trans_cvg;
     trans_kind_cp : coverpoint trans_h.hwrite
     {
        option.comment = "bins for the write and read operations";
        bins write_cb = {1'b1};
        bins read_cb  = {1'b0};
     }

     haddr_cp : coverpoint trans_h.haddr
     {
       option.comment = "bins for the haddr range";
       bins haddr_all_rng_cb = {[32'h0:32'hFFFF]};
     } 

     hwdata_cp : coverpoint trans_h.hwdata[0]
     {
        option.comment = "bins for the hwdata range";
        bins pwdata_all_rng_cb = {['h0:'hFFFF]};
     }

     hsize_cp : coverpoint trans_h.hsize_type
     {
        option.comment = "bins for different size of the hwdata";
        bins hsize_cb[] = {BYTE,HALFWORD,WORD,DOUBLEWORD,WORDLINE_4,WORDLINE_8};
     }

     hrdata_cp : coverpoint trans_h.hrdata
     {
        option.comment = "bins for the different read data(hrdata)";
        bins hrdata_cb = {['h0:'hFFFF]};
     }

     hresp_type_cp : coverpoint trans_h.hresp_type
     {
        option.comment = "bins for the different slave response type ERROR(1) and OKAY(0)";
        bins error_cb = {1'b1};
        bins okay_cb  = {1'b0};
     }

     hburst_type_cp : coverpoint trans_h.hburst_type
     {
       option.comment = "bins for the different burst types";
       bins hburst_type_cb[] = {SINGLE,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16};
     }

     /*master_wait_cp : coverpoint trans_h.htrans_type
     {
       option.comment = "bins for the busy state of the master";
       bins busy_cb = {BUSY};
     }*/
  endgroup
endclass : AHB_UVC_master_coverage_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_coverage_c::new(string name = "AHB_UVC_master_coverage_c", uvm_component parent);
  super.new(name, parent);
  mstr_trans_cvg = new;
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_coverage_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_coverage_c::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_master_coverage_c::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
endtask : run_phase

//////////////////////////////////////////////////////////////////
// Method name        : write()
// Parameter Passed   : handle of the transaction class
// Returned Parameter : none
// Description        : write method of the master coverage
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_coverage_c::write(AHB_UVC_master_transaction_c t);
  
   trans_h = t;
    /** Sample method*/
    //if(spi_mstr_cfg_h.enable_cov)begin
      mstr_trans_cvg.sample();
    //end /** if*/
endfunction : write
