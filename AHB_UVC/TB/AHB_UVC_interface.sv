// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_interface.sv
// Title        : AHB_UVC interface 
// Project      : AHB_UVC VIP
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

interface AHB_UVC_interface();
  
  logic hclk;
  logic hresetn;

  // Master Signals 
  logic [`HADDR_WIDTH  - 1 : 0]Haddr;
  logic [`HBURST_WIDTH - 1: 0]Hburst;
  logic Hmastlock;
  logic [`HPROT_WIDTH  - 1 : 0]Hprot;
  logic [`HSIZE_WIDTH  - 1 : 0]Hsize;
  logic [`HTRANS_WIDTH - 1 : 0]Htrans;
  logic [`HWDATA_WIDTH - 1 : 0]Hwdata;
  logic Hwrite;
  

  //slave signals 
  logic [`HRDATA_WIDTH -1 : 0]Hrdata;
  logic Hready_in;
  logic Hready_out = 0;
  logic Hresp;

/* ASSERTIONS FOR AHB-LITE PROTOCOL  */ 
 
   //assertion for clock frequency check
    property clk_freq_check();
    time current_time;
    (1,current_time=$time)|=>($time-current_time==`TIME_PERIOD);
   endproperty
  
  // Assertion for alligned address only      
   property aligned_address();
    hresetn && Htrans!=0 |-> (Haddr % (2**Hsize) == 0);
  endproperty

  //Assertion for Htrans (after an IDLE state BUSY OR SEQ can't occur)
  property idle_busy_seq_invalid_chnange();
    (Htrans==0) |-> (Htrans!=1 && Htrans!=3);
  endproperty

  //Assertion for Htrans (after an BUSY state IDLE OR NONSEQ can't occur)
  property busy_nonseq_idle_invalid_change();
    (Htrans==1) |-> (Htrans!=0 && Htrans!=2);
  endproperty
  
  //Assertion for invalid transfer for SINGLE hburst can't terminate with a BUSY trans
  property single_invalid_trans_change();
    (Hburst==0) |-> (Htrans!=1);
  endproperty 

  //Assertion for stable htrans after idle to nonseq during waited transfer
  property htrans_stable_during_hready_low();
    (!Hready_out && Htrans==0 && !Hresp ) |=> (Htrans==2 && !Hready_out)|->##[0:$] Hready_out|-> $stable(Htrans) && $stable(Haddr);
  endproperty

  //Assertion for stable Address when transition from BUSY to SEQ in waited transfer for fixed length burst
  property Busy_Seq_stable_addr();
    (!Hready_out && Htrans ==0 && !Hresp && Hburst!=0 ) |=> (Htrans ==3 & !Hready_out )|->##[0:$] Hready_out|-> $stable(Htrans) && $stable(Haddr);
  endproperty

  //Assertion for change of htrans from BUSY to anyother Htrans when Hready_out is low (waited transfer) 
  property Busy_other_type();
    (!Hready_out && Htrans==1 && !Hresp && Hburst==1) |=> (Htrans ==2 || Htrans==3)&& !Hready_out |-> ##[0:$] Hready_out|->$stable(Htrans);    
 endproperty

  task reset(int rst_assrt,int no_cycle_rst_deassrt);
    #rst_assrt;
     hresetn = 1'b0;
    repeat(no_cycle_rst_deassrt)
      @(posedge hclk);
     @(posedge hclk);
      hresetn = 1'b1;
  endtask : reset

  //master driver clocking block
  clocking ahb_mstr_drv_cb @(posedge hclk);
     default input #1 output #1;
     output Haddr;
     output Hburst;
     output Hprot;
     output Hsize;
     output Htrans;
     output Hwrite;
     output Hwdata;
     input Hready_in;
     input Hready_out;
     input Hresp;
  endclocking : ahb_mstr_drv_cb

  //master monitor clocking block
  clocking ahb_mstr_mon_cb @(posedge hclk);
    default input #1 output #1;
    input Haddr;
    input Hburst;
    input Hprot;
    input Hsize;
    input Hwrite;
    input Htrans;
    input Hwdata;
    input Hrdata;
    input Hready_in;
    input Hready_out;
    input Hresp;
  endclocking : ahb_mstr_mon_cb
  
  //slave driver clocking block
  clocking ahb_slv_drv_cb @(posedge hclk);
     default input #1 output #1;
     output Hrdata;
     output Hready_in;
     output Hready_out;
     inout Hresp;
    input Htrans;
  endclocking : ahb_slv_drv_cb

  //slave monitor clocking block
  clocking ahb_slv_mon_cb @(posedge hclk);
    default input #1 output #1;
    input Haddr;
    input Hburst;
    input Hprot;
    input Hsize;
    input Hwrite;
    input Htrans;
    input Hwdata;
    input Hrdata;
    input Hready_in;
    input Hready_out;
    input Hresp;
  endclocking : ahb_slv_mon_cb
endinterface : AHB_UVC_interface
