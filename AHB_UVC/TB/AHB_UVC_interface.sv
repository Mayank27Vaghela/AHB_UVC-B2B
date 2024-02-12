// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_interface.sv
// Title        : AHB_UVC interface 
// Project      : AHB_UVC VIP
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

interface AHB_UVC_interface(input logic hclk , hresetn);

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
endinterface : AHB_UVC_interface
