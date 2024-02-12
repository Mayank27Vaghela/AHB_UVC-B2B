// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_coverage_c.sv
// Title        : AHB_UVC master_coverage class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_coverage_c extends uvm_subscriber#(AHB_UVC_transaction_c);
  `uvm_component_utils(AHB_UVC_master_coverage_c)    

  // component constructor
  extern function new(string name = "AHB_UVC_master_coverage_c", uvm_component parent);
 
  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 

  // write method
  extern virtual function void write(AHB_UVC_transaction_c t); 
endclass : AHB_UVC_master_coverage_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_coverage_c::new(string name = "AHB_UVC_master_coverage_c", uvm_component parent);
  super.new(name, parent);
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
function void AHB_UVC_master_coverage_c::write(AHB_UVC_transaction_c t);
  
    /** Sample method*/
    //if(spi_mstr_cfg_h.enable_cov)begin
    //  cvg.sample(t);
    //end /** if*/
endfunction : write
