// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_monitor.sv
// Title        : AHB_UVC master monitor class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_monitor_c extends uvm_monitor;
    `uvm_component_utils(AHB_UVC_master_monitor_c)    

    // monitor for master coverage and scoreboard connection
    uvm_analysis_port#(AHB_UVC_master_transaction_c) item_collected_port;

    //interface instance
    virtual AHB_UVC_interface uvc_if;

    //transaction handle
    AHB_UVC_master_transaction_c trans_h;

    // component constructor
    extern function new(string name = "AHB_UVC_master_monitor_c", uvm_component parent);

    // component build phase
    extern virtual function void build_phase(uvm_phase phase);

    // component connect phase
    extern virtual function void connect_phase(uvm_phase phase);    

    // component run phase
    extern virtual task run_phase(uvm_phase phase); 

    //sample function
    extern task address_phase();
    extern task data_phase();
endclass : AHB_UVC_master_monitor_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_monitor_c::new(string name = "AHB_UVC_master_monitor_c", uvm_component parent);
    super.new(name, parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_monitor_c::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build phase", UVM_HIGH)
    item_collected_port = new("item_collected_port",this);
    if(!uvm_config_db#(virtual AHB_UVC_interface)::get(this,"","uvc_if",uvc_if))
      `uvm_error(get_type_name(),"Not able to get the interface");
      trans_h = AHB_UVC_master_transaction_c::type_id::create("trans_h");
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_monitor_c::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_master_monitor_c::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
  forever begin
    @(`MSTR_DRV_CB);
    fork 
      begin
        wait(!uvc_if.hresetn); 
      end

      begin
        forever begin
          @(`MSTR_DRV_CB);
          fork 
            address_phase();
            data_phase(); 
          join_any
        end
      end
    join_any
    disable fork;
    wait(uvc_if.hresetn);
  end
endtask : run_phase

task AHB_UVC_master_monitor_c::address_phase();
  trans_h.haddr       = `MSTR_MON_CB.Haddr;
  trans_h.hwrite      = `MSTR_MON_CB.Hwrite;
  trans_h.hburst_type = hburst_enum'(`MSTR_MON_CB.Hburst);
  trans_h.hsize_type  = hsize_enum'(`MSTR_MON_CB.Hsize);
endtask : address_phase

task AHB_UVC_master_monitor_c::data_phase();
  @(`MSTR_DRV_CB);
    trans_h.hwdata = '{`MSTR_MON_CB.Hwdata};

    if((`MSTR_MON_CB.Hready_out) && (`MSTR_MON_CB.Htrans != 00) && (`MSTR_MON_CB.Htrans != 01))
      item_collected_port.write(trans_h);
    //trans_h.print();
endtask : data_phase
