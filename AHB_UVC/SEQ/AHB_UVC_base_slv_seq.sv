// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_monitor_c.sv
// Title        : AHB_UVC slave monitor class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------


class AHB_UVC_base_slv_seq extends uvm_sequence #(AHB_UVC_slave_transaction_c);

  //factroy registration

  `uvm_object_param_utils(AHB_UVC_base_slv_seq)


  `uvm_declare_p_sequencer(AHB_UVC_slave_sequencer_c)

  AHB_UVC_slave_transaction_c trans_q[$];

  extern function new(string name="AHB_UVC_base_slv_seq");
  extern task body();
  extern function void write(AHB_UVC_slave_transaction_c wr_req);
  extern function void read(AHB_UVC_slave_transaction_c rd_req);
   
endclass : AHB_UVC_base_slv_seq

//*****************************************************************************
//methods
//*****************************************************************************

//new function

function AHB_UVC_base_slv_seq::new(string name="AHB_UVC_base_slv_seq");

  super.new(name);

//  p_sequencer.slv_mem =AHB_UVC_slave_memory::type_id::create("slv_mem",null); ;

endfunction : new

//body method

task AHB_UVC_base_slv_seq::body();
          	             
endtask : body

//write

function void AHB_UVC_base_slv_seq::read(AHB_UVC_slave_transaction_c rd_req);

  bit [`HADDR_WIDTH-1:0] addr;
  bit [`HWDATA_WIDTH-1:0] data;
  int addr_offset;
// `uvm_info("SLAVE BASE SEQUENCE","INSIDE BASE SEQUENCE READ METHOD",UVM_MEDIUM)
  addr = rd_req.haddr;
  addr_offset = addr - ((int'(addr/(`HWDATA_WIDTH/8)))*(`HWDATA_WIDTH/8));

 // rd_req.print();

  if(!rd_req.hwrite && !rd_req.hresp_type) begin

  //  `uvm_info("SLAVE SEQUENCE","THIS IS INSIDE READ OPERATION",UVM_MEDIUM)
 
    if(rd_req.htrans_type!=BUSY) begin

      for(int i=0;i<(2**rd_req.hsize_type);i++) begin

        data[(addr_offset*8) +: 8] = p_sequencer.slv_mem.mem[addr];
      //  $display("THE DATA ---------%0h",p_sequencer.slv_mem.mem[addr]);

   //   `uvm_info(get_name(),$sformatf("data in memory %0h",p_sequencer.slv_mem.mem[addr]),UVM_NONE)
	addr_offset++;
        addr++;

      end

      rd_req.hrdata = data;

    end

    rd_req.print();

  end
    
endfunction : read

//read

function void AHB_UVC_base_slv_seq::write(AHB_UVC_slave_transaction_c wr_req);

  bit [`HADDR_WIDTH-1:0] addr;
  bit [`HWDATA_WIDTH-1:0] data;
  int addr_offset;

 `uvm_info("SLAVE BASE SEQUENCE","INSIDE BASE SEQUENCE WRITE METHOD",UVM_MEDIUM)
  trans_q.push_back(wr_req);

  if(!trans_q[0].hwrite)
    trans_q.delete(0);

  if(wr_req.hresp_type)
    trans_q.delete();

  if(trans_q.size()!=0) begin 
   if(trans_q[0].htrans_type==BUSY ||trans_q[0].htrans_type==IDLE)
     trans_q.delete(0);  
  end
 // $display("this is the size ------------------- %0d",$size(trans_q));
//  wr_req.print();

  if($size(trans_q)==2) begin

    addr = trans_q[0].haddr;
    addr_offset = addr - ((int'(addr/(`HWDATA_WIDTH/8)))*(`HWDATA_WIDTH/8));

    `uvm_info("SLAVE SEQUENCE","THIS IS BOTH ADDR AND DATA PHASE RECEIVED TRANSECTION",UVM_MEDIUM)
  //  wr_req.print();
  
    if(trans_q[0].hwrite && !trans_q[0].hresp_type) begin 

      `uvm_info("SLAVE SEQUENCE","THIS IS INSIDE WRITE OPERATION",UVM_MEDIUM)
      
      if(trans_q[0].htrans_type!=BUSY) begin 
        
      `uvm_info("SLAVE SEQUENCE","THIS IS INSIDE IF NOT BUSY",UVM_MEDIUM)
      	for(int i=0;i<(2**trans_q[0].hsize_type);i++) begin
            
          p_sequencer.slv_mem.mem[addr] = trans_q[1].slv_hwdata[(addr_offset*8) +: 8];
          $display("THE DATA-----------------------------------%0h",p_sequencer.slv_mem.mem[addr]);
	  addr_offset++;
          addr++;

        end

      end
   end 
      `uvm_info("SLAVE SEQUENCE","THIS IS SLAVE SENDING TRANSECTION",UVM_MEDIUM)       
      wr_req.print();
    									        
      if(trans_q[0].htrans_type==BUSY)
	     trans_q.delete(0);
      else if(wr_req.hresp_type) 
       trans_q.delete();

  end

endfunction : write
