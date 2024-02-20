// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_wait_test
// Title        : AHB_UVC sanity test class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_wait_test extends AHB_UVC_base_test_c;
  `uvm_component_utils(AHB_UVC_master_wait_test)    

  //Handle of the sequence
  AHB_UVC_master_busy_seq seq_h;
  AHB_UVC_slv_seq_c slv_seq_h;

  // Test constructor
  extern function new(string name = "AHB_UVC_master_wait_test", uvm_component parent);

  // Test build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Test end of elaboration phase
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);

  // Test run phase
  extern virtual task run_phase(uvm_phase phase); 
endclass : AHB_UVC_master_wait_test

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : test constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_wait_test::new(string name = "AHB_UVC_master_wait_test", uvm_component parent);
  super.new(name, parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_wait_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
  seq_h = AHB_UVC_master_busy_seq::type_id::create("seq_h");
  slv_seq_h = AHB_UVC_slv_seq_c::type_id::create("slv_seq_h");
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : end_of_elaboration_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for printing hierarchy
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_wait_test::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
    //uvm_info(get_type_name(), $sformatf("end of elaboration phase\n%s", sprint()), UVM_HIGH)
endfunction : end_of_elaboration_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_master_wait_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "run phase", UVM_HIGH)
    fork
      seq_h.start(ahb_main_env_h.ahb_env_h[0].ahb_master_agent_h.ahb_master_seqr_h);
      slv_seq_h.start(ahb_main_env_h.ahb_env_h[1].ahb_slave_agent_h.ahb_slave_seqr_h);
    join_any
    phase.phase_done.set_drain_time(this,200ns);
    //#200ns;
    phase.drop_objection(this);
endtask : run_phase
