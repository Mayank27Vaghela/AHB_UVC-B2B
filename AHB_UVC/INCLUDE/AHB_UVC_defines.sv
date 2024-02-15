// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_defines.sv
// Title        : AHB_UVC defines
// Project      : AHB_UVC
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------

`ifndef AHB_UVC_DEFINES
`define AHB_UVC_DEFINES

`define HBURST_WIDTH 3
`define HADDR_WIDTH 32
`define HWDATA_WIDTH 32
`define HRDATA_WIDTH 32
`define HPROT_WIDTH 32
`define HSIZE_WIDTH 32
`define HTRANS_WIDTH 32
`define MEM_DEPTH 1024

`define MSTR_DRV_CB uvc_if.ahb_mstr_drv_cb
`define MSTR_MON_CB uvc_if.ahb_mstr_mon_cb
`define SLV_DRV_CB  uvc_if.ahb_slv_drv_cb
`define SLV_MON_CB  uvc_if.ahb_slv_mon_cb
`endif
