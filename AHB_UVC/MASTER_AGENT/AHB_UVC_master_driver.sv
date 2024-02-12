// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_driver_c.sv
// Title        : AHB_UVC master driver class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_driver_c extends uvm_driver#(AHB_UVC_transaction_c);
  `uvm_component_utils(AHB_UVC_master_driver_c)    

  //Instance of the AHB interface
  virtual AHB_UVC_interface uvc_if;
  
  AHB_UVC_transaction_c ahb_trans_h;
  
  bit[(`HADDR_WIDTH -1):0] hwdata_q[$]; 
  htrans_enum              htrans_q[$]; 

  bit [(`HADDR_WIDTH -1):0] l_addr;

  bit [(`HADDR_WIDTH -1):0] starting_addr;
  bit [(`HADDR_WIDTH -1):0] wrap_addr;

  int beat = 1;

  int bytes_in_burst;

  bit first_beat;

  bit get;

  // component constructor
  extern function new(string name = "AHB_UVC_master_driver_c", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    

  // component run phase
  extern virtual task run_phase(uvm_phase phase); 

  extern function void reset(); 

  extern task address_phase(); 

  extern task data_phase(); 

  extern task push_to_local_q(); 

  extern function bit [(`HADDR_WIDTH -1):0] address(); 

endclass : AHB_UVC_master_driver_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_driver_c::new(string name = "AHB_UVC_master_driver_c", uvm_component parent);
    super.new(name, parent);
endfunction : new

//////////////////////////////////////////////////////////////////
// Method name        : build_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for building components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_driver_c::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build phase", UVM_HIGH)
    if(!uvm_config_db#(virtual AHB_UVC_interface)::get(this,"","uvc_if",uvc_if))
      `uvm_error(get_type_name(),"Not able to get interface");
endfunction : build_phase

//////////////////////////////////////////////////////////////////
// Method name        : connect_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : for connecting components
//////////////////////////////////////////////////////////////////
function void AHB_UVC_master_driver_c::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "connect phase", UVM_HIGH)
endfunction : connect_phase

//////////////////////////////////////////////////////////////////
// Method name        : run_phase()
// Parameter Passed   : handle of class uvm_phase
// Returned Parameter : none
// Description        : post build/connect phase
//////////////////////////////////////////////////////////////////
task AHB_UVC_master_driver_c::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "run phase", UVM_HIGH)
    forever begin
       fork : run 
         begin
            wait(!uvc_if.hresetn);
         end

         begin
          forever begin
           get = 1;
           seq_item_port.get_next_item(req);
           //$display($realtime,"get_next_item");
           first_beat = 1'b1;
           beat = 1;
           //forever begin
           $cast(ahb_trans_h,req.clone());
           push_to_local_q();
           //$display("hwdata_q = %0p",hwdata_q);
           l_addr = req.haddr;
           //$display("initial haddr = %0h",l_addr);
           //forever begin
           bytes_in_burst = (2**(int'(req.hsize_type)))*(req.beat_cnt);
           //$display("bytes_in_burst = %0d",bytes_in_burst);
           starting_addr = ((int'(req.haddr/(bytes_in_burst)))*(bytes_in_burst));
           wrap_addr     = starting_addr + (2**(int'(req.hsize_type)))*(req.beat_cnt);
           //$display("the the  = %0h",(req.haddr % ((req.beat_cnt)*(bytes_in_burst))));
           //$display("starting add = %0h",starting_addr);
           //$display("wrap_addr add = %0h",wrap_addr);
           fork
             begin
               repeat(req.beat_cnt)begin
                 @(posedge uvc_if.hclk);
                 //$display("first_beat = %0d",first_beat);
                 if(!beat)begin
                   //$display("Inside the beatt...");
                   ahb_trans_h.haddr = address();
                   l_addr = ahb_trans_h.haddr;
                 end
                 else begin
                   ahb_trans_h.haddr = req.haddr;
                   beat = 0;
                 end
                 //$display("returned haddr = %0h", ahb_trans_h.haddr);
                 //fork
                 address_phase();
                 //end
               end
             end
             begin
              //begin
               repeat(req.beat_cnt+1)begin
                @(posedge uvc_if.hclk);
                if(!first_beat)begin
                    data_phase();
                  //end
                  //join_any
                end
                 first_beat = 1'b0;
               end
             end
           join
           //end
           //wait((hwdata_q.size)==0);
           $display($realtime,"item_done called");
           seq_item_port.item_done(req);
           get = 1'b0;
          end
         end
       join_any
       $display($realtime,"join_any");
       if(get)begin
         seq_item_port.item_done(req);
         get = 1'b0;
       end
       reset();
       //disable run.in;
       disable run;
       wait(uvc_if.hresetn);
    end
endtask : run_phase

function void AHB_UVC_master_driver_c::reset();
 uvc_if.Haddr    <= '0;
 uvc_if.Hburst   <= '0;
 uvc_if.Hprot    <= '0;
 uvc_if.Hsize    <= '0;
 uvc_if.Htrans   <= '0;
 uvc_if.Hwdata   <= '0;
 uvc_if.Hwrite   <= '0;
endfunction : reset

task AHB_UVC_master_driver_c::address_phase();
  wait(uvc_if.Hready_out);
  uvc_if.Htrans  <= htrans_q.pop_front();
  uvc_if.Haddr   <= ahb_trans_h.haddr;
  uvc_if.Hwrite <= req.hwrite;
  uvc_if.Hburst <= req.hburst_type;
  uvc_if.Hsize  <= req.hsize_type;
endtask : address_phase

task AHB_UVC_master_driver_c::data_phase();
  wait(uvc_if.Hready_out);
  uvc_if.Hwdata  <= hwdata_q.pop_front();
  //$display("data_after pop = %p",hwdata_q);
endtask : data_phase

task AHB_UVC_master_driver_c::push_to_local_q();
  if(req.hwrite)begin
    foreach(req.hwdata[i])begin
      hwdata_q.push_back(req.hwdata[i]);
    end
  end
  else
    hwdata_q.push_back(0);
  foreach(req.hwdata[i])begin
    htrans_q.push_back(req.htrans_type[i]);
  end
endtask : push_to_local_q

function bit [(`HADDR_WIDTH -1):0] AHB_UVC_master_driver_c::address();
  if((req.hburst_type)%2 != 0)begin
    //$display("Inside INCR");
    //$display("haddr = %0h",ahb_trans_h.haddr);
    //return l_addr;
    //$display("THE DOOM = %0d",(2**(int'(req.hsize_type))));
    l_addr = l_addr + (2**(req.hsize_type));
    return l_addr;
    //ahb_trans_h.haddr = l_addr;
  end
  else begin
    l_addr = l_addr + (2**(req.hsize_type));
    //$display("-----WRAP haddr = %0h",l_addr);
    //$display("WRAP ADDR = %0h",wrap_addr);
    if(l_addr>=wrap_addr)begin
      //$display("Inside WRAP");
      l_addr  = starting_addr;
      return l_addr;
    end
    else begin
      //$display("inside else Wrap l_addr = %0h",l_addr);
      return l_addr;
    end
  end
endfunction :address

