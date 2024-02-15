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
  bit [(`HADDR_WIDTH -1):0] l_addr;

  bit [(`HADDR_WIDTH -1):0] starting_addr;
  bit [(`HADDR_WIDTH -1):0] wrap_addr;

  int beat = 1;

  int bytes_in_burst;

  bit first_beat;

  bit get;

  int no_of_beat;

  //used for index of the current transaction
  int i;

  bit sync;

  int count;

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
       fork : run 
         begin
            wait(!uvc_if.hresetn);
         end

         begin
          first_beat = 1'b1;
          forever begin
           seq_item_port.get_next_item(req);
           
           //if(count == 0)
           get = 1;
           beat = 1;
           //$cast(ahb_trans_h,req.clone());
           push_to_local_q();
           l_addr = req.haddr;
           //forever begin
           no_of_beat = req.htrans_type.size(); 
           count = no_of_beat;
           bytes_in_burst = (2**(int'(req.hsize_type)))*(no_of_beat);
           starting_addr = ((int'(req.haddr/(bytes_in_burst)))*(bytes_in_burst));
           wrap_addr     = starting_addr + (2**(int'(req.hsize_type)))*(no_of_beat);
           fork
             begin
               repeat(no_of_beat)begin
                 //@(posedge uvc_if.hclk);
                 @(`MSTR_DRV_CB);
                 //if(MSTR_DRV_CB.hresetn)begin
                    htrans_temp = htrans_q.pop_front();
                    sync = 1'b1;
                 //end
                   if(!`MSTR_DRV_CB.Hresp)begin
                     if(htrans_temp != htrans_enum'(NONSEQ))begin
                        if(htrans_temp != htrans_enum'(BUSY) && htrans_temp!= htrans_enum'(IDLE))begin
                          //ahb_trans_h.haddr = address();
                          req.haddr = address();
                          l_addr = req.haddr;
                        end
                     end
                     //else begin
                     //  ahb_trans_h.haddr = req.haddr;
                       //beat = 0;
                     //end
                     //fork
                     address_phase();
                   end
                   else begin
                      @(`MSTR_DRV_CB);  
                      `MSTR_DRV_CB.Htrans <= '0;
                       break;
                   end
                 //i++;
               end
             end
             begin
              //begin
               @(`MSTR_DRV_CB);
               repeat(no_of_beat)begin
                  //if(sync == 1)begin  
                //wait(sync ==1);
                @(`MSTR_DRV_CB);
                   if(!`MSTR_DRV_CB.Hresp)begin
                     //if(htrans_temp != htrans_enum'(NONSEQ))begin
                      //#1;
                      if(htrans_temp != htrans_enum'(BUSY) && htrans_temp != htrans_enum'(IDLE)) begin
                        data_phase();
                        sync = 1'b0;
                      end
                      //else
                       //end
                       //join_any
                     //end
                     first_beat = 1'b0;
                   end
                   else
                     break;
                  //count--;
               end
               //end
             end
           join_any
           //end
           //wait((hwdata_q.size)==0);
           if(get)begin
             seq_item_port.item_done(req);
             get = 1'b0;
           end
          end
         end
       join_any
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
  `MSTR_DRV_CB.Htrans <= htrans_temp;
  `MSTR_DRV_CB.Haddr  <= req.haddr;
  `MSTR_DRV_CB.Hwrite <= req.hwrite;
  `MSTR_DRV_CB.Hburst <= req.hburst_type;
  `MSTR_DRV_CB.Hsize  <= req.hsize_type;
  wait(`MSTR_DRV_CB.Hready_out);
endtask : address_phase

task AHB_UVC_master_driver_c::data_phase();
  if(htrans_temp != htrans_enum'(BUSY) && htrans_temp!= htrans_enum'(IDLE))begin   
    `MSTR_DRV_CB.Hwdata  <= hwdata_q.pop_front();
  end
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
    //return l_addr;
    l_addr = l_addr + (2**(req.hsize_type));
    return l_addr;
    //ahb_trans_h.haddr = l_addr;
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

