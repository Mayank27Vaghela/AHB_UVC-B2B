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

  //Instance of the AHB interface
  virtual AHB_UVC_interface uvc_if;
  
  AHB_UVC_master_transaction_c ahb_trans_h;
  
  bit[(`HADDR_WIDTH -1):0] hwdata_q[$]; 
  htrans_enum              htrans_q[$]; 

  htrans_enum              htrans_temp;
  htrans_enum              htrans_pri;
  bit [(`HADDR_WIDTH -1):0] l_addr;

  bit [(`HADDR_WIDTH -1):0] starting_addr;
  bit [(`HADDR_WIDTH -1):0] wrap_addr;

  int bytes_in_burst;

  bit get;

  int no_of_beat;

  int timeout_count;

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
           $display($realtime,"Get next item called");
           //tra = 0;
           get = 1;
           push_to_local_q();
           $display("hwdata_q = %p",hwdata_q);
           l_addr = req.haddr;
           no_of_beat = req.htrans_type.size(); 
           bytes_in_burst = (2**(int'(req.hsize_type)))*(no_of_beat);
           starting_addr = ((int'(req.haddr/(bytes_in_burst)))*(bytes_in_burst));
           wrap_addr     = starting_addr + (2**(int'(req.hsize_type)))*(no_of_beat);
           
           fork : timeout
           begin
             repeat(no_of_beat)begin
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
                 address_phase();
               end
               else begin
                 @(`MSTR_DRV_CB);  
                 `MSTR_DRV_CB.Htrans <= '0;
                  break;
               end // else
               //end
             //end
             //begin
               //@(`MSTR_DRV_CB);
               //repeat(no_of_beat)begin
                //if(sync)begin
                 //#2;
                 //@(`MSTR_DRV_CB);
                   //hwdata_temp = hwdata_q.pop_front();
                    //sync = 1'b1;
               if(!`MSTR_DRV_CB.Hresp)begin
                      //htrans_pri = htrans_temp;
                     //if(!tra)begin
                      //htrans_pri = htrans_temp; 
                      //tra = 1;
                     //end                        
                 if(htrans_pri != htrans_enum'(BUSY) && htrans_pri != htrans_enum'(IDLE)) begin
                   $display("htrans_pri = %p",htrans_pri);
                   data_phase();
                 end //if 
               end //if
               else
                 break;
                //end
             end //repeat
           end //begin
        
           begin 
             forever begin 
               @(posedge uvc_if.hclk)
                if(`MSTR_DRV_CB.Hready_out == 1)
                  timeout_count = 0;
                else 
                  timeout_count++;
                if(timeout_count > 16)
                  break;
             end
           end
           join_any
             //end
           //join_any
           if(get)begin
             seq_item_port.item_done(req);
             get = 1'b0;
           end //if 
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
       //disable run.in;
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
  `MSTR_DRV_CB.Htrans <= htrans_temp;
  `MSTR_DRV_CB.Haddr  <= req.haddr;
  `MSTR_DRV_CB.Hwrite <= req.hwrite;
  `MSTR_DRV_CB.Hburst <= req.hburst_type;
  `MSTR_DRV_CB.Hsize  <= req.hsize_type;
  //wait(`MSTR_DRV_CB.Hready_out);
endtask : address_phase

task AHB_UVC_master_driver_c::data_phase();
  //if(htrans_temp != htrans_enum'(BUSY) && htrans_temp!= htrans_enum'(IDLE))begin   
 $display($realtime,".......DATA_PHASE htrans = %0p",htrans_temp);
    //`MSTR_DRV_CB.Hwdata  <= hwdata_q.pop_front();
    `MSTR_DRV_CB.Hwdata  <= hwdata_q.pop_front();
  //end
  wait(`MSTR_DRV_CB.Hready_out);
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
`endif

