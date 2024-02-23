// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_main_environment.sv
// Title        : AHB_UVC environment class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

`ifndef AHB_UVC_MAIN_ENV_SV
`define AHB_UVC_MAIN_ENV_SV 
class AHB_UVC_main_environment_c extends uvm_env;
    `uvm_component_utils(AHB_UVC_main_environment_c)    

	// handles declaration
  AHB_UVC_environment_c ahb_env_h[];
  AHB_UVC_env_config_c ahb_env_cfg_h[];
  AHB_UVC_scoreboard_c ahb_sb_h;

  int num_of_env = 2;
    
  // component constructor
  extern function new(string name = "AHB_UVC_main_environment_c", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 
endclass : AHB_UVC_main_environment_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_main_environment_c::new(string name = "AHB_UVC_main_environment_c", uvm_component parent);
  super.new(name, parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_main_environment_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
  ahb_env_h = new[num_of_env];
   ahb_env_cfg_h = new[num_of_env];
  for(int i=0;i<num_of_env;i++)begin
    ahb_env_h[i] = AHB_UVC_environment_c::type_id::create($sformatf("ahb_env_h[%0d]",i),this); 
    ahb_env_cfg_h[i] = AHB_UVC_env_config_c::type_id::create($sformatf("ahb_env_config_h[%0d]",i));
  end

  ahb_env_cfg_h[0].mstr_slv_mode = MSTR;
  ahb_env_cfg_h[1].mstr_slv_mode = SLV;
  
  for(int i=0;i<num_of_env;i++)begin
    uvm_config_db#(AHB_UVC_env_config_c)::set(this,$sformatf("ahb_env_h[%0d]",i),"env_config",ahb_env_cfg_h[i]);
  end

  ahb_sb_h = AHB_UVC_scoreboard_c::type_id::create("ahb_sb_h",this); 

endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_main_environment_c::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
   ahb_env_h[0].ahb_master_agent_h.ahb_master_mon_h.item_collected_port.connect(ahb_sb_h.mmon_imp);
   ahb_env_h[1].ahb_slave_agent_h.ahb_slave_mon_h.item_collected_port.connect(ahb_sb_h.smon_imp);
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_main_environment_c::run_phase(uvm_phase phase);
  super.run_phase(phase);   
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
endtask : run_phase
`endif
