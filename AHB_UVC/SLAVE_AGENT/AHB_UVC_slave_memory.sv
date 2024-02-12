// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_slave_memory.sv
// Title        : AHB_UVC slave monitor class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

class AHB_UVC_slave_memory extends uvm_component;
  `uvm_component_utils(AHB_UVC_slave_memory)

  uvm_analysis_export#(AHB_UVC_slave_transaction_c) item_export;
   
  /** TLM fifo for storing the transactions from the monitor*/
  uvm_tlm_analysis_fifo#(AHB_UVC_slave_transaction_c) item_fifo;
  
  //memory for reactive slave mode
  bit [`HWDATA_WIDTH - 1:0] mem [`MEM_DEPTH];

  // component constructor
  extern function new(string name = "AHB_UVC_slave_memory", uvm_component parent);

  // component build phase
  extern virtual function void build_phase(uvm_phase phase);

  // component connect phase
  extern virtual function void connect_phase(uvm_phase phase);    
  
  // component run phase
  //extern virtual task run_phase(uvm_phase phase);

endclass

  /** Class constructor*/
  function AHB_UVC_slave_memory::new(string name = "AHB_UVC_slave_memory",uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  /** Build_phase*/
  function void AHB_UVC_slave_memory::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    /** Creating slave memory as per the configuration*/
   // slv_mem = new[spi_slv_cfg_h.slv_memory_depth];

    /** Constructing analysis port for the connection to fifo*/
    item_export = new("item_export",this);
    
    /** A analysis fifo to store the transaction from the slave monitor*/
    item_fifo = new("item_fifo",this);
  endfunction : build_phase

  /** Connect_phase*/
  function void AHB_UVC_slave_memory::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(),"START OF CONNECT_PHASE",UVM_HIGH);

    /** Connecting the analysis port and the fifo*/
    item_export.connect(item_fifo.analysis_export);
    `uvm_info(get_type_name(),"END OF CONNECT_PHASE",UVM_HIGH);
  endfunction : connect_phase




