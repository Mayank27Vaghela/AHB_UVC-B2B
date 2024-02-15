// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_top.sv
// Title        : AHB_UVC top module 
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

`timescale 10ns/1ps
`include "AHB_UVC_defines.sv"
`include "AHB_UVC_common_defines.sv"
`include "AHB_UVC_interface.sv"
`include "AHB_UVC_checker.sv"
module AHB_UVC_top;

import uvm_pkg::*;
`include "uvm_macros.svh"

import AHB_UVC_package::*;

  bit Systemclock;

  always #5 Systemclock = ~Systemclock;

  initial begin
    uvc_if.hresetn = 0;
    #6;
    uvc_if.hresetn = 1;
  end

  assign uvc_if.Hready_in = uvc_if.Hready_out;
  assign uvc_if.hclk = Systemclock;
  //assign uvc_if.hresetn = hresetn;

	//interface handle declaration
	AHB_UVC_interface uvc_if();
    
  initial begin
	  uvm_config_db#(virtual AHB_UVC_interface)::set(null, "*", "uvc_if", uvc_if);
    run_test("");
  end
endmodule
