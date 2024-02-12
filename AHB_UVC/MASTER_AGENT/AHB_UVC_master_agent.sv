// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_agent.sv
// Title        : AHB_UVC master agent class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_agent_c extends uvm_agent;
  `uvm_component_utils(AHB_UVC_master_agent_c)    

	// Handles declaration
	AHB_UVC_master_sequencer_c ahb_master_seqr_h;
	AHB_UVC_master_driver_c ahb_master_drv_h;
	AHB_UVC_master_monitor_c ahb_master_mon_h;
  AHB_UVC_master_coverage_c  ahb_master_cov_h;
  AHB_UVC_master_config_c ahb_master_cfg_h;
  // component constructor
  extern function new(string name = "AHB_UVC_master_agent_c", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 
endclass : AHB_UVC_master_agent_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_agent_c::new(string name = "AHB_UVC_master_agent_c", uvm_component parent);
  super.new(name,parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_agent_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
  if(!uvm_config_db#(AHB_UVC_master_config_c)::get(this,"","master_config",ahb_master_cfg_h))
    `uvm_error(get_type_name(),"Not able to get master configuration");

  if(ahb_master_cfg_h.is_active == UVM_ACTIVE)begin  
	  ahb_master_seqr_h = AHB_UVC_master_sequencer_c::type_id::create("ahb_master_seqr_h", this);
	  ahb_master_drv_h = AHB_UVC_master_driver_c::type_id::create("ahb_master_drv_h", this);
  end
  if(ahb_master_cfg_h.mstr_coverage)begin
	  ahb_master_cov_h = AHB_UVC_master_coverage_c::type_id::create("ahb_master_cov_h", this);
  end
  ahb_master_mon_h = AHB_UVC_master_monitor_c::type_id::create("ahb_master_mon_h", this);
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_agent_c::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
  if(ahb_master_cfg_h.is_active == UVM_ACTIVE)begin  
	  ahb_master_drv_h.seq_item_port.connect(ahb_master_seqr_h.seq_item_export);
  end
  if(ahb_master_cfg_h.mstr_coverage)begin
	  ahb_master_mon_h.item_collected_port.connect(ahb_master_cov_h.analysis_export);
  end
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_master_agent_c::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
endtask : run_phase
