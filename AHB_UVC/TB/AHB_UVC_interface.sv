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
  logic Hready_out;
  logic Hresp;

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
