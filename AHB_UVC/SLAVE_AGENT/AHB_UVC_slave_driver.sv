// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_driver_c.sv
// Title        : AHB_UVC slave driver class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slave_driver_c extends uvm_driver#(AHB_UVC_slave_transaction_c);
  `uvm_component_utils(AHB_UVC_slave_driver_c)    

  virtual AHB_UVC_interface slv_vif;
  // component constructor
  extern function new(string name = "AHB_UVC_slave_driver_c", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 

  // send to dut task 
  extern virtual task send_to_dut(AHB_UVC_slave_transaction_c req);
  
  //reset task
  extern virtual task reset();


endclass : AHB_UVC_slave_driver_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_slave_driver_c::new(string name = "AHB_UVC_slave_driver_c", uvm_component parent);
  super.new(name, parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_slave_driver_c::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build phase", UVM_HIGH)
  if(!uvm_config_db#(virtual AHB_UVC_interface)::get(this,"","uvc_if",slv_vif))
     `uvm_error(get_type_name(),"Not able to get the interface");
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_slave_driver_c::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_slave_driver_c::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_type_name(), "run phase", UVM_HIGH)

  wait(!slv_vif.hresetn)
  reset();
  
   forever begin
    fork
      begin
        wait(!slv_vif.hresetn);
      end
      
      forever begin
      @(posedge slv_vif.hclk);
        seq_item_port.get_next_item(req);
        send_to_dut(req);
        seq_item_port.item_done();
      end
    join_any
    disable fork;
    if(!slv_vif.hresetn)
      reset();
    wait(slv_vif.hresetn);
  end

endtask : run_phase

task AHB_UVC_slave_driver_c::send_to_dut(AHB_UVC_slave_transaction_c req);
  
  `uvm_info(get_type_name(), "Inside send_to_dut task", UVM_HIGH)
  //req.print();
    
  if(req.htrans_type == IDLE || req.htrans_type == BUSY)
    begin
    `uvm_info(get_name(),"--------------------------------------------in side htrans_type =IDLE or BUSY-----------------------",UVM_NONE);
      slv_vif.Hready_out <= 1;
      slv_vif.Hresp      <= hresp_enum'(OKAY); 
      slv_vif.Hrdata     <= req.hrdata;
    end

  else if(req.hresp_type) 
    begin
    `uvm_info(get_name(),"--------------------------------------------in side hresp_type =1-----------------------",UVM_NONE);
      slv_vif.Hresp       <= hresp_enum'(ERROR);
      slv_vif.Hrdata      <= '0;
      slv_vif.Hready_out  <= '0;
      @(posedge slv_vif.hclk);
      slv_vif.Hready_out  <= '1;
      slv_vif.Hresp       <= hresp_enum'(ERROR);
    end
  else
    begin
    `uvm_info(get_name(),"--------------------------------------------in side else begin -----------------------",UVM_NONE);
      slv_vif.Hready_out    <= req.hready_out;
      slv_vif.Hresp        <= req.hresp_type;
      slv_vif.Hrdata       <= req.hrdata;
      
    end

   if(!req.hready_out && !slv_vif.Hresp) begin
    `uvm_info(get_name(),"--------------------------------------------in side iffffff -----------------------",UVM_NONE);
    slv_vif.Hready_out <= '1;
    end
   else if(slv_vif.Hresp && slv_vif.Htrans==htrans_enum'(IDLE))
    `uvm_info(get_name(),"--------------------------------------------in side iffffff else  -----------------------",UVM_NONE);
    slv_vif.Hready_out <= '1;
endtask


task AHB_UVC_slave_driver_c::reset();
  slv_vif.Hready_out <='1;
  slv_vif.Hresp <= '0;
  slv_vif.Hrdata <= 0;
endtask
