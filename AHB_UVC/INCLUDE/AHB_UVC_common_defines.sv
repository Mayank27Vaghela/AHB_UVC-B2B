// ------------------------------------------------------------------------- 
// File name    : AHB_UVC_common defines.sv
// Title        : AHB_UVC common defines class
// Project      : AHB_UVC 
// Created On   : 2024-02-07
// Developers   : 
// -------------------------------------------------------------------------


typedef enum bit [2:0]                 {BYTE,HALFWORD,WORD,DOUBLEWORD,WORDLINE_4,WORDLINE_8} hsize_enum;
typedef enum bit [1:0]                 {IDLE,BUSY,NONSEQ,SEQ}                                htrans_enum;
typedef enum bit [(`HBURST_WIDTH-1):0] {SINGLE,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16}   hburst_enum;
typedef enum bit                       {OKAY,ERROR}                                          hresp_enum;
