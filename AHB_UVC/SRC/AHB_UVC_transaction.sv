// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_transaction.sv
// Title        : AHB_UVC transaction class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_transaction_c extends uvm_sequence_item;
    `uvm_object_utils(AHB_UVC_transaction_c)

    // object constructor
    extern function new(string name = "AHB_UVC_transaction_c");
  
    rand bit [(`HADDR_WIDTH -1):0] haddr;
    rand hburst_enum          hburst_type;
    rand hsize_enum            hsize_type;
    rand bit                       hwrite;
    rand bit [(`HWDATA_WIDTH -1):0]    hwdata[];
    bit[(`HRDATA_WIDTH -1):0]            Hrdata;
    hresp_enum                 hresp_type;
    rand int                    incr_size;

    rand bit [(`HBURST_WIDTH-1):0] beat_cnt;
    rand htrans_enum         htrans_type[];

  
  //constraints

    /* constraint for giving value to hburst */
    constraint transfer_num { (hburst_type == SINGLE) -> beat_cnt ==  1;
                              ((hburst_type == INCR4) ||(hburst_type == WRAP4)) -> beat_cnt == 4;  
                               ((hburst_type == INCR8) ||(hburst_type == WRAP8)) -> beat_cnt == 8;
                                ((hburst_type == INCR16) ||(hburst_type == WRAP16)) -> beat_cnt == 16;
                            }
    
    /* Constraint for allined address boundary */  
    constraint addr{haddr%(1<<hsize_type) ==0;}

    /* constraint for 1k address boundary  */
    constraint addr_boundary_limit{ haddr%1024 + ((1<<hsize_type)*beat_cnt) <= 1024; }
    
    //hsize should be less than data width

    constraint hsize_less_than_data_width{ hsize_type <= $clog2(`HWDATA_WIDTH/8); }        

    
    constraint hburst_data_cnt{
                        if(hburst_type==SINGLE)                        hwdata.size==1;
			                  if(hburst_type==INCR)                          hwdata.size==incr_size;
		                  	if(hburst_type==INCR4  || hburst_type==WRAP4)  hwdata.size==4;
			                  if(hburst_type==INCR8  || hburst_type==WRAP8)  hwdata.size==8;
                  			if(hburst_type==INCR16 || hburst_type==WRAP16) hwdata.size==16;
                                  }
 
    constraint fixed_htrans{ htrans_type.size() == hwdata.size(); 
                                    htrans_type[0] == NONSEQ;
				    
				    foreach(htrans_type[i])
				    { if(i>0) htrans_type[i] == SEQ;}}
    
endclass : AHB_UVC_transaction_c

//////////////////////////////////////////////////////////////////
// Method name        : new()
// Parameter Passed   : string and handle of parent class
// Returned Parameter : none
// Description        : component constructor
//////////////////////////////////////////////////////////////////

function AHB_UVC_transaction_c::new(string name = "AHB_UVC_transaction_c");
    super.new(name);
endfunction : new
