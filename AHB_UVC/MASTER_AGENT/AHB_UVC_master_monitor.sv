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
    uvm_analysis_port#(AHB_UVC_transaction_c) item_collected_port;

    //interface instance
    virtual AHB_UVC_interface uvc_if;

    //transaction handle
    AHB_UVC_transaction_c trans_h;

    //queue to store wdata
    AHB_UVC_transaction_c hwdata_q[$];

    //queue to store address
    AHB_UVC_transaction_c trans_q[$];

    //first beat
    bit first_beat;

    int i; 

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
      `uvm_error(get_type_name(),"NOt able to get the interface");
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
    first_beat  = 1'b1;
    $display("monitor");
    forever begin
       $display("in monitor");
       trans_h = AHB_UVC_transaction_c::type_id::create("trans_h");
       @(posedge uvc_if.hclk);
       i++;
       fork
         address_phase();
         begin
           if(!first_beat)
             data_phase();
         end
       join_none
    end
endtask : run_phase

task AHB_UVC_master_monitor_c::address_phase();
  //trans_h.htrans_type = htrans_enum'(uvc_if.Htrans[0]);
  //haddr_q.push_back(uvc_if.Haddr);
  trans_h.haddr       = uvc_if.Haddr;
  trans_h.hwrite      = uvc_if.Hwrite;
  trans_h.hburst_type = hburst_enum'(uvc_if.Hburst);
  trans_h.hsize_type  = hsize_enum'(uvc_if.Hsize);
  trans_q.push_back(trans_h);
  first_beat = 1'b0;
  $display("trans_q = %p",trans_q);
endtask : address_phase

task AHB_UVC_master_monitor_c::data_phase();
  //hwdata_q.push_back(uvc_if.Hwdata);
  trans_q[i-1].hwdata[i-1] = uvc_if.Hwdata;
endtask : data_phase
