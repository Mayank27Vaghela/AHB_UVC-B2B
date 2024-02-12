// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_environment.sv
// Title        : AHB_UVC environment class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

`ifndef AHB_UVC_ENV_SV
`define AHB_UVC_ENV_SV 
class AHB_UVC_environment_c extends uvm_env;
    `uvm_component_utils(AHB_UVC_environment_c)    

	// handles declaration
	AHB_UVC_master_agent_c ahb_master_agent_h;
	AHB_UVC_slave_agent_c ahb_slave_agent_h;
  AHB_UVC_env_config_c  ahb_env_cfg_h;
  AHB_UVC_master_config_c ahb_mstr_cfg_h;
  AHB_UVC_slave_config_c ahb_slv_cfg_h;

  int no_of_env = 2;

  // component constructor
  extern function new(string name = "AHB_UVC_environment_c", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 
endclass : AHB_UVC_environment_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_environment_c::new(string name = "AHB_UVC_environment_c", uvm_component parent);
  super.new(name, parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_environment_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
  
  if(!uvm_config_db#(AHB_UVC_env_config_c)::get(this,"","env_config",ahb_env_cfg_h))
     `uvm_error(get_type_name(),"Not able to get env configuration");

  if(ahb_env_cfg_h.mstr_slv_mode == MSTR)begin
	  ahb_master_agent_h = AHB_UVC_master_agent_c::type_id::create("ahb_master_agent_h", this);
	  ahb_mstr_cfg_h = AHB_UVC_master_config_c::type_id::create("ahb_mstr_cfg_h");
    uvm_config_db#(AHB_UVC_master_config_c)::set(this,"*","master_config",ahb_mstr_cfg_h);
  end

  if(ahb_env_cfg_h.mstr_slv_mode == SLV)begin
	  ahb_slave_agent_h = AHB_UVC_slave_agent_c::type_id::create("ahb_slave_agent_h", this);
	  ahb_slv_cfg_h = AHB_UVC_slave_config_c::type_id::create("ahb_slv_cfg_h");
    uvm_config_db#(AHB_UVC_slave_config_c)::set(this,"*","slave_config",ahb_slv_cfg_h);
  end
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_environment_c::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_environment_c::run_phase(uvm_phase phase);
  super.run_phase(phase);   
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
endtask : run_phase
`endif
