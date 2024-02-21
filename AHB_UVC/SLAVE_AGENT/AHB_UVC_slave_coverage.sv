// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_coverage_c.sv
// Title        : AHB_UVC slave_coverage class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slave_coverage_c extends uvm_subscriber#(AHB_UVC_slave_transaction_c);
  `uvm_component_utils(AHB_UVC_slave_coverage_c)    

  AHB_UVC_slave_transaction_c trans_h;
  
  // component constructor
  extern function new(string name = "AHB_UVC_slave_coverage_c", uvm_component parent);
 
  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // write method
  extern virtual function void write(AHB_UVC_slave_transaction_c t);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 

covergroup slv_trans_cvg;
  
  //bins for the write and read opeartion
  trans_wr_rd_cp : coverpoint trans_h.hwrite
    {
      bins write_cb = {1'b1};
      bins read_cb = {1'b0};
    }

  //bins for haddr ranges 
  trans_haddr_cp : coverpoint trans_h.haddr
    {
      bins low_range = {[32'h0 : 32'hff]};
      bins mid_range = {[32'hfff :32'hfffff]};
      bins hig_range = {[32'hffff : 32'hffffffff]};
    }

  //bins for slv_hwdata ranges
  trans_slv_hwdata_cp : coverpoint trans_h.slv_hwdata

    {
      bins low_range = {[32'h0 : 32'hff]};
      bins mid_range = {[32'hfff :32'hfffff]};
      bins hig_range = {[32'hffff : 32'hffffffff]};
    }

  //bins for hresp 
   hresp_type_cp : coverpoint trans_h.hresp_type
     {
        bins error_cb = {1'b1};
        bins okay_cb  = {1'b0};
     }

  //bins for hburst
    hburst_type_cp : coverpoint trans_h.hburst_type
     {
       bins hburst_type_cb[] = {SINGLE,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16};
     }

    endgroup

endclass : AHB_UVC_slave_coverage_c
      
        
   


//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_slave_coverage_c::new(string name = "AHB_UVC_slave_coverage_c", uvm_component parent);
  super.new(name, parent);
  slv_trans_cvg = new();
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_slave_coverage_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_slave_coverage_c::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_slave_coverage_c::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
endtask : run_phase

//////////////////////////////////////////////////////////////////
// Method name        : write()
// Parameter Passed   : handle of the transaction class
// Returned Parameter : none
// Description        : write method of the slave coverage
//////////////////////////////////////////////////////////////////
function void AHB_UVC_slave_coverage_c::write(AHB_UVC_slave_transaction_c t);
  
   trans_h = t;
    /** Sample method*/
    //if(spi_mstr_cfg_h.enable_cov)begin
      slv_trans_cvg.sample();
    //end /** if*/
endfunction : write


