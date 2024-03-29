// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_driver_c.sv
// Title        : AHB_UVC master driver class
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

`ifndef AHB_UVC_MASTER_DRIVER_C
`define AHB_UVC_MASTER_DRIVER_C
class AHB_UVC_master_driver_c extends uvm_driver#(AHB_UVC_master_transaction_c);
  `uvm_component_utils(AHB_UVC_master_driver_c)
  `uvm_register_cb(AHB_UVC_master_driver_c,AHB_UVC_master_driver_cb);  

  //Instance of the AHB interface
  virtual AHB_UVC_interface uvc_if;
  
  //Master trasnaction class handle
  AHB_UVC_master_transaction_c ahb_trans_h;
  
  //Hwdata data queue
  bit[(`HADDR_WIDTH -1):0] hwdata_q[$]; 
  
  //Htrans queue
  htrans_enum              htrans_q[$]; 

  //htrans enum instance
  htrans_enum              htrans_temp;

  //htrans enum
  htrans_enum              htrans_pri;

  //local address(new address)
  bit [(`HADDR_WIDTH -1):0] l_addr;

  //Starting address
  bit [(`HADDR_WIDTH -1):0] starting_addr;

  //Wrap address
  bit [(`HADDR_WIDTH -1):0] wrap_addr;

  //Total bytes in a burst
  int bytes_in_burst;

  //Used to sync the get_next_item and item_done call
  bit get;

  //Total number of beats in a transaction
  int no_of_beat;

  //Timeout for Hready_out wait
  int timeout_count;

  //Used to synchronize the hresp
  bit b;

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

  extern function void x_drive_err();
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
    `uvm_info("mstr_drv", "connect phase", UVM_HIGH)
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
       fork
         begin
            wait(!uvc_if.hresetn);
         end //reset

         begin
          forever begin
           seq_item_port.get_next_item(req);
           get = 1;
           `uvm_info(get_type_name(),$sformatf("get transaction = %s",req.sprint),UVM_NONE);
           if(!req.enb_x_drv)
             push_to_local_q();
           `uvm_do_callbacks(AHB_UVC_master_driver_c,AHB_UVC_master_driver_cb,change_burst_inbet_err(htrans_q)); 
           l_addr = req.haddr;
           no_of_beat = req.htrans_type.size(); 
           bytes_in_burst = (2**(int'(req.hsize_type)))*(no_of_beat);
           starting_addr = ((int'(req.haddr/(bytes_in_burst)))*(bytes_in_burst));
           wrap_addr     = starting_addr + (2**(int'(req.hsize_type)))*(no_of_beat);
           
           fork
           begin
             for(int i=1;i<=no_of_beat;i++)begin
               @(`MSTR_DRV_CB);
               htrans_pri = htrans_temp;
               htrans_temp = htrans_q.pop_front();
               if(!`MSTR_DRV_CB.Hresp)begin
                 if(htrans_temp != htrans_enum'(NONSEQ))begin
                   if(htrans_temp != htrans_enum'(BUSY) && htrans_temp!= htrans_enum'(IDLE))begin
                     req.haddr = address();
                     l_addr = req.haddr;
                   end //if
                 end //if
                 if(i == req.enb_hsize_change_in_between_burst_cb)
                   req.hsize_type = BYTE;
                 
                 if(i == req.enb_hburst_change_in_between_burst_cb)
                   req.hburst_type = INCR16;

                 if(!req.enb_x_drv)
                   address_phase();
                 else 
                   x_drive_err();

                 if(htrans_pri != htrans_enum'(BUSY) && htrans_pri != htrans_enum'(IDLE)) begin
                   if(!req.enb_x_drv)
                     data_phase();
                   else
                     x_drive_err();
                end //if 
               end //if
               else begin
                 `MSTR_DRV_CB.Htrans <= '0;
                 b = 1;
                 break;
               end // else
             end //for
           end //begin
        
           begin 
             forever begin 
               @(posedge uvc_if.hclk);

                if(`MSTR_DRV_CB.Hready_out == 1)
                  timeout_count = 0;
                else 
                  timeout_count++;
                if(timeout_count > 16)begin
                  `uvm_error(get_type_name(),"TIMEOUT OCCURED! - A slave can not hold Hready_out more than 16 clock cycles.");
                  timeout_count = 0;
                  htrans_q.delete();
                  hwdata_q.delete();
                  break;
                end
             end
           end
           join_any
           if(get)begin
             seq_item_port.item_done(req);
             get = 1'b0;
           end //if 
          if(b==1)begin
            b = 0;
            break;
          end
          end //forever
         end //begin
       join_any
       disable fork;
       reset();
       htrans_q.delete();
       hwdata_q.delete();
       if(get)begin
         seq_item_port.item_done(req);
         get = 1'b0;
       end //if
       wait(uvc_if.hresetn);
    end //forever
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
  wait(`MSTR_DRV_CB.Hready_out);
  `MSTR_DRV_CB.Htrans <= htrans_temp;
  `MSTR_DRV_CB.Haddr  <= req.haddr;
  `MSTR_DRV_CB.Hwrite <= req.hwrite;
  `MSTR_DRV_CB.Hburst <= req.hburst_type;
  `MSTR_DRV_CB.Hsize  <= req.hsize_type;
endtask : address_phase

task AHB_UVC_master_driver_c::data_phase();
  wait(`MSTR_DRV_CB.Hready_out);
  `MSTR_DRV_CB.Hwdata  <= hwdata_q.pop_front();
endtask : data_phase

task AHB_UVC_master_driver_c::push_to_local_q();
  if(req.hwrite)begin
    foreach(req.hwdata[i])begin
      hwdata_q.push_back(req.hwdata[i]);
    end
  end
  else begin
    repeat(req.hwdata.size())begin
      hwdata_q.push_back(0);
    end
  end

  foreach(req.htrans_type[i])begin
    htrans_q.push_back(req.htrans_type[i]);
  end
endtask : push_to_local_q

function bit [(`HADDR_WIDTH -1):0] AHB_UVC_master_driver_c::address();
  if((req.hburst_type)%2 != 0)begin
    l_addr = l_addr + (2**(req.hsize_type));
    return l_addr;
  end
  else begin
    l_addr = l_addr + (2**(req.hsize_type));
    if(l_addr>=wrap_addr)begin
      l_addr  = starting_addr;
      return l_addr;
    end
    else begin
      return l_addr;
    end
  end
endfunction :address

function void AHB_UVC_master_driver_c::x_drive_err();
  `MSTR_DRV_CB.Htrans <= 'hx;
  `MSTR_DRV_CB.Haddr  <= 'hx;
  `MSTR_DRV_CB.Hwrite <= 'hx;
  `MSTR_DRV_CB.Hburst <= 'hx;
  `MSTR_DRV_CB.Hsize  <= 'hx;
  `MSTR_DRV_CB.Hwdata <= 'hx;
endfunction : x_drive_err
`endif


