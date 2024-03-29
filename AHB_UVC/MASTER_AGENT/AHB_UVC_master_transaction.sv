// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_master_transaction.sv
// Title        : AHB_UVC master_transaction class
// Project      : AHB_UVC VIP
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_master_transaction_c extends uvm_sequence_item;

    // object constructor
    extern function new(string name = "AHB_UVC_master_transaction_c");

    rand bit [(`HADDR_WIDTH -1):0] haddr;
    rand hburst_enum          hburst_type;
    rand hsize_enum            hsize_type;
    rand bit                       hwrite;
    rand bit [(`HWDATA_WIDTH -1):0]    hwdata[];
    bit[(`HRDATA_WIDTH -1):0]            hrdata;
    hresp_enum                 hresp_type;
    rand int                    incr_size;

    rand bit [(`HBURST_WIDTH-1):0] beat_cnt;
    rand htrans_enum         htrans_type[];
  
    rand int busy_index;

    rand htrans_enum busy_queue[$];

    rand int enb_hsize_change_in_between_burst_cb;

    rand int enb_hburst_change_in_between_burst_cb;

    rand bit enb_x_drv;

    `uvm_object_utils_begin(AHB_UVC_master_transaction_c)
        `uvm_field_int(haddr,UVM_ALL_ON)
        `uvm_field_int(hwrite,UVM_ALL_ON)
        `uvm_field_array_int(hwdata,UVM_ALL_ON)
        `uvm_field_int(hrdata,UVM_ALL_ON)
        `uvm_field_enum(hburst_enum,hburst_type,UVM_ALL_ON)
        `uvm_field_enum(hsize_enum,hsize_type,UVM_ALL_ON)
        `uvm_field_array_enum(htrans_enum,htrans_type,UVM_ALL_ON)
        `uvm_field_int(busy_index,UVM_ALL_ON)
    `uvm_object_utils_end
     
  //constraints

   /* constraint for giving value to hburst 
    constraint transfer_num { (hburst_type == SINGLE) -> beat_cnt ==  1;
                              ((hburst_type == INCR4) ||(hburst_type == WRAP4)) -> beat_cnt == 4;  
                               ((hburst_type == INCR8) ||(hburst_type == WRAP8)) -> beat_cnt == 8;
                                ((hburst_type == INCR16) ||(hburst_type == WRAP16)) -> beat_cnt == 16;
                            }*/
    
    /* Constraint for allined address boundary */  
    constraint addr{haddr%(1<<hsize_type) ==0;}

    
    //hsize should be less than data width

    constraint hsize_less_than_data_width{ hsize_type <= $clog2(`HWDATA_WIDTH/8); }        

    
    constraint hburst_data_cnt{
                        if(hburst_type==SINGLE)                        hwdata.size==1;
			                  if(hburst_type==INCR)                          hwdata.size==incr_size;
		                  	if(hburst_type==INCR4  || hburst_type==WRAP4)  hwdata.size==4;
			                  if(hburst_type==INCR8  || hburst_type==WRAP8)  hwdata.size==8;
                  			if(hburst_type==INCR16 || hburst_type==WRAP16) hwdata.size==16;
                                  }
    /*fixed trans type */ 
    constraint fixed_htrans{ htrans_type.size() == hwdata.size(); 
                             htrans_type[0] == NONSEQ;	    
				                     foreach(htrans_type[i])
				                     { if(i>0) htrans_type[i] == SEQ;}}

    /* constraint for 1k address boundary  */
    constraint addr_boundary_limit{ haddr%1024 + ((1<<hsize_type)*hwdata.size()) <= 1024; }

    constraint no_of_busy {soft busy_queue.size() == 0;}

    constraint busy_trans_queue {foreach(busy_queue[i])
                                  { 
                                    busy_queue[i] == htrans_enum'(BUSY);
                                  }
                                }

    constraint hsize_err {soft enb_hsize_change_in_between_burst_cb == 0;}

    constraint x_drv_err {soft enb_x_drv == 0;}

    constraint hburst_err {soft enb_hburst_change_in_between_burst_cb == 0;}

    extern function void post_randomize();
endclass : AHB_UVC_master_transaction_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////
function AHB_UVC_master_transaction_c::new(string name = "AHB_UVC_master_transaction_c");
    super.new(name);
endfunction : new

function void AHB_UVC_master_transaction_c::post_randomize();
   htrans_enum temp_trans_q[$];   
   temp_trans_q = htrans_type;
   //foreach(busy_queue[i])begin
   repeat(busy_queue.size())begin
     temp_trans_q.insert(busy_index,busy_queue.pop_front());
   end
   htrans_type = temp_trans_q;
endfunction : post_randomize
   
