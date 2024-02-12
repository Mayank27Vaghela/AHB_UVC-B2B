// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_base_test
// Title        : AHB_UVC base test class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_base_test_c extends uvm_test;
  `uvm_component_utils(AHB_UVC_base_test_c)    

	// Environment class handle declaration
	AHB_UVC_main_environment_c ahb_main_env_h;
  AHB_UVC_env_config_c ahb_env_cfg_h;

  // Test constructor
  extern function new(string name = "AHB_UVC_base_test_c", uvm_component parent);

  // Test build phase
  extern virtual function void build_phase(uvm_phase phase);

  // Test end of elaboration phase
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);

  // Test run phase
  extern virtual task run_phase(uvm_phase phase); 
endclass : AHB_UVC_base_test_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : test constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_base_test_c::new(string name = "AHB_UVC_base_test_c", uvm_component parent);
  super.new(name, parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_base_test_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
	ahb_main_env_h = AHB_UVC_main_environment_c::type_id::create("ahb_main_env_h", this);
	//ahb_env_cfg_h = AHB_UVC_main_env_config_c::type_id::create("ahb_env_cfg_h");
  //uvm_config_db#(AHB_UVC_env_config_c)::set(this,"*","env_config",ahb_env_cfg_h);
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : end_of_elaboration_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for printing hierarchy
//////////////////////////////////////////////////////////////////
function void AHB_UVC_base_test_c::end_of_elaboration_phase(uvm_phase phase);
     //Printing Topology
    `uvm_info(get_type_name(), $sformatf("end of elaboration phase\n%s", sprint()), UVM_NONE)
endfunction : end_of_elaboration_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_base_test_c::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "run phase", UVM_HIGH)
     phase.raise_objection(this);
      `uvm_info(get_type_name(),"INSIDE RUN_PHASE",UVM_HIGH); 
     phase.drop_objection(this);
endtask : run_phase
