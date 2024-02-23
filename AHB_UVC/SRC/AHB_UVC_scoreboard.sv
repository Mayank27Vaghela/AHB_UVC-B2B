// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_scoreboard_c.sv
// Title        : AHB_UVC Scoreboard
// Project      : AHB_UVC 
// Created On   : 2024-02-022
// Developers   : 
// -------------------------------------------------------------------------

`ifndef AHB_UVC_SCOREBOARD_SV
`define AHB_UVC_SCOREBOARD_SV
class AHB_UVC_scoreboard_c extends uvm_scoreboard;
 `uvm_component_utils(AHB_UVC_scoreboard_c); 

  //reference model memory
  bit[(`HWDATA_WIDTH-1):0] ref_mem [int];
  
  bit[(`HWDATA_WIDTH-1):0] sb_actual_q[$];
  bit[(`HWDATA_WIDTH-1):0] sb_expected_q[$];


  bit[(`HWDATA_WIDTH-1):0] sb_actual_temp;
  bit[(`HWDATA_WIDTH-1):0] sb_expected_temp;

  //counts the number of the passed transaction
  int pass_count;

  `uvm_analysis_imp_decl(_ahb_mstr_mon)
  `uvm_analysis_imp_decl(_ahb_slv_mon)

  //analysis port
  uvm_analysis_imp_ahb_mstr_mon#(AHB_UVC_master_transaction_c,AHB_UVC_scoreboard_c) mmon_imp;
  uvm_analysis_imp_ahb_slv_mon#(AHB_UVC_slave_transaction_c,AHB_UVC_scoreboard_c) smon_imp;

  //transaction class handles
  AHB_UVC_master_transaction_c mtrans_h;
  AHB_UVC_slave_transaction_c  strans_h;

  // component constructor
  extern function new(string name = "AHB_UVC_scoreboard_c", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  //component run phase
  extern virtual task run_phase(uvm_phase phase); 

  //component extract phase
  extern virtual function void extract_phase(uvm_phase phase); 
 
  //master monitor write method
  extern function void write_ahb_mstr_mon(AHB_UVC_master_transaction_c mtrans_h);

  //slave monitor write method
  extern function void write_ahb_slv_mon(AHB_UVC_slave_transaction_c strans_h);

endclass : AHB_UVC_scoreboard_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_scoreboard_c::new(string name = "AHB_UVC_scoreboard_c", uvm_component parent);
    super.new(name, parent);
    mmon_imp = new("mmon_imp",this);
    smon_imp = new("smon_imp",this);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_scoreboard_c::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build phase", UVM_HIGH)
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_scoreboard_c::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("mstr_drv", "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_scoreboard_c::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
  forever begin
    wait(sb_actual_q.size > 0 && sb_expected_q.size > 0);
    
    sb_actual_temp = sb_actual_q.pop_front(); 
    sb_expected_temp = sb_expected_q.pop_front();
    
    if(sb_actual_temp == sb_expected_temp)begin
      if(`PASS_COUNT_FULL)begin
        `uvm_info(get_type_name(),$sformatf(" PASSED ACTUAL DATA = %0h,EXPECTED DATA = %0h",sb_actual_temp,sb_expected_temp),UVM_NONE)
      end
      else
        pass_count++; 
    end
    else
      `uvm_error(get_type_name(),$sformatf(" FAILED ACTUAL DATA = %0h,EXPECTED DATA = %0h",sb_actual_temp,sb_expected_temp));
  end
endtask

//extract_phase
function void AHB_UVC_scoreboard_c::extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  //as per the macro printing the pass count
  if(!`PASS_COUNT_FULL)begin
    `uvm_info(get_type_name(),$sformatf(" \n\tPASSED || NUMBER OF PASSED B2B WRITE AND READ TRANSACTIONS = %0d\n",pass_count),UVM_NONE);
  end
endfunction : extract_phase

function void AHB_UVC_scoreboard_c::write_ahb_mstr_mon(AHB_UVC_master_transaction_c mtrans_h);
  `uvm_info(get_type_name(),$sformatf("Transaction sampled by master monitor = %s\n",mtrans_h.sprint),UVM_NONE);
  if(mtrans_h.hwrite)
    ref_mem[mtrans_h.haddr] = mtrans_h.hwdata[0];
  else
    sb_expected_q.push_back(ref_mem[mtrans_h.haddr]);
    //`uvm_info(get_type_name(),$sformatf("===========$$ ref_mem = %p",ref_mem),UVM_NONE)
endfunction : write_ahb_mstr_mon

function void AHB_UVC_scoreboard_c::write_ahb_slv_mon(AHB_UVC_slave_transaction_c strans_h);
  `uvm_info(get_type_name(),$sformatf("Transaction sampled by salve monitor = %s\n",strans_h.sprint),UVM_NONE);
  sb_actual_q.push_back(strans_h.hrdata);
endfunction : write_ahb_slv_mon 
`endif

