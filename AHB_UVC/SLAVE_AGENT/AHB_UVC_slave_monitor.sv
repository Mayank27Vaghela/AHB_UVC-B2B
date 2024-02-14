// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_monitor_c.sv
// Title        : AHB_UVC slave monitor class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slave_monitor_c extends uvm_monitor;
  `uvm_component_utils(AHB_UVC_slave_monitor_c)    

  // analysis port for connecting the slave coverage and slave memory
  uvm_analysis_port#(AHB_UVC_slave_transaction_c) item_collected_port;
  virtual AHB_UVC_interface slv_vif;
  AHB_UVC_slave_transaction_c ahb_trans;
  uvm_analysis_port #(AHB_UVC_slave_transaction_c) mon_ap_mem;
  // component constructor
  extern function new(string name = "AHB_UVC_slave_monitor_c", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 
  
  //address phase 
  extern virtual  task addr_phase();
  
  //data_phase
  extern virtual task data_phase();

endclass : AHB_UVC_slave_monitor_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_slave_monitor_c::new(string name = "AHB_UVC_slave_monitor_c", uvm_component parent);
  super.new(name, parent);
   mon_ap_mem = new("mon_ap_mem",this);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
////////////////////////////////////// ahb_trans=ahb_slv_trans::type_id::create("ahb_trans");////////////////////////////
function void AHB_UVC_slave_monitor_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
  item_collected_port = new("item_collected_port",this);
   ahb_trans=AHB_UVC_slave_transaction_c::type_id::create("ahb_trans");
   if(!uvm_config_db#(virtual AHB_UVC_interface)::get(this,"","uvc_if",slv_vif))
     `uvm_error(get_type_name(),"Not able to get the interface");
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_slave_monitor_c::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
////////////////////////////////////////////////////////////////////

task AHB_UVC_slave_monitor_c::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)
    
  forever begin
    fork 
      forever begin
        @(posedge slv_vif.hclk);
        fork 
          addr_phase();
          data_phase();
        join_any
      end
      begin
        wait(!slv_vif.hresetn);
      end
    join_any
    disable fork;
    wait(slv_vif.hresetn);
  end
  
endtask : run_phase

task AHB_UVC_slave_monitor_c::addr_phase();

  AHB_UVC_slave_transaction_c trans;

  `uvm_info(get_type_name(), "in address phase of Slave monitor ", UVM_HIGH)
  if(slv_vif.Hready_in && slv_vif.hresetn)begin
      #1;
      ahb_trans.haddr = slv_vif.Haddr;      
      ahb_trans.hwrite = slv_vif.Hwrite;      
      ahb_trans.hburst_type = hburst_enum'(slv_vif.Hburst);
      ahb_trans.hsize_type = hsize_enum'(slv_vif.Hsize);
      ahb_trans.hresp_type = hresp_enum'(slv_vif.Hresp);
      ahb_trans.htrans_type = htrans_enum'(slv_vif.Htrans);      
     //ahb_trans.address_phase = 1'b1;
      
      mon_ap_mem.write(ahb_trans);
      `uvm_info(get_name(),$sformatf("Slave monitor addrt phase print :\n %s",ahb_trans.sprint()),UVM_NONE)
  end
endtask : addr_phase

task AHB_UVC_slave_monitor_c::data_phase();
      
  AHB_UVC_slave_transaction_c trans;

  `uvm_info(get_type_name(), "in data phase of Slave monitor ", UVM_HIGH)
  @(posedge slv_vif.hclk);
  
  if(slv_vif.Hready_in && slv_vif.hresetn)begin
    ahb_trans.slv_hwdata      = slv_vif.Hwdata;
    ahb_trans.hrdata      = slv_vif.Hrdata;
    ahb_trans.hresp_type  = hresp_enum'(slv_vif.Hresp); 
    ahb_trans.hready_out  = slv_vif.Hready_out;
    //ahb_trans.data_phase = 1'b1;

 //   mon_ap_mem.write(ahb_trans);
    
  end

endtask : data_phase
